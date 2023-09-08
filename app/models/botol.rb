# == Schema Information
#
# Table name: botols
#
#  id         :bigint           not null, primary key
#  barcode    :string(255)
#  jenis      :string(255)
#  name       :string(255)
#  product    :string(255)
#  ukuran     :string(255)
#  uuid       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Botol < ApplicationRecord
  has_many :botol_harga, dependent: :destroy
  has_one_attached :primary_image, dependent: :destroy
  has_many_attached :images, dependent: :destroy do |attachable|
    attachable.variant :fix, resize_to_limit: [300, 300]
  end
  before_create :set_uuid

  SERVER_VALIDATION = "https://bottlenobottle.hasbala.cloud/predict"

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def image
    if self.images[0].key
      Cloudinary::Utils.cloudinary_url(self.images[0].key, :width => 300, :height => 300, :crop => :fill)
    end
  end

  def self.validate(foto)
    result = Cloudinary::Uploader.upload(foto, :detection => "coco", :auto_tagging => 0.8)
    # begin
    #   url = URI.parse(SERVER_VALIDATION)
    #   https = Net::HTTP.new(url.host, url.port)
    #   https.use_ssl = true
    #   request = Net::HTTP::Post.new(url)
    #   request["Content-Type"] = "application/json"
    #   request.body = JSON.dump({
    #     "url": image_url,
    #   })
    #   response = https.request(request)
    #   result = JSON.parse(response.read_body)
    #   is_botol = false
    #   result.each do |data|
    #     prob = data["probability"] * 100
    #     if prob > 75
    #       is_botol = true
    #       break
    #     end
    #   end
    #   is_botol
    # rescue # Jaga-jaga kalo server validationnya ngadat
    #   true
    # end
  end
end
