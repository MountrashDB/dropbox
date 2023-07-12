class TransactionDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "Transaction.id", cond: :eq, searchable: true },
      diterima: { source: "Transaction.diterima", cond: :eq, searchable: true },
      harga: { source: "Transaction.harga", cond: :eq },
      mitra_amount: { source: "Transaction.mitra_amount" },
      user_amount: { source: "Transaction.user_amount" },
      box: { source: "Box.nama", cond: :like, searchable: true },
      mitra: { source: "Mitra.name", cond: :like, searchable: true },
      user: { source: "User.username", cond: :like, searchable: true },
      image: { source: "Transaction.foto.url", searchable: false },
      email: { source: "User.email", cond: :like, searchable: true },
      botol: { source: "Transaction.botol_info", cond: :like, searchable: true },
      created_at: { source: "Transaction.created_at", cond: :like, searchable: true },
    }
  end

  # def initialize(params, opts = {})
  #   @mitra_id = opts[:mitra_id]
  # end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        diterima: record.diterima,
        harga: record.harga,
        mitra_amount: record.mitra_amount,
        user_amount: record.user_amount,
        box: record.box.nama,
        mitra: record.mitra.name,
        user: record.user.username,
        email: record.user.email,
        image: record.foto.url,
        botol: record.botol_info,
        created_at: record.created_at,
      }
    end
  end

  def get_raw_records
    if options[:mitra_id]
      Transaction.where(mitra_id: options[:mitra_id]).joins(:box, :user, :mitra)
    elsif options[:user_id]
      Transaction.where(user_id: options[:user_id]).joins(:box, :user, :mitra)
    else
      Transaction.all.joins(:box, :user, :mitra)
    end
  end
end
