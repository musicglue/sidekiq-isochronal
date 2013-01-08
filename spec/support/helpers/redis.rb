require 'sidekiq'

def redis_result operation, *args
  @result = nil
  Sidekiq.redis { |conn| @result = conn.send(operation.to_sym, *args) }
  return @result
end