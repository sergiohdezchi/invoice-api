module Reports
  class TopSellingDaysReport
    DEFAULT_LIMIT = 10
    CACHE_EXPIRY = 23.hours

    def initialize(limit: DEFAULT_LIMIT)
      @limit = limit
      @date = Date.today
    end

    def call
      Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRY) do
        fetch_top_selling_days
      end
    end

    def refresh!
      Rails.cache.delete(cache_key)
      call
    end

    private

    attr_reader :limit, :date

    def cache_key
      "reports:top_selling_days:limit=#{limit}:date=#{date}"
    end

    def fetch_top_selling_days
      Invoice.group("DATE(invoice_date)")
             .order("SUM(total) DESC")
             .limit(limit)
             .pluck("DATE(invoice_date)", "SUM(total)")
    end
  end
end
