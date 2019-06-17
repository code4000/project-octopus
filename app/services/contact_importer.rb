class ContactImporter < CSVImporter

  def self.import_class
    Contact
  end

  # add tag_list as it isnt a model attribute - but contacts have many
  def self.valid_headers
    (super + ['tag_list']).sort
  end
end
