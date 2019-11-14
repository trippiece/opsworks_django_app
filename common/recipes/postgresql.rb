# install packages(gdal is only for installing its dependencies)
%w{gdal proj-devel json-c postgresql95-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

# install gdal 2.1.3 using conan
gdal_version = "2.1.3"

bash 'uninstall gdal and re-install its newer version with conan' do
  code <<-EOC
  sudo rpm -e --nodeps gdal
  sudo pip install conan==0.29
  export PATH=$PATH:/usr/local/bin
  conan remote add opsworks https://api.bintray.com/conan/trippiece/opsworks
  conan install Gdal/#{gdal_version}@amrael/stable -r opsworks
  GDAL_HASH=`conan info Gdal/#{gdal_version}@amrael/stable | awk '/^[ \t]+ID:/ {print $2}'`
  sudo sh -c "echo 'export PATH=\$PATH:$HOME/.conan/data/Gdal/#{gdal_version}/amrael/stable/package/$GDAL_HASH/bin' > /etc/profile.d/gdal.sh"
  export PATH=$PATH:$HOME/.conan/data/Gdal/#{gdal_version}/amrael/stable/package/$GDAL_HASH/bin
  sudo sh -c "echo $HOME/.conan/data/Gdal/#{gdal_version}/amrael/stable/package/$GDAL_HASH/lib > /etc/ld.so.conf.d/gdal-#{gdal_version}.conf"
  sudo ldconfig
  EOC
  user node[:app][:owner]
  group node[:app][:group]
  environment 'HOME' => "/home/#{node[:app][:owner]}"
end
