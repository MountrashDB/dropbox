class Api::V1::AdminOutletController < AdminController
  def create
    outlet = Outlet.new()
    outlet.name = params[:name]
    outlet.email = params[:email]
    outlet.active = params[:active]
    outlet.phone = params[:phone]
    # outlet.city_id = params[:city_id]
    # outlet.district_id = params[:district_id]
    # outlet.province_id = params[:province_id]
    outlet.password = params[:password]
    outlet.password_confirmation = params[:password_confirmation]
    if outlet.save
      render json: outlet
    else
      render json: outlet.errors, status: :bad_request
    end
  end

  def voucher_create
    outlet = Outlet.find_by(id: params[:outlet_id])
    if outlet      
      if params[:avai_start] && params[:avai_end]
        mulai = params[:avai_start].to_date
        akhir = params[:avai_end].to_date
        days = (akhir - mulai).to_i + 1
        if days > 0
          voucher = Voucher.new()
          voucher.outlet = outlet
          voucher.avai_start = mulai
          voucher.avai_end = akhir
          voucher.days = days
          if voucher.save
            render json: VoucherBlueprint.render(voucher)
          else
            render json: voucher.errors, status: :bad_request
          end
        else
          render json: {message: "Days cannot below than zero"}, status: :bad_request
        end
      else
        render json: outlet.errors, status: :bad_request
      end
    else
      render json: {message: "Outlet not found"}, status: :not_found
    end
  end

  def show
    outlet = Outlet.find_by(id: params[:id])
    if outlet
      render json: OutletBlueprint.render(outlet)
    else
      render json: {message: "Outlet not found"}, status: :not_found
    end
  end

  def update
    outlet = Outlet.find_by(id: params[:id])
    if outlet
      outlet.name = params[:name]
      outlet.email = params[:email]
      outlet.active = params[:active]
      outlet.phone = params[:phone]
      if outlet.save
        render json: outlet
      else
        render json: outlet.errors, status: :bad_request
      end
    else
      render json: {message: "Outlet not found"}, status: :not_found
    end
  end

  def change_password
    outlet = Outlet.find_by(id: params[:id])
    if outlet
      outlet.password = params[:password]
      outlet.password_confirmation = params[:password_confirmation]
      if outlet.save
        render json: {message: "Password changed"}
      else
        render json: outlet.errors, status: :bad_request
      end
    else
      render json: {message: "Outlet not found"}, status: :not_found
    end
  end

  def destroy
    outlet = Outlet.find_by(id: params[:id])
    if outlet 
      outlet.destroy
      render json: {message: "Success deleted"}
    else
      render json: {message: "Outlet not found"}, status: :not_found
    end
  end

  def voucher_destroy
    voucher = Voucher.find_by(id: params[:id])
    if voucher
      voucher.destroy
      render json: {message: "Voucher Success deleted"}
    else
      render json: {message: "Voucher not found"}, status: :not_found
    end
  end

  def voucher_show
    voucher = Voucher.find_by(id: params[:id])
    if voucher      
      render json: VoucherBlueprint.render(voucher)
    else
      render json: {message: "Voucher not found"}, status: :not_found
    end
  end

  def voucher_update_status
    voucher = Voucher.find_by(id: params[:id])
    if voucher      
      if params[:status] == "paid" or params[:status] == "expired"
        begin
          if params[:status] == "paid"
            voucher.paying!
          else
            voucher.expiring!
          end 
          render json: VoucherBlueprint.render(voucher)
        rescue => e
          logger.fatal e
          render json: {message: "Failed update status"}, status: :bad_request
        end
      else
        render json: {message: "Voucher not found"}, status: :not_found        
      end
    else
      render json: {message: "Voucher not found"}, status: :not_found
    end
  end

  def datatable
    render json: OutletDatatable.new(params)
  end

  def voucher_datatable
    render json: VoucherDatatable.new(params)
  end
end
