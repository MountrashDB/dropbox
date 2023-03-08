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
        mitra: record.mitra.name
      }
    end
  end

  def get_raw_records
    if @current_mitra
      Box.where(mitra_id: @current_mitra.id)
    else
      Box.all
    end
  end
end
