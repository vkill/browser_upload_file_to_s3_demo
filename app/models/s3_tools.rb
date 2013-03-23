require 'aws-sdk'
require 'net/http'

class S3Tools

  ::AWS.config(:logger => Rails.logger)
  AWS.config(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  )

  S3 = AWS::S3.new
  S3_BUCKET = S3.buckets[ENV['AWS_S3_BUCKET']]

  class << self

    def object_url_for(object_key, method, options={})
      obj = S3_BUCKET.objects[object_key.to_s]
      url = obj.url_for method, options
      url.to_s
    end

    def delete_object(object_key, method, options={})
      url = object_url_for(object_key, method, options)
      remote_delete_object(url)
    end

    private

    def remote_delete_object(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 30
      http.read_timeout = 30
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Delete.new(uri.request_uri)

      response = http.request(request)

      yield response if block_given?

      if response.code.to_i == 204
        true
      else  
        false
      end
    end
  end

end