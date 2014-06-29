require "in_payment_schedulex/engine"

module InPaymentSchedulex
  mattr_accessor :contract_class, :show_contract_path, :contract_resource
  
  def self.contract_class
    @@contract_class.constantize
  end
end
