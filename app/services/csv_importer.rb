require 'csv'

class CSVImporter
  include ActiveModel::Validations

  attr_reader :file, :items

  validate :required_headers_are_present

  def initialize(path)
    file = File.new(path)
    @csv_file = CSV.new(file, headers: true).read
    @items = []
  end

  def save
    return false unless valid?
    all_succeeded = true

    @csv_file.each.with_index(1) do |row, index|
      save_result = create_or_update(row.to_hash.with_indifferent_access, index)
      if save_result
        @items.push(save_result)
      else
        all_succeeded = false
      end
    end
    all_succeeded
  end

  def save!
    validate!
    @csv_file.each do |row|
      @items.push(create_or_update!(row.to_hash.with_indifferent_access))
    end
  end

  def import_class
    self.class.import_class
  end

  def required_headers
    self.class.required_headers
  end

  def self.valid_headers
    filtered_column_names = self.import_class.column_names.reject{|c| [:id, :created_at, :updated_at].include?(c.to_sym)}
    (filtered_column_names + ['tag_list']).sort
  end

  def self.required_headers
    import_class.validators.find{|v| v.instance_of? ActiveRecord::Validations::PresenceValidator}.attributes
  end

  def headers_to_find_duplicates_by
    import_class.validators.find{|v| v.instance_of? ActiveRecord::Validations::UniquenessValidator}.attributes
  end

  private

  def required_headers_are_present
    required_headers.each do |header|
      errors.add(:file, "#{header} column not found") unless @csv_file.headers.include?(header.to_s)
    end
  end

  # Create or update a row
  def create_or_update(row_hash, line_number)
    imported_object = find_or_initialize_by_key_fields(row_hash)

    succeeded = imported_object.update(row_hash)
    unless succeeded
      imported_object.errors.full_messages.each do |error_message|
        errors.add(:file, "line #{line_number}: #{error_message}");
      end
    end
    succeeded
  end

  def create_or_update!(row_hash)
    imported_object = find_or_initialize_by_key_fields(row_hash)
    imported_object.update!(row_hash)
    return imported_object
  end

  def find_or_initialize_by_key_fields(row_hash)
    row_key_fields = row_hash.slice(*headers_to_find_duplicates_by)
    query = nil

    row_key_fields.each do |field|
      field_where_query = import_class.where(field.first => field.second)

      # if this is first query don't use or, but if it's not add a new clause using or
      query = query.nil? ? field_where_query : query.or(field_where_query)
    end

    # assign query result, if query doesn't find results create a new instance
    result = query.first_or_initialize(row_hash)
  end
end
