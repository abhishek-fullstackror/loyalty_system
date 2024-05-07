# == Schema Information
#
# Table name: airport_lounge_access_rewards
#
#  id          :bigint           not null, primary key
#  reward_type :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_airport_lounge_access_rewards_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class AirportLoungeAccessReward < ApplicationRecord
  belongs_to :user
  enum reward_type: {
    standard_tier_reward: 0,
    gold_tier_reward: 1,
    platinum_tier_reward: 2
  }
end
