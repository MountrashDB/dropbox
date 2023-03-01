class UserBlueprint < Blueprinter::Base
    identifier :id

    view :register do
        fields :uuid, :email, :username, :active_code, :phone, :active
    end
end
