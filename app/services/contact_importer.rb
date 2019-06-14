class ContactImporter < CSVImporter

  def import_class
    self.class.import_class
  end

  def required_headers
    [:first_name, :last_name, :email]
  end

  def headers_to_find_duplicates_by
    [:email]
  end

  def self.import_class
    Contact
  end
end
