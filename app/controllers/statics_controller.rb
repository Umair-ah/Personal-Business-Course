require 'stripe'
Stripe.api_key = "sk_test_51NcIGEJdM2t98eyhyW2R6HDffCWMy4msgF16bpW3Mi20ihKOgpoPItOne2lVDSmqxUDZ4ehVJLnqAYErZvimN46h00fYFnRiOL"

class StaticsController < ApplicationController
  def home
    @my_courses = current_user.access_to_courses.order(created_at: :desc)
    @user_payments = current_user.payments
  end
end