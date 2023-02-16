class Api::V1::UsersController < ApplicationController
  def index
    render json: User.all
  end

  def show
    user = User.find_by(uuid: params[:uuid])
    if user
      render json: user
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def datatable    
    render json: UserDatatable.new(params)    
  end

  def create
    user = User.new()
    user.name = params[:name]
    user.email = params[:email]
    user.active = params[:active]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    if user.save
      render json: user
    else
      render json: user.errors
    end
  end

  def update
    user = User.find_by(uuid: params[:uuid])
    if user
      user.name = params[:name]
      user.email = params[:email]      
      user.active = params[:active]
      user.save
      render json: user
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def destroy    
    if user = User.find_by(uuid: params[:uuid])
      user.delete
      render json: {message: "Deleted"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  private
end
