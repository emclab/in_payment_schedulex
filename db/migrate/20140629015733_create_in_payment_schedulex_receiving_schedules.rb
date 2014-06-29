class CreateInPaymentSchedulexReceivingSchedules < ActiveRecord::Migration
  def change
    create_table :in_payment_schedulex_receiving_schedules do |t|
      t.integer :contract_id
      t.date :pay_date
      t.decimal :amount, :precision => 10, :scale => 2
      t.integer :last_updated_by_id
      t.integer :paid_percentage, :default => 0
      t.string :brief_note
      t.integer :payment_type_id
      t.date :pay_out_date
      t.string :wf_state

      t.timestamps
    end
    
    add_index :in_payment_schedulex_receiving_schedules, :contract_id, :name => :in_payment_schedulex_receiving_schedules_on_contr_id
    add_index :in_payment_schedulex_receiving_schedules, :pay_date
    add_index :in_payment_schedulex_receiving_schedules, :payment_type_id, :name => :in_payment_schedulex_receiving_schedules_on_type_id
    add_index :in_payment_schedulex_receiving_schedules, :wf_state
  end
end
