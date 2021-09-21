begin
  gem 'cloudflair', '= 0.3.0'
  gem 'faraday', '>=0.13', '<0.14'
rescue LoadError
  unless defined?(ChefSpec)
    run_context = Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new)

    require 'chef/resource/chef_gem'

    cloudflair = Chef::Resource::ChefGem.new('cloudflair', run_context)
    cloudflair.version '= 0.3.0'
    cloudflair.run_action(:install)
  end
end
