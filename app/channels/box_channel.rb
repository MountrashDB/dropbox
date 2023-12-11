class BoxChannel < ApplicationCable::Channel
  def subscribed
    stream_from "BoxChannel_#{params[:uuid]}"    
    @uuid = params[:uuid]    
    if box = Box.find_by(uuid: @uuid)
      box.update(online: true)
      ActionCable.server.broadcast("BoxStatusChannel_" + @uuid, {online: true})
    end
  end

  def unsubscribed
    @uuid = params[:uuid]    
    if box = Box.find_by(uuid: @uuid).update(online: false, last_online: DateTime.now)
      ActionCable.server.broadcast("BoxStatusChannel_" + box.uuid, {online: false, last_online: DateTime.now})
    end
  end
end
