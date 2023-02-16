class MerkDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Merk.id", cond: :eq },
      name: { source: "Merk.name", cond: :like }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        uuid: record.uuid,
        name: record.name
      }
    end
  end

  def get_raw_records
    Merk.all
  end
end
