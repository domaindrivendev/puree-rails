require 'spec_helper'
require 'generators/puree/scaffold/scaffold_generator'

describe Puree::ScaffoldGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)  

  before(:all) do
    prepare_destination

    config_path = File.join(destination_root, 'config')
    Dir.mkdir(config_path)

    File.open(File.join(config_path, 'routes.rb'), 'w') do |file|
      file.write("Dummy::Application.routes.draw do\n")
      file.write('end')
    end

    lib_path = File.join(destination_root, 'lib')
    Dir.mkdir(lib_path)

    File.open(File.join(lib_path, 'domain.rb'), 'w') do |file|
      file.write("module Domain\n")
      file.write('end')
    end

    File.open(File.join(lib_path, 'persistence.rb'), 'w') do |file|
      file.write("module Persistence\n")
      file.write('end')
    end
  end
  
  context 'When no arguments are provided' do
    it 'should display usage information' do
      expect { generator }.to raise_error(Thor::RequiredArgumentMissingError)
    end
  end

  context 'When a resource name and attributes are provided' do
    before(:all) { run_generator %w(conference id:integer name:string --template-engine=slim --skip-test-framework) }

    it 'should create a resource route' do
      assert_file('config/routes.rb') do |content|
        assert_match(/resources :conferences/, content)
      end
    end

    it 'should add a controller' do
      assert_file('app/controllers/conferences_controller.rb') do |content|
        assert_match(/class ConferencesController < ApplicationController/, content) do |controller|
          assert_instance_method(:new, controller)
          assert_instance_method(:create, controller)
          assert_instance_method(:index, controller)
          assert_instance_method(:show, controller)
        end
      end
    end

    it 'should add an aggregate root to the domain model' do
      assert_file('lib/domain/conference.rb') do |content|
        assert_match(/class Conference/, content)
        assert_match(/def initialize\(id, name\)/, content)
      end
      
      assert_file('lib/domain.rb') do |content|
        assert_match(/^require_relative 'domain\/conference'/, content)
      end
    end

    it 'should add a repository accessor to the persistence module' do
      assert_file('lib/persistence.rb') do |content|
        assert_method(:conference_repository, content)
      end
    end

    it 'should add a create command to the view model' do
      assert_file('app/models/create_conference.rb') do |content|
        assert_match(/class CreateConference/, content)
      end
    end

    it 'should invoke the orm generator to add a record to the view model' do
      assert_file('app/models/conference.rb') do |content|
        assert_match(/class Conference/, content)
      end

      assert_migration 'db/migrate/create_conferences.rb' do |content|
        assert_method :change, content do |change_method|
          assert_match(/t\.integer :id/, change_method)
          assert_match(/t\.string :name/, change_method)
        end
      end
    end

    it 'should invoke the template engine generator to add views' do
      assert_file('app/views/conferences/index.html.slim')
      assert_file('app/views/conferences/new.html.slim')
    end
  end
end