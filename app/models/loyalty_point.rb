# == Schema Information
#
# Table name: loyalty_points
#
#  id         :bigint           not null, primary key
#  points     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_loyalty_points_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class LoyaltyPoint < ApplicationRecord
  belongs_to :user
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }
end
