puts "=== Start TipeSampaah seeding ... ==="
tipes = [
  { id: 1, name: "Sampah Plastik", image_url: "https://res.cloudinary.com/dghu0ntvd/image/upload/v1692968573/jenis/Mount-plastik_wntvxk.png" },
  { id: 2, name: "Sampah Metal", image_url: "https://res.cloudinary.com/dghu0ntvd/image/upload/v1692968573/jenis/Mount-metal_z9aoxw.png" },
  { id: 3, name: "Sampah Organik", image_url: "https://res.cloudinary.com/dghu0ntvd/image/upload/v1692968573/jenis/Mount-organik_ggu0q3.png" },
  { id: 4, name: "Sampah Elektronik", image_url: "https://res.cloudinary.com/dghu0ntvd/image/upload/v1692968573/jenis/Mount-elektronik_f4xnrv.png" },
  { id: 5, name: "Sampah Kaca", image_url: "https://res.cloudinary.com/dghu0ntvd/image/upload/v1692968573/jenis/Mount-kaca_wpvp8i.png" },
  { id: 6, name: "Sampah Kertas", image_url: "https://res.cloudinary.com/dghu0ntvd/image/upload/v1692968573/jenis/Mount-paper_txujzg.png" },
]

tipes.each do |data|
  TipeSampah.find_or_create_by(id: data[:id]) do |tipe|
    tipe.id = data[:id]
    tipe.name = data[:name]
    tipe.image_url = data[:image_url]
    tipe.save
  end
end

puts "=== Province seeding done... ==="
