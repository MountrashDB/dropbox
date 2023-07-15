class Api::V1::Partner::PartnerController < PartnerController
  before_action :check_partner_token, only: [
                                        :change_password,
                                        :dashboard,
                                        :recent,
                                      ]

  if Rails.env.production?
    @@token_expired = 3.days.to_i
  else
    @@token_expired = 30.days.to_i
  end

  def register
    partner = Partner.new()
    partner.nama = params[:nama]
    partner.email = params[:email]
    partner.handphone = params[:handphone]
    partner.nama_usaha = params[:nama_usaha]
    partner.alamat_kantor = params[:alamat_kantor]
    partner.password = params[:password]
    if partner.save
      render json: PartnerBlueprint.render(partner, view: :login)
    else
      render json: { error: partner.errors }
    end
  end

  def verify
    partner = Partner.find_by(uuid: params[:uuid], verified: nil)
    if partner.save
      render json: PartnerBlueprint.render(partner, view: :login)
    else
      render json: { error: partner.errors }
    end
  end

  def login
    partner = Partner.find_by(email: params[:email])
    if partner && partner.authenticate(params[:password])
      if partner.verified
        payload = {
          uuid: partner.uuid,
          exp: Time.now.to_i + @@token_expired,
        }
        jwt = JWT.encode payload, ENV["secret_key_base"], ENV["token_algorithm"]
        render json: { uuid: partner.uuid, jwt: jwt, email: partner.email, nama: partner.nama, api_key: partner.api_key, api_secret: partner.api_secret }
      else
        render json: { message: "Not yet verified" }, status: :not_found
      end
    else
      render json: { message: "Email or password not match" }, status: :not_found
    end
  end

  def verify
    partner = Partner.find_by(uuid: params[:uuid], verified: nil)
    if partner
      partner.update(verified: true)
      render json: PartnerBlueprint.render(partner, view: :login)
    else
      render json: { message: "Not found or already verified" }, status: :not_found
    end
  end

  def change_password
    partner = Partner.find_by(email: @current_partner.email, verified: true, approved: true)
    if partner && partner.authenticate(params[:old_password])
      partner.password = params[:new_password]
      if partner.save
        render json: { message: "Changed" }
      else
        render json: { error: partner.errors }
      end
    else
      render json: { message: "Old password not match" }, status: :not_found
    end
  end

  def dashboard
    render json: Partner.dashboard(@current_partner.id)
  end

  def recent
    users = User.where(partner_id: @current_partner.id).order(created_at: :desc).limit(10)
    render json: UserBlueprint.render(users, view: :register)
  end
end
