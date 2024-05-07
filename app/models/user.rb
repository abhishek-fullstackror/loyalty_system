# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthday_month         :string
#  email                  :string(255)
#  encrypted_password     :string           default(""), not null
#  free_coffee_reward     :boolean          default(FALSE)
#  name                   :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
    include UserTransactions
end
