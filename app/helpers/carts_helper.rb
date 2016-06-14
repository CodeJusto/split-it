module CartsHelper

  #defines the percentage of the goal that the cart
  #is currently at
  def cart_progress(total_paid, goal)
    ((total_paid.to_f / goal.to_f) * 100).ceil
  end

  # def check_minimum_payment(goal, minimum_payment)
  #   new_total = goal + minumum_payment 
  #   if new_total > goal
  #     minimum_payment = new_total - goal
  #   else
  #     minumum_payment = minimum_payment
  #   end
  # end

  def get_cart_payments(id)
    payments = Payment.where(cart_id: id)
    payments.select { | payment | payment.refund == nil }
  end

  def calculate_total_payments(array)
    values = array.map(&:amount)
    values.inject(0){ |sum,x| sum + x }
  end

end
