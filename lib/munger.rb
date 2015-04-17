# encoding: UTF-8
#!/usr/bin/env ruby -w

require 'rdf'
require 'rdf/ntriples'
require 'test/unit'
require 'csv'

class Munger

  @@model = nil
  @@baseURI = nil

  def initialize ()
    create_new_model
  end

  def create_new_model ()
      @@model = RDF::Graph.new
  end

  def add_triple (s, p, o)
    @@model << [s, p, o]
  end

  def get_model ()
    return @@model
  end

  def get_model_as_ntriples ()
    @@model.dump(:ntriples)
  end

  def read_data_from_file (file)
    @data = {}
    CSV.foreach(file,
                 {:headers => true, :header_converters => :symbol}
                ) do |row|
      @data.merge!(row)
    end

    return @data
  end

  def set_base_uri (uri)
    @@baseURI = uri
  end

  def get_base_uri ()
    return @@baseURI
  end

  def add_creator (creator)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/dc/terms/creator"),
      RDF::URI.new("http://www.ntnu.no/ub/digital/person/" + creator)
      )
  end

  def add_title (title)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/dc/terms/title"),
      RDF::Literal.new(title)
      )
  end

    def add_identifier (identifier)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/dc/terms/identifier"),
      RDF::Literal.new(identifier)
      )
  end
end