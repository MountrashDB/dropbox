class Api::V1::JemputanAdminController < Api::V1::AdminController
    def jemputan_update
        if Jemputan.find(params[:id]).update(status: params[:status])
            render json: { message: "Updated" }
        else
            render json: { message: "Error" }, status: :bad_request
        end
    end
end