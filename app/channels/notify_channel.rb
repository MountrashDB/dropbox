class NotifyChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "NotifyChannel_#{params[:uuid]}"
    @uuid = params[:uuid]
    stream_for @uuid
  end

  # NotifyChannel.broadcast_to "abcd", image: "http://www.google.com", diterima: true

  def receive(data)
    # NotifyChannel.broadcast_to("abcd", message: "Hello dah")
    # ActionCable.server.broadcast("NotifyChannel", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
