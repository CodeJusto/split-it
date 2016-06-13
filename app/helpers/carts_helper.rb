module CartsHelper

  #defines the percentage of the goal that the cart
  #is currently at
  def cart_progress(total_paid, goal)
    ((total_paid.to_f / goal.to_f) * 100).ceil
  end

end
