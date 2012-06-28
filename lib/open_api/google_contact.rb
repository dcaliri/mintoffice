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

    def request(method, url, header={}, body=nil)
      header = {"Authorization" => "GoogleLogin auth = #{authorization_token}", "GData-Version" => "3.0", 'Content-Type' => 'application/json'}.merge(header)

      url = URI.parse(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      case method
      when :get
        http.send(method, url.request_uri, header)
      when :post
        http.send(method, url.request_uri, body, header)
      when :put
        http.send(method, url.request_uri, body, header)
      end
    end

    class Base < OpenStruct
    end

    def add_emails_to_xml(email_list, doc, opts={})
      options = {namespace: true}.merge(opts)
      email_list.each do |email|
        if email.email?
          node = Nokogiri::XML::Node.new('gd:email',doc)
          node['label'] = email.target
          node['address'] = email.email
          node['displayName'] = email.email

          doc.xpath('//*').first.add_child(node)
          node.namespace = nil unless options[:namespace]
        end
      end
    end

    def add_phone_numbers_to_xml(phone_number_list, doc, opts={})
      options = {namespace: true}.merge(opts)

      phone_number_list.each do |phone_number|
        if phone_number.number?
          node = Nokogiri::XML::Node.new('gd:phoneNumber', doc)
          node['label'] = phone_number.target
          node.content = phone_number.number

          doc.xpath('//*').first.add_child(node)
          node.namespace = nil unless options[:namespace]
        end
      end
    end

    def add_name_to_xml(resource, doc, opts={})
      options = {namespace: true}.merge(opts)
      unless resource.name.blank?
        node = Nokogiri::XML::Node.new('gd:name', doc)

        given_name = Nokogiri::XML::Node.new('gd:givenName',node)
        if resource.firstname?
          given_name.content = resource.firstname
          node.add_child(given_name)
        end

        family_name = Nokogiri::XML::Node.new('gd:familyName',node)
        if resource.lastname?
          family_name.content = resource.lastname
          node.add_child(family_name)
        end

        full_name = Nokogiri::XML::Node.new('gd:fullName',node)
        full_name.content = resource.name
        node.add_child(full_name)

        doc.xpath('//*').first.add_child(node)

        unless options[:namespace]
          node.namespace = nil
          given_name.namespace = nil
          family_name.namespace = nil
          full_name.namespace = nil
        end
      end
    end

    def add_organization_to_xml(resource, doc, opts={})
      options = {namespace: true}.merge(opts)
      node = Nokogiri::XML::Node.new('gd:organization', doc)
      node['rel'] = "http://schemas.google.com/g/2005#other"

      org_name = Nokogiri::XML::Node.new('gd:orgName',node)
      if resource.company_name
        org_name.content = resource.company_name
        node.add_child(org_name)
      end

      org_title = Nokogiri::XML::Node.new('gd:orgTitle',node)
      if resource.position
        org_title.content = resource.position
        node.add_child(org_title)
      end

      doc.xpath('//*').first.add_child(node)

      unless options[:namespace]
        node.namespace = nil
        org_name.namespace = nil
        org_title.namespace = nil
      end
    end

    def add_addresses_to_xml(address_list, doc, opts={})
      options = {namespace: true}.merge(opts)
      address_list.each do |address|
        node = Nokogiri::XML::Node.new('gd:structuredPostalAddress', doc)
        node['label'] = address.target

        city = Nokogiri::XML::Node.new('gd:city',node)
        if address.city?
          city.content = address.city
          node.add_child(city)
        end

        region = Nokogiri::XML::Node.new('gd:region',node)
        if address.province?
          region.content = address.province
          node.add_child(region)
        end

        postcode = Nokogiri::XML::Node.new('gd:postcode',node)
        if address.postal_code?
          postcode.content = address.postal_code
          node.add_child(postcode)
        end

        country = Nokogiri::XML::Node.new('gd:country',node)
        if address.country?
          country.content = address.country
          node.add_child(country)
        end

        formatted = Nokogiri::XML::Node.new('gd:formattedAddress',node)
        if address.info
          formatted.content = address.info
          node.add_child(formatted)
        end

        doc.xpath('//*').first.add_child(node)

        unless options[:namespace]
          node.namespace = nil
          formatted.namespace = nil
          country.namespace = nil
          postcode.namespace = nil
          region.namespace = nil
          city.namespace = nil
        end
      end
    end

    def add_websites_to_xml(website_list, doc, opts={})
      options = {namespace: true}.merge(opts)
      website_list.each do |website|
        node = Nokogiri::XML::Node.new('gContact:website', doc)
        node['label'] = website.target
        node['href'] = website.description

        doc.xpath('//*').first.add_child(node)

        node.namespace = nil unless options[:namespace]
      end
    end

    def create(resource)
      url = "https://www.google.com/m8/feeds/contacts/default/full"
      entry_xml = <<-EOF
        <atom:entry xmlns:atom='http://www.w3.org/2005/Atom' xmlns:gd='http://schemas.google.com/g/2005'>
          <atom:category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/contact/2008#contacts/>
        </atom:entry>
      EOF

      entry_doc = Nokogiri::XML(entry_xml, nil, 'UTF-8')

      add_name_to_xml(resource, entry_doc, namespace: false)
      add_organization_to_xml(resource, entry_doc, namespace: false)
      add_emails_to_xml(resource.emails, entry_doc, namespace: false)
      add_phone_numbers_to_xml(resource.phone_numbers, entry_doc, namespace: false)
      add_addresses_to_xml(resource.addresses, entry_doc, namespace: false)
      add_websites_to_xml(resource.others, entry_doc, namespace: false)

      # raise entry_doc.to_xml.inspect
      response = request(:post, url, {'Content-Type' => 'application/atom+xml'}, entry_doc.to_xml)
      Rails.logger.info "create result = #{response.body.inspect}"

      doc = Nokogiri::XML(response.body, nil, 'UTF-8')
      doc.remove_namespaces!
      resource.google_id = doc.xpath('//id').first.content.split('/').last

      info = request(:get, "https://www.google.com/m8/feeds/contacts/default/full/#{resource.google_id}")
      info = Nokogiri::XML(info.body, nil, 'UTF-8')
      info.remove_namespaces!
      resource.google_etag = info.xpath('//entry').first['etag']

      resource.save!
    end

    def update(resource)
      url = "https://www.google.com/m8/feeds/contacts/default/full/#{resource.google_id}"
      etag = resource.google_etag

      entry_xml = "<?xml version='1.0' encoding='UTF-8'?>
      <entry xmlns='http://www.w3.org/2005/Atom' xmlns:gContact='http://schemas.google.com/contact/2008' xmlns:batch='http://schemas.google.com/gdata/batch' xmlns:gd='http://schemas.google.com/g/2005'>
        <id>http://www.google.com/m8/feeds/contacts/default/base/73c1a5e80e641fc6</id>
      </entry>"
      entry_doc = Nokogiri::XML(entry_xml, nil, 'UTF-8')

      add_name_to_xml(resource, entry_doc)
      add_organization_to_xml(resource, entry_doc)
      add_emails_to_xml(resource.emails, entry_doc)
      add_phone_numbers_to_xml(resource.phone_numbers, entry_doc)
      add_addresses_to_xml(resource.addresses, entry_doc)
      add_websites_to_xml(resource.others, entry_doc)

      response = request(:put, url, {'Content-Type' => 'application/atom+xml', 'If-Match' => etag}, entry_doc.to_xml)

      Rails.logger.info "result = #{response.body.inspect}"

      doc = Nokogiri::XML(response.body, nil, 'UTF-8')
      doc.remove_namespaces!
      resource.google_etag = doc.xpath('//entry').first['etag']
      resource.save!

      doc.xpath('//id').first.content
    end

    def save(resource)
      if resource.google_id?
        update(resource)
      else
        create(resource)
      end
    end

    def load
      @contacts ||= []
      if @contacts.empty?
        @doc.xpath('//feed/entry').each do |node|
          attributes = {
            id: (node.xpath('./id').first.content.split('/').last rescue ""),
            etag: (node['etag'] rescue ""),
            updated: (node.xpath('./updated').first.content rescue ""),
            title: (node.xpath('./title').first.content rescue ""),
            givenName: (node.xpath('./name/givenName').first.content rescue ""),
            familyName: (node.xpath('./name/familyName').first.content rescue ""),
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

          # raise attributes.inspect

          @contacts << Base.new(attributes)
        end
      end
      @contacts
    end
  end
end