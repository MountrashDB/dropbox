class Api::V1::MerksController < ApplicationController
  def index
    render json: Merk.all
  end

  def show
    merk = Merk.find_by(uuid: params[:uuid])
    if merk
      render json: merk
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def datatable    
    render json: MerkDatatable.new(params)    
  end

  def create
    merk = Merk.new()
    merk.name = params[:name]
    if merk.save
      render json: merk
    else
      render json: merk.errors
    end
  end

  def update
    merk = Merk.find_by(uuid: params[:uuid])
    if merk
      merk.name = params[:name]
      merk.save
      render json: merk
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def destroy    
    if merk = Merk.find_by(uuid: params[:uuid])
      merk.delete
      render json: {message: "Deleted"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  private
end
