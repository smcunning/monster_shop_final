class ChangePercentageToBeIntegerInDiscounts < ActiveRecord::Migration[5.2]
  def change
    def change
      change_column :discounts, :percentage, :integer
    end
  end
end
