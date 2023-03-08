class AdminDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "Admin.uuid", cond: :like },
      first_name: { source: "Admin.first_name", cond: :like },
      last_name: { source: "Admin.last_name", cond: :like },
      email: { source: "Admin.email", cond: :like },
      active: { source: "Admin.active", cond: :eq }
    }
  end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        first_name: record.first_name,
        last_name: record.last_name,
        email: record.email,
        active: record.active
      }
    end
  end

  def current_admin
    @current_admin ||= options[:current_admin]
  end

  def get_raw_records    
    Admin.all
  end
end
