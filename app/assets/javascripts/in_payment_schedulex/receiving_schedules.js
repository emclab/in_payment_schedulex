// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$( "#receiving_schedule_pay_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#receiving_schedule_pay_out_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#receiving_schedule_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#receiving_schedule_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});