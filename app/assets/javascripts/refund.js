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
        var newTotal = response.updated_cart_total;
        var newProgress = response.updated_pctg;
        removePayment(paymentId);
        alert('Payment has been refunded');
        $('.total-amount').text(newTotal);
        $('.percent-of-goal').text(newProgress);
      })
    }
  });
});

var removePayment = function(paymentId){
    $('.contribution-details[data-payment-id=' + paymentId + ']').fadeOut(function(){
        $(this).remove();        
    });
}