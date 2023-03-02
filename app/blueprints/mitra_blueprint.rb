class MitraBlueprint < Blueprinter::Base
    identifier :id

    view :register do
        fields :uuid, :email, :name, :activation_code, :phone
    end

    view :after_update do
        fields :uuid, :email, :name, :phone
    end
end
