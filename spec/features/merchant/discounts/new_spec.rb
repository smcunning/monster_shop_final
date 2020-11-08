require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit the merchant items new page" do
    before(:each) do
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

    it 'I can add a new discount by filling out a form' do
      name = "15% Off"
      percentage = 0.15
      min_purchase = 30

      click_link "Create Discount"

      expect(current_path).to eq("/merchant/discounts/new")

      fill_in :name, with: name
      fill_in :percentage, with: percentage
      fill_in :min_purchase, with: min_purchase

      click_button "Save"

      new_discount = Discount.last

      expect(current_path).to eq("/merchant/discounts")
      expect(new_discount.name).to eq(name)
      expect(new_discount.percentage).to eq(percentage)
      expect(new_discount.min_purchase).to eq(min_purchase)
      expect(new_discount.merchant_id).to eq(@merchant.id)
      expect(new_discount.active?).to be(false)

      expect(page).to have_content("New discount created successfully!")

      within "#discount-#{Discount.last.id}" do
        expect(page).to have_link(new_discount.name)
        expect(page).to have_content(new_discount.percentage)
        expect(page).to have_content(new_discount.min_purchase)
        expect(page).to have_content("Discount Inactive")
      end
    end

#Sad Path Tests

    describe 'I cannot add a discount without certain information' do
      it 'no name' do
        percentage = 0.15
        min_purchase = 30

        click_link "Create Discount"

        fill_in :name, with: ""
        fill_in :percentage, with: percentage
        fill_in :min_purchase, with: min_purchase

        click_button "Save"

        expect(current_path).to eq("/merchant/discounts")
        expect(page).to have_content("Name can't be blank")
      end

      it 'no percentage' do
        name = "15% Off"
        min_purchase = 30

        click_link "Create Discount"

        fill_in :name, with: name
        fill_in :percentage, with: ""
        fill_in :min_purchase, with: min_purchase

        click_button "Save"

        expect(current_path).to eq("/merchant/discounts")
        expect(page).to have_content("Percentage can't be blank")
      end

      it 'no min purchase' do
        name = "15% Off"
        percentage = 0.15

        click_link "Create Discount"

        fill_in :name, with: name
        fill_in :percentage, with: percentage
        fill_in :min_purchase, with: ""

        click_button "Save"

        expect(current_path).to eq("/merchant/discounts")
        expect(page).to have_content("Min purchase can't be blank")
      end
    end

    xit 'I cannot add negative percentage value' do

    end

    xit 'I cannot add negative minimum purchase value' do

    end

    xit 'I cannot add a duplicate discount' do

    end
  end
end
