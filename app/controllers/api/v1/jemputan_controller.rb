class Api::V1::JemputanController < AdminController
  before_action :check_user_token

  def alamat_jemput
    alamats = @current_user.alamat_jemputs.order(created_at: :desc).limit(20)
    render json: AlamatJemputBlueprint.render(alamats)
  end

  def alamat_jemput_delete
    alamat = @current_user.alamat_jemputs.find_by(id: params[:id])
    if alamat
      alamat.delete
      render json: { message: "Success" }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def alamat_jemput_create
    data = AlamatJemput.new()
    data.latitude = params[:latitude]
    data.longitude = params[:longitude]
    data.user_id = @current_user.id
    data.alamat = params[:alamat]
    data.kodepos = params[:kodepos]
    data.catatan = params[:catatan]
    if data.save
      render json: { message: "Success", alamat: data }
    else
      render json: { message: "Gagal menyimpan" }, status: :bad_request
    end
  end

  def alamat_jemput_update
    if data = @current_user.alamat_jemputs.where(id: params[:id]).first    
      data.latitude = params[:latitude]
      data.longitude = params[:longitude]
      data.alamat = params[:alamat]
      data.kodepos = params[:kodepos]
      data.catatan = params[:catatan]
      if data.save
        render json: { message: "Success", alamat: data }
      else
        render json: { message: "Gagal menyimpan" }, status: :bad_request
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def alamat_jemput_show
    data = @current_user.alamat_jemputs.where(id: params[:id])
    if data
      render json: { message: "Success", alamat: data.first }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def jam_list
    jams = JamJemput.select("id,label").order(urut: :asc)
    render json: { data: jams }
  end
end
