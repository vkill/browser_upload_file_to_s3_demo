module AWSS3S3ObjectExtension

  extend ActiveSupport::Concern

  included do
    alias_method_chain :signature, :dev
    alias_method_chain :request_for_signing, :dev
  end

  private

  def request_for_signing_with_dev(options)
    req = request_for_signing_without_dev(options)
    if options.has_key?(:headers)
      _headers = options[:headers]
      if _headers.has_key?('content-type')
        req.headers['content-type'] = _headers['content-type']
      else
        req.headers['content-type'] = 'application/octetstream'
      end
    end
    req
  end

  def signature_with_dev(method, expires, request)

    if method.to_s.upcase != "PUT"
      return signature_without_dev(method, expires, request)
    end

    parts = []
    parts << method
    parts << ""
    parts << request.headers['content-type']
    parts << expires
    if token = config.credential_provider.session_token
      parts << "x-amz-security-token:%s" % token
    end
    parts << request.canonicalized_resource

    string_to_sign = parts.join("\n")

    Rails.logger.debug "StringToSign: %s" % string_to_sign

    secret = config.credential_provider.secret_access_key
    AWS::Core::Signer.sign(secret, string_to_sign, 'sha1')
  end

end