require 'spec_helper'

module InPaymentSchedulex
  describe ReceivingSchedule do
    it "should be OK" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule)
      p.should be_valid
    end
    
    it "should reject nil amount" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :amount => nil)
      p.should_not be_valid
    end
    
    it "should take 0 amount" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :amount => 0)
      p.should be_valid
    end
    
    it "should have received date" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :pay_date => nil)
      p.should_not be_valid
    end
    
    it "should have contract id" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :contract_id => nil)
      p.should_not be_valid
    end
    
    it "should have 0 contract id" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :contract_id => 0)
      p.should_not be_valid
    end
    
    it "should be OK if paid_percentage is 60" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :paid_percentage => 60)
      p.should be_valid
    end
    
    it "should be not OK if paid_percentage is 160" do
      p = FactoryGirl.build(:in_payment_schedulex_receiving_schedule, :paid_percentage => 160)
      p.should_not be_valid
    end
  end
end
