# == Schema Information
#
# Table name: partners
#
#  id              :bigint           not null, primary key
#  alamat_kantor   :text(65535)
#  api_key         :string(255)
#  api_secret      :string(255)
#  approved        :boolean
#  email           :string(255)
#  handphone       :string(255)
#  nama            :string(255)
#  nama_usaha      :string(255)
#  password_digest :string(255)
#  uuid            :string(255)
#  verified        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class PartnerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
