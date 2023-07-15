class BotolhargaBlueprint < Blueprinter::Base    
    fields :harga, :uuid
    association :box, blueprint: BoxBlueprint, view: :show_harga
    association :botol, blueprint: BotolBlueprint
end
