app_directory = "#{node[:app][:directory]}/#{node[:app][:host]}"

# deploy git repository.
git app_directory do
  repository "https://github.com/rbenv/rbenv.git"
  reference "master"
  user node[:app][:owner]
  group node[:app][:group]
  action :checkout
end

directory "#{app_directory}/shims" do
  owner node[:app][:owner]
  group node[:app][:group]
  mode 00755
  action :create
end

directory "#{app_directory}/versions" do
  owner node[:app][:owner]
  group node[:app][:group]
  mode 00755
  action :create
end

directory "#{app_directory}/plugins" do
  owner node[:app][:owner]
  group node[:app][:group]
  mode 00755
  action :create
end

cookbook_file "/etc/profile.d/rbenv.sh" do
  source "rbenv.sh"
  owner node[:app][:owner]
  group node[:app][:group]
  mode 0644
end

# ruby-buildインストール
git "#{app_directory}/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  reference "master"
  user node[:app][:owner]
  group node[:app][:group]
  action :checkout
end

# ruby install
execute "rbnev-install" do
  not_if "source /etc/profile.d/rbenv.sh; rbenv versions | grep 2.2.2"
  command "source /etc/profile.d/rbenv.sh; rbenv install 2.2.2"
end

# rubyバージョン設定
execute "rbnev-global" do
  not_if "source /etc/profile.d/rbenv.sh; rbenv global | grep 2.2.2"
  command "source /etc/profile.d/rbenv.sh; rbenv global 2.2.2; rbenv rehash"
end