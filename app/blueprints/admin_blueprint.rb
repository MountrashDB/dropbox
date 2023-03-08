class AdminBlueprint < Blueprinter::Base
    identifier :id

    fields :email, :uuid, :first_name, :last_name, :active

        field :image do |data|
            if data
                data.image.url
            else
                "-"
            end
        end
end
