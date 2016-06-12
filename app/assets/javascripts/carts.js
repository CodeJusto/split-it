
$(document).ready(function() {
  $('.inviteLink').attr("href", (window.location.hostname + ':3000/invite/' + $('.inviteLink').data("key")));
  console.log("Test")

}); 