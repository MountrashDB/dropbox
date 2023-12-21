class VoucherDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "Voucher.id", cond: :eq },
      code: { source: "Voucher.code", cond: :like },
      days: { source: "Voucher.days", cond: :like },
      avai_start: { source: "Voucher.avai_start", cond: :like },
      avai_end: { source: "Voucher.avai_end", cond: :like },
      expired: { source: "Voucher.avai_end", cond: :eq },
      outlet: { source: "Outlet.name", cond: :eq },
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        code: record.code,
        days: record.days,
        avai_start: record.avai_start,
        avai_end: record.avai_end,
        outlet: record.outlet.name
      }
    end
  end

  def get_raw_records
    # insert query here
    Voucher.all.includes(:outlet)
  end

end
