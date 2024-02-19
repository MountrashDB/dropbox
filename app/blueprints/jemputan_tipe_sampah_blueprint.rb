class JemputanTipeSampahBlueprint < Blueprinter::Base
    identifier :id
    association :tipe_sampah, blueprint: TipeSampahBlueprint
end
