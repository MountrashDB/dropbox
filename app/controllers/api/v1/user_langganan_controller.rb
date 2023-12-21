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
end
