class BotolDetectionJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(args)
    transaction = Transaction.find(args)
    result = Cloudinary::Uploader.upload(transaction.foto.url, :detection => "coco", :auto_tagging => 0.8)
    begin
      confidence = result["info"]["detection"]["object_detection"]["data"]["coco"]["tags"]["bottle"][0]["confidence"]
      if confidence > 0.7
        transaction.diterima = true
      else
        transaction.diterima = false
      end
    rescue
      transaction.diterima = false
    end
    transaction.save
  end
end
