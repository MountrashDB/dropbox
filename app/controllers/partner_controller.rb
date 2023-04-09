class PartnerController < ActionController::API
  def check_partner_token
    begin
      if !@current_partner = Partner.get_header(request.headers)
        render json: { error: true, message: I18n.t("error.admin.token_error") }, status: :unauthorized
      end
    rescue
      render json: { error: true, message: I18n.t("error.admin.need_login") }, status: :unauthorized
    end
  end
end
