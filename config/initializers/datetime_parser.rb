DateTime.class_eval do
  def self.parse_by_params(params, key)
    new(params["#{key}(1i)"].to_i, params["#{key}(2i)"].to_i, params["#{key}(3i)"].to_i)
  end
end

Date.class_eval do
  def self.parse_by_params(params, key)
    new(params["#{key}(1i)"].to_i, params["#{key}(2i)"].to_i, params["#{key}(3i)"].to_i)
  end
end