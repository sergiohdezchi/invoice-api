class Invoice < ApplicationRecord
  scope :between_dates, ->(start_date, end_date) do
    where(invoice_date: start_date.beginning_of_day..end_date.end_of_day)
  end
end
