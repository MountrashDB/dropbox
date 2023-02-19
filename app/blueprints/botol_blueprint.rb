class BotolBlueprint < Blueprinter::Base
    identifier :id

    fields :name, :uuid, :ukuran
    association :merk, blueprint: MerkBlueprint
    
    view :show do
        field :images do |img|
            image_urls = img.images.map do |image|
                if image
                    {
                        thumb: image.variant(:thumb).url,
                        full: image.variant(:full).url,
                    }        
                end    
            end
        end
    end

    view :index do
        field :images do |img|
            if img.images[0].variant(:thumb).url
                img.images[0].variant(:thumb).url
            else
                "-"
            end
        end
    end
end
