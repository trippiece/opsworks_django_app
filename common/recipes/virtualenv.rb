# install python and other required packages.
%w{python38 python38-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

include_recipe "python::pip"

python_pip "virtualenv" do
  version "20.13.1"
  action :install
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
