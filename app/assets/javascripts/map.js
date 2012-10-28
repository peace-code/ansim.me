document.write('<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>');

var Map = function(options) {

    var root = this;

    this.map = null;
    this.canvas = options['canvas'][0];
    this.center = options['center'] || new google.maps.LatLng(37.49227,126.89779);

    this.categories = options['categories'];
    this.current_category = this.categories[0];
    this.data_url = options['data_url']
    this.type = options['type'] || 'grade';

    this.markers = [];
    this.info_view = $('#map_info');
    this.info_view_template = $('#map_info_template');

    this.initialize = function() {
        var myOptions = {
            zoom: 15,
            center: root.center,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        var map = root.map = new google.maps.Map(root.canvas, myOptions);

        google.maps.event.addListener(map, 'mouseup', root.fetch_data);
        google.maps.event.addListener(map, 'zoom_changed', root.fetch_data);
        google.maps.event.addListener(map, 'idle', root.fetch_data);
    }

    this.plcae_markers = function(data) {
        var new_makers_count = 0;

            for(var i=0; i < data.length; i++) {
                var id = data[i]._id;
                if (root.exists_in_markers(id)) {
                    // skip
                } else {
                    for(j in root.categories) {
                        var category = root.categories[j];
                        var value = data[i][category];
                        var coordinates = data[i].coordinates;
                        if (value != '-' && coordinates != null) {
                            var pinImage = root.build_marker_image(value);
                            var pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
                                    new google.maps.Size(40, 37),
                                    new google.maps.Point(0, 0),
                                    new google.maps.Point(12, 35));

                            marker = new google.maps.Marker({
                                map             : root.map,
                                position    : new google.maps.LatLng(coordinates[1], coordinates[0]),
                                icon            : pinImage,
                                shadow        : pinShadow,
                                title         : id,
                                category    : category
                            });

                            if (category != root.current_category) {
                                marker.setVisible(false);
                            }

                            google.maps.event.addListener(marker, 'click', function() {
                                root.show_info_view(this.title);
                            });

                            root.markers.push({ id: id, marker: marker });
                            new_makers_count++;
                        }
                    } // for
                } // else
            } // for
        console.log("load " + data.length + " data & new "+ new_makers_count +" markers");
    }

    this.exists_in_markers = function(id) {
        for(i in root.markers) {
            if (root.markers[i].id == id) return true
        }
        return false;
    }

    this.build_marker_image = function(value) {
        if (this.type == 'grade') {
            var pinColor = ['', "39b54a", "8dc73f", "fff200", "f26522", "ee1c24"][value];
            return new google.maps.MarkerImage(
                "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
                new google.maps.Size(21, 34),
                new google.maps.Point(0,0),
                new google.maps.Point(10, 34)
            );
        }
    }

    this.change_category = function(category) {
        root.current_category = category;
        for(i in root.markers) {
            var marker = root.markers[i].marker;
            marker.setVisible(marker.category == root.current_category);
        }
    }

    // these methods called by google map
    this.show_info_view = function(id) {
        $.getJSON([root.data_url, '/', id].join(''))
            .success(function(data) {
                var html = _.template(root.info_view_template.html(), data);

                $(root.info_view).html(html);
                $(root.info_view).width($(root.canvas).width());
                $(root.info_view).offset($(root.canvas).offset());
                $(root.info_view).show();
            });
    }

    this.fetch_data = function() {
        var map = this;
        var bounds = map.getBounds();
        $jqXHR = $.getJSON(root.data_url, {
            north_east: bounds.getNorthEast().lng() + ',' + bounds.getNorthEast().lat(),
            south_west: bounds.getSouthWest().lng() + ',' + bounds.getSouthWest().lat()
        }).success(function(data) {
            root.plcae_markers(data);
        });
    }

    this.set_center = function(position) {
        if (position.coords != undefined) {
            var point = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        } else {
            var point = position;
        }
        root.info_view.hide();
        root.map.setCenter(point);
        root.map.setZoom(14);
    }

} // Map end