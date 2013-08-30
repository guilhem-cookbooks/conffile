use_inline_resources

action :configure do
  ruby_block "Configure #{current_resource.name}" do
    block do
      IniFile.new( :filename => current_resource.path).merge(current_resource.parameters).write
    end
    not_if { current_resource.configured }
  end
end

action :install do
  ruby_block "Install #{current_resource.name}" do
    block do
      IniFile.new( :filename => current_resource.path, :content => current_resource.parameters).write
    end
    not_if { current_resource.installed }
  end
end

action :remove do
  file current_resource.path do
    action :delete
  end
end

def load_current_resource
  require 'inifile'

  @current_resource = Chef::Resource::ConffileIni.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.path(@new_resource.path)
  @current_resource.parameters(@new_resource.parameters)
  if ini_equal?(@current_resource.path,@current_resource.parameters)
    @current_resource.installed = true
    @current_resource.configured = true
  elsif ini_include?(@current_resource.path,@current_resource.parameters)
    @current_resource.configured = true
  end
end

def ini_equal?(path, parameters)
  if ::File.exits(path)
    current_ini = IniFile.new(path)
    return true if current_ini.to_h == parameters
  end
  return false
end

def ini_include?(path,parameters)
  if ::File.exits(path)
    current_ini = IniFile.new(path)
    return true if current_ini.to_h.merge(parameters) == current_ini
  end
  return false
end
