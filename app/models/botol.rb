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
#
class Botol < ApplicationRecord
  has_many :botol_harga, dependent: :destroy
  has_one_attached :primary_image, dependent: :destroy, service: :cloudinary 
  has_many_attached :images, dependent: :destroy, service: :cloudinary 
  before_create :set_uuid

  def set_uuid
      self.uuid = SecureRandom.uuid
  end

  def image
    if self.images[0].key
      Cloudinary::Utils.cloudinary_url(self.images[0].key, :width => 200, :height => 200, :crop => :fill)
    end
  end
end
