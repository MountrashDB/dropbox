# == Schema Information
#
# Table name: botols
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  ukuran     :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  merk_id    :bigint
#
# Indexes
#
#  index_botols_on_merk_id  (merk_id)
#
# Foreign Keys
#
#  fk_rails_...  (merk_id => merks.id)
#
require "test_helper"

class BotolTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
