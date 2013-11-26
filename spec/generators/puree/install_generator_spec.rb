require 'spec_helper'
require 'generators/puree/install/install_generator'

describe Puree::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "should create a domain model namespace" do
    assert_directory('lib/domain')
    assert_file('lib/domain.rb') do |content|
    end
  end

  it "should create a persistence namespace" do
    assert_directory('lib/persistence')
    assert_file('lib/persistence.rb') do |content|
    end
  end

  it "should create an integration namespace" do
    assert_directory('lib/integration')
    assert_file('lib/integration.rb') do |content|
    end
  end

  # it "should install the migrations for the event store" do
  #   assert_file('db/migrate/20120923055931_create_aggregate_records.rb')
  #   assert_file('db/migrate/20120923055932_create_event_records.rb')
  # end
end