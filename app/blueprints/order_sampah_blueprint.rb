class OrderSampahBlueprint < Blueprinter::Base
  identifier :id
  fields :sub_total, :total, :status, :uuid, :fee, :created_at, :updated_at
  association :user, blueprint: UserBlueprint, view: :order_sampah
end
