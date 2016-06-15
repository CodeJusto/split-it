module CartsHelper

  #defines the percentage of the goal that the cart
  #is currently at
  def cart_progress(total_paid, goal)
    return 0 if goal == 0
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

  def update_user_address(user_params)
    # binding.pry
    current_user.update(street_address: user_params["cart"]["street_address"], 
                        street_address2: user_params["cart"]["street_address2"],
                        country: user_params["cart"]["country"],
                        city: user_params["cart"]["city"],
                        province: user_params["cart"]["province"],
                        zip_code: user_params["cart"]["zip_code"],
                        )
    current_user.save!
    binding.pry
  end

end
