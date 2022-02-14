# install python and other required packages.
%w{python38 python38-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

include_recipe "python::pip"

# pip install
bash "pip install -r requirements.txt" do
  cwd app_directory
  user node[:app][:owner]
  group node[:app][:group]
  code <<-EOC
  export HOME=~#{node[:app][:owner]}
  #{node[:virtualenv][:path]}/bin/pip install pip==20.3.4
  #{node[:virtualenv][:path]}/bin/pip install pip==20.13.1
  EOC
end

directory node[:virtualenv][:parent] do
  owner node[:app][:owner]
  group node[:app][:group]
  mode 0755
  action :create
end

python_virtualenv node[:virtualenv][:path] do
  owner node[:app][:owner]
  group node[:app][:group]
  interpreter "python38"
  action :create
end

# python2 is required by dynamic-dynamodb.
python_virtualenv "#{node[:virtualenv][:parent]}/python2" do
  owner node[:app][:owner]
  group node[:app][:group]
  interpreter "python27"
  action :create
end
