require 'rails_helper'

describe ContactImporter do
  it_behaves_like 'a csv importer'

  describe 'valid CSV with duplicates' do
    let!(:contact) { Contact.create(first_name: "Michael", last_name: "Angelo", email: "art@example.com") }
    let!(:subject) { described_class.new( Rails.root.join('spec', 'services', 'contact_importer_csv_files', 'valid_duplicates.csv') ) }
    before {subject.save}

    it 'has no errors' do
      expect(subject.errors).to be_empty
    end

    it 'doesnt create new records' do
      expect(Contact.count).to eq(1)
    end

    it 'has updated the duplicates' do
      expect(Contact.first.email).to eq(contact.email)
      expect(Contact.first.first_name).to eq(contact.first_name)
      expect(Contact.first.last_name).to eq(contact.last_name)
      expect(Contact.first.role).to eq("Artist")
      expect(Contact.first.organisation).to eq("Vatican")
    end
  end
end
