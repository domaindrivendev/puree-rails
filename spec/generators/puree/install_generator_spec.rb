require 'spec_helper'
require 'generators/puree/install/install_generator'

describe Puree::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "should create an app folder for event listeners" do
    assert_directory('app/listeners')
  end

  it "should add an initializer for wiring up event listeners" do
    assert_file('config/initializers/puree-rails.rb')
  end

  it "should create a domain module" do
    assert_directory('lib/domain')
    assert_file('lib/domain.rb') do |content|
    end
  end

  it "should create a persistence module" do
    assert_file('lib/persistence.rb') do |content|
    end
  end

  it 'should add a base command to the view model' do
    assert_file('app/models/command.rb') do |content|
      assert_match(/class Command/, content)
    end
  end

  it "should install migrations for the event store" do
    assert_file('db/migrate/20131201000000_create_event_streams.rb')
    assert_file('db/migrate/20131201000001_create_event_records.rb')
  end

  it "should install migrations for the id generator" do
    assert_file('db/migrate/20131201000002_create_id_counters.rb')
  end
end