module Limiter
  extend ActiveSupport::Concern

  def check_limitation_ip_address
    token_bucket = TokenBucketManager.for_domain('client')
    token_bucket.with_resource(current_resource)
                .with_method(current_method)
                .with_ip_address(request.remote_ip).check_rate_limitation_with_ip_address
  rescue TokenBucket::TooManyRequestsError => e
    render json: {
      detail: e.message
    }, status: :too_many_requests
  end

  private

  def current_method
    params[:action]
  end

  def current_resource
    request.path.split('/').last
  end
end
