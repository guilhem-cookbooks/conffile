actions :configure, :install, :remove
default_action :configure

attribute :path, :name_attribute => true, :kind_of => String, :required => true
attribute :parameters, :kind_of => Hash, :required => true

attr_accessor :installed, :configured
