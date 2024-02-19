class Api::V1::UserLanggananController < AdminController
    before_action :check_user_token
    
    def check_voucher        
        today = Date.today
        voucher = Voucher.where('avai_start <= ? AND avai_end >= ? AND code = ? AND status = "paid"', today, today, params[:code].to_i)
        if voucher.first
            render json: voucher.first
        else
            render json: {message: "Voucher not found or not yet activated"}, status: :not_found
        end
    end

    def jam_jemput
        render json: JamJemputBlueprint.render(JamJemput.order(urut: :asc))
    end

    def alamat_jemput
        render json: AlamatJemputBlueprint.render(AlamatJemput.where(user: @current_user))
    end

    def order_jemput
        jemputan = Jemputan.new
        jemputan.gambar = params[:gambar] 
        jemputan.tanggal = params[:tanggal]
        jemputan.berat = params[:berat]
        jemputan.alamat_jemput_id = params[:alamat_jemput_id]
        jemputan.jam_jemput_id = params[:jam_jemput_id]
        jemputan.catatan = params[:catatan]
        jemputan.user = @current_user
        jemputan.voucher = params[:voucher]
        if jemputan.save            
            if params[:tipe_sampahs]
                tipes = params[:tipe_sampahs].split(",")
                tipes.each do |tp|
                    jemputan.jemputan_tipe_sampahs.create!(tipe_sampah_id: tp)
                end
            end
            render json: JemputanBlueprint.render(jemputan)
        else
            render json: jemputan.errors
        end
    end

    def order_send
        jemputan = Jemputan.find_by(uuid: params[:uuid], user: @current_user)
        if jemputan
            begin
                jemputan.sending!
                render json: {message: "Success"}
            rescue 
                render json: { message: "Failed" }, status: :bad_request
            end 
        else
            render json: { message: "Data not found" }, status: :not_found
        end
    end

    def detail
        jemputan = Jemputan.find_by(uuid: params[:uuid], user: @current_user)
        if jemputan
            render json: JemputanBlueprint.render(jemputan)
        else
            render json: { message: "Data not found" }, status: :not_found
        end
    end

    def order_cancel
        jemputan = Jemputan.find_by(uuid: params[:uuid], user: @current_user)
        if jemputan
            begin
                jemputan.cancelling!
                render json: {message: "Success cancelled"}
            rescue 
                render json: { message: "Failed" }, status: :bad_request
            end 
        else
            render json: { message: "Data not found" }, status: :not_found
        end
    end
end
