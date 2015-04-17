# encoding: UTF-8
#!/usr/bin/env ruby -w

require 'test/unit'
require "munger"

class TestMunger < Test::Unit::TestCase

	def test_create_model
		model = Munger.new
		assert_not_equal nil, model
	end

end
