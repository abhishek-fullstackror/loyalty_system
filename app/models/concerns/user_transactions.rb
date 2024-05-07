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
   
end