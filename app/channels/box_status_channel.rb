class BoxStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "BoxStatusChannel_#{params[:uuid]}"        
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
