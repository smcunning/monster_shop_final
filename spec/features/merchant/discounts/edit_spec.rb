require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit the merchant discounts index page" do
    before :each do
      @merchant = create(:merchant)
      @merchant_user = create(:user, role: 1, merchant_id: @merchant.id)
      @discount_1 = Discount.create!(name: "5% Off", percentage: 0.05, min_purchase: 5, active?: true, merchant_id: @merchant.id)
      @discount_2 = Discount.create!(name: "10% Off", percentage: 0.10, min_purchase: 10, active?: true, merchant_id: @merchant.id)
      @discount_3 = Discount.create!(name: "25% Off", percentage: 0.25, min_purchase: 5, active?: false, merchant_id: @merchant.id)

      visit login_path
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password
      click_button "Login"

      visit "/merchant/discounts"
    end

    it "I see an edit button next to any discount" do

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_button("Edit")
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_button("Edit")
      end

      within "#discount-#{@discount_3.id}" do
        expect(page).to have_button("Edit")
      end
    end
  end

  describe "After clicking edit, I am taken to a form to edit the item's data" do
    before :each do
      @merchant = create(:merchant)
      @merchant_user = create(:user, role: 1, merchant_id: @merchant.id)
      @discount_1 = Discount.create!(name: "5% Off", percentage: 0.05, min_purchase: 5, active?: true, merchant_id: @merchant.id)
      @discount_2 = Discount.create!(name: "10% Off", percentage: 0.10, min_purchase: 10, active?: true, merchant_id: @merchant.id)
      @discount_3 = Discount.create!(name: "25% Off", percentage: 0.25, min_purchase: 5, active?: false, merchant_id: @merchant.id)

      visit login_path
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password
      click_button "Login"

      visit "/merchant/discounts"

      within "#discount-#{@discount_1.id}" do
        click_on "Edit"
      end
    end

    it "is pre-populated with all the discount's information" do
      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}/edit")
      expect(find_field(:name).value).to eq(@discount_1.name)
      expect(find_field(:percentage).value).to eq(@discount_1.price.to_s)
      expect(find_field(:min_purchase).value).to eq(@discount_1.description)
    end

    it "and I can change the data about the item" do
      fill_in :name, with: "Holiday Promo"
      fill_in :percentage, with: 0.20
      fill_in :min_purchase, with: 5

      click_on "Update Discount"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Discount has been successfully updated!")

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("Holiday Promo")
        expect(page).to have_content("0.20")
        expect(page).to have_content("5")
      end
    end


    it 'I get a flash message if entire form is not filled out' do
      fill_in :name, with: ""
      fill_in :percentage, with: 0.20
      fill_in :min_purchase, with: 5

      click_button "Update Discount"

      expect(page).to have_content("Name can't be blank")
      expect(find_field(:name).value).to eq("")
      expect(find_field(:percentage).value).to eq(0.20)
      expect(find_field(:min_purchase).value).to eq(5)
    end
  end
end
