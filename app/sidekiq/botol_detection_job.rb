class BotolDetectionJob
  # include ActiveStorage::SetCurrent
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(uid)
    transaction = Transaction.find(uid)
    # result = Cloudinary::Uploader.upload(transaction.foto.url, :detection => "coco")
    # result = Cloudinary::Uploader.upload(transaction.foto.url, :categorization => "aws_rek_tagging")
    # puts result["info"]["data"]
    foto_url = transaction.foto.url
    begin
      # confidence = result["info"]["detection"]["object_detection"]["data"]["coco"]["tags"]["bottle"][0]["confidence"]
      # confidence = result["info"]["detection"]["object_detection"]["data"]["openimages"]["tags"]["bottle"][0]["confidence"]
      confidence = 0.7
      if confidence > 0.5
        transaction.diterima = true
        ActionCable.server.broadcast("NotifyChannel_#{transaction.user.uuid}", {
          status: "complete",
          image: foto_url,
          point: transaction.user_amount,
          diterima: true,
          message: "Congratulations you get a point of",
        })
        Box.reset_failed(transaction.box_id)
        transaction.user.history_tambahkan(transaction.user_amount, "Botol", "Diterima")
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
        transaction.user.history_tambahkan(0, "Botol", "Rejected")
      end
    rescue => e
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
      transaction.user.history_tambahkan(0, "Botol", "Rejected")
    end
    transaction.save
  end
end
