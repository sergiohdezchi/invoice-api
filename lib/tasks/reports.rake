namespace :reports do
  desc "Generate and send daily top selling days report asynchronously"
  task :queue_daily_top_sells, [ :limit ] => :environment do |task, args|
    limit = 10
    puts "Queueing daily top selling days report job with limit of #{limit} entries..."
    DailyTopSellsReportJob.perform_later(limit)
    puts "Daily top selling days report job queued successfully!"
  end
end
