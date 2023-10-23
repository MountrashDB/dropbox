class JemputanBlueprint < Blueprinter::Base
    identifier :id
    fields :catatan, :status, :tanggal, :total, :fee, :uuid
    association :alamat_jemput, blueprint: AlamatJemputBlueprint
    association :jemputan_details, blueprint: JemputanDetailBlueprint
end
