class HomeController < ApplicationController
  def index
    render json: { message: "Server is running" }
  end

  def version
    render json: { version: 2 }
  end
end
