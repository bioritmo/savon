lib = File.expand_path "../lib", __FILE__
$:.unshift lib unless $:.include? lib

require "bioritmo/savon/version"

Gem::Specification.new do |s|
  s.name = "biosavon"
  s.version = BioRitmo::Savon::Version
  s.date = Date.today.to_s

  s.authors = "Adriano Torres"
  s.email = "adriano.torres@bioritmo.com.br"
  s.homepage = "http://github.com//bioritmo/savon/tree/bioritmo"
  s.summary = "Heavy metal Ruby SOAP client library"

  s.files = Dir["[A-Z]*", "{lib,spec}/**/*.{rb,xml,yml,gz}"]
  s.files += [".autotest", "spec/spec.opts"]
  s.test_files = Dir["spec/**/*.rb"]

  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options  = ["--charset=UTF-8", "--line-numbers", "--inline-source"]
  s.rdoc_options += ["--title", "Savon - Heavy metal Ruby SOAP client library"]

  s.add_dependency "builder", ">= 2.1.2"
  s.add_dependency "crack", ">= 0.1.4"

  s.add_development_dependency "rspec", ">= 1.2.8"
  s.add_development_dependency "mocha", ">= 0.9.7"
  s.add_development_dependency "fakeweb", ">= 1.2.7"
end