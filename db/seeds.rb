# This file should contain all the record creation needed to seed the database with its default values.
# The data will create completely in English as requested.

# Clear existing data in the right order to respect foreign key constraints (be careful with this in production)
puts "Clearing existing data..."
ActiveRecord::Base.connection.execute("TRUNCATE TABLE quotation_items RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE quotations RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE projects RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE clients RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE materials RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE services RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE users RESTART IDENTITY CASCADE")

puts "Creating Users..."

users = []
users << User.create!(
  email: 'admin@example.com',
  username: 'admin',
  password: 'password123',
  name: 'John',
  last_name: 'Smith',
  role: :admin,
  status: :active
)

users << User.create!(
  email: 'salesperson1@example.com',
  username: 'salesperson1',
  password: 'password123',
  name: 'Michael',
  last_name: 'Johnson',
  role: :salesperson,
  status: :active
)

users << User.create!(
  email: 'salesperson2@example.com',
  username: 'salesperson2',
  password: 'password123',
  name: 'David',
  last_name: 'Brown',
  role: :salesperson,
  status: :active
)

users << User.create!(
  email: 'engineer1@example.com',
  username: 'engineer1',
  password: 'password123',
  name: 'Robert',
  last_name: 'Davis',
  role: :engineer,
  status: :active
)

users << User.create!(
  email: 'engineer2@example.com',
  username: 'engineer2',
  password: 'password123',
  name: 'James',
  last_name: 'Wilson',
  role: :engineer,
  status: :active
)

# Create more users to reach 10
10.times do |i|
  name = Faker::Name.first_name
  users << User.create!(
    email: "user#{i+6}@example.com",
    username: name.downcase + "#{i+6}",
    password: 'password123',
    name: name,
    last_name: Faker::Name.last_name,
    role: [:admin, :salesperson, :engineer].sample,
    status: :active
  ) if users.length < 10
end

puts "Created #{users.length} Users"

puts "Creating Clients..."
clients = []
10.times do |i|
  clients << Client.create!(
    company_name: Faker::Company.name,
    tax_id: Faker::Company.ein, # Using EIN instead of Spanish tax ID
    contact_name: Faker::Name.name,
    contact_email: "contact#{i+1}@#{Faker::Internet.domain_name}",
    contact_phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    client_type: [:residential, :industrial, :governmental].sample
  )
end
puts "Created #{clients.length} Clients"

puts "Creating Projects..."
projects = []
10.times do |i|
  projects << Project.create!(
    folio_number: "PRO-#{i+1}",
    name: Faker::Company.catch_phrase,
    description: Faker::Lorem.paragraph,
    client: clients.sample,
    responsible: users.select { |u| u.role == 'engineer' || u.role == 'admin' }.sample || users.first,
    location: Faker::Address.full_address,
    project_type: [:construction, :installation, :modification].sample,
    status: [:planned, :accepted, :in_progress, :completed, :cancelled].sample,
    start_date: Faker::Date.between(from: 3.months.ago, to: Date.today),
    estimated_end_date: Faker::Date.forward(days: 90),
    actual_end_date: [nil, Faker::Date.between(from: 3.months.ago, to: Date.today)].sample
  )
end
puts "Created #{projects.length} Projects"

puts "Creating Materials..."
materials = []
10.times do |i|
  materials << Material.create!(
    code: "MAT-#{i+1}",
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    unit: [:piece, :meter, :kg, :liter, :unit].sample,
    cost_price: Faker::Commerce.price(range: 10.0..500.0),
    public_price: Faker::Commerce.price(range: 15.0..600.0),
    category: [:electric, :mechanical, :tools, :safety, :other].sample
  )
end
puts "Created #{materials.length} Materials"

puts "Creating Services..."
services = []
10.times do |i|
  services << Service.create!(
    code: "SER-#{i+1}",
    title: Faker::Commerce.department,
    description: Faker::Lorem.sentence,
    unit: [:hour, :service, :shift, :project, :unit].sample,
    suggested_price: Faker::Commerce.price(range: 50.0..200.0),
    public_price: Faker::Commerce.price(range: 60.0..250.0),
    category: [:installation, :maintenance, :consulting, :other].sample
  )
end
puts "Created #{services.length} Services"

puts "Creating Quotations..."
quotations = []
10.times do |i|
  quotations << Quotation.create!(
    quotation_number: "QT-#{i+1}",
    project: projects.sample,
    client: clients.sample,
    salesperson: users.select { |u| u.role == 'salesperson' }.sample || users.first,
    project_type: [:high_voltage, :low_voltage, :automation].sample,
    publish_date: Faker::Date.between(from: 2.months.ago, to: Date.today),
    expiry_date: Faker::Date.forward(days: 30),
    subtotal: 0, # Will be calculated after creating items
    total: 0, # Will be calculated after creating items
    status: [:draft, :sent, :approved, :rejected, :cancelled].sample,
    terms_conditions: Faker::Lorem.paragraph,
    notes: Faker::Lorem.sentence,
    revision_number: rand(0..5)
  )
end
puts "Created #{quotations.length} Quotations"

puts "Creating Quotation Items..."
quotation_items = []
quotations.each do |quotation|
  # Create 2-5 items per quotation
  rand(2..5).times do
    type = [:material, :service].sample
    if type == :material && materials.any?
      item = materials.sample
      price = item.public_price
    else
      item = services.sample
      price = item.public_price
    end

    quantity = rand(1..10)
    amount = price * quantity

    quotation_item = QuotationItem.new(
      item_type: type,
      description: item ? item.title : Faker::Lorem.sentence,
      quantity: quantity,
      unit: [:piece, :meter, :hour, :kg].sample,
      unit_price: price,
      amount: amount,
      currency: [:MXN, :USD].sample
    )
    quotation_item.quotation = quotation
    quotation_item.save!
    quotation_items << quotation_item
  end
  
  # Update quotation totals
  subtotal = quotation.quotation_items.sum(:amount)
  quotation.update!(subtotal: subtotal, total: subtotal)
end
puts "Created #{quotation_items.length} Quotation Items"

puts "Seed completed successfully!"
puts "\nSummary:"
puts "Users: #{User.count}"
puts "Clients: #{Client.count}"
puts "Projects: #{Project.count}"
puts "Materials: #{Material.count}"
puts "Services: #{Service.count}"
puts "Quotations: #{Quotation.count}"
puts "Quotation Items: #{QuotationItem.count}"