class VoucherBlueprint < Blueprinter::Base
    identifier :id
    fields :code, :avai_start, :avai_end, :days, :status
    association :outlet, blueprint: OutletBlueprint
end
