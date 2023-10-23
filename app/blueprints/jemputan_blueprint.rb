class JemputanBlueprint < Blueprinter::Base
    identifier :id
    fields :catatan, :status, :tanggal, :total, :fee
    association :alamat_jemput, blueprint: AlamatJemputBlueprint
    association :jemputan_details, blueprint: JemputanDetailBlueprint
end
