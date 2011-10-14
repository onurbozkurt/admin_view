require File.join(File.dirname(__FILE__), 'test_helper')

require 'generators/admin_view_generator'

class AdminViewGeneratorTest < Rails::Generators::TestCase

  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  tests AdminViewGenerator

  test "create the controllers and specs" do
    run_generator %w(User --search_by email)

    assert_file "app/controllers/admin/base_controller.rb", /class Admin::BaseController < ApplicationController/
    assert_file "app/controllers/admin/users_controller.rb", /class Admin::UsersController < Admin::BaseController/
    assert_file "spec/controllers/admin/base_controller_spec.rb", /describe Admin::BaseController do/
    assert_file "spec/controllers/admin/users_controller_spec.rb", /describe Admin::UsersController do/
    assert_file "app/views/admin/users/index.html.erb"
    assert_file "app/views/admin/users/show.html.erb"
    assert_file "app/views/admin/users/new.html.erb"
    assert_file "app/views/admin/users/edit.html.erb"
    assert_file "app/views/admin/users/_form.html.erb"
    assert_file "app/helpers/admin/base_helper.rb", /def sortable/
  end

  test "--no-create option skips assets to create new record" do
    run_generator %w(User --no_create)

    assert_no_file "app/views/admin/users/new.html.erb"
    content = File.read("tmp/app/views/admin/users/index.html.erb")
    assert content !~ /Create a new/

    content = File.read("tmp/app/controllers/admin/users_controller.rb")
    assert content !~ /def new/
    assert content !~ /def create/
  end
end
