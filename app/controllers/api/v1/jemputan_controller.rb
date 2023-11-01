class Api::V1::JemputanController < AdminController
  before_action :check_user_token

  @@fee_jemput = 2.5 # In percentage

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
    data.phone = params[:phone]
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
      data.phone = params[:phone]
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

  def jemputan_create
    ActiveRecord::Base.transaction do
      puts params
      data = Jemputan.new()
      data.catatan = params[:catatan]
      data.tanggal = params[:tanggal]
      data.jam_jemput_id = params[:jam_jemput_id]
      data.alamat_jemput_id = params[:alamat_jemput_id]
      data.user_id = @current_user.id
      if data.save
        detail = params[:detail]
        total = 0
        detail.map do |d|
          tipe_sampah_id = d["tipe_sampah_id"].to_i
          tipe_sampah = TipeSampah.find(tipe_sampah_id)
          qty = d["qty"].to_i
          sub_total = qty * tipe_sampah.harga
          jd = JemputanDetail.new()
          jd.harga = tipe_sampah.harga
          jd.qty = qty
          jd.sub_total = sub_total
          jd.jemputan_id = data.id
          jd.tipe_sampah_id = tipe_sampah_id
          jd.save
          total += sub_total
        end      
        data.total = total
        data.fee = @@fee_jemput/100 * total
        data.save
        render json: JemputanBlueprint.render(data)
      else
        render json: { message: "Failed", error: data.error}, status: :bad_request
      end
    end # Transaction
  end

  def jemputan_show
    if jemputan = Jemputan.find(params[:id])
      render json: JemputanBlueprint.render(jemputan)
    else
      render json: { message: "Not found"}, status: :not_found
    end
  end

  def jemputan_delete
    if jemputan = @current_user.jemputans.find_by(id: params[:id])
      jemputan.destroy
      render json: { message: "Deleted"}
    else
      render json: { message: "Not found"}, status: :not_found
    end
  end
end
