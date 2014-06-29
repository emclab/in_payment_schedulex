# This migration comes from multi_item_contractx (originally 20140617025959)
class CreateMultiItemContractxContractItems < ActiveRecord::Migration
  def change
    create_table :multi_item_contractx_contract_items do |t|
      t.integer :contract_item_id
      t.integer :contract_id

      t.timestamps
    end
    
    add_index :multi_item_contractx_contract_items, :contract_item_id
    add_index :multi_item_contractx_contract_items, :contract_id
  end
end
