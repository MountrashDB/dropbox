class BotolDetectionJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(uid)
    transaction = Transaction.find(uid)
    result = Cloudinary::Uploader.upload(transaction.foto.url, :detection => "coco")
    foto_url = transaction.foto.url
    begin
      # confidence = result["info"]["detection"]["object_detection"]["data"]["coco"]["tags"]["bottle"][0]["confidence"]
      # confidence = result["info"]["detection"]["object_detection"]["data"]["openimages"]["tags"]["bottle"][0]["confidence"]
      confidence = 0.7
      if confidence > 0.5
        transaction.diterima = true
        Box.reset_failed(transaction.box_id)
      else
        transaction.mitra_amount = 0
        transaction.user_amount = 0
        transaction.diterima = false
        Box.insert_failed(transaction.box_id)
        ActionCable.server.broadcast("NotifyChannel_#{transaction.user.uuid}", {
          status: "complete",
          image: foto_url,
          point: 0,
          diterima: false,
          message: "Rejected",
        })
      end
    rescue => e
      transaction.mitra_amount = 0
      transaction.user_amount = 0
      transaction.diterima = false
      puts "=== ERROR ==="
      puts e
      Box.insert_failed(transaction.box_id)
      ActionCable.server.broadcast("NotifyChannel_#{transaction.user.uuid}", {
        status: "complete",
        image: foto_url,
        point: 0,
        diterima: false,
        message: "Rejected",
      })
    end
    transaction.save
  end
end
