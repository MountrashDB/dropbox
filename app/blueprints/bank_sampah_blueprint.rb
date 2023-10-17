class BankSampahBlueprint < Blueprinter::Base
  identifier :id
  fields :name
  view :full do
    fields :phone, :active, :email, :latitude, :longitude, :city, :district, :province
  end
end
