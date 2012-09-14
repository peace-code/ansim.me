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
	$('#search_btn').on('click', function(){
		var point = cities[$('#search_city').val()];
		if (point) {
			$('map_info').hide();
			map.setCenter(point);
			map.setZoom(14);
		}
	});
	$('#search_city').on('change', function(){
		
	});
	$('#search_subcity').on('change', function(){
		
	});
});