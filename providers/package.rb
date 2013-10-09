include Chef::Mixin::PowershellOut

def whyrun_supported?
	true
end

action :add do
	if @current_resource.exists
		Chef::Log.info "#{@new_resource} already exists - nothing to do."
	else
		converge_by("Add #{@new_resource}") do
			add_appv_package
		end
	end
end

action :remove do
	if @current_resource.exists
		converge_by("Remove #{@new_resource}") do
			remove_appv_package
		end
	else
		Chef::Log.info "#{@new_resource} doesn't exist - can't delete."
	end
end

def load_current_resource
	@current_resource = Chef::Resource::AppvPackage.new(@new_resource.name)
	@current_resource.name(@new_resource.name)
	@current_resource.package_name(@new_resource.package_name)
	@current_resource.source(@new_resource.source)
	@current_resource.version(@new_resource.version)

	if appv_package_exists?(@current_resource.package_name, @current_resource.version)
		@current_resource.exists = true
	end
end

def add_appv_package
	powershell_script "Adding App-V Package #{new_resource.package_name}" do
		code <<-EOH
		Import-Module AppvClient
		Add-AppVClientPackage -Path "#{new_resource.source}" | Publish-AppVClientPackage -Global
		EOH
	end
end

def remove_appv_package
	powershell_script "Removing App-V Package #{new_resource.package_name}" do
		code <<-EOH
		Import-Module AppvClient
		Stop-AppVClientPackage -Name #{new_resource.package_name} | Remove-AppVClientPackage
		EOH
	end
end

def appv_package_exists?(name, version)
	powershell_string = "$pkg = Get-AppVClientPackage #{name}; $pkg.IsPublishedGlobally"
	powershell_string += " -and ($pkg.Version -eq '#{version}')" if version
	cmd = powershell_out(powershell_string)
	cmd.run_command
	cmd.stdout =~ /True/
end
