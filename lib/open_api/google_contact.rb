# encoding: UTF-8
module OpenApi
  GOOGLE_LOGIN_URL="https://www.google.com/accounts/ClientLogin"
  ACCOUNT_TYPE="HOSTED_OR_GOOGLE"
  SERVICE="cp"
  SOURCE="neomantic-ruby-1.8.7"

  class GoogleContact
    attr_reader :authorization_token

    def initialize(params)
      make_authorization_token(params[:id], params[:password])
    end

    def make_authorization_token(id, password)
      url = URI.parse(GOOGLE_LOGIN_URL)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      data = {
        "accountType" => ACCOUNT_TYPE,
        "Email" => ERB::Util.url_encode(id),
        "Passwd" => ERB::Util.url_encode(password),
        "service" => SERVICE,
        "source" => SOURCE
      }
      form_data = data.map {|key,value| "#{key.to_s}=#{value.to_s}" }.join('&')

      response = http.post(url.path, form_data)
      response.body.each_line do |line|
        @authorization_token = line.sub(/Auth=/,'').strip! if line =~ /Auth=/
      end
      @authorization_token
    end

    def request(method, url, header={}, body=nil)
      header = {
        "Authorization" => "GoogleLogin auth = #{authorization_token}",
        "GData-Version" => "3.0",
        'Content-Type' => 'application/json'
      }.merge(header)

      url = URI.parse(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = case method
                 when :get
                   http.send(method, url.request_uri, header)
                 when :post
                   http.send(method, url.request_uri, body, header)
                 when :put
                   http.send(method, url.request_uri, body, header)
                 end

      raise ArgumentError, response.body unless response.is_a? Net::HTTPSuccess
      response
    end

    class Base < OpenStruct
    end

    def create(resource)
      url = "https://www.google.com/m8/feeds/contacts/default/full"
      entry = <<-EOF
        <atom:entry xmlns:atom='http://www.w3.org/2005/Atom' xmlns:gd='http://schemas.google.com/g/2005'>
          <atom:category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/contact/2008#contacts/>
        </atom:entry>
      EOF

      doc = Nokogiri::XML(entry, nil, 'UTF-8')
      builder = XMLBuilder.new(doc, namespace: false)
      builder.name(resource)
      builder.organization(resource)
      builder.emails(resource)
      builder.phone_numbers(resource)
      builder.addresses(resource)
      builder.websites(resource)

      response = request(:post, url, {'Content-Type' => 'application/atom+xml'}, doc.to_xml)

      doc = Nokogiri::XML(response.body, nil, 'UTF-8')
      doc.remove_namespaces!
      resource.id = doc.xpath('//id').first.content.split('/').last

      info = request(:get, "https://www.google.com/m8/feeds/contacts/default/full/#{resource.id}")
      info = Nokogiri::XML(info.body, nil, 'UTF-8')
      info.remove_namespaces!

      resource.etag = info.xpath('//entry').first['etag']
    end

    def update(resource)
      url = "https://www.google.com/m8/feeds/contacts/default/full/#{resource.id}"
      etag = resource.etag

      entry = "<?xml version='1.0' encoding='UTF-8'?>
      <entry xmlns='http://www.w3.org/2005/Atom' xmlns:gContact='http://schemas.google.com/contact/2008' xmlns:batch='http://schemas.google.com/gdata/batch' xmlns:gd='http://schemas.google.com/g/2005'>
        <id>http://www.google.com/m8/feeds/contacts/default/base/#{resource.id}</id>
      </entry>"

      doc = Nokogiri::XML(entry, nil, 'UTF-8')
      builder = XMLBuilder.new(doc)
      builder.name(resource)
      builder.organization(resource)
      builder.emails(resource)
      builder.phone_numbers(resource)
      builder.addresses(resource)
      builder.websites(resource)

      response = request(:put, url, {'Content-Type' => 'application/atom+xml', 'If-Match' => etag}, doc.to_xml)

      doc = Nokogiri::XML(response.body, nil, 'UTF-8')
      doc.remove_namespaces!
      resource.etag = doc.xpath('//entry').first['etag']

      doc.xpath('//id').first.content
    end

    def save(resource)
      if resource.id
        update(resource)
      else
        create(resource)
      end
    end

    def load
      @contacts ||= []
      if @contacts.empty?
        response = request(:get, "https://www.google.com/m8/feeds/contacts/default/full")

        doc = Nokogiri::XML(response.body, nil, 'UTF-8')
        doc.remove_namespaces!
        doc.xpath('//feed/entry').each do |node|
          attributes = {
            id: (node.xpath('./id').first.content.split('/').last rescue ""),
            etag: (node['etag'] rescue ""),
            updated: (node.xpath('./updated').first.content rescue ""),
            title: (node.xpath('./title').first.content rescue ""),
            given_name: (node.xpath('./name/givenName').first.content rescue ""),
            family_name: (node.xpath('./name/familyName').first.content rescue ""),
            company: (node.xpath('./organization/orgName').first.content rescue ""),
            position: (node.xpath('./organization/orgTitle').first.content rescue ""),
            emails: (node.xpath('./email').map do |email|
              {
                label: (email['label'] || email['rel'].split('#').last rescue nil),
                email: email['address']
              }
            end rescue []),
            phone_numbers: (node.xpath('./phoneNumber').map do |phone_number|
              {
                label: (phone_number['label'] || phone_number['rel'].split('#').last rescue nil),
                phone_number: phone_number.content
              }
            end rescue []),
            addresses: (node.xpath('./structuredPostalAddress').map do |address|
              {
                label: (address['label'] || address['rel'].split('#').last rescue nil),
                city: (address.xpath('./city').first.content rescue ""),
                region: (address.xpath('./region').first.content rescue ""),
                country: (address.xpath('./country').first.content rescue ""),
                postcode: (address.xpath('./postcode').first.content rescue ""),
              }
            end rescue []),
            websites: (node.xpath('./website').map do |website|
              {
                label: website['rel'] || website['label'],
                url: website['href']
              }
            end rescue []),
          }

          @contacts << Base.new(attributes)
        end
      end
      @contacts
    end
  end
end