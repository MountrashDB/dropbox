table = CSV.parse(File.read("/home/deploy/dropbox/current/public/botols.csv"), headers: true)

table.each do |botol|
  barcode = botol["Barcode"]&.strip
  name = botol["Product Name"]&.strip
  product = botol["Product"]&.strip
  jenis = botol["Material"]&.strip
  botol = Botol.find_or_initialize_by(barcode: barcode)
  botol.name = name
  botol.product = product
  botol.jenis = jenis&.downcase
  botol.save
end

puts "=== Botol seeds done ==="
