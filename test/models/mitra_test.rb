# == Schema Information
#
# Table name: mitras
#
#  id                     :bigint           not null, primary key
#  activation_code        :string(255)
#  address                :string(255)
#  avatar                 :string(255)
#  contact                :string(255)
#  dates                  :datetime
#  email                  :string(255)
#  encrypted_password     :string(255)
#  name                   :string(255)
#  phone                  :string(255)
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  status                 :integer
#  terms                  :integer
#  uuid                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  partner_id             :integer
#
require "test_helper"

class MitraTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
