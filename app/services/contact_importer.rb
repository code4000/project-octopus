class ContactImporter < CSVImporter
  def required_headers
    [:first_name, :last_name, :email]
  end
end
