$(function() {

  $('.refund-button').on('click', function(e){
    e.preventDefault();
    // e.stopPropagation();
    var $payment = $(this).parents('.contribution-details');
    var paymentId = $payment.data('payment-id');
    var data = paymentId;

    if (confirm('Are you sure you want to refund this payment?')){
      $.ajax({
        type: "POST",
        url: '/refunds',
        data: { id: data },
      }).done(function(response){
        console.log(response);
        // look at response and grab the price from it
        // attach listener on the 'total display price'
        // var new_price = response price + total display price
        // .text(new_price) to attach new calculation to DOM
        removePayment(paymentId);
        alert('Payment has been refunded');
      })
    }
  });
});

var removePayment = function(paymentId){
    $('.contribution-details[data-payment-id=' + paymentId + ']').fadeOut(function(){
        $(this).remove();        
    });
}