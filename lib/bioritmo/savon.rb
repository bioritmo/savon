module BioRitmo
  module Savon
    # Raised in case of an HTTP error.
    class HTTPError < StandardError; end

    # Raised in case of a SOAP fault.
    class SOAPFault < StandardError; end

  end
end

# standard libs
require "logger"
require "net/https"
require "base64"
require "digest/sha1"
require "rexml/document"
require "stringio"
require "zlib"
require "cgi"

# gem dependencies
require "builder"
require "crack/xml"

# core files
require "bioritmo/savon/core_ext"
require "bioritmo/savon/wsse"
require "bioritmo/savon/soap"
require "bioritmo/savon/logger"
require "bioritmo/savon/request"
require "bioritmo/savon/response"
require "bioritmo/savon/wsdl_stream"
require "bioritmo/savon/wsdl"
require "bioritmo/savon/client"
require "bioritmo/savon/version"