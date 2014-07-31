require 'spec_helper'

module InPaymentSchedulex
  describe ReceivingSchedulesController do
    before(:each) do
      controller.should_receive(:require_signin)
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
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all payments for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InPaymentSchedulex::ReceivingSchedule.scoped.order('pay_date DESC, paid_percentage')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :last_updated_by_id => @u.id, :contract_id => @contract.id)
        qs1 = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :last_updated_by_id => @u.id, :contract_id => @contract1.id)
        get 'index' , {:use_route => :in_payment_schedulex}
        assigns(:receiving_schedules).should =~ [qs, qs1]       
      end
      
      it "should return payments for the project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InPaymentSchedulex::ReceivingSchedule.scoped.order('pay_date DESC, paid_percentage')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule,  :last_updated_by_id => @u.id, :contract_id => @contract.id)
        qs1 = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :last_updated_by_id => @u.id, :contract_id => @contract1.id)
        get 'index' , {:use_route => :in_payment_schedulex, :contract_id => @contract.id}
        assigns(:receiving_schedules).should eq([qs])
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :in_payment_schedulex, :contract_id => @contract.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.sales_id == session[:user_id]")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:in_payment_schedulex_receiving_schedule, :contract_id => @contract.id)
        get 'create' , {:use_route => :in_payment_schedulex,  :receiving_schedule => qs, :contract_id => @contract.id, :parent_record_id => @contract.id, :parent_resource => 'multi_item_contractx/contracts'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:in_payment_schedulex_receiving_schedule, :amount => nil, :contract_id => @contract.id)
        get 'create' , {:use_route => :in_payment_schedulex, :receiving_schedule => qs, :contract_id => @contract1.id}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :contract_id => @contract.id)
        get 'edit' , {:use_route => :in_payment_schedulex, :id => qs.id, :contract_id => @contract1.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule)
        get 'update' , {:use_route => :in_payment_schedulex, :id => qs.id, :contract_id => @contract.id, :receiving_schedule => {:brief_note => 'true'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule)
        get 'update' , {:use_route => :in_payment_schedulex, :id => qs.id, :contract_id => @contract.id, :receiving_schedule => {:amount => nil}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :contract_id => @contract.id, :last_updated_by_id => @u.id)
        get 'show' , {:use_route => :in_payment_schedulex, :id => qs.id}
        response.should be_success
      end
    end
  end
end
