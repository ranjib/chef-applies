remote_file '/opt/chef-server.deb' do
  source 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.8-1.ubuntu.12.04_amd64.deb'
  not_if {File.exists?('/opt/chef-server.deb')}
end
 
dpkg_package 'chef-server' do
  source '/opt/chef-server.deb'
  action :install
end
 
execute "reconfigure_chef_server" do
  command "chef-server-ctl reconfigure"
end
 
file '/etc/chef-server/chef-server.rb' do
  content "bookshelf['url'] = 'https://#{node.ipaddress}'
  bookshelf['vip'] = '#{node.ipaddress}'"
  notifies :run, "execute[reconfigure_chef_server]"
end
