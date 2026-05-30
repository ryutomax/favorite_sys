# サンプルコンテンツを3件用意する（再実行しても重複しないようにする）
samples = [
  { title: "海辺の朝焼け", body: "水平線からのぼる太陽がオレンジ色に空を染めます。" },
  { title: "山頂からの眺め", body: "雲海の上に頭を出した峰々が連なっています。" },
  { title: "夜の街明かり", body: "高層ビルの窓ひとつひとつに人々の暮らしがあります。" }
]

samples.each do |attrs|
  Content.find_or_create_by!(title: attrs[:title]) do |content|
    content.body = attrs[:body]
  end
end

puts "Seeded #{Content.count} contents."
