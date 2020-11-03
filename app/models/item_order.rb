class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity
  scope :fulfilled, -> (order_id){ where('order_id = ? AND fulfill_status = ?', order_id, "fulfilled")}

  belongs_to :item
  belongs_to :order

  def self.unique_items
    select(:item_id).distinct.count
  end

  def subtotal
    price * quantity
  end
end
