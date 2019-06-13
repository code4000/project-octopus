require 'rails_helper'

shared_examples "a failed import" do
  describe "#items" do
    it 'returns an empty list' do
      expect(subject.items).to be_empty
    end
  end
end

describe ContactImporter do
  # TOOD: partial success
  # TOOD: full success
  # TODO: duplicates - warning/silent/update?
  it_behaves_like 'a csv importer'

end
