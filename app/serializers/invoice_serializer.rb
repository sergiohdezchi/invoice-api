class InvoiceSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :invoice_number, :total, :status, :invoice_date, :customer_name

  attribute :formatted_date do |invoice|
    invoice.invoice_date.strftime("%Y-%m-%d")
  end
  
  attribute :formatted_total do |invoice|
    sprintf('%.2f', invoice.total)
  end
end
