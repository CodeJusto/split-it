$(function() {

  var $form = $('#payment-form');
  $form.submit(function(event) {
    event.preventDefault();
    // Disable the submit button to prevent repeated clicks:
    $form.find('.submit').prop('disabled', true);
    // Request a token from Stripe:
    Stripe.card.createToken($form, stripeResponseHandler);
    // Prevent the form from being submitted:
    return false;
  });

});
function stripeResponseHandler(status, response) {
  // Grab the form:
  var $form = $('#payment-form');

  if (response.error) { // Problem!

    // Show the errors on the form:
    $form.find('.payment-errors').text(response.error.message);
    $form.find('.submit').prop('disabled', false); // Re-enable submission

  } else { // Token was created!

    // Get the token ID:
    var token = response.id;

    // Insert the token ID into the form so it gets submitted to the server:
    $form.append($('<input type="hidden" name="stripeToken">').val(token));
    // Submit the form:
    var dataSet = $form.serialize();
      $.ajax({
      type: "POST",
      url: $form.attr("action"),
      data: dataSet,
      complete: function(response){
        $form.get(0).reset();
        var payee = response.responseJSON.payee[0].name;
        var amtpd = response.responseJSON.payment;
        var newTotal = response.responseJSON.updated_cart_total;
        var newProgress = response.responseJSON.updated_pctg;
        console.log(newTotal);
        $('#paymentsList').append('<p>' + payee + ' paid $' + amtpd + '</p>');
        $('.total-amount').text(newTotal);
        $('.percent-of-goal').text(newProgress);
      },
      error: function(){
        console.log("Something went wrong!");
      }
    });
  }
};




