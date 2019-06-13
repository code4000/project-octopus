class ContactImporter < CSVImporter

  def import_class
    Contact
  end

  def required_headers
    [:first_name, :last_name, :email]
  end

  def headers_to_find_duplicates_by
    [:email]
  end
end
