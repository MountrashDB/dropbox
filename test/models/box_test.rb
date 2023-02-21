# == Schema Information
#
# Table name: boxes
#
#  id         :bigint           not null, primary key
#  lang       :string(255)
#  lat        :string(255)
#  max        :integer
#  qr_code    :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class BoxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
