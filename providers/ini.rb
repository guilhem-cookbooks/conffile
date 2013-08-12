use_inline_resources

include Chef::DSL::IncludeRecipe
include 'inifile'

action :add do
  install_files

  include_recipe "prosody::config"
  ruby_block "Configure module #{new_resource.module}" do
    block do
      node.override['prosody']['modules_enabled'] = node['prosody']['modules_enabled'] + [ new_resource.module ]
      node.override['prosody']['modules_disabled'] = node['prosody']['modules_disabled'] - [ new_resource.module ]
      node.save
    end
    notifies :create, "template[Configure prosody]"
    not_if { current_resource.configured }
  end
end

action :install do
  install_files
end

action :delete do
  ruby_block "Unconfigure module #{new_resource.module}" do
    block do
      node.override['prosody']['modules_enabled'] = node['prosody']['modules_enabled'] - [ new_resource.module ]
      node.save
    end
    only_if { current_resource.configured }
  end
end

def load_current_resource
  @current_resource = Chef::Resource::ProsodyModule.new(@new_resource.name)
  @current_resource.path(@new_resource.path)
  @current_resource.parameters(@new_resource.parameters)
  @current_resource.exists = true if ini_equal?(@current_resource.path,@current_resource.parameters)
end

def ini_equal?(path, parameters)
  if ::File.exits(path)
    current_ini = IniFile.load(path)
    futur_ini = IniFile.new() << parameters
    return true if current_ini == futur_ini
  end
  return false
end

def local_path(file)
  return ::File.join(node['prosody']['chef_plugin_path'], "mod_#{new_resource.module}", file)
end

def install_files
  include_recipe "prosody::service"
  new_resource.files.each do |file, uri|
    directory ::File.dirname(local_path(file)) do
      owner "root"
      group node['prosody']['group']
      mode "0754"
    end

    remote_file local_path(file) do
      source uri
      owner "root"
      group node['prosody']['group']
      mode "0754"
    end
    notifies :restart, "service[prosody]"
  end
end
