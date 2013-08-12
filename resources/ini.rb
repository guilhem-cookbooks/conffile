actions :create, :remove
default_action :create

attribute :path, :name_attribute => true, :kind_of => String, :required => true
attribute :parameters, :kind_of => Hash, :required => true

attr_accessor :exists
