class KycDatatable < AjaxDatatablesRails::ActiveRecord
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      uuid: { source: "Kyc.uuid", cond: :like, searchable: true },
      nama: { source: "Kyc.nama", cond: :like, searchable: true },
      desa: { source: "Kyc.desa", cond: :like, searchable: true },
      status: { source: "Kyc.status", cond: :like, searchable: true },
      desa: { source: "Kyc.desa", cond: :like, searchable: true },
      tempat_tinggal: { source: "Kyc.tempat_tinggal", cond: :like, searchable: true },
      no_ktp: { source: "Kyc.no_ktp", cond: :like, searchable: true },
      mitra: { source: "Mitra.name", cond: :like, searchable: true },
    }
  end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        nama: record.nama,
        tempat_tinggal: record.tempat_tinggal,
        status: record.status,
        no_ktp: record.no_ktp,
        mitra: record.mitra.name,
      }
    end
  end

  def get_raw_records
    Kyc.all.joins(:mitra)
  end
end
