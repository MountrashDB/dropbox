class AdminController < ApplicationController
  skip_before_action :verify_authenticity_token
  include Pagy::Backend

  private

  def check_admin_token
    begin
      if !@current_admin = Admin.get_admin(request.headers)
        render json: { error: true, message: t("error.admin.token_error") }, status: :unauthorized
      end
    rescue
      render json: { error: true, message: t("error.admin.need_login") }, status: :unauthorized
    end
  end

  def check_mitra_token
    begin
      if !@current_mitra = Mitra.get_mitra(request.headers)
        render json: { error: true, message: t("error.admin.token_error") }, status: :unauthorized
      end
    rescue
      render json: { error: true, message: t("error.admin.need_login") }, status: :unauthorized
    end
  end

  def check_user_token
    begin
      if !@current_user = User.get_user(request.headers)
        render json: { error: true, message: t("error.admin.token_error") }, status: :unauthorized
      end
    rescue
      render json: { error: true, message: t("error.admin.need_login") }, status: :unauthorized
    end
  end

  def check_outlet_token
    begin
      if !@current_outlet = Outlet.get_outlet(request.headers)
        render json: { error: true, message: t("error.admin.token_error") }, status: :unauthorized
      end
    rescue
      render json: { error: true, message: t("error.admin.need_login") }, status: :unauthorized
    end
  end

  def check_banksampah_token
    begin
      if !@current_banksampah = Banksampah.get_banksampah(request.headers)
        render json: { error: true, message: t("error.admin.token_error") }, status: :unauthorized
      end
    rescue
      render json: { error: true, message: t("error.admin.need_login") }, status: :unauthorized
    end
  end
end
