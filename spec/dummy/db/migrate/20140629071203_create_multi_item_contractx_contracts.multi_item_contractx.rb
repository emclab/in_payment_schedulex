# This migration comes from multi_item_contractx (originally 20140617025823)
class CreateMultiItemContractxContracts < ActiveRecord::Migration
  def change
    create_table :multi_item_contractx_contracts do |t|
      t.string :name
      t.integer :customer_id
      t.decimal :contract_total, :precision => 10, :scale => 2
      t.decimal :tax, :precision => 10, :scale => 2
      t.decimal :other_charge, :precision => 10, :scale => 2
      t.integer :payment_term
      t.text :payment_agreement
      t.boolean :paid_out, :default => false
      t.boolean :signed, :default => false
      t.date :sign_date
      t.integer :signed_by_id
      t.boolean :contract_on_file
      t.integer :last_updated_by_id
      t.string :contract_num
      t.boolean :void, :default => false
      t.text :contract_info
      t.integer :sales_id
      t.string :customer_signed_by, :default => false
      t.date :contract_date
      t.string :wf_state
      t.integer :category_id
      t.string :customer_po
      
      t.timestamps
    end
    
    add_index :multi_item_contractx_contracts, :customer_id
    add_index :multi_item_contractx_contracts, :sales_id
    add_index :multi_item_contractx_contracts, :void
    add_index :multi_item_contractx_contracts, :paid_out
    add_index :multi_item_contractx_contracts, :signed
    add_index :multi_item_contractx_contracts, :wf_state
    add_index :multi_item_contractx_contracts, :category_id
    add_index :multi_item_contractx_contracts, :customer_po
    add_index :multi_item_contractx_contracts, :name
  end
end
