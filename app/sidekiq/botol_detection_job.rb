class BotolDetectionJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(uid)
    transaction = Transaction.find(uid)
    # result = Cloudinary::Uploader.upload(transaction.foto.url, :detection => "coco", :auto_tagging => 0.5)
    Rails.logger.error "=== uid ==="
    Rails.logger.error uid
    Rails.logger.error "=== Checking ==="
    # begin
    # confidence = result["info"]["detection"]["object_detection"]["data"]["coco"]["tags"]["bottle"][0]["confidence"]
    transaction.diterima = true
    #   confidence = 0.8 # Untuk sementara
    #   if confidence > 0.5
    #     transaction.diterima = true
    #   else
    #     Rails.logger.error "=== Rejected ==="
    #     transaction.mitra_amount = 0
    #     transaction.user_amount = 0
    #     transaction.diterima = false
    #     NotifyChannel.broadcast_to transaction.user.uuid,
    #                                status: "complete",
    #                                image: transaction.foto.url,
    #                                point: 0,
    #                                diterima: false,
    #                                message: "Rejected"
    #   end
    # rescue Exception => e
    #   Rails.logger.error "=== Error Detection ==="
    #   Rails.logger.error e
    #   transaction.mitra_amount = 0
    #   transaction.user_amount = 0
    #   NotifyChannel.broadcast_to transaction.user.uuid,
    #                              status: "complete",
    #                              image: transaction.foto.url,
    #                              point: 0,
    #                              diterima: false,
    #                              message: "Rejected"
    #   transaction.diterima = false
    # end
    transaction.save
  end
end
