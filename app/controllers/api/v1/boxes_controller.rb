class Api::V1::BoxesController < AdminController
  before_action :check_admin_token

  def show
    box = Box.find_by(uuid: params[:uuid])
    if box
      render json: box
    else
      render json: { message: "Not found" }, status: :not_found
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
    box.type_progress = params[:type_progress]
    box.mitra_share = params[:mitra_share]
    box.user_share = params[:user_share]
    box.latitude = params[:latitude]
    box.longitude = params[:longitude]
    box.price_pcs = params[:price_pcs]
    box.price_kg = params[:price_kg]
    box.admin_id = @current_admin.id
    box.mitra_id = Mitra.find_by(uuid: params[:mitra_uuid]).id
    if box.save
      render json: BoxBlueprint.render(box)
    else
      render json: { error: box.errors }
    end
  end

  def update
    if box = Box.find_by(uuid: params[:uuid])
      box.cycles = params[:cycles]
      box.dates = params[:dates]
      box.jenis = params[:jenis]
      box.nama = params[:nama]
      box.qty = params[:qty]
      box.revenue = params[:revenue]
      box.type_progress = params[:type_progress]
      box.mitra_share = params[:mitra_share]
      box.user_share = params[:user_share]
      box.latitude = params[:latitude]
      box.longitude = params[:longitude]
      box.price_pcs = params[:price_pcs]
      box.price_kg = params[:price_kg]
      box.admin_id = @current_admin.id
      if mitra = Mitra.find_by(uuid: params[:mitra_uuid])
        box.mitra_id = mitra.id
      end
      if box.save
        render json: BoxBlueprint.render(box)
      else
        render json: { error: box.errors }
      end
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def destroy
    if box = Box.find_by(uuid: params[:uuid])
      box.delete
      render json: { message: "Deleted" }
    else
      render json: { message: "Not found" }, status: :not_found
    end
  end

  def list
    if params[:search]
      box = Box.where("LOWER(nama) LIKE ?", "%" + params[:search].downcase + "%").order(nama: :asc)
      render json: BoxBlueprint.render(box)
    else
      render json: BoxBlueprint.render(Box.all.order(nama: :asc))
    end
  end

  private
end
