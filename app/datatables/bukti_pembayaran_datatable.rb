class BuktiPembayaranDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "BuktiPembayaran.id", cond: :eq },
      mitra: { source: "Mitra.name", cond: :like },
      nominal: { source: "BuktiPembayaran.nominal", cond: :like },
      status: { source: "BuktiPembayaran.status", cond: :eq},
      admin: { source: "Admin.email", cond: :like},
      created_at: {source: "BuktiPembayaran.created_at"},
      image: { source: "BuktiPembayara.image.url", searchable: false },
      updated_at: {source: "BuktiPembayaran.updated_at"}
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        nominal: record.nominal,
        status: record.status,
        mitra: record.mitra.name,
        admin: record.admin.email,
        image: record.image.url != nil ? record.image.url : "",
        created_at: record.created_at,
        updated_at: record.updated_at,
      }
    end
  end

  def get_raw_records
    BuktiPembayaran.all.joins(:admin, :mitra)
  end

end
