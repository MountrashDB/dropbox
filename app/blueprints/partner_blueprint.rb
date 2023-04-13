class PartnerBlueprint < Blueprinter::Base
  identifier :uuid
  fields :nama

  view :login do
    fields :nama_usaha, :email, :handphone, :api_key, :api_secret, :alamat_kantor, :verified, :approved
  end
end
