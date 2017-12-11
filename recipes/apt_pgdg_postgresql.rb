if not %w(stretch jessie squeeze wheezy sid lucid precise saucy trusty utopic).include? node['postgresql']['pgdg']['release_apt_codename']
  raise "Not supported release by PGDG apt repository"
end

include_recipe 'apt'

file "remove deprecated Pitti PPA apt repository" do
  action :delete
  path "/etc/apt/sources.list.d/pitti-postgresql-ppa"
end


remote_file "#{Chef::Config[:file_cache_path]}/ACCC4CF8.asc" do
  source 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
  notifies :run, 'bash[apt-key-add]', :immediately
end

apt_update 'update'

package 'apt-transport-https'

bash 'apt-key-add' do
  code "sudo apt-key add #{Chef::Config[:file_cache_path]}/ACCC4CF8.asc"
  action :nothing
end

apt_repository 'apt.postgresql.org' do
  uri 'http://apt.postgresql.org/pub/repos/apt'
  distribution "#{node['postgresql']['pgdg']['release_apt_codename']}-pgdg"
  components ['main', node['postgresql']['version']]
  # key 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
  action :add
end
