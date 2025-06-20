require 'rails_helper'

RSpec.describe InvoiceFetch, type: :service do
  describe '#initialize' do
    it 'sets default values when no parameters are provided' do
      service = described_class.new

      expect(service.start_date).to be_nil
      expect(service.end_date).to eq(Date.today)
      expect(service.page).to eq(1)
      expect(service.per_page).to eq(25)
      expect(service.errors).to be_empty
    end

    it 'correctly parses dates from string parameters' do
      service = described_class.new(
        start_date: '2023-01-01',
        end_date: '2023-12-31',
        page: '2',
        per_page: '50'
      )

      expect(service.start_date).to eq(Date.parse('2023-01-01'))
      expect(service.end_date).to eq(Date.parse('2023-12-31'))
      expect(service.page).to eq(2)
      expect(service.per_page).to eq(50)
    end

    it 'handles invalid dates gracefully' do
      service = described_class.new(start_date: 'invalid-date')

      expect(service.start_date).to be_nil
      expect(service.errors).to be_empty
    end
  end

  describe '#call' do
    let(:start_date) { Date.parse('2023-01-01') }
    let(:end_date) { Date.parse('2023-12-31') }
    let(:invoice1) { create(:invoice, invoice_date: Date.parse('2023-06-15')) }
    let(:invoice2) { create(:invoice, invoice_date: Date.parse('2023-07-20')) }
    let(:cache_key) { "invoices/#{start_date}/#{end_date}/page-1/per-25" }

    before do
      allow(Rails.cache).to receive(:fetch).and_yield
    end

    it 'fetches paginated invoices between the specified dates' do
      service = described_class.new(start_date: start_date.to_s, end_date: end_date.to_s)

      invoice_relation = double('InvoiceRelation')
      paginated_result = [ invoice2, invoice1 ]

      expect(Invoice).to receive(:between_dates).with(start_date, end_date).and_return(invoice_relation)
      expect(invoice_relation).to receive(:order).with(invoice_date: :desc).and_return(invoice_relation)
      expect(invoice_relation).to receive(:paginate).with(page: 1, per_page: 25).and_return(paginated_result)

      expect(service.call).to eq(paginated_result)
    end

    it 'uses Rails cache with the correct key' do
      service = described_class.new(start_date: start_date.to_s, end_date: end_date.to_s)

      expect(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 1.hour)

      service.call
    end
  end

  describe '#generate_cache_key' do
    it 'generates the correct cache key format' do
      service = described_class.new(
        start_date: '2023-01-01',
        end_date: '2023-12-31',
        page: 2,
        per_page: 50
      )

      cache_key = service.send(:generate_cache_key)

      expect(cache_key).to eq('invoices/2023-01-01/2023-12-31/page-2/per-50')
    end
  end
end
