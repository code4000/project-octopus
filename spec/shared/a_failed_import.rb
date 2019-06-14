shared_examples "a failed import" do
  describe "#items" do
    it 'returns an empty list' do
      expect(subject.items).to be_empty
    end
  end
end
