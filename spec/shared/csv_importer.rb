shared_examples "a csv importer" do
  let!(:import_class) { described_class.import_class }
  let!(:csv_directory) { "#{described_class.to_s.underscore}_csv_files" }

  # TOOD: partial success
  # TOOD: full success
  # TODO: duplicates - warning/silent/update?

  describe 'non-CSV file' do
    let!(:subject) { described_class.new( Rails.root.join("spec", "services", csv_directory, "non_csv.txt") ) }
    it_behaves_like 'an invalid record'
    it_behaves_like 'a failed import'
    # TODO: errors hash check message
  end

  describe 'headerless CSV file' do
    let!(:subject) { described_class.new( Rails.root.join('spec', 'services', csv_directory, 'headerless.csv') ) }
    it_behaves_like 'an invalid record'
    it_behaves_like 'a failed import'
    # TODO: errors hash check message
  end

  describe 'CSV file with invalid headers' do
    let!(:subject) { described_class.new( Rails.root.join('spec', 'services', csv_directory, 'invalid_headers.csv') ) }
    it_behaves_like 'an invalid record'
    it_behaves_like 'a failed import'
    # TODO: errors hash check message
  end

  describe 'valid CSV with failed records' do
    let!(:subject) { described_class.new( Rails.root.join('spec', 'services', csv_directory, 'invalid_records.csv') ) }
    # TODO: check has imported some stuff
    # TODO: errors hash check message
  end

  describe 'valid CSV import' do
    let!(:subject) { described_class.new( Rails.root.join('spec', 'services', csv_directory, 'valid.csv') ) }

    describe '#save' do
      let!(:save_result) { subject.save }

      it 'save returns true' do
        expect(save_result).to be_truthy
      end

      it 'has no errors' do
        expect(subject.errors).to be_empty
      end

      it 'creates new records' do
        expect(import_class.count).to eq(3)
      end
    end

    describe '#save!' do
      let!(:save_result) { subject.save! }

      it 'save returns true' do
        expect(save_result).to be_truthy
      end

      it 'has no errors' do
        expect(subject.errors).to be_empty
      end

      it 'creates new records' do
        expect(import_class.count).to eq(3)
      end
      # returns true
    end

    # TODO check everything's good
  end

end
