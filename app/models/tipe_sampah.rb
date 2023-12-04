# == Schema Information
#
# Table name: tipe_sampahs
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  harga      :float(24)
#  image_url  :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#  == Schema Information
#
# Table name: tipe_sampahs
#
#  id         :bigint           not null, primary key
#  harga      :float(24)
#  image_url  :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TipeSampah < ApplicationRecord
  validates :name, length: { in: 1..35 }, presence: true
  validates :harga, presence: true
  has_one_attached :image, dependent: :destroy, service: :local
end
