class PartnerBlueprint < Blueprinter::Base
  identifier :uuid

  view :login do
    fields :nama, :nama_usaha, :email, :handphone, :api_key, :api_secret, :alamat_kantor, :verified, :approved
  end
end
