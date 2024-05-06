class TransactionsController < ApplicationController
  def new
    @transaction = Transaction.new
  end

  def create
    country_name = get_country_name
   @transaction = current_user.transactions.build(transaction_params.merge(country: country_name))
    if @transaction.save
      update_user_points(@transaction.user)
      redirect_to root_path, notice: 'Transaction created successfully!'
    else
      render :new, locals: { error: @transaction.errors }, status: :unprocessable_entity
    end
  end

  private
  
  def transaction_params
    params.require(:transaction).permit(:amount)
  end

  def update_user_points(user)
    points_earned = (user.total_spent / 100) * 10
    points_earned *= 2 if user.foreign_transactions.any?
    user.loyalty_points.create(points: points_earned.to_i)
    points_earned.to_i
  end

  def get_country_name
    ip_address = request.ip
    location_data = Geocoder.search(ip_address)
    location_data.first&.country || "IN"
  end

end


