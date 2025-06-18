class DailyTopSellsReportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    limit = args.first || 10
    top_selling_days = Reports::TopSellingDaysReport.new(limit: limit).call
    return if top_selling_days.empty?

    TopInvoiceSellsMailer.daily_report(top_selling_days).deliver_now
  end
end
