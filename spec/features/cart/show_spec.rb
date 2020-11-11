require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end

      it 'Next to each item is a way to increase the amount of that item' do
        ruler = @mike.items.create(name: "Ruler", description: "Measure away!", price: 1, image: "https://static6.depositphotos.com/1106005/640/i/450/depositphotos_6403604-stock-photo-wooden-ruler.jpg", inventory: 2)
        visit "/items/#{ruler.id}"
        click_on "Add To Cart"

        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_button('+')
          end
        end

        within "#cart-item-#{ruler.id}" do
          click_on '+'
          expect(page).to have_content("2")
          expect(page).to have_content("$2")
          expect(page).to_not have_button('+')
        end
      end

      it 'Next to each item is a way to decrease the amount of that item' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_button('+')
          end
        end

        within "#cart-item-#{@pencil.id}" do
          click_on '+'
          expect(page).to have_content("2")
          click_on '-'
          expect(page).to have_content("1")
          click_on '-'
        end

        expect(page).to_not have_content(@pencil.name)
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end

#Bulk Discounts

  describe "I can buy items in bulk and receive a discount" do
    before :each do
      @gobbeldygook = Merchant.create!(name: "Gobbeldygooks Monster Depot", address: "666 Fire and Brimstone Rd.", city: "Sheol", state: "Hell", zip: "66666")
      @monstersrus = Merchant.create!(name: "Monsters R Us", address: "Shades of Death Avenue", city: "Dis", state: "Hell", zip: "66666")
      @pitfiend = @gobbeldygook.items.create!(name: "Pit Fiend", description: "Beings of pure and unimaginable evil", price: 100, inventory: 50, image: "https://static.wikia.nocookie.net/forgottenrealms/images/9/98/Monster_Manual_5e_-_Devil%2C_Pit_Fiend_-_Michael_Berube_-_p77.jpg/revision/latest/scale-to-width-down/908?cb=20200327120148")
      @succubus = @gobbeldygook.items.create!(name: "Succubus", description: "Demon of unpure wiles", price: 50, inventory: 25, image: "https://static.wikia.nocookie.net/forgottenrealms/images/8/8d/Succubus-5e.jpg/revision/latest/scale-to-width-down/591?cb=20161121204309")
      @abishai = @monstersrus.items.create!(name: "Abishai", description: "Draconic devil in service to the queen", price: 25, inventory: 75, image: "https://static.wikia.nocookie.net/forgottenrealms/images/7/78/Abishai_Colors.jpg/revision/latest/scale-to-width-down/400?cb=20110908013842")
      @discount_5_off = Discount.create!(name: "5% off of 5 items", percentage: 5, min_purchase: 5, merchant_id: @gobbeldygook.id, active?: true)
      @discount_6_off = Discount.create!(name: "6% off of 6 items", percentage: 6, min_purchase: 6, active?: true, merchant_id: @gobbeldygook.id)
      @discount_20_off = Discount.create!(name: "20% Off of 10 or More", percentage: 20, min_purchase: 10, merchant_id: @monstersrus.id, active?: true)

      visit "/items/#{@pitfiend.id}"
      click_button "Add To Cart"
      visit "/cart"

      click_button "+"
      click_button "+"
      click_button "+"
    end

    it 'when I add enough items to qualify for a discount, it appears in the cart' do
      within "#cart-item-#{@pitfiend.id}" do
        expect(page).to have_content("$400.00")
        expect(page).to have_content("4")
        expect(page).to have_content("$100.00")

        click_button "+"
      end

      within "#cart-item-#{@pitfiend.id}" do
        expect(page).to have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$475.00")
        expect(page).to_not have_content("$500.00")
        expect(page).to have_content("5")
        expect(page).to have_content("$95.00")
      end
    end

    it 'when I remove items from the cart and disqualify for a discount, the discount disappears' do
      click_button "+"

      within "#cart-item-#{@pitfiend.id}" do
        expect(page).to have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$475.00")
      end

      click_button "-"

      within "#cart-item-#{@pitfiend.id}" do
        expect(page).to_not have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$400.00")
      end
    end

    it 'only the item that qualifies for the discount has a discount applied to it' do
      within "#cart-item-#{@pitfiend.id}" do
        click_button "+"
      end

      visit "/items/#{@succubus.id}"
      click_button "Add To Cart"
      visit "/cart"

      within "#cart-item-#{@pitfiend.id}" do
        expect(page).to have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
      end

      within "#cart-item-#{@succubus.id}" do
        expect(page).to_not have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("#{@succubus.price}")
      end
    end

    it 'only items from the merchant with the discount qualify for the discount' do
      within "#cart-item-#{@pitfiend.id}" do
        click_button "+"
      end

      visit "/items/#{@abishai.id}"
      click_button "Add To Cart"
      visit "/cart"

      within "#cart-item-#{@pitfiend.id}" do
        expect(page).to have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
      end

      within "#cart-item-#{@abishai.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"

        expect(page).to_not have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("#{@abishai.price}")
      end
    end


    it 'if the item qualifies for two or more discounts, the larger discount applies' do

      within "#cart-item-#{@pitfiend.id}" do
        click_button "+"
        expect(page).to have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$475.00")
        expect(page).to have_content("5")
        expect(page).to have_content("$95.00")
      end

      within "#cart-item-#{@pitfiend.id}" do
        click_button "+"
        expect(page).to have_content("#{@discount_6_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$564.00")
        expect(page).to have_content("6")
        expect(page).to have_content("$94.00")

        expect(page).to_not have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to_not have_content("$475.00")
        expect(page).to_not have_content("$95.00")
      end
    end

    it 'can apply discounts from multiple merchants in the same cart' do

      within "#cart-item-#{@pitfiend.id}" do
        click_button "+"
      end

      visit "/items/#{@abishai.id}"
      click_button "Add To Cart"
      visit "/cart"

      within "#cart-item-#{@abishai.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"


        expect(page).to have_content("#{@discount_20_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$20.00")
        expect(page).to have_content("1")
        expect(page).to have_content("$200.00")
      end

      within "#cart-item-#{@pitfiend.id}" do
        expect(page).to have_content("#{@discount_5_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$475.00")
        expect(page).to have_content("5")
        expect(page).to have_content("$95.00")
      end

      expect(page).to have_content("Total: $675.00")
    end

  it 'does not apply discounts when they are not active' do
    visit "/items/#{@abishai.id}"
    click_button "Add To Cart"
    visit "/cart"

      within "#cart-item-#{@abishai.id}" do
        expect(page).to_not have_content("#{@discount_20_off.percentage} Percent Discount Applied!")
        expect(page).to have_content("$25.00")
        expect(page).to have_content("1")
        expect(page).to have_content("$25.00")
      end
    end
  end
end
