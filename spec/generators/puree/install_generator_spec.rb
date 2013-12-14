require 'spec_helper'
require 'generators/puree/install/install_generator'

describe Puree::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "should create a domain module" do
    assert_directory('lib/domain')
    assert_file('lib/domain.rb') do |content|
    end
  end

  it "should create a persistence module" do
    assert_directory('lib/persistence')
    assert_file('lib/persistence.rb') do |content|
    end
  end

  it "should install migrations for the event store" do
    assert_file('db/migrate/20131201000000_create_event_streams.rb')
    assert_file('db/migrate/20131201000001_create_event_records.rb')
  end
end