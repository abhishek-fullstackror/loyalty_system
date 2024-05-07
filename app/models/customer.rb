# == Schema Information
#
# Table name: customers
#
#  id         :bigint           not null, primary key
#  user_type  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_customers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Customer < ApplicationRecord
  belongs_to :user
  
  enum user_type: {
    standard_tier: 0,
    gold_tier: 1,
    platinum_tier: 2
  }
  
end
