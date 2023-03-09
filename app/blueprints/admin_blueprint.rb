class AdminBlueprint < Blueprinter::Base
    identifier :uuid

    fields :email, :first_name, :last_name, :active

        field :image do |data|
            if data
                data.image.url
            else
                "-"
            end
        end
end
