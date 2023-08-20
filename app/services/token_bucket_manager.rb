class TokenBucketManager
  RULE_FILE_PATH = 'config/rate_limit_rule.yaml'.freeze

  def initialize resource_rules, domain
    @resource_rules = resource_rules
    @domain = domain
  end

  def self.for_domain domain
    resource_rules = Rails.cache.fetch(['limiter', domain], expires_in: 12.hours) do
      rules = YAML.load_file(RULE_FILE_PATH)
      resources = rules['rate_limit_rules'].find { |rule| rule['domain'] == domain }
      resources['resources']
    end

    TokenBucketManager.new(resource_rules, domain)
  end

  def with_resource resource
    @resource = resource
    self
  end

  def with_method method
    @method = method
    self
  end

  def with_ip_address ip_address
    @ip_address = ip_address
    self
  end

  def check_rate_limitation_with_ip_address
    resource = @resource_rules.find { |r| r['name'] == @resource }
    return if resource.blank?

    action = resource['actions'].find { |ac| ac['action'] == @method }
    return if action.blank?

    config = {
      resource_name: resource['name'],
      method: @method,
      domain: @domain,
      detail: action['descriptors']
    }

    TokenBucket.new(config).consume(@ip_address)
  end
end

class TokenBucket
  def initialize config
    @domain = config[:domain]
    @resource_name = config[:resource_name]
    @method = config[:method]
    @key = config[:detail]['key']

    @unit = config[:detail]['rate_limit']['unit']
    @request_per_unit = config[:detail]['rate_limit']['request_per_unit']

    @lock = Mutex.new
  end

  def consume ip_address
    @lock.synchronize do
      data = refill_tokens(ip_address)
      raise TooManyRequestsError, 'Too many requests' if data[:tokens].zero?

      data[:tokens] = data[:tokens] - 1
      Rails.cache.write([@domain, @resource_name, @method, @key, ip_address], data)
    end
  end

  class TooManyRequestsError < StandardError; end

  private

  def refill_tokens ip_address
    value = Rails.cache.read([@domain, @resource_name, @method, @key, ip_address])

    new_value = {
      last_refill_time: Time.zone.now,
      tokens: @request_per_unit
    }

    if value.blank? || (value[:last_refill_time] + 1.send(@unit) < Time.zone.now)
      Rails.cache.write([@domain, @resource_name, @method, @key, ip_address], new_value)
      return new_value
    end

    value
  end
end
