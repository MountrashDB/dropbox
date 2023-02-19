class Botol < ApplicationRecord
  belongs_to :merk  
  has_many_attached :images, dependent: :destroy, service: :cloudinary do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :full, resize_to_limit: [500, 500]
  end
  before_create :set_uuid

  def set_uuid
      self.uuid = SecureRandom.uuid
  end
end
