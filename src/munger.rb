# encoding: UTF-8
#!/usr/bin/env ruby -w

require 'rdf'
require 'rdf/ntriples'

class Munger

  model = null

  def initialize ()
    get_new_model
  end

  def create_new_model ()
    if (model == null)
      graph = RDF::Graph.new
    end
    else
      STDOUT.puts "Attempted to initialize model, but a pre-existing model was found"
  end

  def get_model ()
    graph.dump(:ntriples)
  end 




end