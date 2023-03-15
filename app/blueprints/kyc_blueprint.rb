class KycBlueprint < Blueprinter::Base
    identifier :id

    fields :uuid, 
            :agama, 
            :desa, 
            :nama, 
            :no_ktp, 
            :pekerjaan, 
            :rt, 
            :rw, 
            :status, 
            :tgl_lahir,
            :tempat_tinggal
    association :province, blueprint: ProvinceBlueprint
    association :city, blueprint: CityBlueprint
    association :district, blueprint: DistrictBlueprint

    field :ktp_image do |data|
        if data
            data.ktp_image.url
        else
            "-"
        end
    end
end
