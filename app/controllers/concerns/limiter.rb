module Limiter
  extend ActiveSupport::Concern

  def check_limitation
    token_bucket = TokenBucketManager.new(request.remote_ip)
    token_bucket.check_rate_limitation_with_ip_address
  end
end
