class NotifyController < ApplicationController
  def index
    @uuid = params[:uuid]
  end

  def box_index
    @uuid = params[:uuid]
  end

  def box_status
    @uuid = params[:uuid]
    box = Box.find_by(uuid: @uuid)
    if box
      @box = box
    else
      render "not_found"
    end
  end
end
