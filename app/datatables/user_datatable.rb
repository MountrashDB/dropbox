class UserDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "User.id", cond: :eq },
      username: { source: "User.username", cond: :like, searchable: true },
      email: { source: "User.email", cond: :like, searchable: true },
      uuid: { source: "User.uuid", cond: :like },
      active: { source: "User.active", cond: :eq },
      balance: { source: "User.usertransactions.balance" },
      created_at: { source: "User.created_at", cond: :eq },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        uuid: record.uuid,
        username: record.username,
        email: record.email,
        active: record.active,
        created_at: record.created_at,
        balance: record.usertransactions.balance,
      }
    end
  end

  def get_raw_records
    User.all
  end
end
