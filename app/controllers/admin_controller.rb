class AdminController < ApplicationController
    # skip_before_action :verify_authenticity_token
    include Pagy::Backend

    private
    def check_token      
      begin       
        if !@current_user = Admin.get_admin(request.headers)   
          render json: {error: true, message: t('error.admin.token_error')}, status: :unauthorized
        end
      rescue
        render json: {error: true, message: t('error.admin.need_login')}, status: :unauthorized
      end
    end
end
