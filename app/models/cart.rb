class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def remove_one(item)
    @contents[item] -= 1
    if @contents[item] == 0
      @contents.delete(item)
    end
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    sale_price(item) * @contents[item.id.to_s]
  end

  def total
    total = 0.0
    @contents.each do |item_id,quantity|
      item = Item.find(item_id)
      total += sale_price(item) * quantity
    end
    total
  end

  def inventory_check(item)
    @contents[item.id.to_s] < item.inventory
  end

  def item_count(item_id)
    @contents[item_id.to_s]
  end

  def apply_discount(item)
    item.merchant.discounts.where("? >= min_purchase", item_count(item.id)).order(percentage: :desc).limit(1).pluck(:percentage).first
  end

  def sale_price(item)  
    if apply_discount(item)
      item.price * (100 - apply_discount(item))*0.01
    else
      item.price
    end
  end
end
