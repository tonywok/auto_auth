require 'test_helper'

class AutoAuthTest < Rails::Generators::TestCase
  tests AutoAuth::InstallGenerator
  destination File.expand_path("../tmp", __FILE__)
  setup :prepare_destination

  test "truth" do
    run_generator ['--dev']
    assert_file "app/models/user.rb"
  end
end
