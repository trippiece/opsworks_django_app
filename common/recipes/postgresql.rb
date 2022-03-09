# install packages(gdal is only for installing its dependencies)
%w{gdal proj-devel json-c postgresql95-devel}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

# install gdal 2.2.0 using conan
gdal_version = "2.2.0"

bash 'uninstall gdal and re-install its newer version with conan' do
  code <<-EOC
  sudo rpm -e --nodeps gdal
  export PATH=$PATH:/usr/local/bin
  sudo yum install gcc72 gcc72-c++ -y
  sudo wget http://download.osgeo.org/gdal/2.2.0/gdal-2.2.0.tar.gz
  sudo tar xvzf gdal-2.2.0.tar.gz
  cd gdal-2.2.0
  sudo ./configure
  sudo make
  sudo make install
  sudo cp /usr/local/lib/libgdal.so.20* /usr/lib64/
  EOC
  user node[:app][:owner]
  group node[:app][:group]
  environment 'HOME' => "/home/#{node[:app][:owner]}"
end
