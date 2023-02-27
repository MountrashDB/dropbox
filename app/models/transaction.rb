# == Schema Information
#
# Table name: transactions
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Transaction < ApplicationRecord
end
