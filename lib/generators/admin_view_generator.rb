require 'rails/generators/resource_helpers'
require 'rails/generators/named_base'

class AdminViewGenerator < Rails::Generators::NamedBase

  include Rails::Generators::ResourceHelpers

  source_root File.expand_path('../templates', __FILE__)

  def create_base_controller
    empty_directory "app/controllers/admin"
    path = File.join("app/controllers/admin", "base_controller.rb")
    template("base_controller.rb", path) unless File.exists?(path)
  end

  def create_controller
    @attributes = get_model_columns
    template "controller.rb", File.join("app/controllers/admin", "#{controller_file_name}_controller.rb")
  end

  def create_views
    empty_directory "app/views/admin/#{controller_file_name}"
    @attributes = get_model_columns
    available_views.each do |view|
      template "views/#{view}.html.erb", File.join("app/views/admin", controller_file_name, "#{view}.html.erb")
    end
  end

  def add_resource_route
    return false
    return if not File.exists?("config/routes.rb")
    route_config =  "namespace :admin do "
    route_config << "resources :#{file_name.pluralize} do "
    route_config << "member do get 'move_up', 'move_down', 'move_to_top', 'move_to_bottom' end"
    route_config << " end end"
    route route_config
  end

  protected

  def available_views
    ["index", "new", "show", "edit", "_form"]
  end

  def model_exists?(klass_name)
    begin
      klass = Module.const_get(klass_name)
      return klass.superclass == ActiveRecord::Base
    rescue NameError
      return false
    end
  end

  def get_model_columns
    if model_exists?(class_name)
      class_name.constantize.send(:columns)
    else
      [] # allow user (and test) to generate the view files
    end
  end

end
