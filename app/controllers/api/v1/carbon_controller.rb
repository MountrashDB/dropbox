class Api::V1::CarbonController < ApplicationController
    skip_before_action :verify_authenticity_token

    def list
        box = Box.order(botol_total: :desc)
        if box
          render json: CarbonBlueprint.render(box.limit(50), view: :carbon)
        else
          render json: { message: "Not found" }, status: :not_found
        end
    end
end
