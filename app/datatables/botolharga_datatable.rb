class BotolhargaDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "BotolHarga.uuid", cond: :eq },
      harga: { source: "BotolHarga.harga", cond: :eq },
      botol: { source: "Botol.name", cond: :like, searchable: true},
      box: { source: "Box.nama", cond: :like, searchble: true}
    }
  end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        harga: record.harga,
        botol: record.botol.name,
        box: record.box.nama
      }
    end
  end

  def get_raw_records
    BotolHarga.all
  end

end
