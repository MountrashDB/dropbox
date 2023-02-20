class BotolDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    # botol.name = params[:name]
    #   botol.ukuran = params[:ukuran]
    #   botol.merk_id = params[:merk_id]
    #   botol.images.attach(params[:images])
    @view_columns ||= {
      id: { source: "Botol.id", cond: :eq },
      uuid: { source: "Botol.uuid", cond: :eq },
      name: { source: "Botol.name", cond: :eq },
      merk: { source: "Merk.name", cond: :eq },    
      ukuran: { source: "Botol.ukuran", cond: :eq },      
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,        
        uuid: record.uuid,
        name: record.name,
        merk: record.merk.name,
        ukuran: record.ukuran,
        image: record.images[0].key != nil ? Cloudinary::Utils.cloudinary_url(record.images[0].key, :width => 200, :height => 200, :crop => :fill) : "-"
      }
    end
  end

  def get_raw_records
    # insert query here
    Botol.all
  end

end
