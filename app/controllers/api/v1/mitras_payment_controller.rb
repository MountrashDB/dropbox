class Api::V1::MitrasPaymentController   < Api::V1::MitrasController
    before_action :check_mitra_token
    
    def create_payment
        bukti = BuktiPembayaran.new
        bukti.nominal = params[:nominal] 
        bukti.image = params[:image]       
        bukti.mitra = @current_mitra
        if bukti.save
            render json: {message: "Terima kasih. Bukti pembayaran Anda akan segera dicek dan diproses oleh Admin"}
        else
            render json: {message: bukti.errors}, status: :bad_request
        end
    end
end