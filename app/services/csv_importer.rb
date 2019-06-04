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
    @csv_file.each do |row|
      Contact.create(row.to_hash)
    end
    true
  end

  def save!
    validate!
    @csv_file.each do |row|
      Contact.create!(row.to_hash)
    end
  end

  private

  def required_headers_are_present
    required_headers.each do |header|
      errors.add(:file, "#{header} column not found") unless @csv_file.headers.include?(header.to_s)
    end
  end

end
