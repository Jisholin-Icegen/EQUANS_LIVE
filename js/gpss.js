
function LoaderOff(Interval) {
    setTimeout(function () {
        $('.loaderElement').css("display", "none");
        $('.loader-wrapper').css("display", "none");
    }, Interval);
}



function ShowMap(lat, lon) {

    var myLatlng = new google.maps.LatLng(lat, lon) // This is used to center the map to show our markers
    var mapOptions = {
        center: myLatlng,
        zoom: 18,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        marker: true
    };
    var map = new google.maps.Map(document.getElementById("tdPorter"), mapOptions);
    var marker = new google.maps.Marker({
        position: myLatlng
    });
    marker.setMap(map);
}



function ShowMapIframe(lat, lon) {

    var source = "https://maps.google.com/maps?q=" + lat + "," + lon + "&hl=es;z=18&output=embed";

    $('#iframeGPS').attr('src', source);

}


function LoaderOn() {
    $('.loaderElement').css("display", "inline-block");
}
