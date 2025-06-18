class InvoiceSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :invoice_number, :total, :status

  attribute :formatted_date do |invoice|
    invoice.invoice_date.strftime("%Y-%m-%d")
  end
end
