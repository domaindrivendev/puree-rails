require 'spec_helper'
require 'generators/puree/command/command_generator'

describe Puree::CommandGenerator do
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

  context 'when a name and fields are provided, ' do
    before(:all) { run_generator %w(call_for_submissions conference_id:integer) }

    it 'should add the command to the view model' do
      assert_file('app/models/call_for_submissions.rb') do |content|
        assert_match(/class CallForSubmissions < Command/, content)
      end
    end
  end
end