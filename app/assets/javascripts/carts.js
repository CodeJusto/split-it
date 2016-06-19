
$(document).ready(function() {
  
  $('.FBInvite').on('click', function(e) {
    console.log("Facebook")
    e.preventDefault();
    var FBLink = window.location.hostname + ':3000/invite/' + $('FBInvite').data('key')
    FB.ui({
      method: 'send',
      link: 'http://dailyhive.com/vancouver/pne-playland-redevelopment-vancouver-theme-park'
    });
  });

  $('.cart_form').on('click', function(e) {
    debugger
    e.preventDefault();
  $.ajax({
    url: '/create',
      method: 'POST',
    success: function(data) {
      console.log(data);
    }
  });

  });

    

  //$('.inviteLink').attr("href", (window.location.hostname + ':3000/invite/' + $('.inviteLink').data("key")));
  // console.log("Test")


}); 