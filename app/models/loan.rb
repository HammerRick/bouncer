class Loan < ApplicationRecord
  include Policies

  validates :name, presence: true
  validates_length_of :cpf, is: 11
  validates :birthdate, presence: { message: "invalid, please follow this pattern: 'yyyy-mm-dd'" }
  validates :terms, inclusion: { in: [6, 9, 12], message: 'can only be 6, 9 or 12' }
  validates_numericality_of :income
  validates_numericality_of :amount, greater_than_or_equal_to: 1000,
                                     less_than_or_equal_to: 4000,
                                     message: "Must be a number between '1000.00' and '4000.00'"

  before_validation do
    self.cpf = cpf.gsub(/\D/, '') unless cpf.nil?
  end

  def age
    today = Date.today
    birthday_has_passed = today.month > birthdate.month || (today.month == birthdate.month && today.day >= birthdate.day)
    today.year - birthdate.year - (birthday_has_passed ? 0 : 1)
  end
end
