actions :add, :remove
default_action :add
attribute :package_name, :name_attribute => true, :kind_of => String,
	:required => true
attribute :source, :kind_of => String
attribute :version, :kind_of => String

attr_accessor :exists
