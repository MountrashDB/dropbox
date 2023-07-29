class NotifyController < ApplicationController
  def index
    @uuid = params[:uuid]
  end
end
