require_dependency "in_payment_schedulex/application_controller"

module InPaymentSchedulex
  class ReceivingSchedulesController < ApplicationController
    before_action :require_employee
    before_action :load_parent_record

    def index
      @title = t('Receiving Schedules')
      @receiving_schedules = params[:in_payment_schedulex_receiving_schedules][:model_ar_r]
      @receiving_schedules = @receiving_schedules.where(:contract_id => @contract.id) if @contract      
      @receiving_schedules = @receiving_schedules.page(params[:page]).per_page(@max_pagination)     
      @erb_code = find_config_const('receiving_schedule_index_view', 'in_payment_schedulex')
    end


    def new
      @title = t('New Receiving Schedule')
      @receiving_schedule = InPaymentSchedulex::ReceivingSchedule.new
      @erb_code = find_config_const('receiving_schedule_new_view', 'in_payment_schedulex')
    end


    def create
      @receiving_schedule = InPaymentSchedulex::ReceivingSchedule.new(new_params)
      @receiving_schedule.last_updated_by_id = session[:user_id]
      if @receiving_schedule.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        #for render new when data error
        @contract = InPaymentSchedulex.contract_class.find_by_id(params[:receiving_schedule][:contract_id]) if params[:receiving_schedule].present? && params[:receiving_schedule][:contract_id].present? 
        @erb_code = find_config_const('receiving_schedule_new_view', 'in_payment_schedulex')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Receiving Schedule')
      @receiving_schedule = InPaymentSchedulex::ReceivingSchedule.find_by_id(params[:id])
      @erb_code = find_config_const('receiving_schedule_edit_view', 'in_payment_schedulex')
    end

    def update
      @receiving_schedule = InPaymentSchedulex::ReceivingSchedule.find_by_id(params[:id])
      @receiving_schedule.last_updated_by_id = session[:user_id]
      if @receiving_schedule.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('receiving_schedule_edit_view', 'in_payment_schedulex')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end

    def show
      @title = t('Receiving Schedule Info')
      @receiving_schedule = InPaymentSchedulex::ReceivingSchedule.find_by_id(params[:id])
      @erb_code = find_config_const('receiving_schedule_show_view', 'in_payment_schedulex')
    end

    protected
    
    def load_parent_record
      @contract = InPaymentSchedulex.contract_class.find_by_id(params[:contract_id]) if params[:contract_id].present? 
      @contract = InPaymentSchedulex.contract_class.find_by_id(InPaymentSchedulex::ReceivingSchedule.find_by_id(params[:id]).contract_id) if params[:id].present? 
    end
    
    private
    
    def new_params
      params.require(:receiving_schedule).permit(:amount, :brief_note, :contract_id, :paid_percentage, :pay_date, :payment_type_id, :paid_out)
    end
    
    def edit_params
      params.require(:receiving_schedule).permit(:amount, :brief_note, :paid_percentage, :pay_date, :payment_type_id, :pay_out_date, :paid_out)
    end
  end
end
