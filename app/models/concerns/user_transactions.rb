# app/models/concerns/user_transactions.rb
module UserTransactions
    extend ActiveSupport::Concern
    
      included do
        has_many :transactions
        has_one :loyalty_point
        has_one :customer
        validates :email, presence: true, uniqueness: true
        validates :name, presence: true
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
        devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
        # CALLBACKS
        after_commit :check_free_coffee_reward
        after_save :update_user_tier
        before_update :expire_points
      end

    def total_spent
      transactions.sum(:amount)
    end
    
    def foreign_transactions
      transactions.where(country: 'foreign')
    end
    
    def check_free_coffee_reward
      if loyalty_point && loyalty_point.points >= 100 && !free_coffee_reward
        update(free_coffee_reward: true)
      end
    end

    def check_birthday_reward?
      today = Date.today
      if today.month == birthday_month.to_i && !free_coffee_reward
        update(free_coffee_reward: true)
      end
     return today.month == birthday_month.to_i
    end

    def eligible_for_cash_rebate?
      transactions.count >= 10 && transactions.where("amount > ?", 100).exists?
    end
    
    def eligible_for_free_movie_tickets?
      transactions.where("created_at >= ?", 60.days.ago).sum(:amount) > 1000
    end

    def points
      self.loyalty_point&.points
    end

    # Logic for expire points every year
    def expire_points
      self.loyalty_point&.destroy  if self.loyalty_point&.created_at < 1.year.ago
    end

    # Call this method to update user tier based on points
    def update_user_tier
      points = self.loyalty_point&.points
      self.create_customer(user_type: :standard_tier) unless self.customer.present?
      self.customer.user_type = if points && points >= 5000
                        :platinum_tier
                      elsif points && points >= 1000
                        :gold_tier
                      else
                        :standard_tier
                      end
      self.customer.update_columns(user_type: self.customer.user_type)
    end

    def calculate_user_tier
      # Logic to calculate user tier based on the highest points in the last two cycles
      last_two_cycles_points = user.loyalty_point.points if loyalty_point.created_at >=  2.years.ago
      
      customer.user_type = if last_two_cycles_points >= 5000
                             :platinum_tier
                           elsif last_two_cycles_points >= 1000
                             :gold_tier
                           else
                             :standard_tier
                           end
      customer.save
    end

    def award_airport_lounge_access_reward
      if customer.user_type_changed? && customer.user_type.to_sym == :gold_tier
        # Award 4x Airport Lounge Access Reward
        4.times do
          AirportLoungeAccessReward.create(user_id: customer.user_id, reward_type: :gold_tier_reward)
        end
      end
    end

    def award_bonus_points
      
      current_date = Time.current
      quarter_start = current_date.beginning_of_quarter
      quarter_end = current_date.end_of_quarter
    
     
      total_spending = transactions.where(transaction_type: :purchase)
                                   .where('created_at >= ? AND created_at <= ?', quarter_start, quarter_end)
                                   .sum(:amount)
    
      
      if total_spending > 2000
        loyalty_points.create(points: 100, reason: 'Quarterly spending bonus')
      end
    end
   
end