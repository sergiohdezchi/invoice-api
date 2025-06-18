class TopInvoiceSellsMailer < ApplicationMailer
  default from: "reports@test.com"

  def daily_report(top_sales)
    @top_sales = top_sales
    mail(to: ENV.fetch("TOP_SALES_EMAIL", "admin@test.com"), subject: "Top Invoice Sells Report")
  end
end
