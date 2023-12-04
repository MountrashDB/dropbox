class TipeSampahBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :harga, :active
  field :image_url do |data|
    if data
        data.image.url
    else
        "-"
    end
end
end
