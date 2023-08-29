class SampahDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "Sampah.uuid", cond: :eq, searchable: true },
      name: { source: "Sampah.name", cond: :like },
      harga_kg: { source: "Sampah.harga_kg", searchable: false },
      harga_satuan: { source: "Sampah.harga_satuan", searchable: false },
      active: { source: "Sampah.active", cond: :like },
      tipe_sampah: { source: "TipeSampah.name", cond: :like },
      created_at: { source: "Sampah.created_at", cond: :like, searchable: true },
      updated_at: { source: "Sampah.updated_at", cond: :like, searchable: true },
    }
  end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        name: record.name,
        harga_kg: record.harga_kg,
        harga_satuan: record.harga_satuan,
        tipe_sampah: record.tipe_sampah.name,
        active: record.active,
        created_at: record.created_at,
        updated_at: record.updated_at,
      }
    end
  end

  def current_banksampah
    @current_banksampah ||= options[:current_banksampah]
  end

  def get_raw_records
    Sampah.where(banksampah: options[:current_banksampah]).joins(:banksampah, :tipe_sampah)
  end
end
