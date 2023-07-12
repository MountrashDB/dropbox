# == Schema Information
#
# Table name: botols
#
#  id         :bigint           not null, primary key
#  barcode    :string(255)
#  jenis      :integer
#  name       :string(255)
#  product    :string(255)
#  ukuran     :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class BotolTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
