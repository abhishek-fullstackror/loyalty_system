# app/models/concerns/user_transactions.rb
module UserTransactions
    extend ActiveSupport::Concern
    
    included do
        has_many :transactions
        has_many :loyalty_points
        validates :email, presence: true, uniqueness: true
        validates :name, presence: true
    end

    def total_spent
      transactions.sum(:amount)
    end
    
    def foreign_transactions
      transactions.where(country: 'foreign')
    end
   
end