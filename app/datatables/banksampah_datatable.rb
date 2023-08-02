class BanksampahDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    @view_columns ||= {
      uuid: { source: "Banksampah.uuid", cond: :eq, searchable: true },
      name: { source: "Banksampah.name", cond: :like },
      active: { source: "Banksampah.active", cond: :like },
      email: { source: "Banksampah.email", cond: :like },
      created_at: { source: "Banksampah.created_at", cond: :like, searchable: true },

    }
  end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        name: record.name,
        email: record.email,
        active: record.active,
        created_at: record.created_at,
      }
    end
  end

  def get_raw_records
    Banksampah.all
  end
end
