require 'rails_helper'

RSpec.describe 'Merchant Item New' do
  before :each do
    @merch_1 = create(:merchant)
    @m1_items = create_list(:item, 10, merchant_id: @merch_1.id)
  end
  describe "Can create a new merchant's item" do
    it 'has link to create new item' do
      visit merchant_items_path(@merch_1)

      expect(page).to have_link("Create New Item")
    end

    it 'clicking link takes merchant to new item page' do

      visit merchant_items_path(@merch_1)

      click_link("Create New Item")
      expect(current_path).to eq(new_merchant_item_path(@merch_1))
    end

    it 'new page has a form to add item info that then redirects back to merchant index page with that item on it' do

      visit merchant_items_path(@merch_1)

      click_link("Create New Item")

      fill_in :item_name, with: "Christmas Album"
      fill_in :item_description, with: "YEEEEEEEEEEHAWWWWWWWWWWWW"
      fill_in :item_unit_price, with: 2000
      click_button 'Create Item'
      expect(current_path).to eq(merchant_items_path(@merch_1))
      new_item = Item.last
      

      within "#item-#{new_item.id}" do
        expect(page).to have_content("Christmas Album")
      end


    end

    it 'new items are by default disabled' do
      visit merchant_items_path(@merch_1)

      click_link("Create New Item")

      fill_in :item_name, with: "Christmas Album"
      fill_in :item_description, with: "YEEEEEEEEEEHAWWWWWWWWWWWW"
      fill_in :item_unit_price, with: 2000
      click_button 'Create Item'
      new_item = Item.last
      within '.disabled_items' do
        within "#item-#{new_item.id}" do
          expect(page).to have_content(new_item.name)
        end
      end
      within '.enabled_items' do
        expect(page).to_not have_css("#item-#{new_item.id}")
      end
    end

    it 'returns to new page with error message if name (or other fields) not filled out' do
      visit merchant_items_path(@merch_1)

      click_link("Create New Item")

      fill_in :name, with: ""
      fill_in :description, with: "YEEEEEEEEEEHAWWWWWWWWWWWW"
      fill_in :unit_price, with: 2000
      click_button 'Create Item'
      expect(current_path).to eq(new_merchant_item_path(@merch_1))
      expect(page).to have_content("Error: Name can't be blank")
    end
  end
end
