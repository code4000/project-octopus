class ContactImporter < CSVImporter
  def required_headers
    [:first_name, :last_name, :email]
  end

  def create_or_update(contact_hash, line_number)
    contact = Contact.find_or_initialize_by(email: contact_hash[:email])

    succeeded = contact.update(contact_hash)
    unless succeeded
      contact.errors.full_messages.each do |error_message|
        # TODO: add row number
        errors.add(:file, "line #{line_number}: #{error_message}");

      end
    end
    succeeded
  end

  def create_or_update!(contact_hash)
    contact = Contact.find_or_initialize_by(email: contact_hash[:email])
    contact.update!(contact_hash)
    return contact
  end
end
