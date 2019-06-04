shared_examples "an invalid record" do
  describe "#validate" do
    it 'returns false' do
      expect(subject.validate).to be_falsey
    end
  end

  describe "#validate!" do
    it 'raises an exception' do
      expect { subject.validate! }.to raise_error(expected_error)
    end
  end

  describe "#valid?" do
    it 'returns false' do
      expect(subject.valid?).to be_falsey
    end
  end

  describe "#invalid?" do
    it 'returns true' do
      expect(subject.invalid?).to be_truthy
    end
  end

  describe "#save" do
    it 'returns false' do
      expect(subject.save).to be_falsey
    end
  end

  describe "#save!" do
    it 'raises an exception' do
      expect { subject.save! }.to raise_error(expected_error)
    end
  end

  describe "#errors" do
    before do
      subject.validate
    end

    it 'is not empty' do
      expect(subject.errors).not_to be_empty
    end
  end

  def expected_error
    if described_class.included_modules.include?(ActiveRecord::Validations)
      expected_error = ActiveRecord::RecordInvalid
    else
      expected_error = ActiveModel::ValidationError
    end
  end
end
