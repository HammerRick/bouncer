class AddResultsToLoan < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :status, :string
    add_column :loans, :result, :string
    add_column :loans, :refused_policy, :string
    add_column :loans, :approved_terms, :integer
    add_column :loans, :monthly_installment, :decimal
  end
end
