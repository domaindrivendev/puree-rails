require 'spec_helper'
require 'generators/puree/value_object/value_object_generator'

describe Puree::ValueObjectGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)  

  before(:all) do
    prepare_destination

    lib_path = File.join(destination_root, 'lib')
    Dir.mkdir(lib_path)

    File.open(File.join(lib_path, 'domain.rb'), 'w') do |file|
      file.write("module Domain\n")
      file.write('end')
    end
  end
  
  context 'when no arguments are provided, ' do
    it 'should display usage information' do
      expect { generator }.to raise_error(Thor::RequiredArgumentMissingError)
    end
  end

  context 'when a name but no attributes are provided, ' do
    it 'should display usage information' do
      expect { generator %w(organizer) }.to raise_error(Thor::RequiredArgumentMissingError)
    end
  end

  context 'when a name and attributes are provided, ' do
    before(:all) { run_generator %w(organizer user_id:integer name:string) }

    it 'should add a value object to the domain model' do
      assert_file('lib/domain/organizer.rb') do |content|
        assert_match(/class Organizer/, content)
        assert_match(/def initialize\(user_id, name\)/, content)
        assert_match(/def ==\(other\)/, content)
        assert_match(/def hash/, content)
      end
      
      assert_file('lib/domain.rb') do |content|
        assert_match(/^require_relative 'domain\/organizer'/, content)
      end
    end

  end
end