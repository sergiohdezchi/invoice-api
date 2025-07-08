class Invoice < ApplicationRecord
  # Validaciones
  validates :invoice_number, presence: true, uniqueness: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validates :invoice_date, presence: true
  
  # Estados posibles para una factura
  enum status: {
    pending: 'pending',
    paid: 'paid',
    cancelled: 'cancelled',
    overdue: 'overdue'
  }
  
  # Scopes
  scope :between_dates, ->(start_date, end_date) do
    where(invoice_date: start_date.beginning_of_day..end_date.end_of_day)
  end
  
  scope :pending, -> { where(status: 'pending') }
  scope :paid, -> { where(status: 'paid') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :overdue, -> { where(status: 'overdue') }
end
