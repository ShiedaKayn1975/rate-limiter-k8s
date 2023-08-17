module Limiter
  extend ActiveSupport::Concern
  
  def check_limitation
    TokenBucketManager.new
  end
end
