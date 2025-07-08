require 'faker'

# Generar 500 facturas con datos variados
puts "Creando 500 facturas..."

# Definir posibles estados de facturas
statuses = ['pending', 'paid', 'cancelled', 'overdue']

# Crear series de facturas con prefijos distintos
prefixes = ['F001', 'F002', 'F003', 'A001', 'B001']

# Crear facturas con fechas en los últimos 2 años y montos variados
500.times do |i|
  # Generar número de factura único
  prefix = prefixes.sample
  number = sprintf('%06d', i + 1)
  invoice_number = "#{prefix}-#{number}"
  
  # Generar fecha aleatoria en los últimos 2 años
  invoice_date = Faker::Date.between(from: 2.years.ago, to: Date.today)
  
  # Generar total aleatorio entre 100 y 10,000
  total = rand(100..10000).to_f
  
  # Asignar estado basado en la fecha para hacer datos más realistas
  status = if invoice_date > 1.month.ago && [true, false].sample
             'pending'
           elsif invoice_date < 2.weeks.ago && invoice_date > 3.months.ago && rand < 0.1
             'cancelled'
           elsif invoice_date < 1.month.ago && rand < 0.15
             'overdue'
           else
             'paid'
           end
  
  # Generar nombre de cliente
  customer_name = Faker::Company.name
  
  # Crear la factura
  Invoice.create!(
    invoice_number: invoice_number,
    total: total,
    status: status,
    invoice_date: invoice_date,
    customer_name: customer_name
  )
  
  # Mostrar progreso
  if (i + 1) % 100 == 0
    puts "  #{i + 1} facturas creadas..."
  end
end

# Mostrar resumen
pending_count = Invoice.pending.count
paid_count = Invoice.paid.count
cancelled_count = Invoice.cancelled.count
overdue_count = Invoice.overdue.count

puts "Creación de facturas completada."
puts "Resumen:"
puts "  Pendientes: #{pending_count}"
puts "  Pagadas: #{paid_count}"
puts "  Canceladas: #{cancelled_count}"
puts "  Vencidas: #{overdue_count}"
puts "Total: #{Invoice.count} facturas"
