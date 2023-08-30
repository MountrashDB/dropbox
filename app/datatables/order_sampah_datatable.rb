class OrderSampahDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "OrderSampah.uuid", cond: :like },
      sub_total: { source: "OrderSampah.sub_total" },
      total: { source: "OrderSampah.total" },
      user: { source: "User.username", cond: :like },
      status: { source: "OorderSampah.status", cond: :like },
      created_at: { source: "OrderSampah.created_at", cond: :like, searchable: true },
    }
  end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        status: record.status,
        sub_total: record.sub_total,
        total: record.total,
        user: record.user.username,
        created_at: record.created_at,
      }
    end
  end

  def current_banksampah
    @current_banksampah ||= options[:current_banksampah]
  end

  def get_raw_records
    OrderSampah.where(banksampah: options[:current_banksampah]).joins(:banksampah, :user)
  end
end
