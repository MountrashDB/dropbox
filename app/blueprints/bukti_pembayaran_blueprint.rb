class BuktiPembayaranBlueprint < Blueprinter::Base
    identifier :id
    fields :nominal, :created_at, :updated_at
    association :mitra, blueprint: MitraBlueprint
    association :admin, blueprint: AdminBlueprint
end
