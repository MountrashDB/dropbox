class Api::V1::TipeSampahController < AdminController
    before_action :check_admin_token

    def tipesampah_show
        tipe = TipeSampah.find_by(id: params[:id])
        if tipe     
            render json: TipeSampahBlueprint.render(tipe)
        else
          render json: { message: "Record not found" }, status: :not_found
        end
    end

    def tipesampah_destroy
        tipe = TipeSampah.find_by(id: params[:id])
        if tipe
            tipe.destroy     
            render json: TipeSampahBlueprint.render(tipe)
        else
          render json: { message: "Record not found" }, status: :not_found
        end
    end

    def tipesampah_create
        tipe = TipeSampah.new()
        tipe.name = params[:name]
        tipe.harga = params[:harga]
        tipe.active = params[:active]
        tipe.image = params[:image]
        if tipe.save
          tipe.image.attach(params[:image]) if params[:image]
          render json: TipeSampahBlueprint.render(tipe)
        else
          render json: { error: tipe.errors }
        end
      end
    
    def tipesampah_update
        tipe = TipeSampah.find_by(id: params[:id])
        if tipe
          tipe.name = params[:name]
          tipe.harga = params[:harga]
          tipe.active = params[:active]
          if tipe.save
            tipe.image.attach(params[:image]) if params[:image]
            render json: TipeSampahBlueprint.render(tipe)
          else
            render json: { error: tipe.errors }
          end
        else
          render json: { message: "Record not found" }, status: :not_found
        end
    end


  def tipesampah_datatable
    render json: TipeSampahDatatable.new(params)
  end
end
