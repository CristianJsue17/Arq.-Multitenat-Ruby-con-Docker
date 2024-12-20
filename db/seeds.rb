require "open-uri"
require "active_support/inflector"

puts "Cleaning database..."
Product.destroy_all
Tenant.destroy_all
User.destroy_all

puts "Creating tenants..."
tenant1 = Tenant.create(name: "CompuFIIS", subdomain: "compufiis")
tenant2 = Tenant.create(name: "MueblesOfi", subdomain: "mueblesofi")

puts "Creating products..."

products = [
  # Tenant 1: CompuFIIS - Productos de tecnología
  { tenant: tenant1, name: "Mouse Logitech MX Master 3", description: "Mouse inalámbrico ergonómico", price: 100.00, brand: "Logitech", stock: 30, category: "accesorios", material: "Plástico", dimension: "126x84x51 mm", peso: "141 g", color: "Negro", caracteristicas: "Bluetooth, USB-C, DPI ajustable", image_filename: "logitech_mx.jpg" },
  { tenant: tenant1, name: "MacBook Pro 14", description: "Laptop profesional con chip M2 Pro", price: 1999.99, brand: "Apple", stock: 10, category: "laptops", material: "Aluminio", dimension: "312.6x221.2x15.5 mm", peso: "1.6 kg", color: "Gris Espacial", caracteristicas: "Chip M2 Pro, 16GB RAM, 512GB SSD", image_filename: "macbook_pro.jpg" },
  { tenant: tenant1, name: "iPhone 15 Pro", description: "Smartphone de última generación con chip A17 Pro", price: 999.99, brand: "Apple", stock: 25, category: "celulares", material: "Titanio", dimension: "146.6x70.6x8.25 mm", peso: "187 g", color: "Titanio Natural", caracteristicas: "A17 Pro, 128GB, Cámara 48MP", image_filename: "iphone_15_pro.jpg" },

  # Tenant 2: MueblesOfi - Productos de muebles
  { tenant: tenant2, name: "Silla Ergonómica", description: "Silla ergonómica para oficina", price: 200.00, brand: "OfiMuebles", stock: 20, category: "muebles", material: "Cuero", dimension: "120x60x50 cm", peso: "15 kg", color: "Negro", caracteristicas: "Ajustable en altura, soporte lumbar", image_filename: "silla_ergonomica.jpg" },
  { tenant: tenant2, name: "Escritorio Ajustable", description: "Escritorio de altura ajustable", price: 450.00, brand: "OfiMuebles", stock: 15, category: "muebles", material: "Madera", dimension: "150x75x80 cm", peso: "30 kg", color: "Marrón", caracteristicas: "Altura ajustable, acabado premium", image_filename: "escritorio_ajustable.jpg" }
]

products.each do |product_attrs|
  product = Product.new(product_attrs.except(:image_filename))
  format_name = ActiveSupport::Inflector.transliterate(product.name).gsub(" ", "+")
  image_url = "https://placehold.co/800x600.jpg?text=#{format_name}"

  begin
    downloaded_image = URI.open(image_url)
    product.image.attach(
      io: downloaded_image,
      filename: product_attrs[:image_filename],
      content_type: "image/jpeg"
    )

    if product.save
      puts "Created #{product.name} for tenant #{product.tenant.name}"
    else
      puts "Failed to create #{product.name}: #{product.errors.full_messages.join(', ')}"
    end
  rescue OpenURI::HTTPError => e
    puts "Failed to download image for #{product.name}: #{e.message}"
  end
end

puts "Finished creating #{Product.count} products"

puts "\nProducts created by tenant:"
Product.joins(:tenant).group("tenants.name").count.each do |tenant_name, count|
  puts "#{tenant_name}: #{count} products"
end

# Crear usuario administrador
User.create(
  username: "admin",
  password: "password123",
  password_confirmation: "password123",
  tenant: tenant1
)
