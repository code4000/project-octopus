require 'rails_helper'

describe StudentImporter do
  it_behaves_like 'a csv importer'

  describe 'valid CSV with duplicates' do
    let!(:student) { Student.create(first_name: "Anton", last_name: "Walker", email: "awalker@example.com") }
    let!(:subject) { described_class.new( Rails.root.join('spec', 'services', 'student_importer_csv_files', 'valid_duplicates.csv') ) }
    before {subject.save}

    it 'has no errors' do
      expect(subject.errors).to be_empty
    end

    it 'doesnt create new records' do
      expect(Student.count).to eq(1)
    end

    it 'has updated the duplicates' do
      expect(Student.first.email).to eq(student.email)
      expect(Student.first.first_name).to eq(student.first_name)
      expect(Student.first.last_name).to eq(student.last_name)
      expect(Student.first.prison_number).to eq("A800DD")
      expect(Student.first.gender).to eq("Male")
    end
  end
end
