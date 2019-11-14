# install python and other required packages.
%w{python35 python35-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

include_recipe 'python::virtualenv'

directory node[:virtualenv][:parent] do
  owner node[:app][:owner]
  group node[:app][:group]
  mode 0755
  action :create
end

python_virtualenv node[:virtualenv][:path] do
  owner node[:app][:owner]
  group node[:app][:group]
  interpreter "python35"
  action :create
end

# python2 is required by dynamic-dynamodb.
python_virtualenv "#{node[:virtualenv][:parent]}/python2" do
  owner node[:app][:owner]
  group node[:app][:group]
  interpreter "python27"
  action :create
end
