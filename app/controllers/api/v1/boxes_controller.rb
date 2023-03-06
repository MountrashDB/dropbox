class Api::V1::BoxesController < AdminController
  before_action :check_admin_token

  def show
    box = Box.find_by(uuid: params[:uuid])
    if box
      render json: box
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  def datatable    
    render json: BoxDatatable.new(params)    
  end
  
  def create
    box = Box.new()    
    box.cycles = params[:cycles]
    box.dates = params[:dates]
    box.jenis = params[:jenis]
    box.nama = params[:nama]
    box.qty = params[:qty]
    box.revenue = params[:revenue]
    box.mitra_share = params[:mitra_share]    
    box.user_share = params[:user_share]    
    box.latitude = params[:latitude]
    box.longitude = params[:longitude]    
    box.admin_id = @current_admin.id
    box.mitra_id = Mitra.find_by(uuid: params[:mitra_uuid]).id
    if box.save
      render json: BoxBlueprint.render(box)
    else
      render json: {error: box.errors}
    end
  end

  def update    
    if box = Box.find_by(uuid: params[:uuid])
      box.qr_code = params[:qr_code]
      box.lat = params[:lat]
      box.lang = params[:lang]
      box.max = params[:max]
      box.save
      render json: box
    else
      render json: {message: "Not found"}, status: :not_found
    end    
  end

  def destroy    
    if box = Box.find_by(uuid: params[:uuid]) 
      box.delete      
      render json: {message: "Deleted"}
    else
      render json: {message: "Not found"}, status: :not_found
    end
  end

  private
end
