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
      all_succeeded = false unless create_or_update(row.to_hash.with_indifferent_access, index)
    end
    all_succeeded
  end

  def save!
    validate!
    @csv_file.each do |row|
      create_or_update!(row.to_hash.with_indifferent_access)
    end
  end

  private

  def required_headers_are_present
    required_headers.each do |header|
      errors.add(:file, "#{header} column not found") unless @csv_file.headers.include?(header.to_s)
    end
  end

end
