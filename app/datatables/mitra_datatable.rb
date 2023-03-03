class MitraDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "Mitra.id", cond: :eq },
      name: { source: "Mitra.name", cond: :like },
      phone: { source: "Mitra.phone", cond: :like },
      email: { source: "Mitra.email", cond: :like },
      contact: { source: "Mitra.contact", cond: :like },
      status: { source: "Mitra.status", cond: :eq },

    }
  end

  def data
    records.map do |record|
      {
        # example:
        uuid: record.uuid,
        name: record.name,
        phone: record.phone,
        email: record.email,
        contact: record.contact,
        status: record.status
      }
    end
  end

  def get_raw_records
    Mitra.all
  end

end
