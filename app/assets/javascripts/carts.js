
$(document).on('page:load', function() {
  
  $('.FBInvite').on('click', function(e) {
    console.log("Facebook")
    e.preventDefault();
    var FBLink = window.location.hostname + ':3000/invite/' + $('FBInvite').data('key')
    FB.ui({
      method: 'send',
      link: 'http://dailyhive.com/vancouver/pne-playland-redevelopment-vancouver-theme-park'
    });
  });


  //$('.inviteLink').attr("href", (window.location.hostname + ':3000/invite/' + $('.inviteLink').data("key")));
  // console.log("Test")


}); 