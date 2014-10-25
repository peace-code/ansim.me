//= require jquery
//= require jquery_ujs
//= require underscore
//= require bootstrap
//= require map

_.templateSettings = {
  interpolate : /\{\{(.+?)\}\}/g
};

$(document).ready(function() {

  $('.nav-sidebar a').on('click', function(event) {
    if (map) {
      $(this).parents('.nav-sidebar').find('li').removeClass('active');
      $(this).parents('.nav-sidebar li').addClass('active');
      map.change_category(($(this).data('type')));
      return false;
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
      map.set_center(point);
    }
  });

  $('#current_pos_btn').on('click', function() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(map.set_center);
    } else {
      alert('현재 위치를 가져올 수 없습니다');
    }
  });

});