class Api::V1::BotolsController < ApplicationController
    def index
      render json: BotolBlueprint.render(Botol.all, view: :index)
    end
  
    def show
      botol = Botol.find_by(uuid: params[:uuid])
      if botol
        render json: BotolBlueprint.render(botol, view: :show)
      else
        render json: {message: "Not found"}, status: :not_found
      end
    end
  
    def datatable    
      render json: BotolDatatable.new(params)    
    end
  
    def create
      botol = Botol.new()
      botol.name = params[:name]
      botol.ukuran = params[:ukuran]
      botol.merk_id = params[:merk_id]
      botol.images.attach(params[:images])
      if botol.save
        botol.save
        render json: BotolBlueprint.render(botol, view: :show)
      else
        render json: botol.errors
      end
    end
  
    def update    
      if botol = Botol.find_by(uuid: params[:uuid])
        botol.name = params[:name]
        botol.ukuran = params[:ukuran]
        botol.merk_id = params[:merk_id]
        if params[:images]
            botol.images.attach(params[:images])
        end
        botol.save
        render json: botol
      else
        render json: {message: "Not found"}, status: :not_found
      end    
    end
  
    def destroy    
      if botol = Botol.find_by(uuid: params[:uuid]) 
        botol.images.purge
        botol.delete      
        render json: {message: "Deleted"}
      else
        render json: {message: "Not found"}, status: :not_found
      end
    end
  
    private
  end
  