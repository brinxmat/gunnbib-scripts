# encoding: UTF-8
#!/usr/bin/env ruby -w

require 'rdf'
require 'rdf/ntriples'
require 'test/unit'

class Munger

  @@model = nil

  def initialize ()
    create_new_model
  end

  def create_new_model ()
    if (@@model == nil)
      @@model = RDF::Graph.new
    else
      STDOUT.puts "Attempted to initialize model, but a pre-existing model was found"
    end
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

end