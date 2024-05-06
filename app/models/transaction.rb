# == Schema Information
#
# Table name: transactions
#
#  id         :bigint           not null, primary key
#  amount     :decimal(10, 2)   not null
#  country    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_transactions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Transaction < ApplicationRecord
  belongs_to :user
end
