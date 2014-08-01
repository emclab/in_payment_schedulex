require "in_payment_schedulex/engine"

module InPaymentSchedulex
  mattr_accessor :contract_class, :show_contract_path, :contract_resource, :customer_class
  
  def self.contract_class
    @@contract_class.constantize
  end
  
  def self.customer_class
    @@customer_class
  end
end
