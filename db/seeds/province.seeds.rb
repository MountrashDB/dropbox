# How to use
# rake db:seed:single SEED=province
puts "=== Start Province seeding ... ==="
provinces = [
{id:1, name:'Bali', displays:1},
{id:2, name:'Bangka Belitung', displays:1},
{id:3, name:'Banten', displays:1},
{id:4, name:'Bengkulu', displays:1},
{id:5, name:'DI Yogyakarta', displays:1},
{id:6, name:'DKI Jakarta', displays:1},
{id:7, name:'Gorontalo', displays:1},
{id:8, name:'Jambi', displays:1},
{id:9, name:'Jawa Barat', displays:1},
{id:10, name:'Jawa Tengah', displays:1},
{id:11, name:'Jawa Timur', displays:1},
{id:12, name:'Kalimantan Barat', displays:1},
{id:13, name:'Kalimantan Selatan', displays:1},
{id:14, name:'Kalimantan Tengah', displays:1},
{id:15, name:'Kalimantan Timur', displays:1},
{id:16, name:'Kalimantan Utara', displays:1},
{id:17, name:'Kepulauan Riau', displays:1},
{id:18, name:'Lampung', displays:0},
{id:19, name:'Maluku', displays:0},
{id:20, name:'Maluku Utara', displays:0},
{id:21, name:'Nanggroe Aceh Darussalam (NAD)', displays:0},
{id:22, name:'Nusa Tenggara Barat (NTB)', displays:0},
{id:23, name:'Nusa Tenggara Timur (NTT)', displays:0},
{id:24, name:'Papua', displays:0},
{id:25, name:'Papua Barat', displays:0},
{id:26, name:'Riau', displays:0},
{id:27, name:'Sulawesi Barat', displays:0},
{id:28, name:'Sulawesi Selatan', displays:0},
{id:29, name:'Sulawesi Tengah', displays:0},
{id:30, name:'Sulawesi Tenggara', displays:0},
{id:31, name:'Sulawesi Utara', displays:0},
{id:32, name:'Sumatera Barat', displays:0},
{id:33, name:'Sumatera Selatan', displays:0},
{id:34, name:'Sumatera Utara', displays:0}
]

provinces.each do |data|
    Province.find_or_create_by(id: data[:id]) do |province|
        province.id = data[:id]
        province.name = data[:name]
        province.displays = data[:displays]
        province.save
    end
end

puts "=== Province seeding done... ==="
