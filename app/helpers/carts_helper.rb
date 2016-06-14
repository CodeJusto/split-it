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

  def convert_to_cents(num)
   (num.to_f * 100).to_i
  end

end
