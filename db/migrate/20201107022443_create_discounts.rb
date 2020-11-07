class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.float :percentage
      t.integer :min_purchase
      t.boolean :active?, default: false
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
