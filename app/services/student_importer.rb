class StudentImporter < CSVImporter

  def import_class
    self.class.import_class
  end

  def required_headers
    [:first_name, :last_name, :email, :prison_number]
  end

  def headers_to_find_duplicates_by
    [:email, :prison_number]
  end

  def self.import_class
    Student
  end
end
