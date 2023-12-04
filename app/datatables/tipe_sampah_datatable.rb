class TipeSampahDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    @view_columns ||= {
      id: { source: "TipeSampah.id", cond: :eq, searchable: true },
      name: { source: "TipeSampah.name", cond: :like, searchable: true },
      harga: { source: "TipeSampah.harga", cond: :like },
      active: { source: "TipeSampah.harga",cond: :eq, searchable: true },
      image: { source: "TipeSampah.image.url", searchable: false },         
      created_at: { source: "TipeSampah.created_at", cond: :like, searchable: true },
      updated_at: { source: "TipeSampah.updated_at", cond: :like, searchable: true },      
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        name: record.name,
        harga: record.harga,
        active: record.active,
        image: record.image.url != nil ? record.image.url : '',
        created_at: record.created_at,
        updated_at: record.updated_at,
      }
    end
  end

  def get_raw_records
    TipeSampah.all
  end

end
