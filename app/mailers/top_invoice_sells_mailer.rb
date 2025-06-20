class TopInvoiceSellsMailer < ApplicationMailer
  default from: "sergiohdez.chi@gmail.com"

  def daily_report(top_sales)
    @top_sales = top_sales
    mail(to: ENV.fetch("TOP_SALES_EMAIL", "sergiohdez.chi@gmail.com"), subject: "Top Invoice Sells Report")
  end
end
