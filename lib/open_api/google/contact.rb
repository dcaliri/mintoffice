module OpenApi
  module Google
    GOOGLE_LOGIN_URL="https://www.google.com/accounts/ClientLogin"
    ACCOUNT_TYPE="HOSTED_OR_GOOGLE"
    SERVICE="cp" # contacts service identifier
    SOURCE="neomantic-ruby-1.8.7" #this could be changed

    class Contact
      attr_reader :authorization_token

      def initialize(params)
        make_authorization_token(params[:id], params[:password])

        response = request(:get, "https://www.google.com/m8/feeds/contacts/default/full")
        @doc = Nokogiri::XML(response.body, nil, 'UTF-8')
        @doc.remove_namespaces!
      end

      def make_authorization_token(id, password)
        url = URI.parse(GOOGLE_LOGIN_URL)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if url.scheme == "https"
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        data = { "accountType" => ACCOUNT_TYPE,
            "Email" => ERB::Util.url_encode(id),
            "Passwd" => ERB::Util.url_encode(password),
            "service" => SERVICE,
            "source" => SOURCE }

        form_data = data.map {|key,value| "#{key.to_s}=#{value.to_s}" }.join('&')
        response = http.post(url.path, form_data)
        @authorization_token = ""
        response.body.each_line { |line|
          if line =~ /Auth=/
            @authorization_token = line.sub(/Auth=/,'').strip!
          end
        }
        @authorization_token
      end

      def request(method, url, params={})
        header = {"Authorization" => "GoogleLogin auth = #{authorization_token}", "GData-Version" => "3.0", 'Content-Type' => 'application/json'}
        form_data = params.map {|key,value| "#{key.to_s}=#{value.to_s}" }.join('&')

        url = URI.parse(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.send(method, url.request_uri, header, form_data)
      end

      class Base < OpenStruct
      end

      def save(resource)
        request(:post, "https://www.google.com/m8/feeds/contacts/default/full")
      end

      def load
        @contacts ||= []
        if @contacts.empty?
          @doc.xpath('//feed/entry').each do |node|
            attributes = {
              id: (node.xpath('./id').first.content rescue ""),
              updated: (node.xpath('./updated').first.content rescue ""),
              title: (node.xpath('./title').first.content rescue ""),
              givenName: (node.xpath('./name/givenName').first.content rescue ""),
              familyName: (node.xpath('./name/familyName').first.content rescue ""),
              email: (node.xpath('./email').first['address'] rescue ""),
              address: (node.xpath('./structuredPostalAddress/formattedAddress').first.content rescue ""),
              phoneNumber: (node.xpath('./phoneNumber').first.content rescue ""),
              website: (node.xpath('./website').first['href'] rescue "")
            }

            @contacts << Base.new(attributes)
          end
        end
        @contacts
      end
    end
  end
end