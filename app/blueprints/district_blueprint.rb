class DistrictBlueprint < Blueprinter::Base
    identifier :id

    fields :name, :province_id, :city_id
end
