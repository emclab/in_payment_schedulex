require 'rails_helper'

module InPaymentSchedulex
  RSpec.describe ReceivingSchedulesController, type: :controller do
    routes {InPaymentSchedulex::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_employee)
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @cust = FactoryGirl.create(:kustomerx_customer)
      @cust1 = FactoryGirl.create(:kustomerx_customer, :name => 'new new', :short_name => 'n new')
      @contract = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :sales_id => @u.id, :customer_id => @cust.id, :contract_num => 'a new one')
      @contract1 = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :customer_id => @cust1.id)
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all payments for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InPaymentSchedulex::ReceivingSchedule.all.order('pay_date DESC, paid_percentage')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :last_updated_by_id => @u.id, :contract_id => @contract.id)
        qs1 = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :last_updated_by_id => @u.id, :contract_id => @contract1.id)
        get 'index' 
        expect(assigns(:receiving_schedules)).to match_array([qs, qs1])      
      end
      
      it "should return payments for the project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InPaymentSchedulex::ReceivingSchedule.all.order('pay_date DESC, paid_percentage')")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule,  :last_updated_by_id => @u.id, :contract_id => @contract.id)
        qs1 = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :last_updated_by_id => @u.id, :contract_id => @contract1.id)
        get 'index' , {:contract_id => @contract.id}
        expect(assigns(:receiving_schedules)).to match_array([qs])
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        get 'new' , {:contract_id => @contract.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.sales_id == session[:user_id]")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:in_payment_schedulex_receiving_schedule, :contract_id => @contract.id)
        get 'create' , { :receiving_schedule => qs, :contract_id => @contract.id, :parent_record_id => @contract.id, :parent_resource => 'multi_item_contractx/contracts'}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.attributes_for(:in_payment_schedulex_receiving_schedule, :amount => nil, :contract_id => @contract.id)
        get 'create' , {:receiving_schedule => qs, :contract_id => @contract1.id}
        expect(response).to render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :contract_id => @contract.id)
        get 'edit' , {:id => qs.id, :contract_id => @contract1.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule)
        get 'update' , {:id => qs.id, :contract_id => @contract.id, :receiving_schedule => {:brief_note => 'true'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule)
        get 'update' , {:id => qs.id, :contract_id => @contract.id, :receiving_schedule => {:amount => nil}}
        expect(response).to render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :contract_id => @contract.id, :last_updated_by_id => @u.id)
        get 'show' , {:id => qs.id}
        expect(response).to be_success
      end
    end
  end
end
