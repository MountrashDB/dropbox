# == Schema Information
#
# Table name: banks
#
#  id         :bigint           not null, primary key
#  is_active  :boolean
#  kode_bank  :string(255)
#  name       :string(255)
#  url_image  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bank < ApplicationRecord
  def self.bank_list
    # Async do
    #   puts "=== READ ==="
    #   internet = Async::HTTP::Internet.new
    #   response = internet.get("https://news.mountrash.com/feed/").read
    #   # Process the response here
    #   return response.read
    # end
  end
end
