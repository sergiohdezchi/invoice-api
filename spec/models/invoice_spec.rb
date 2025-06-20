require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'scopes' do
    describe '.between_dates' do
      let(:start_date) { Date.parse('2023-01-01') }
      let(:end_date) { Date.parse('2023-01-31') }

      let!(:invoice_before_range) { create(:invoice, invoice_date: Date.parse('2022-12-25')) }
      let!(:invoice_start_of_range) { create(:invoice, invoice_date: start_date) }
      let!(:invoice_middle_of_range) { create(:invoice, invoice_date: Date.parse('2023-01-15')) }
      let!(:invoice_end_of_range) { create(:invoice, invoice_date: end_date) }
      let!(:invoice_after_range) { create(:invoice, invoice_date: Date.parse('2023-02-05')) }

      it 'returns invoices with dates within the specified range' do
        result = described_class.between_dates(start_date, end_date)

        expect(result).to include(invoice_start_of_range)
        expect(result).to include(invoice_middle_of_range)
        expect(result).to include(invoice_end_of_range)
        expect(result).not_to include(invoice_before_range)
        expect(result).not_to include(invoice_after_range)
        expect(result.count).to eq(3)
      end

      it 'handles date correctly' do
        datetime_result = described_class.between_dates(
          DateTime.parse('2023-01-01 10:00:00'),
          DateTime.parse('2023-01-31 22:00:00')
        )

        expect(datetime_result).to include(invoice_start_of_range)
        expect(datetime_result).to include(invoice_middle_of_range)
        expect(datetime_result).to include(invoice_end_of_range)
        expect(datetime_result.count).to eq(3)
      end

      it 'uses beginning_of_day for start_date and end_of_day for end_date' do
        morning_invoice = create(:invoice, invoice_date: DateTime.parse('2023-01-01 00:01:00'))
        evening_invoice = create(:invoice, invoice_date: DateTime.parse('2023-01-31 23:59:00'))

        result = described_class.between_dates(start_date, end_date)

        expect(result).to include(morning_invoice)
        expect(result).to include(evening_invoice)
      end
    end
  end
end
