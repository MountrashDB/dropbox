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

    def show_harga
      if botol = Botol.find_by(uuid: params[:uuid])
        render json: BotolhargaBlueprint.render(botol.botol_harga)     
      else
        render json: {message: "Not found"}, status: :not_found
      end
    end

    def create_harga
      if botol = Botol.find_by(uuid: params[:uuid]) 
        harga = BotolHarga.new()
        harga.botol = botol
        harga.box = Box.find_by(uuid: params[:box_uuid])
        harga.harga = params[:harga]
        if harga.save
          render json: BotolhargaBlueprint.render(harga)
        else
          render json: harga.errors
        end
      else
        render json: {message: "Not found"}, status: :not_found
      end
    end

    def update_harga
      if botol = Botol.find_by(uuid: params[:uuid]) 
        harga = Botol.b
        harga.botol = botol
        harga.box = Box.find_by(uuid: params[:box_uuid])
        harga.harga = params[:harga]
        if harga.save
          render json: {message: "Success"}
        else
          render json: harga.errors
        end
      else
        render json: {message: "Not found"}, status: :not_found
      end
    end

    private
  end
  