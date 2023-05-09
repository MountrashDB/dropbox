class MitraDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "Mitra.id", cond: :eq },
      name: { source: "Mitra.name", cond: :like, orderable: true },
      phone: { source: "Mitra.phone", cond: :like },
      email: { source: "Mitra.email", cond: :like, orderable: true },
      contact: { source: "Mitra.contact", cond: :like },
      status: { source: "Mitra.status", cond: :eq, orderable: true },
      balance: { source: "Mitra.mitratransactions.balance", cond: :eq, orderable: true },
      created_at: { source: "Mitra.created_at", orderable: true },
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
        status: record.status,
        balance: record.mitratransactions.balance,
        created_at: record.created_at,
      }
    end
  end

  def get_raw_records
    Mitra.all
  end
end
