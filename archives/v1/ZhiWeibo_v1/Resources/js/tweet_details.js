
function isRetina(){
  return window.devicePixelRatio >= 2
}

function standardImageParams(width, height){
  var params = []
  if (isRetina()){
    params.push("size=" + (width > 640 ? 640 : width * 2) + "x" + (height * 2))
  } else {
    params.push("size=" + width + "x" + height)
  }
  params.push("sensor=true")
  params.push("mobile=true")
  return params
}

function loadMapOnPage(image_url, destination_url, width, height){
  $('.static-map').attr('href', destination_url)
  $('.static-map').css('background-image', "url('" + image_url.replace(/\\/g, '\\\\') + "')")
  //if (isRetina()){
  //  var background_size = '290px ' + height + 'px'
  //  $('.static-map').css('-webkit-background-size', background_size).css('max-width', '290px')
  //  $('.static-map').css('width', '290px')
  //} else {
    var background_size = '' + width + 'px ' + height + 'px'
    $('.static-map').css('-webkit-background-size', background_size).css('max-width', width + 'px')
    $('.static-map').css('width', width + 'px')
  //}
}

function loadCoordinateMap(latitude, longitude, width, height){
	var params = standardImageParams(width, height);
	params.push("markers=size:mid|color:red|" + latitude + "," + longitude);
	params.push("zoom=12");
	var destination_url = 'zhiweibo://map:' + [latitude, longitude].join(',')
	var image_url = "http://maps.google.com/maps/api/staticmap?" + params.join("&");
	loadMapOnPage(image_url, destination_url, width, height);
}

String.prototype.lpad = function(padString, length) {
	var str = this;
    while (str.length < length)
        str = padString + str;
    return str;
}

String.prototype.binaryInvert = function(){
  var newString = ''
  for(var i = 0; i < this.length; i++){
    newString = newString + (this.charAt(i) == '0' ? '1' : '0')
  }
  return newString
}
String.prototype.reverse = function(){
  var text = ''
  for (var i = 0; i <= this.length; i++){
    text = this.substring(i, i+1) + text;
  }
  return text
}
binary = function(n){
  if (n >= 0){
    console.log(String(n.toString(2).lpad('0', 32)))
    return n.toString(2).lpad('0', 32)
  } else {
    return Math.abs(n + 1).toString(2).lpad('0', 32).binaryInvert()
  }
}

function chunk(text, size){
  var out = []
  var s = text.reverse();
  for(var i = 0; i < s.length ; i = i + size){
    var v = s.substr(i, size).reverse()
    if (v.length == size){
      console.log(v)
      out.push(v)
    }
  }
  var foundLast = false
  while(!foundLast){
    if(parseInt(out[out.length - 1]) == 0){
      out.pop()
    } else {
      foundLast = true
    }
  }
  for(var i = 0; i < out.length; i++){
    var prefix;
    if (i == out.length - 1) {
      prefix = '0'
    } else {
      prefix = '1'
    }
    out[i] = String.fromCharCode(parseInt(prefix + out[i], 2) + 63)
  }
  return out.join('')
}

function encodePoints(pairs){
  var out = ''
  var newArray = []
  for(var i = 0; i < pairs.length ; i++){
    if (i == 0){
      newArray.push(pairs[i])
    } else {
      var latDiff = pairs[i][0] - pairs[i - 1][0]
      var lonDiff = pairs[i][1] - pairs[i - 1][1]
      newArray.push([latDiff, lonDiff])
    }
  }
  for(var i = 0; i < newArray.length ; i++){
    out = out + encodePoint(newArray[i][1]) + encodePoint(newArray[i][0])
  }
  return out
}

function encodePoint(point) {
  var intValue = Math.round(point * 100000)
  var binaryValue = binary(intValue)
  var shifted = binaryValue.substr(1, 31) + '0'
  if (intValue < 0){
    shifted = shifted.binaryInvert()
  }
  return chunk(shifted, 5)
}
