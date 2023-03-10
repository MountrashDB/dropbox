class Api::V1::MitrasController < ApplicationController
  def index
    render json: Mitra.all
  end

  def show
    mitra = Mitra.find_by(uuid: params[:uuid])
    if mitra
      render json: mitra
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def datatable    
    render json: MitraDatatable.new(params)    
  end

  def create
    mitra = Mitra.new()
    mitra.name = params[:name]
    mitra.contact = params[:contact]
    mitra.email = params[:email]
    mitra.phone = params[:phone]
    mitra.address = params[:address]
    if mitra.save
      render json: mitra
    else
      render json: mitra.errors
    end
  end

  def update
    mitra = Mitra.find_by(uuid: params[:uuid])
    if mitra
      mitra.name = params[:name]
      mitra.contact = params[:contact]
      mitra.email = params[:email]
      mitra.phone = params[:phone]
      mitra.address = params[:address]
      mitra.save
      render json: mitra
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def destroy    
    if mitra = Mitra.find_by(uuid: params[:uuid])
      mitra.delete
      render json: {message: "Deleted"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  private
end
