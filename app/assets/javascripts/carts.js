
$(document).on('page:load', function() {
  
  $('.sendInvite').on('click', function(e) {
    console.log("Facebook")
    e.preventDefault();
    var sendInvite = window.location.hostname + ':3000/invite/' + $('sendInvite').data('key')
    FB.ui({
      method: 'send',
      link: 'http://dailyhive.com/vancouver/pne-playland-redevelopment-vancouver-theme-park',
      message: 'test'
    });
  });


  $('.inviteLink').attr("href", (window.location.hostname + ':3000/invite/' + $('.inviteLink').data("key")));
  // console.log("Test")


}); 