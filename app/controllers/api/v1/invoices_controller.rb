module Api
  module V1
    class InvoicesController < ApplicationController
      def index
        binding.irb
        return render json: { error: "start_date parameter is required" }, status: :bad_request unless index_params[:start_date].present?

        invoices = InvoiceFetch.new(index_params).call

        render json: InvoiceSerializer.new(invoices,
          meta: {
            current_page: invoices.current_page,
            total_pages: invoices.total_pages,
            total_count: invoices.total_entries
          }
        ).serializable_hash
      end

      private

      def index_params
         params.permit(:start_date, :end_date, :page, :per_page)
      end
    end
  end
end
