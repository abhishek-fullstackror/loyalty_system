class TransactionsController < ApplicationController
  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.save
      update_user_points(@transaction.user)
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  private
  
  def transaction_params
    country_name = get_country_name
    params.require(:transaction).permit(:user_id, :amount).merge(country: country_name)
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
    country_name = location_data.first&.country if location_data.present?
  end

end


