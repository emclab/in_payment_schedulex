module InPaymentSchedulex
  class ReceivingSchedule < ActiveRecord::Base
    attr_accessor :last_update_by_name, :payment_type, :cancelled_noupdate, :contract_id_noupdate, :paid_out_noupdate
                                   
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :contract, :class_name => InPaymentSchedulex.contract_class.to_s
    belongs_to :payment_type, :class_name => 'Commonx::MiscDefinition'

    validates :amount, :presence => true,
                       :numericality => {:greater_than_or_equal_to => 0}                            
    validates :pay_date, :presence => true
    validates :contract_id, :presence => true, :numericality => {:greater_than => 0}
    validates :paid_percentage, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}, :if => 'paid_percentage.present?'
    validates :payment_type_id, :numericality => {:greater_than => 0}, :if => 'payment_type_id.present?'
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'in_payment_schedulex')
      eval(wf) if wf.present?
    end        
  end
end
