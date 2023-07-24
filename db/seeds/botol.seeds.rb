table = CSV.parse(File.read("/media/arie/ad56d4df-7910-4232-bfac-73335c95d39a/home/arie/Web/ruby/Bell/dropbox/public/botols.csv"), headers: true)

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
