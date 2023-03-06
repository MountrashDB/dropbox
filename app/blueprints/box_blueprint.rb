class BoxBlueprint < Blueprinter::Base
    identifier :id

    fields :nama, 
        :uuid,
        :qr_code,
        :qty,
        :cycles, 
        :dates, 
        :jenis, 
        :latitude, 
        :longitude, 
        :mitra_share, 
        :user_share, 
        :type_progress,
        :created_at,
        :updated_at
    association :mitra, blueprint: MitraBlueprint
end
