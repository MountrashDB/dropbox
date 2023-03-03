class MitraBlueprint < Blueprinter::Base
    identifier :id

    fields :uuid
    view :register do
        fields :email, :name, :activation_code, :phone
    end

    view :after_update do
        fields :email, :name, :phone
    end

    view :admin_index do
        fields :name
    end

    view :show do
        fields :email, :name, :phone
        association :kyc, blueprint: KycBlueprint
    end
end
