class BoxDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Box.id", cond: :eq },
      uuid: { source: "Box.uuid", cond: :like },
      nama: { source: "Box.nama", cond: :like, searchable: true },
      jenis: { source: "Box.jenis", cond: :like },
      type_progress: { source: "Box.type_progress", cond: :like },
      qr_code: { source: "Box.qr_code", cond: :like },
      latitude: { source: "Box.latitude", cond: :like },
      longitude: { source: "Box.longitude", cond: :like },
      mitra: { source: "Mitra.name", cond: :like, searchable: true },
      max: { source: "Box.max", cond: :eq },
      mitra_share: { source: "Box.mitra_share" },
      user_share: { source: "Box.user_share" },
      created_at: { source: "Box.created_at" },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        uuid: record.uuid,
        nama: record.nama,
        jenis: record.jenis,
        type_progress: record.type_progress,
        qr_code: record.qr_code,
        latitude: record.latitude,
        longitude: record.longitude,
        mitra: record.mitra.name,
        mitra_share: record.mitra_share,
        user_share: record.user_share,
        created_at: record.created_at,
      }
    end
  end

  def current_mitra
    @current_mitra ||= options[:current_mitra]
  end

  def get_raw_records
    if current_mitra
      # Mitra list
      Box.where(mitra_id: current_mitra.id).joins(:mitra)
    else
      # Admin list
      Box.all.joins(:mitra)
    end
  end
end
