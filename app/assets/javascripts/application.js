// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require underscore
//= require twitter/bootstrap
//= require_tree .

_.templateSettings = {
  interpolate : /\{\{(.+?)\}\}/g
};

$(document).ready(function() {

	$('.sidebar-nav .nav-list a').on('click', function(event) {
		if (map) {
			event.preventDefault();

			$(this).parents('.nav-list').find('li').removeClass('active');
			$(this).parents('.nav-list li').addClass('active');

			var type = ($(this).data('type'));
			map_change_type(type);
		}
	}).popover({ 'placement': 'right', 'trigger': 'hover' });

	$('#search_city').on('change', function(){
		var city = $('#search_city').val();
		var subcities = cities[city]['subcities'];

		var $search_subcity = $('#search_subcity');
		$search_subcity.html("<option>시/군/구</option>");
		for(subcity in subcities) {
			$search_subcity.append("<option>"+subcity+"</option>");
		}
	});

	$('#search_subcity').on('change', function(){
		var point = cities[$('#search_city').val()]['subcities'][$('#search_subcity').val()];
		if (point) {
			$('#map_info').hide();
			map.setCenter(point);
			map.setZoom(14);
		}
	});

	$('#current_pos_btn').on('click', function() {
		if (navigator.geolocation) {
			navigator.geolocation.getCurrentPosition(map_set_center);
		} else {
			alert('현재 위치를 가져올 수 없습니다');
		}
	});

});