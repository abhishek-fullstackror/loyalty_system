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
   
end