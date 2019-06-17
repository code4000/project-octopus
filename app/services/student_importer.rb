class StudentImporter < CSVImporter

  def self.import_class
    Student
  end

  # add tag_list as it isnt a model attribute - but students have many
  def self.valid_headers
    (super + ['tag_list']).sort
  end
end
