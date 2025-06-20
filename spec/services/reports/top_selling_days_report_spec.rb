require 'rails_helper'

RSpec.describe Reports::TopSellingDaysReport, type: :service do
  describe '#initialize' do
    it 'sets default limit when not provided' do
      report = described_class.new

      expect(report.instance_variable_get(:@limit)).to eq(described_class::DEFAULT_LIMIT)
      expect(report.instance_variable_get(:@date)).to eq(Date.today)
    end

    it 'uses provided limit when specified' do
      custom_limit = 5
      report = described_class.new(limit: custom_limit)

      expect(report.instance_variable_get(:@limit)).to eq(custom_limit)
    end
  end

  describe '#call' do
    let(:report) { described_class.new(limit: 3) }
    let(:cache_key) { "reports:top_selling_days:limit=3:date=#{Date.today}" }
    let(:top_selling_days) do
      [
        [ Date.parse('2023-06-15'), 1500.0 ],
        [ Date.parse('2023-05-20'), 1200.0 ],
        [ Date.parse('2023-07-10'), 900.0 ]
      ]
    end

    before do
      allow(Rails.cache).to receive(:fetch).and_yield
    end

    it 'fetches top selling days from database' do
      expect(report).to receive(:fetch_top_selling_days).and_return(top_selling_days)

      result = report.call
      expect(result).to eq(top_selling_days)
    end

    it 'uses Rails cache with the correct key' do
      allow(report).to receive(:fetch_top_selling_days).and_return(top_selling_days)

      expect(Rails.cache).to receive(:fetch)
        .with(cache_key, expires_in: described_class::CACHE_EXPIRY)
        .and_return(top_selling_days)

      report.call
    end

    it 'returns cached results when available' do
      expect(Rails.cache).to receive(:fetch)
        .with(cache_key, expires_in: described_class::CACHE_EXPIRY)
        .and_return(top_selling_days)

      expect(report).not_to receive(:fetch_top_selling_days)

      result = report.call
      expect(result).to eq(top_selling_days)
    end
  end

  describe '#refresh!' do
    let(:report) { described_class.new }
    let(:cache_key) { "reports:top_selling_days:limit=#{described_class::DEFAULT_LIMIT}:date=#{Date.today}" }
    let(:report_data) { [ [ '2023-06-15', 1500.0 ] ] }

    it 'deletes the cache and then calls the report' do
      expect(Rails.cache).to receive(:delete).with(cache_key)
      expect(report).to receive(:call).and_return(report_data)

      result = report.refresh!
      expect(result).to eq(report_data)
    end
  end

  describe '#fetch_top_selling_days' do
    let(:report) { described_class.new(limit: 2) }

    before do
      create(:invoice, invoice_date: '2023-01-01', total: 500)
      create(:invoice, invoice_date: '2023-01-01', total: 700)
      create(:invoice, invoice_date: '2023-01-02', total: 400)
      create(:invoice, invoice_date: '2023-01-02', total: 300)
      create(:invoice, invoice_date: '2023-01-03', total: 1500)
    end

    it 'returns the correct top selling days in descending order' do
      result = report.send(:fetch_top_selling_days)

      expect(result.size).to eq(2)
      expect(result[0][0].to_s).to eq('2023-01-03')
      expect(result[0][1]).to eq(1500.0)
      expect(result[1][0].to_s).to eq('2023-01-01')
      expect(result[1][1]).to eq(1200.0)
    end

    it 'respects the limit parameter' do
      custom_report = described_class.new(limit: 3)
      result = custom_report.send(:fetch_top_selling_days)

      expect(result.size).to eq(3)
      expect(result[0][0].to_s).to eq('2023-01-03')
      expect(result[1][0].to_s).to eq('2023-01-01')
      expect(result[2][0].to_s).to eq('2023-01-02')
    end
  end

  describe '#cache_key' do
    it 'generates the correct cache key format' do
      custom_date = Date.parse('2023-05-15')
      custom_limit = 5
      report = described_class.new(limit: custom_limit)
      report.instance_variable_set(:@date, custom_date)

      cache_key = report.send(:cache_key)

      expect(cache_key).to eq("reports:top_selling_days:limit=5:date=2023-05-15")
    end
  end
end
