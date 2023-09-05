class UserBlueprint < Blueprinter::Base
  identifier :id

  view :order_sampah do
    fields :email, :username, :phone
  end

  view :register do
    fields :uuid, :email, :username, :active_code, :phone, :active
  end
end
