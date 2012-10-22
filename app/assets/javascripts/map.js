document.write('<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>');

var Map = function() {

  this.canvas = null;

  this.initialize = function(canvas) {
    this.canvas = canvas;
  }
}

var markers = [];
var map_info = $('#map_info');

var MAP_TYPES = ['antibiotics', 'injections'];
var current_map_type = MAP_TYPES[0];

function initialize_map() {
  var myOptions = {
    zoom: 15,
    center: new google.maps.LatLng(37.49227,126.89779),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  google.maps.event.addListener(map, 'mouseup', fetch_data);
  google.maps.event.addListener(map, 'zoom_changed', fetch_data);
  google.maps.event.addListener(map, 'idle', fetch_data);
}

function map_set_center(position) {
  var point = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
  map_info.hide();
  map.setCenter(point);
  map.setZoom(14);
}

function exists_in_markers(id) {
  for(i in markers) {
    if (markers[i].id == id) return true
  }
  return false;
}

function show_hospital_overlay(id) {
  var $info = map_info;
  var $canvas = $('#map_canvas');
  var url = '/hospitals/' + id;

  $.getJSON(url)
      .success(function(data) {
        var html = _.template($('#map_info_template').html(), data);

        console.log(id, data);

        $info.html(html);
        $info.width($canvas.width());
        $info.offset($canvas.offset());
        $info.show();
      });
}

function map_change_type(type) {
  current_map_type = type;
  for(i in markers) {
    var marker = markers[i].marker;
    marker.setVisible(marker.type == current_map_type);
  }
}

function map_build_marker_image(grade) {
  var pinColor = ['', "39b54a", "8dc73f", "fff200", "f26522", "ee1c24"][grade];
  return new google.maps.MarkerImage(
            "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
            new google.maps.Size(21, 34),
            new google.maps.Point(0,0),
            new google.maps.Point(10, 34));
}

function place_markers(data) {
  var new_makers_count = 0;

    for(var i=0; i < data.length; i++) {
    var id = data[i]._id;
    if (window.exists_in_markers(id)) {
      // skip
    } else {

      for(j in MAP_TYPES) {
        var type = MAP_TYPES[j];
        var grade = data[i][type];
        if (grade != '-') {
          var pinImage = map_build_marker_image(grade);
          var pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
              new google.maps.Size(40, 37),
              new google.maps.Point(0, 0),
              new google.maps.Point(12, 35));

          marker = new google.maps.Marker({
            map:map,
            position: new google.maps.LatLng(data[i].coordinates[1], data[i].coordinates[0]),
            icon: pinImage,
            shadow: pinShadow,
            title: id,
            type: type
          });

          if (type != current_map_type) {
            marker.setVisible(false);
          }

          google.maps.event.addListener(marker, 'click', function() {
            window.show_hospital_overlay(this.title);
          });

          markers.push({ id: id, marker: marker });
          new_makers_count++;
        }
      } // for
    } // else
    } // for
  console.log("load " + data.length + " data & new "+ new_makers_count +" markers");
}

function fetch_data() {
        var url = '/hospitals.json';
        var map = this;
    var bounds = map.getBounds();
        $jqXHR = $.getJSON(url, {
                        north_east: bounds.getNorthEast().lng() + ',' + bounds.getNorthEast().lat(),
                        south_west: bounds.getSouthWest().lng() + ',' + bounds.getSouthWest().lat()
                }).success(function(data) {
                    place_markers(data);
                });
}