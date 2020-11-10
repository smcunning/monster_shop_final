require 'rails_helper'

describe 'As a merchant' do
  before :each do
    @merchant = create(:merchant)
    @merchant_user = create(:user, role: 1, merchant_id: @merchant.id)
    @discount_1 = Discount.create!(name: "5% Off", percentage: 5, min_purchase: 5, active?: true, merchant_id: @merchant.id)
    @discount_2 = Discount.create!(name: "10% Off", percentage: 10, min_purchase: 10, active?: true, merchant_id: @merchant.id)
    @discount_3 = Discount.create!(name: "25% Off", percentage: 25, min_purchase: 5, active?: false, merchant_id: @merchant.id)

    visit login_path
    fill_in :email, with: @merchant_user.email
    fill_in :password, with: @merchant_user.password
    click_button "Login"

    visit "/merchant/discounts"
  end

  it "I see a delete button next to any discount" do

    within "#discount-#{@discount_1.id}" do
      expect(page).to have_button("Delete")
    end

    within "#discount-#{@discount_2.id}" do
      expect(page).to have_button("Delete")
    end

    within "#discount-#{@discount_3.id}" do
      expect(page).to have_button("Delete")
    end
  end

  it 'I can delete a discount' do

    within "#discount-#{@discount_1.id}" do
      click_button "Delete"
    end

    expect(current_path).to eq("/merchant/discounts")
    expect(page).not_to have_css("#discount-#{@discount_1.id}")
  end
end
