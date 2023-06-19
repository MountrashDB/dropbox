class WithdrawlDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    if params[:type] == "user"
      @view_columns ||= {
        id: { source: "Withdrawl.id", cond: :eq },
        email: { source: "User.email", cond: :like },
        amount: { source: "Withdrawl.amount", cond: :eq },
        bank: { source: "Bank.name", cond: :eq },
        status: { source: "Withdrawl.status", cond: :eq },
        updated_at: { source: "Withdrawl.updated_at" },
      }
    else
      @view_columns ||= {
        id: { source: "Withdrawl.id", cond: :eq },
        email: { source: "Mitra.email", cond: :like },
        amount: { source: "Withdrawl.amount", cond: :eq },
        bank: { source: "Bank.name", cond: :eq },
        status: { source: "Withdrawl.status", cond: :eq },
        updated_at: { source: "Withdrawl.updated_at" },
      }
    end
  end

  def data
    if params[:type] == "user"
      records.map do |record|
        {
          id: record.id,
          email: record.user.email,
          amount: record.amount,
          status: record.status,
          bank: record.bank.name,
          updated_at: record.updated_at,
        }
      end
    else
      records.map do |record|
        {
          id: record.id,
          email: record.mitra.email,
          amount: record.amount,
          status: record.status,
          bank: record.bank.name,
          updated_at: record.updated_at,
        }
      end
    end
  end

  def get_raw_records
    if params[:type] == "user"
      Withdrawl.all.joins(:user, :bank).order(updated_at: :desc)
    else
      Withdrawl.all.joins(:mitra, :bank).order(updated_at: :desc)
    end
  end
end
