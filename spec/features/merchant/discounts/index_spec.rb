require 'rails_helper'

describe "Merchant Discounts Index Page" do
  describe "When I visit the merchant discounts page" do
    before(:each) do
      @merchant = create(:merchant)
      @merchant_user = create(:user, role: 1, merchant_id: @merchant.id)
      @discount_1 = Discount.create!(name: "5% Off", percentage: 5, min_purchase: 5, active?: true, merchant_id: @merchant.id)
      @discount_2 = Discount.create!(name: "10% Off", percentage: 10, min_purchase: 10, active?: true, merchant_id: @merchant.id)
      @discount_3 = Discount.create!(name: "25% Off", percentage: 25, min_purchase: 5, active?: false, merchant_id: @merchant.id)

      visit login_path
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: @merchant_user.password
      click_button "Login"
    end

    it 'shows me a list of that merchants discounts' do
      visit "/merchant/discounts"

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content(@discount_1.name)
        expect(page).to have_content(@discount_1.percentage)
        expect(page).to have_content(@discount_1.min_purchase)
        expect(page).to have_content("Discount Active")
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content(@discount_2.name)
        expect(page).to have_content(@discount_2.percentage)
        expect(page).to have_content(@discount_2.min_purchase)
        expect(page).to have_content("Discount Active")
      end

      within "#discount-#{@discount_3.id}" do
        expect(page).to have_content(@discount_3.name)
        expect(page).to have_content(@discount_3.percentage)
        expect(page).to have_content(@discount_3.min_purchase)
        expect(page).to have_content("Discount Inactive")
      end
    end

    it 'has a link to create a new discount' do
      visit "/merchant/discounts"

      within ".discount-options" do
        expect(page).to have_link("Create Discount")

        click_link "Create Discount"

        expect(current_path).to eq("/merchant/discounts/new")
      end
    end

    it 'has a link to activate an inactive discount' do
      visit "/merchant/discounts"

      within "#discount-#{@discount_3.id}" do
        expect(page).to have_content("Discount Inactive")
        expect(page).to_not have_link('Deactivate')
      end

      within "#discount-#{@discount_3.id}" do
        click_on 'Activate'
      end

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content('This discount is now activated.')

      within "#discount-#{@discount_3.id}" do
        expect(page).to have_content("Discount Active")
        expect(page).to have_link('Deactivate')
      end
    end

    it 'has a link to disactivate an active discount' do
      visit "/merchant/discounts"

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("Discount Active")
        expect(page).to_not have_link('Activate')
      end

      within "#discount-#{@discount_1.id}" do
        click_on 'Deactivate'
      end

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content('This discount is now inactive.')

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("Discount Inactive")
        expect(page).to have_link('Activate')
      end
    end
  end
end
