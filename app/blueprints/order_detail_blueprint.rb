class OrderDetailBlueprint < Blueprinter::Base
  identifier :id
  fields :harga, :qty, :satuan, :sub_total
  association :tipe_sampah, blueprint: TipeSampahBlueprint
end
