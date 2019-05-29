require 'rails_helper'
# TODO: refactor ionto rails helper
require_relative '../shared/an_invalid_record.rb'

describe Student do
  describe 'uniqueness' do
    describe 'prison number and email are nil' do
      let (:subject) { build(:student, prison_number: nil, email: nil) }

      it_behaves_like 'an invalid record'

      it 'marks email as invalid' do
        subject.validate
        expect(subject.errors[:email]).to include("can't be blank if prison number is also blank")
      end

      it 'marks email as invalid' do
        subject.validate
        expect(subject.errors[:prison_number]).to include("can't be blank if email is also blank")
      end
    end

    describe 'email is not nil but not unique' do
      before { create(:student, email: 'duplicate@example.com') }

      let (:subject) { build(:student, email: 'duplicate@example.com') }

      it_behaves_like 'an invalid record'
    end

    describe 'prison number is not nil but not unique' do
      before { create(:student, prison_number: 'abc123') }

      let (:subject) { build(:student, prison_number: 'abc123') }

      it_behaves_like 'an invalid record'
    end

    describe 'both email and prison number are unique' do
      let(:subject) { build(:student) }

      it 'is valid' do
        expect(subject.valid?).to be_truthy
      end
    end

  end
end
