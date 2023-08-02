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
        transaction.mitra_amount = 0
        transaction.user_amount = 0
        transaction.diterima = false
        NotifyChannel.broadcast_to transaction.user.uuid,
                                   status: "complete",
                                   image: transaction.foto.url,
                                   point: 0,
                                   diterima: false,
                                   message: "Rejected"
      end
    rescue
      transaction.mitra_amount = 0
      transaction.user_amount = 0
      NotifyChannel.broadcast_to transaction.user.uuid,
                                 status: "complete",
                                 image: transaction.foto.url,
                                 point: 0,
                                 diterima: false,
                                 message: "Rejected"
      transaction.diterima = false
    end
    transaction.save
  end
end
