class BoxDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Box.id", cond: :eq },
      uuid: { source: "Box.uuid", cond: :like },
      qr_code: { source: "Box.qr_code", cond: :like },
      lat: { source: "Box.lat", cond: :like },
      lang: { source: "Box.lat", cond: :like },
      max: { source: "Box.max", cond: :eq },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        uuid: record.uuid,
        qr_code: record.qr_code,
        lat: record.lat,
        lang: record.lang,
        max: record.max,
      }
    end
  end

  def get_raw_records
    Box.all
  end
end
