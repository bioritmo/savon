require "savon/soap/xml"
require "savon/soap/request"
require "savon/soap/response"
require "akami"
require "httpi"

module Savon
  class Operation

    def self.create(operation_name, wsdl)
      ensure_exists! operation_name, wsdl
      new(operation_name, wsdl)
    end

    def self.ensure_exists!(operation_name, wsdl)
      unless wsdl.soap_actions.include? operation_name
        raise ArgumentError, "Unable to find SOAP operation: #{operation_name}\n" \
                             "Operations provided by your service: #{wsdl.soap_actions.inspect}"
      end
    end

    def initialize(name, wsdl)
      @name = name
      @wsdl = wsdl
    end

    def call(opts = {})
      # XXX: pretend like we already support all options from here on [dh, 2012-11-24]
      options = Struct.new(:raise_errors, :env_namespace, :soap_version, :soap_header,
                           :message, :xml, :hooks, :logger, :pretty_print_xml).new

      options.message      = opts[:message]
      options.soap_version = 1
      options.hooks        = Class.new { def fire(*) yield end }.new
      options.logger       = Class.new { def log(msg, *) end   }.new

      http = create_http(options)
      wsse = create_wsse(options)
      soap = create_soap(options)
      soap.wsse = wsse

      request = SOAP::Request.new(options, http, soap)
      response = request.response

      # XXX: store and resend cookies [dh, 2012-12-06]
      #http.set_cookies(response.http)

      # XXX: leaving this out for now [dh, 2012-12-06]
      #if wsse.verify_response
        #WSSE::VerifySignature.new(response.http.body).verify!
      #end

      response
    end

    private

    def create_soap(options)
      soap = SOAP::XML.new(options)
      soap.body = options.message
      soap.xml = options.xml

      soap.endpoint = @wsdl.endpoint
      soap.element_form_default = @wsdl.element_form_default

      soap.namespace = namespace
      soap.namespace_identifier = namespace_identifier

      add_wsdl_namespaces_to_soap(soap)
      add_wsdl_types_to_soap(soap)

      # XXX: leaving out the option to set attributes on the input tag for now [dh, 2012-12-06]
      soap.input = [namespace_identifier, soap_input_tag.to_sym, {}] # attributes]
      soap
    end

    def create_wsse(options)
      # TODO: akami needs to be configured somehow [dh, 2012-12-06]
      Akami.wsse
    end

    def create_http(options)
      # TODO: httpi needs to know about proxies, auth, etc [dh, 2012-12-06]
      http = HTTPI::Request.new
      http.headers["SOAPAction"] = %{"#{soap_action}"}
      http
    end

    def soap_input_tag
      @wsdl.soap_input(@name.to_sym)
    end

    def soap_action
      @wsdl.soap_action(@name.to_sym)
    end

    def namespace
      # XXX: why the fallback? [dh, 2012-11-24]
      #if operation_namespace_defined_in_wsdl?
        @wsdl.parser.namespaces[namespace_identifier.to_s]
      #else
        #@wsdl.namespace
      #end
    end

    def namespace_identifier
      @wsdl.operations[@name][:namespace_identifier].to_sym
    end

    def add_wsdl_namespaces_to_soap(soap)
      @wsdl.type_namespaces.each do |path, uri|
        soap.use_namespace(path, uri)
      end
    end

    def add_wsdl_types_to_soap(soap)
      @wsdl.type_definitions.each do |path, type|
        soap.types[path] = type
      end
    end

  end
end