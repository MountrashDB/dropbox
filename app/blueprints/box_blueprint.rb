class BoxBlueprint < Blueprinter::Base
  identifier :uuid

  fields :nama,
         :uuid,
         :qr_code,
         :qty,
         :cycles,
         :dates,
         :jenis,
         :latitude,
         :longitude,
         :mitra_share,
         :user_share,
         :type_progress,
         :created_at,
         :updated_at,
         :price_pcs,
         :price_kg
  association :mitra, blueprint: MitraBlueprint

  view :show_harga do
    excludes :qr_code, :qty, :cycles, :dates, :jenis, :latitude, :longitude, :mitra_share, :user_share, :type_progress, :created_at, :updated_at
  end
end
