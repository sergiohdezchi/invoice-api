class InvoiceFetch
  attr_reader :start_date, :end_date, :page, :per_page, :errors

  def initialize(params = {})
    @start_date = parse_date(params[:start_date])
    @end_date = parse_date(params[:end_date]) || Date.today
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || 25).to_i
    @errors = []
  end

  def call
    cache_key = generate_cache_key
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      fetch_paginated_invoices
    end
  end

  private

  def parse_date(date_string)
    return nil if date_string.blank?

    Date.parse(date_string)
  end

  def generate_cache_key
    "invoices/#{start_date}/#{end_date}/page-#{page}/per-#{per_page}"
  end

  def fetch_paginated_invoices
    Invoice.between_dates(start_date, end_date)
           .order(invoice_date: :desc)
           .paginate(page: page, per_page: per_page)
  end
end
