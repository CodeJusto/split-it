module CartsHelper

  #defines the percentage of the goal that the cart
  #is currently at
  # def cart_progress(total_paid, goal)
  #   return 0 if goal == 0
  #   ((total_paid.to_f / goal.to_f) * 100).ceil
  # end

  def get_cart_payments(id)
    payments = Payment.where(cart_id: id)
    payments.select { | payment | payment.refund == nil }
  end

  # def calculate_total_payments(array)
  #   values = array.map(&:amount)
  #   values.inject(0){ |sum,x| sum + x }
  # end


end
