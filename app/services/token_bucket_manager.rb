class TokenBucketManager
  RULE_FILE_PATH = "config/rate_limit_rule.yaml"

  def initialize ip
    @ip = ip
  end

  def check_rate_limitation_with_ip_address
    @rule = Rails.cache.fetch(["limiter", "ip_address"], expires_in: 12.hours) do
      rules = YAML.load_file(RULE_FILE_PATH)
      resources = rules[:rate_limit_rules].filter {|rule| rule[:domain] == "client"}
      resources
    end
  end
end
