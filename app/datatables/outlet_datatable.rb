class OutletDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Outlet.id", cond: :eq },
      name: { source: "Outlet.name", cond: :like },
      email: { source: "Outlet.email", cond: :like },
      phone: { source: "Outlet.phone", cond: :like },
      active: { source: "Outlet.active", cond: :eq },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        email: record.email,
        name: record.name,
        active: record.active,
        phone: record.phone,
      }
    end
  end

  def get_raw_records
    Outlet.all
  end
end
