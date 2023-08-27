class HargaSampahBlueprint < Blueprinter::Base
  fields :harga_kg, :harga_satuan
  association :tipe_sampah, blueprint: TipeSampahBlueprint
  association :banksampah, blueprint: TipeSampahBlueprint
end
