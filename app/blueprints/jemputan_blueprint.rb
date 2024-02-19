class JemputanBlueprint < Blueprinter::Base
    identifier :id
    fields :uuid, :catatan, :status, :tanggal, :total, :fee, :berat
    association :alamat_jemput, blueprint: AlamatJemputBlueprint
    association :jemputan_details, blueprint: JemputanDetailBlueprint
    association :jemputan_tipe_sampahs, blueprint: JemputanTipeSampahBlueprint
end
