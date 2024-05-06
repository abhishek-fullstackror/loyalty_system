# app/models/concerns/user_transactions.rb
module UserTransactions
    extend ActiveSupport::Concern
    
    included do
        has_many :transactions
        has_one :loyalty_point
        validates :email, presence: true, uniqueness: true
        validates :name, presence: true
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
   
end