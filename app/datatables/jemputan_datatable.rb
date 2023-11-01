class JemputanDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Jemputan.id", cond: :eq },
      user: { source: "User.name", cond: :like },
      alamat: { source: "AlamatJemput.alamat", cond: :like},
      phone: { source: "AlamatJemput.phone", cond: :like},
      status: { source: "Jemputan.status", cond: :like},
      tanggal: { source: "Jemputan.total"},
      total: { source: "Jemputan.total"}
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        user: record.user.name,
        alamat: record.alamat_jemput.alamat,
        phone: record.alamat_jemput.phone,
        total: record.total,
        status: record.status,
        tanggal: record.tanggal,
      }
    end
  end

  def get_raw_records
    Jemputan.all.joins(:user, :alamat_jemput)
    # insert query here    # User.all
  end

end
