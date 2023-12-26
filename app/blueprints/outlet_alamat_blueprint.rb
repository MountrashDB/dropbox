class OutletAlamatBlueprint < Blueprinter::Base
    identifier :id
    fields :name, :phone, :alamat, :pic
    field :foto do |data|
        if data
            data.foto.url
        else
            "-"
        end
    end
end
