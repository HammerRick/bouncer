require 'rails_helper'

RSpec.describe Loan, type: :model do
  let(:loan) { build :loan }

  it 'is valid with valid values' do
    expect(loan).to be_valid
  end

  describe 'name validations' do
    it 'is valid with valid name' do
      loan.name = 'User Doe'
      expect(loan).to be_valid
    end

    it 'is invalid with blank name' do
      loan.name = ''
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ name: ["can't be blank"] })
    end
  end

  describe 'birthdate validations' do
    it 'is valid with valid birthdate' do
      loan.birthdate = '1994-04-19'
      expect(loan).to be_valid
    end

    it 'is invalid with blank birthdate' do
      loan.birthdate = ''
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ birthdate: ["invalid, please follow this pattern: 'yyyy-mm-dd'"] })
    end

    it 'is invalid with invalid birthdate' do
      loan.birthdate = '1994-111-03'
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ birthdate: ["invalid, please follow this pattern: 'yyyy-mm-dd'"] })
    end
  end

  describe 'cpf validations' do
    it 'is valid with a valid cpf' do
      loan.cpf = '961.016.146-41'
      expect(loan).to be_valid
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

    it 'is valid with a valid cpf without any pontuation' do
      loan.cpf = '96101614641'
      expect(loan).to be_valid
    end

    it 'is valid with a valid cpf regardeless of dots and slashes, as long as the digit count is right' do
      loan.cpf = '961............................016--------.146-41'
      expect(loan).to be_valid
    end

    it 'is valid with a valid cpf with any other characters in the middle' do
      loan.cpf = 'a9sd;s6é10qw161xD4641towel'
      expect(loan).to be_valid
    end
  end

  describe 'terms validations' do
    it 'is valid without valid terms' do
      loan.terms = 9
      expect(loan).to be_valid
    end

    it 'is invalid without terms' do
      loan.terms = nil
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ terms: ['can only be 6, 9 or 12'] })
    end

    it 'is invalid with invalid terms' do
      loan.terms = 7
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ terms: ['can only be 6, 9 or 12'] })
    end
  end

  describe 'income validations' do
    it 'is invalid without income' do
      loan.income = nil
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ income: ['is not a number'] })
    end

    it 'is invalid with invalid income' do
      loan.income = '1231231s'
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ income: ['is not a number'] })
    end
  end

  describe 'amount validations' do
    it 'is invalid without amount' do
      loan.amount = nil
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ amount: ["Must be a number between '1000.00' and '4000.00'"] })
    end

    it 'is invalid with invalid number for amount' do
      loan.amount = '1231231s'
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ amount: ["Must be a number between '1000.00' and '4000.00'"] })
    end

    it 'is invalid with amount higher than allowed' do
      loan.amount = '4000.01'
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ amount: ["Must be a number between '1000.00' and '4000.00'"] })
    end

    it 'is invalid with amount lower than allowed' do
      loan.amount = '999.99'
      expect(loan).to be_invalid
      expect(loan.errors.messages).to eq({ amount: ["Must be a number between '1000.00' and '4000.00'"] })
    end
  end
end
