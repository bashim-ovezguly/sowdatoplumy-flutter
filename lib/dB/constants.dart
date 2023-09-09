
var username = 'admin';
var password = '00000';


class Urls{
  String server_url = "http://216.250.9.45:8000";

  String get_server_url()
  {
    return server_url;
  }
}


var global_headers = {
  'App-Version': 1,
  'Device-Id': '',
  'Location-Id': '',
  'Content-Type': 'application/x-www-form-urlencoded',
};

void setHeadersDevice_id(value){
  global_headers['Device-Id'] = value;
}

void setHeadersLocation_id(value){
  global_headers['Location-Id'] = value.toString();
}