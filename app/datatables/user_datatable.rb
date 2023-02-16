class UserDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "User.id", cond: :eq },
      name: { source: "User.name", cond: :like },
      email: { source: "User.email", cond: :like },      
      active: { source: "User.active", cond: :eq },      
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        email: record.email,
        active: record.active
      }
    end
  end

  def get_raw_records
    # insert query here
    User.all
  end

end
