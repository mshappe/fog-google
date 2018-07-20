require "helpers/test_helper"
require "pry"

class UnitTestMonitoringCollections < MiniTest::Test
  def setup
    Fog.mock!
    @client = Fog::Monitoring.new(provider: "google")

    # TimeSeries API has no 'get' method
    exceptions = [Fog::Google::Monitoring::TimeseriesCollection]
    # Enumerate all descendants of Fog::Collection
    descendants = ObjectSpace.each_object(Fog::Collection.singleton_class).to_a

    @collections = descendants.select { |x| x.name.match /Fog::Google::Monitoring/ } - exceptions
  end

  def teardown
    Fog.unmock!
  end

  def test_common_methods
    # This tests whether Fog::Compute::Google collections have common lifecycle methods
    @collections.each do |klass|
      obj = klass.new
      assert obj.respond_to?(:all), "#{klass} should have an .all method"
      assert obj.respond_to?(:get), "#{klass} should have a .get method"
      assert obj.respond_to?(:each), "#{klass} should behave like Enumerable"
    end
  end

  def test_collection_get_arguments
    # TODO: Fixture for #352
    skip
    @collections.each do |klass|
      obj = klass.new
      assert_operator(obj.method(:get).arity, :<=, 1,
                      "#{klass} should have at most 1 required parameter in get()")
    end
  end
end
