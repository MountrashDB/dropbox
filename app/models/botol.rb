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
#  merk_id    :bigint           not null
#
# Indexes
#
#  index_botols_on_merk_id  (merk_id)
#
# Foreign Keys
#
#  fk_rails_...  (merk_id => merks.id)
#
class Botol < ApplicationRecord
  belongs_to :merk  
  has_one_attached :image, dependent: :destroy, service: :cloudinary 
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
