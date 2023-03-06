class Api::V1::KycController < ApplicationController
    def province
      render json: ProvinceBlueprint.render(Province.active)
    end

    def city
        if (params[:province_id])            
            render json: CityBlueprint.render(City.where(province_id: params[:province_id]).order(name: :asc) )
        else
            render json: {message: "Not found"}, status: :not_found
        end
    end

    def district
        if (params[:province_id] && params[:city_id])            
            render json: DistrictBlueprint.render(District.where(province_id: params[:province_id], city_id: params[:city_id]).order(name: :asc) )
        else
            render json: {message: "Not found"}, status: :not_found
        end
    end

    def total_waiting
        total = Kyc.where(status: 0).count
        render json: {total: total}
    end
end