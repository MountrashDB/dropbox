# == Schema Information
#
# Table name: histories
#
#  id          :bigint           not null, primary key
#  amount      :float(24)
#  description :string(255)
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_histories_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class History < ApplicationRecord
  belongs_to :user, optional: true
end
