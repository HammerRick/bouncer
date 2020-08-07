require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe 'validations' do
    let(:loan) { build :loan }

    it 'is valid with valid values' do
      expect(loan).to be_valid
    end

    it 'is invalid with blank name' do
      loan.name = ''
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ name: ["can't be blank"] })
    end

    it 'is invalid being to short for a cpf' do
      loan.cpf = '961.016.146-4'
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ cpf: ['is the wrong length (should be 11 characters)'] })
    end

    it 'is invalid being to long for a cpf' do
      loan.cpf = '961.016.146-412'
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ cpf: ['is the wrong length (should be 11 characters)'] })
    end

    it 'is valid with a valid cpf regardeless of dots and slashes, as long as the digit count is right' do
      loan.cpf = '961............................016--------.146-41'
      expect(loan).to be_valid
    end

    it 'is invalid with blank birthdate' do
      loan.birthdate = ''
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ birthdate: ["can't be blank"] })
    end

    it 'is invalid without amount' do
      loan.amount = nil
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ amount: ["can't be blank"] })
    end

    it 'is invalid without terms' do
      loan.terms = nil
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ terms: ['is not included in the list'] })
    end

    it 'is invalid with invalid terms' do
      loan.terms = 7
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ terms: ['is not included in the list'] })
    end

    it 'is invalid without income' do
      loan.income = nil
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ income: ["can't be blank"] })
    end
  end
end
