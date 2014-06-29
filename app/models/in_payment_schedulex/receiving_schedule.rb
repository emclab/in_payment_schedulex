module InPaymentSchedulex
  class ReceivingSchedule < ActiveRecord::Base
    attr_accessor :last_update_by_name, :payment_type, :cancelled_noupdate, :contract_id_noupdate
    attr_accessible :amount, :brief_note, :contract_id, :paid_percentage, :pay_date, :payment_type_id,
                    :as => :role_new
    attr_accessible :amount, :brief_note, :paid_percentage, :pay_date, :payment_type_id, :pay_out_date,
                    :contract_id_noupdate,
                    :as => :role_update
    
    attr_accessor :contract_id_s, :start_date_s, :end_date_s, :customer_id_s, :payment_type_id_s, :paid_percentage_s, :time_frame_s

    attr_accessible :contract_id_s, :start_date_s, :end_date_s, :customer_id_s, :payment_type_id_s, :time_frame_s, :paid_percentage_s,
                    :as => :role_search_stats
                                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :contract, :class_name => InPaymentSchedulex.contract_class.to_s
    belongs_to :payment_type, :class_name => 'Commonx::MiscDefinition'

    validates :amount, :presence => true,
                       :numericality => {:greater_than_or_equal_to => 0}                            
    validates :pay_date, :presence => true
    validates :contract_id, :presence => true, :numericality => {:greater_than => 0}
    validates :payment_type_id, :numericality => {:greater_than => 0}, :if => 'payment_type_id.present?'
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'in_payment_schedulex')
      eval(wf) if wf.present?
    end        
  end
end
