# == Schema Information
#
# Table name: server_responses
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  headers    :text(65535)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ServerResponse < ApplicationRecord
end
