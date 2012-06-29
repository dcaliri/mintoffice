# encoding: UTF-8
module OpenApi
  class XMLBuilder
    def initialize(doc, opts={})
      @doc = doc
      @options = {namespace: true}.merge(opts)
    end

    def name(resource)
      node = Nokogiri::XML::Node.new('gd:name', doc)

      given_name = Nokogiri::XML::Node.new('gd:givenName',node)
      if resource.given_name
        given_name.content = resource.given_name
        node.add_child(given_name)
      end

      family_name = Nokogiri::XML::Node.new('gd:familyName',node)
      if resource.family_name
        family_name.content = resource.family_name
        node.add_child(family_name)
      end

      full_name = Nokogiri::XML::Node.new('gd:fullName',node)
      full_name.content = resource.full_name
      node.add_child(full_name)

      parent.add_child(node)

      unless options[:namespace]
        node.namespace = nil
        given_name.namespace = nil
        family_name.namespace = nil
        full_name.namespace = nil
      end
    end

    def organization(resource)
      node = Nokogiri::XML::Node.new('gd:organization', doc)
      node['rel'] = "http://schemas.google.com/g/2005#other"

      org_name = Nokogiri::XML::Node.new('gd:orgName',node)
      if resource.company
        org_name.content = resource.company
        node.add_child(org_name)
      end

      org_title = Nokogiri::XML::Node.new('gd:orgTitle',node)
      if resource.position
        org_title.content = resource.position
        node.add_child(org_title)
      end

      parent.add_child(node)

      unless options[:namespace]
        node.namespace = nil
        org_name.namespace = nil
        org_title.namespace = nil
      end
    end

    def emails(list)
      list.each do |email|
        if email[:email]
          node = Nokogiri::XML::Node.new('gd:email',doc)
          node['label'] = email[:label]
          node['address'] = email[:email]
          node['displayName'] = email[:email]

          parent.add_child(node)

          node.namespace = nil unless options[:namespace]
        end
      end
    end

    def phone_numbers(list)
      list.each do |phone_number|
        if phone_number[:phone_number]
          node = Nokogiri::XML::Node.new('gd:phoneNumber', doc)
          node['label'] = phone_number[:label]
          node.content = phone_number[:phone_number]

          parent.add_child(node)

          node.namespace = nil unless options[:namespace]
        end
      end
    end

    def addresses(list)
      list.each do |address|
        node = Nokogiri::XML::Node.new('gd:structuredPostalAddress', doc)
        node['label'] = address.label

        city = Nokogiri::XML::Node.new('gd:city',node)
        if address.city
          city.content = address.city
          node.add_child(city)
        end

        region = Nokogiri::XML::Node.new('gd:region',node)
        if address.region
          region.content = address.region
          node.add_child(region)
        end

        postcode = Nokogiri::XML::Node.new('gd:postcode',node)
        if address.postcode
          postcode.content = address.postcode
          node.add_child(postcode)
        end

        country = Nokogiri::XML::Node.new('gd:country',node)
        if address.country
          country.content = address.country
          node.add_child(country)
        end

        formatted = Nokogiri::XML::Node.new('gd:formattedAddress',node)
        if address.formatted
          formatted.content = address.formatted
          node.add_child(formatted)
        end

        parent.add_child(node)

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

    def websites(list)
      list.each do |website|
        if website[:url]
          node = Nokogiri::XML::Node.new('gContact:website', doc)
          node['label'] = website[:label]
          node['href'] = website[:url]

          parent.add_child(node)

          node.namespace = nil unless options[:namespace]
        end
      end
    end

    private
    def doc
      @doc
    end

    def parent
      @doc.xpath('//*').first
    end

    def options
      @options
    end
  end
end