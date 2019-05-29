import 'spec_helper'

describe CSVImporter do
  # TOOD: partial success
  # TOOD: full success
  # TODO: duplicates - warning/silent/update?

  describe 'non-CSV file' do
    it_behaves_like 'an invalid import'
    # TODO: errors hash check message
  end

  describe 'headerless CSV file' do
    it_behaves_like 'an invalid import'
    # TODO: errors hash check message
  end

  describe 'CSV file with invalid headers' do
    it_behaves_like 'an invalid import'
    # TODO: errors hash check message
  end

  describe 'valid CSV with ' do
    it_behaves_like 'an invalid import'
    # TODO: errors hash check message
  end
end

shared_examples "an invalid import" do
  describe "#validate" do
    it 'returns false' do
      expect(importer.validate).to be_falsey
    end
  end

  describe "#validate!" do
    it 'raises an exception' do
      expect { importer.validate! }.to raise_error(ActiveModel::ValidationError)
    end
  end

  describe "#valid?" do
    it 'returns false' do
      expect(importer.valid?).to be_falsey
    end
  end

  describe "#invalid?" do
    it 'returns true' do
      expect(importer.invalid?).to be_truthy
    end
  end

  describe "#save" do
    it 'returns false' do
      expect(importer.save).to be_falsey
    end
  end

  describe "#save!" do
    it 'raises an exception' do
      expect { importer.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#items" do
    it 'returns an empty list' do
      expect(importer.items).to be_empty
    end
  end

  describe "#errors" do
    it 'is not empty' do
      expect(importer.errors).not_to be_empty
    end
  end
end
