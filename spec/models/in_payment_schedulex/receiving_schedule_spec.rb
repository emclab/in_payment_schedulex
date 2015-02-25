require 'rails_helper'

module InPaymentSchedulex
  RSpec.describe ReceivingSchedule, type: :model do
    it "should be OK" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule)
      expect(p).to be_valid
    end
    
    it "should reject nil amount" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :amount => nil)
      expect(p).not_to be_valid
    end
    
    it "should take 0 amount" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :amount => 0)
      expect(p).to be_valid
    end
    
    it "should have received date" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :pay_date => nil)
      expect(p).not_to be_valid
    end
    
    it "should have contract id" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :contract_id => nil)
      expect(p).not_to be_valid
    end
    
    it "should have 0 contract id" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :contract_id => 0)
      expect(p).not_to be_valid
    end
    
    it "should be OK if paid_percentage is 60" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :paid_percentage => 60)
      expect(p).to be_valid
    end
    
    it "should be not OK if paid_percentage is 160" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :paid_percentage => 160)
      expect(p).not_to be_valid
    end
  end
end
