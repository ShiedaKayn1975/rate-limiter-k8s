require "active_support/concern"

module RateLimiter
  extend ActiveSupport::Concern

  included do
    def check_limitation
      TokenBucketManager.new
    end
  end
end
