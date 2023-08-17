class TokenBucketManager
  RULE_FILE_PATH = "config/rate_limit_rule.yaml"

  def initialize ip
    @ip = ip
  end

  def check_rate_limitation_with_ip_address
    @rule = Rails.cache.fetch(["limiter", "ip_address"], expires_in: 12.hours) do
      YAML.load_file(RULE_FILE_PATH)
    end
  end
end
