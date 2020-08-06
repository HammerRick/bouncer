class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans, id: :uuid do |t|
      t.string :name
      t.string :cpf
      t.date :birthdate
      t.decimal :amount
      t.integer :terms
      t.decimal :income

      t.timestamps
    end
  end
end
