# == Schema Information
#
# Table name: usertransactions
#
#  id          :bigint           not null, primary key
#  balance     :float(24)        default(0.0)
#  credit      :float(24)        default(0.0)
#  debit       :float(24)        default(0.0)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_usertransactions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Usertransaction < ApplicationRecord
  belongs_to :user

  after_create :send_notify

  def send_notify    
    NotifyChannel.broadcast_to self.user.uuid, status: "complete", image: Cloudinary::Utils.cloudinary_url(self.foto.key, :width => 200, :height => 200, :crop => :fill), diterima: true
  end
end
