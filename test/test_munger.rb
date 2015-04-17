# encoding: UTF-8
#!/usr/bin/env ruby -w

require 'test/unit'
require "munger"
require 'rdf'

class TestMunger < Test::Unit::TestCase
  @@s = RDF::URI.new("http://example.com/d1")
  @@p = RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
  @@o = RDF::URI.new("http://example.com/v/Book")

  def test_create_model ()
    model = Munger.new
    assert_not_equal nil, model
  end

  def test_create_triple ()
    model = Munger.new
    model.add_triple(@@s, @@p, @@o)
    output = model.get_model
    assert(
      output.has_statement?(
        RDF::Statement.new(@@s, @@p, @@o)
      ), 
    "Model did not contain expected work data")
  end

  def test_get_model_as_ntriples
    test_model = RDF::Graph.new << [@@s, @@p, @@o]
    model = Munger.new
    model.add_triple(@@s, @@p, @@o)
    output = model.get_model_as_ntriples
    assert_equal(test_model.dump(:ntriples), output)
  end

end
