# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :multi_item_contractx_contract, :class => 'MultiItemContractx::Contract' do
    name 'a contract'
    customer_id 1
    contract_total "9.99"
    other_charge "9.99"
    payment_term 1
    payment_agreement "MyText"
    paid_out false
    signed false
    sign_date "2014-06-16"
    #signed_by_id 1
    contract_on_file false
    #last_updated_by_id 1
    contract_num "MyString"
    void false
    contract_info "MyText"
    sales_id 1
    customer_signed_by "MyString"
    contract_date "2014-06-16"
  end
end
