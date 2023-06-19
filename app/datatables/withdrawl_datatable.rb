class WithdrawlDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Withdrawl.id", cond: :eq },
      email: { source: "User.email", cond: :like },
      amount: { source: "Withdrawl.amount", cond: :eq },
      kode_bank: { source: "Withdrawl.kodeBank", cond: :eq },
      status: { source: "Withdrawl.status", cond: :eq },
      updated_at: { source: "Withdrawl.updated_at" },
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        email: record.user.email,
        amount: record.amount,
        status: record.status,
        kode_bank: record.kodeBank,
        updated_at: record.updated_at,
      }
    end
  end

  def get_raw_records
    Withdrawl.all.joins(:user).order(updated_at: :desc)
  end
end
