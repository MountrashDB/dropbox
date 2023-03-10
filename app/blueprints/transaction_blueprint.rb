class TransactionBlueprint < Blueprinter::Base
    identifier :uuid

    view :check_botol do
        fields :harga, :diterima, :created_at
        field :foto do |data|
            if data
                data.foto.url
            else
                "-"
            end
        end
    end
end
