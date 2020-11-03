class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status:  %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def status_check
    if self.item_orders.fulfilled.count == self.item_orders.count && self.status != "packaged"
      update(:status => "packaged")
    end
    self.status
  end
end
