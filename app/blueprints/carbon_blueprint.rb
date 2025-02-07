class CarbonBlueprint < Blueprinter::Base
  identifier :uuid

  view :carbon do
    fields :nama, :botol_total
    field :location do |box|
        "#{box.latitude}, #{box.longitude}"
    end
    field :total_trx do |box|
      Transaction.where(box_id: box.id).count    
    end

    field :material do |box|
      trx = Transaction.where(box_id: box.id).count        
      hasil = trx * 0.105
    end

    field :manufacturing do |box|
      trx = Transaction.where(box_id: box.id).count        
      hasil = trx * 0.03
    end

    field :transportation do |box|
      trx = Transaction.where(box_id: box.id).count        
      hasil = trx * 0.05
    end

    field :recycle do |box|
      trx = Transaction.where(box_id: box.id).count        
      hasil = trx * 0.02
    end

    field :total_carbon do |box|
      trx = Transaction.where(box_id: box.id).count        
      hasil = trx * 0.2
    end
  end
end
