require 'rails_helper'

describe 'as a user' do
  describe 'when I visit my order show page where a discount has been applied' do
    before :each do
      @merchant = create(:merchant)
      @user = create(:user)
      @discount_1 = Discount.create!(name: "5% Off", percentage: 5, min_purchase: 5, active?: true, merchant_id: @merchant.id)
      @item = create(:item, merchant: @merchant)
      @order = create(:order, user: @user)
      @io = create(:item_order, price: 10, quantity: 5, item: @item, order: @order)

      visit "/profile/orders/#{@order.id}"
    end

    it 'shows the discounted order total' do
      save_and_open_page
      expect(page).to have_content("$47.50")
      expect(page).to_not have_content("$50.00")
    end
  end
end
