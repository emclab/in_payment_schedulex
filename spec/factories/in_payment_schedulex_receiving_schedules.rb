# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :in_payment_schedulex_receiving_schedule, :class => 'InPaymentSchedulex::ReceivingSchedule' do
    contract_id 1
    pay_date "2014-06-28"
    amount "9.99"
    #last_updated_by_id 1
    paid_percentage 1
    brief_note "MyString"
    payment_type_id 1

  end
end
