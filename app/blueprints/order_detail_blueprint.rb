class OrderDetailBlueprint < Blueprinter::Base
  identifier :id
  fields :harga, :qty, :satuan, :sub_total
  association :sampah, blueprint: SampahBlueprint
end
