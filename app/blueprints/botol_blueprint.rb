class BotolBlueprint < Blueprinter::Base
    identifier :id

    fields :name, :uuid, :ukuran
    association :merk, blueprint: MerkBlueprint
    
    view :show do
        field :images do |img|
            image_urls = img.images.map do |image|
                if image
                    {
                        thumb: Cloudinary::Utils.cloudinary_url(image.key, :width => 200, :height => 200, :crop => :fill),
                        full: Cloudinary::Utils.cloudinary_url(image.key),
                    }        
                end    
            end
        end
    end

    view :index do
        field :images do |img|
            if img.images[0]
                Cloudinary::Utils.cloudinary_url(img.images[0].key, :width => 200, :height => 200, :crop => :fill)
            else
                "-"
            end
        end
    end
end
