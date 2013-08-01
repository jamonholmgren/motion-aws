# Adapted from https://forums.aws.amazon.com/message.jspa?messageID=467432
module MotionAWS
  class Signer
 
    def initialize(options = {})
      @secret_key = options[:secret_key]
      raise Exception.new("You must supply a :secret_key") unless @secret_key
      @access_key = options[:access_key]
    end
 
    def query_with_signature(hash)
      return hash_to_query( add_signature(hash)  )
    end
 
    # Pass in a hash representing params for a query string.
    # param keys should be strings, not symbols please.
    # Will return a param with the "Signature" key/value added, without
    # modifying original.
    def add_signature(params)
      # Make a copy to not modify original
      add_signature!( Hash[params]  )
    end
 
    # Like #add_signature, but will mutate the hash passed in,
    # adding a "Signature" key/value to hash passed in, and return
    # hash too.
    def add_signature!(params)
 
      # supply timestamp, signature method, signature version and access key if not already provided
      params["Timestamp"] ||= Time.now.iso8601
      params["AWSAccessKeyId"] ||= access_key
      params["SignatureMethod"] ||= "HmacSHA256"
      params["SignatureVersion"] ||= "2"
      # Existing "Signature"? That's gotta go before we generate a new
      # signature and add it.
      params.delete("Signature")
 
      query_string = canonical_querystring(params)
 
      string_to_sign = string_to_sign(query_string)
 
      sign = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), @secret_key, string_to_sign)
      # chomp is important!  the base64 encoded version will have a newline at the end
      signature = Base64.encode64(sign).chomp
 
      params["Signature"] = signature
 
      #order doesn't matter for the actual request, we return the hash
      #and let client turn it into a url.
      return params
    end
 
    # Insist on specific method of URL encoding, RFC3986.
    def url_encode(string)
      # It's kinda like CGI.escape, except CGI.escape is encoding a tilde when
      # it ought not to be, so we turn it back. Also space NEEDS to be %20 not +.
      return CGI.escape(string).gsub("%7E", "~").gsub("+", "%20")
    end
 
    # param keys should be strings, not symbols please. return a string joined
    # by & in canonical order.
    def canonical_querystring(params)
      # I hope this built-in sort sorts by byte order, that's what's required.
      values = params.keys.sort.collect {|key|  [url_encode(key), url_encode(params[key].to_s)].join("=") }
 
      return values.join("&")
    end
 
    def string_to_sign(query_string, options = {})
      options[:verb] = "GET"
      options[:request_uri] = "/"
      options[:host] = "ec2.ap-southeast-1.amazonaws.com"
 
      return options[:verb] + "\n" +
        options[:host].downcase + "\n" +
        options[:request_uri] + "\n" +
        query_string
    end
 
    # Turns a hash into a query string, returns the query string.
    # url-encodes everything to Amazon's specifications.
    def hash_to_query(hash)
      hash.collect do |key, value|
 
        url_encode(key) + "=" + url_encode(value)
 
      end.join("&")
    end
 
    def secret_key
      return @secret_key
    end
    def access_key
      return @access_key
    end
    def access_key=(a)
      @access_key = a
    end
 
  end
end
