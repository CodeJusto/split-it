$(function() {

  $('.refund-button').on('click', function(e){
    e.preventDefault();
    // e.stopPropagation();
    var $payment = $('.contribution-details');
    var paymentId = $payment.data('payment-id');
    var data = paymentId;

    if (confirm('Are you sure you want to refund this payment?')){
      $.ajax({
        type: "POST",
        url: '/refund',
        data: { id: data },
      }).done(function(response){
        console.log(response);
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