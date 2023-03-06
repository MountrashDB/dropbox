class MitraBlueprint < Blueprinter::Base
    identifier :id

    fields :uuid, :name
    view :register do
        fields :email, :activation_code, :phone
    end

    view :profile do        
        fields :email, :activation_code, :phone
        field :image do |data|
            if data
                data.image.url
            else
                "-"
            end
        end
    end

    view :after_update do
        fields :email, :phone
    end

    view :admin_index do
        fields :name
    end

    view :show do
        fields :email, :phone
        association :kyc, blueprint: KycBlueprint
    end
end
