class Loan < ApplicationRecord
  validates :name, presence: true
  validates_length_of :cpf, is: 11
  validates :birthdate, presence: true
  validates :amount, presence: true
  validates :terms, inclusion: { in: [6, 9, 12] }
  validates :income, presence: true

  before_validation do
    self.cpf = cpf.gsub(/\D/, '')
  end
end
