# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :kustomerx_contact, :class => 'Kustomerx::Contact' do
    customer_id 1
    name "contact"
    position "manager in chief"
    phone "phone MyString4"
    cell_phone "cell MyString5"
    email "email@b.com"
    brief_note "MyText8"
  end
end
