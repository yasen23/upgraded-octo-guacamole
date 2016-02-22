function getUrlVars() {
  var vars = [], hash;
  var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
  for(var i = 0; i < hashes.length; i++) {
    hash = hashes[i].split('=');
    vars.push(hash[0]);
    vars[hash[0]] = hash[1];
  }
  return vars;
}

$(document).ready(function() {
  var params = getUrlVars();
  if (params["error"] != undefined) {
    $("#error-span").text(decodeURI(params["error"])).show();
    console.log(decodeURI(params["error"]));
  }
});
