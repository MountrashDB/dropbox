# == Schema Information
#
# Table name: outlets
#
#  id                     :bigint           not null, primary key
#  active                 :boolean
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_outlets_on_email                 (email) UNIQUE
#  index_outlets_on_reset_password_token  (reset_password_token) UNIQUE
#
require "test_helper"

class OutletTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
