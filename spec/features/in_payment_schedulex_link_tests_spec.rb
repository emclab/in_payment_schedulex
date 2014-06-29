require 'spec_helper'

describe "LinkTests" do
  describe "GET /in_payment_schedulex_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "InPaymentSchedulex::ReceivingSchedule.scoped.order('pay_date DESC, paid_percentage')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'show', :resource => 'in_payment_schedulex_receiving_schedules', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "") 
      ua1 = FactoryGirl.create(:user_access, :action => 'create_pay_receiving_schedule', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")   
           
      @cust = FactoryGirl.create(:kustomerx_customer)
      @cust1 = FactoryGirl.create(:kustomerx_customer, :name => 'new new', :short_name => 'n new')
      @contract = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :customer_id => @cust.id, :contract_num => 'a new')
      @contract1 = FactoryGirl.create(:multi_item_contractx_contract, :void => false, :last_updated_by_id => @u.id, :customer_id => @cust1.id)
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works!" do
      qs = FactoryGirl.create(:in_payment_schedulex_receiving_schedule, :last_updated_by_id => @u.id, :contract_id => @contract.id)
      log = FactoryGirl.create(:commonx_log, :log => 'some logss', :resource_id => qs.id, :resource_name => 'in_payment_schedulex_receiving_schedules')
      
      visit receiving_schedules_path
      save_and_open_page
      click_link qs.id.to_s
      page.should have_content('Receiving Schedule Info')
      page.should have_content('some logss')
      click_link 'New Log'
      page.should have_content('Log')
      #save_and_open_page
      visit receiving_schedules_path() 
      save_and_open_page
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Receiving Schedule')
      fill_in 'receiving_schedule_brief_note', :with => 'new name'
      click_button 'Save'
      visit receiving_schedules_path()
      click_link qs.id.to_s
      page.should have_content('new name')
      #wrong data
      visit receiving_schedules_path() 
      click_link 'Edit'
      page.should have_content('Edit Receiving Schedule')
      fill_in 'receiving_schedule_pay_date', :with => 10.days.ago
      click_button 'Save'
      visit receiving_schedules_path()
      click_link qs.id.to_s
      save_and_open_page
      page.should_not have_content(10.days.ago)
      
      visit receiving_schedules_path(:contract_id => @contract.id)
      page.should have_content('Receiving Schedules')
      click_link 'New Receiving Schedule'
      page.should have_content('New Receiving Schedule')
      fill_in 'receiving_schedule_pay_date', :with => Date.today
      fill_in 'receiving_schedule_amount', :with => 33333
      click_button 'Save'
      visit receiving_schedules_path()
      save_and_open_page
      page.should have_content(Date.today.strftime('%Y/%m/%d'))
      #wrong data
      visit receiving_schedules_path(:contract_id => @contract.id)
      page.should have_content('Receiving Schedules')
      click_link 'New Receiving Schedule'
      save_and_open_page
      page.should have_content('New Receiving Schedule')
      fill_in 'receiving_schedule_pay_date', :with => 7.days.ago
      fill_in 'receiving_schedule_amount', :with => nil
      click_button 'Save'
      visit receiving_schedules_path()
      page.should_not have_content(7.days.ago.strftime('%Y/%m/%d'))
    end
  end
end
