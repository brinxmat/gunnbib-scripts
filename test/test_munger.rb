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
    "Model did not contain expected triple")
  end

  def test_get_model_as_ntriples ()
    test_model = RDF::Graph.new << [@@s, @@p, @@o]
    model = Munger.new
    model.add_triple(@@s, @@p, @@o)
    output = model.get_model_as_ntriples
    assert_equal(test_model.dump(:ntriples), output)
  end

  def test_read_data_from_file ()
    munger = Munger.new
    output = munger.read_data_from_file('test/data/simple.csv')
    data = {:field_0 => 'zero', 
            :field_1 => 'one'}
    assert_equal(data, output)
  end

  def test_set_base_uri ()
    munger = Munger.new
    munger.set_base_uri(@@s)
    assert_equal(munger.get_base_uri, @@s)
  end

  def test_add_creator ()
    p_creator = RDF::URI.new("http://purl.org/dc/terms/creator")
    o_creator = RDF::URI.new("http://www.ntnu.no/ub/digital/person/f1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_creator("f1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_creator, o_creator)
      ), 
    "Model did not contain expected creator triple")
  end

  def test_add_title ()
    p_title = RDF::URI.new("http://purl.org/dc/terms/title")
    o_title = "t1"
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_title("t1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_title, o_title)
      ), 
    "Model did not contain expected title triple")
  end

  def test_add_identifier ()
    p_identifier = RDF::URI.new("http://purl.org/dc/terms/identifier")
    o_identifier = "i1"
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_identifier("i1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_identifier, o_identifier)
      ), 
    "Model did not contain expected identifier triple")
  end

end
