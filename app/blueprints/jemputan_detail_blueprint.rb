class JemputanDetailBlueprint < Blueprinter::Base
    identifier :id
    fields :harga, :qty, :sub_total
    association :tipe_sampah, blueprint: TipeSampahBlueprint
end
