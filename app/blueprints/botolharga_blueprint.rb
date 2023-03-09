class BotolhargaBlueprint < Blueprinter::Base    
    fields :harga
    association :box, blueprint: BoxBlueprint, view: :show_harga
    association :botol, blueprint: BotolBlueprint
end
