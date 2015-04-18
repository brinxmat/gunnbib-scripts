# encoding: UTF-8
#!/usr/bin/env ruby -w

require 'test/unit'
require "munger"
require 'rdf'
require 'uuid'
require 'rdf/isomorphic'

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

  def test_add_recipient ()
    p_recipient = RDF::URI.new("http://purl.org/ontology/bibo/recipient")
    o_recipient = RDF::URI.new("http://www.ntnu.no/ub/digital/person/f1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_recipient("f1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_recipient, o_recipient)
      ), 
    "Model did not contain expected recipient triple")
  end

  def test_add_document_type ()
    p_format = RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
    o_format = RDF::URI.new("http://www.ntnu.no/ub/digital/format/f1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_document_type("f1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_format, o_format)
      ), 
    "Model did not contain expected format triple")
  end  

  def test_add_country ()
    p_country = RDF::URI.new("http://www.ntnu.no/ub/data/nl#geoSubjectCountry")
    o_country = RDF::URI.new("http://sws.geonames.org/f1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_country("f1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_country, o_country)
      ), 
    "Model did not contain expected country triple")
  end 

  def test_add_county ()
    p_county = RDF::URI.new("http://www.ntnu.no/ub/data/nl#geoSubjectCounty")
    o_county = RDF::URI.new("http://sws.geonames.org/f1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_county("f1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_county, o_county)
      ), 
    "Model did not contain expected county triple")
  end 

  def test_add_municipality ()
    p_municipality = RDF::URI.new("http://www.ntnu.no/ub/data/nl#geoSubjectMunicipality")
    o_municipality = RDF::URI.new("http://sws.geonames.org/f1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_municipality("f1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_municipality, o_municipality)
      ), 
    "Model did not contain expected municipality triple")
  end

  def test_add_place_of_creation ()
    p_place_of_creation = RDF::URI.new("http://www.ntnu.no/ub/data/nl#placeOfCreation")
    o_place_of_creation = RDF::URI.new("http://sws.geonames.org/f1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_place_of_creation("f1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_place_of_creation, o_place_of_creation)
      ), 
    "Model did not contain expected place of creation triple")
  end 

  def test_add_genre ()
    p_genre = RDF::URI.new("http://www.ntnu.no/ub/data/nl#genre")
    o_genre = RDF::URI.new("http://www.ntnu.no/ub/data/genre/g1")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_genre("g1")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_genre, o_genre)
      ), 
    "Model did not contain expected genre triple")
  end

  def test_add_text_subject ()
    p_text_subject = RDF::URI.new("http://purl.org/dc/terms/subject")
    o_text_subject = RDF::Literal.new("test")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_text_subject("test")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_text_subject, o_text_subject)
      ), 
    "Model did not contain expected text subject triple")
  end

  def test_add_subject ()
    p_subject = RDF::URI.new("http://purl.org/dc/terms/subject")
    o_subject = RDF::URI.new("http://www.example.com/subject")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_subject("subject")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_subject, o_subject)
      ), 
    "Model did not contain expected subject triple")
  end

  def test_add_map_scale ()
    p_map_scale = RDF::URI.new("http://www.geographicknowledge.de/vocab/maps#hasScale")
    o_map_scale = RDF::Literal.new("test")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_map_scale("test")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_map_scale, o_map_scale)
      ), 
    "Model did not contain expected map scale triple")
  end

  def test_add_dimensions ()
    p_dimensions = RDF::URI.new("http://www.ntnu.no/ub/data/nl#dimensions")
    o_dimensions = RDF::Literal.new("20 x 20")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_dimensions("20 x 20")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_dimensions, o_dimensions)
      ), 
    "Model did not contain expected dimensions triple")
  end

  def test_add_note ()
    p_note = RDF::URI.new("http://www.ntnu.no/ub/data/nl#note")
    o_note = RDF::Literal.new("Note")
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_note("Note")
    model = munger.get_model

    assert(
      model.has_statement?(
        RDF::Statement.new(@@s, p_note, o_note)
      ), 
    "Model did not contain expected note triple")
  end

  def test_add_point_date ()
    repo = RDF::Repository.load('./test/data/simple_point_date.nt')
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_point_date("2015-04-17")
    output = munger.get_model
    isomorphic = repo.isomorphic_with? output
    assert(isomorphic == true, "The round-tripped point-date models were not the same: #{isomorphic}")
  end

  def test_add_point_date_uncertain ()
    repo = RDF::Repository.load('./test/data/simple_point_date_uncertain.nt')
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_point_date("2015-04-17?")
    output = munger.get_model
    isomorphic = repo.isomorphic_with? output
    assert(isomorphic == true, "The round-tripped point-date models were not the same: #{isomorphic}")
  end

  def test_add_point_date_year ()
    repo = RDF::Repository.load('./test/data/simple_point_date_year.nt')
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_point_date("2015")
    output = munger.get_model
    isomorphic = repo.isomorphic_with? output
    assert(isomorphic == true, "The round-tripped point-date models were not the same: #{isomorphic}")
  end

  def test_add_span_year
    repo = RDF::Repository.load('./test/data/simple_interval_year.nt')
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_interval_date("2014–2015")
    output = munger.get_model
    isomorphic = repo.isomorphic_with? output
    assert(isomorphic == true, "The round-tripped span-date models were not the same: #{isomorphic}")
  end

  def test_add_span_year_uncertain
    repo = RDF::Repository.load('./test/data/simple_interval_year_uncertain.nt')
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_interval_date("2014–2015?")
    output = munger.get_model
    isomorphic = repo.isomorphic_with? output
    assert(isomorphic == true, "The round-tripped span-date models were not the same: #{isomorphic}")
  end

  def test_add_span_date
    repo = RDF::Repository.load('./test/data/simple_interval_date.nt')
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_interval_date("2014-01-02–2015-01-02")
    output = munger.get_model
    STDOUT.puts output.dump(:ntriples)
    isomorphic = repo.isomorphic_with? output
    assert(isomorphic == true, "The round-tripped span-date models were not the same: #{isomorphic}")
  end
  def test_add_span_date_uncertain
    repo = RDF::Repository.load('./test/data/simple_interval_date_uncertain.nt')
    munger = Munger.new
    munger.set_base_uri(@@s)
    munger.add_interval_date("2014-01-02–2015-01-02?")
    output = munger.get_model
    STDOUT.puts output.dump(:ntriples)
    isomorphic = repo.isomorphic_with? output
    assert(isomorphic == true, "The round-tripped span-date models were not the same: #{isomorphic}")
  end
end
