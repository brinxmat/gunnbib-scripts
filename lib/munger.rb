# encoding: UTF-8
#!/usr/bin/env ruby -w

require 'rdf'
require 'rdf/ntriples'
require 'test/unit'
require 'csv'
require 'uuid'
require 'date'
require 'securerandom'
require 'pp'
class Munger

  @@model = nil
  @@baseURI = nil

  def initialize ()
    create_new_model
  end

  def create_new_model ()
      @@model = RDF::Repository.new
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
    @data = Array.new
    CSV.foreach(file,
                 {:headers => true, :header_converters => :symbol}
                ) do |row|
      @data.push(row.to_hash)
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

  def add_recipient (recipient)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/ontology/bibo/recipient"),
      RDF::URI.new("http://www.ntnu.no/ub/digital/person/" + recipient)
      )
  end

  def add_document_type (type)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"),
      RDF::URI.new("http://www.ntnu.no/ub/digital/format/" + type)
      )
  end

  def add_country (country)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#geoSubjectCountry"),
      RDF::URI.new("http://sws.geonames.org/" + country)
      )
  end

  def add_county (county)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#geoSubjectCounty"),
      RDF::URI.new("http://sws.geonames.org/" + county)
      )
  end

  def add_municipality (municipality)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#geoSubjectMunicipality"),
      RDF::URI.new("http://sws.geonames.org/" + municipality)
      )
  end

    def add_place_of_creation (place)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#placeOfCreation"),
      RDF::URI.new("http://sws.geonames.org/" + place)
      )
  end

  def add_genre (genre)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#genre"),
      RDF::URI.new("http://www.ntnu.no/ub/data/genre/" + genre)
      )
  end

  def add_text_subject (subject)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/dc/terms/subject"),
      RDF::Literal.new(subject.strip)
      )
  end

  def add_subject (subject)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/dc/terms/subject"),
      RDF::URI.new("http://www.example.com/" + subject)
      )
  end

  def add_map_scale (scale)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.geographicknowledge.de/vocab/maps#hasScale"),
      RDF::Literal.new(scale)
      )
  end

  def add_dimensions (dimensions)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#dimensions"),
      RDF::Literal.new(dimensions)
      )
  end

  def add_note (note)
    add_triple(
      get_base_uri,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#note"),
      RDF::Literal.new(note)
      )
  end

  def create_bnode ()
    bnode = RDF::Node.new(SecureRandom.uuid)
    return bnode
  end

  def parse_date (date)
    d = nil
    if date =~ /^[0-9]{4}$/
      d = date
    elsif date
      d = Date.parse date
    end
    return d
  end

  def uncertain (date)
    return date.include? "?"
  end

  def add_owl_time_instant (bnode, date)
    d = parse_date date

    if (d.is_a?(Date))
      year = d.year.to_s
      month = d.month.to_s
      day = d.day.to_s
    else
      year = d
    end

    add_triple(
      bnode,
      RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"),
      RDF::URI.new("http://www.w3.org/2006/time#Instant")
    )
    add_triple(
      bnode,
      RDF::URI.new("http://www.w3.org/2006/time#year"),
      RDF::Literal.new(year, :datatype => RDF::XSD.gYear)
    )

    if (month != nil)
      add_triple(
        bnode,
        RDF::URI.new("http://www.w3.org/2006/time#month"),
        RDF::Literal.new("--" + month, :datatype => RDF::XSD.gMonth)
      )
      add_triple(
        bnode,
        RDF::URI.new("http://www.w3.org/2006/time#day"),
        RDF::Literal.new("---" + day, :datatype => RDF::XSD.gDay)
      )
    end

  end

  def test_certainty (date)
    certainty = 10
    if (uncertain(date))
       date = date.tr('?','')
       certainty = 5
    end
    return {:date => date, :certainty => certainty}
  end

  def add_point_date (date)
    
    d = test_certainty(date)

    bnode = create_bnode

    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/dc/terms/date"),
      bnode
    )

    add_owl_time_instant(bnode, d[:date].to_s)
    add_triple(
      bnode,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#certainty"),
      RDF::Literal.new(d[:certainty].to_s, :datatype => RDF::XSD.integer)
    )
  end

  def add_interval_date (date)
    d = test_certainty(date)

    date1, date2 = d[:date].split(/–/u)

    bnode = create_bnode()
    beginNode = create_bnode()
    endNode = create_bnode()

    add_triple(
      get_base_uri,
      RDF::URI.new("http://purl.org/dc/terms/date"),
      bnode
    )

    add_triple(
      bnode,
      RDF::URI.new("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"),
      RDF::URI.new("http://www.w3.org/2006/time#Interval")
    )

    add_triple(
      bnode,
      RDF::URI.new("http://www.w3.org/2006/time#hasBeginning"),
      beginNode
    )
    add_owl_time_instant(beginNode, date1)

    add_triple(
      bnode,
      RDF::URI.new("http://www.w3.org/2006/time#hasEnd"),
      endNode
    )
    add_owl_time_instant(endNode, date2)

    add_triple(
      bnode,
      RDF::URI.new("http://www.ntnu.no/ub/data/nl#certainty"),
      RDF::Literal.new(d[:certainty].to_s, :datatype => RDF::XSD.integer)
    )
   
  end

  def munge (data)

    set_base_uri RDF::URI.new("http://www.ntnu.no/ub/digital/document/" + data[:nyid])

    add_identifier data[:nyid]
    
    if (data[:dokid_objektid])
      ids = data[:dokid_objektid].split(',')
      ids.each { |id| add_identifier id }
    end
    
    if (data[:forfatterauthorized])
      auths = data[:forfatterauthorized].split(',')
      auths.each { |id| add_creator id }
    end

    if (data[:brevmottakerauthorized])
      brevmottaker = data[:brevmottakerauthorized].split(',')
      brevmottaker.each { |id| add_recipient id }
    end
    
    if (data[:tittel])
      add_title data[:tittel]
    end

    if (data[:datayear])
      date = data[:datayear].split(',')
      date.each { |date| 
      if date.include? '–'
      add_interval_date date
      else
        add_point_date date
      end
      }
    end

    if (data[:fysisk_form])
      form = data[:fysisk_form].split(',')
      form.each {|f| add_document_type f}
    end

    if (data[:omhandlet_sted])
      sted = data[:omhandlet_sted].split(',')
      sted.each {|f| add_text_subject f}
    end

    if (data[:land_geonameid_])
      sted = data[:land_geonameid_].split(',')
      sted.each {|f| add_country f}
    end

    if (data[:fylke_geonameid_])
      sted = data[:fylke_geonameid_].split(',')
      sted.each {|f| add_county f}
    end

    if (data[:kommune_bygd_geonameid_])
      sted = data[:kommune_bygd_geonameid_].split(',')
      sted.each {|f| add_municipality f}
    end

    if (data[:skapelsessted_geonameid])
      sted = data[:skapelsessted_geonameid].split(',')
      sted.each {|f| add_place_of_creation f}
    end

    if (data[:genre])
      sted = data[:genre].split(',')
      sted.each {|f| add_genre f}
    end

    if (data[:emneord_norske])
      sted = data[:emneord_norske].split(',')
      sted.each {|f| add_text_subject f}
    end

    if (data[:emneord_norske])
      sted = data[:emneord_norske].split(',')
      sted.each {|f| add_text_subject f}
    end

    if (data[:bemerkninger_noter])
      add_note data[:bemerkninger_noter]
    end
    if (data[:scale])
      sted = data[:scale].split(',')
      sted.each {|f| add_map_scale f}
    end
    if (data[:size])
      sted = data[:size].split(',')
      sted.each {|f| add_dimensions f}
    end    
  end

  def read (file)

    data = read_data_from_file(file)

    pp data

    data.each { |x| munge x }

  end


end