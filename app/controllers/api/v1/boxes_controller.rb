class Api::V1::BoxesController < ApplicationController
  def index
    render json: Box.all
  end

  def show
    box = Box.find_by(uuid: params[:uuid])
    if box
      render json: box
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def datatable    
    render json: BoxDatatable.new(params)    
  end

  def create
    box = Box.new()
    box.qr_code = params[:qr_code]
    box.lat = params[:lat]
    box.lang = params[:lat]
    box.max = params[:max]
    box.save
    render json: box
  end

  def update    
    if box = Box.find_by(uuid: params[:uuid])
      box.qr_code = params[:qr_code]
      box.lat = params[:lat]
      box.lang = params[:lang]
      box.max = params[:max]
      box.save
      render json: box
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def destroy    
    if box = Box.find_by(uuid: params[:uuid]) 
      box.delete      
      render json: {message: "Deleted"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  private
end
