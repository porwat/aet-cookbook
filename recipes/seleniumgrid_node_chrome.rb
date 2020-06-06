#
# Cookbook Name:: aet
# Recipe:: seleniumgrid_node_ff
#
# AET Cookbook
#
# Copyright (C) 2016 Cognifide Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# PREREQUISITES
###############################################################################

package 'unzip' do
  action :install
end

###############################################################################

# Create dedicated group
group node['aet']['seleniumgrid']['group'] do
  action :create
end

# Create dedicated user
user node['aet']['seleniumgrid']['user'] do
  group node['aet']['seleniumgrid']['group']
  system true
  action :create
end

# Create dedicated node directory
directory "#{node['aet']['seleniumgrid']['node_ch']['root_dir']}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0755'
  action :create
  recursive true
end

# Create log directory
directory "#{node['aet']['seleniumgrid']['node_ch']['log_dir']}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0755'
  action :create
  recursive true
end

# Install Chrome Browser
# Download Chrome binaries
remote_file "/tmp/google-chrome-stable_x86_64.rpm" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0755'
  source node['aet']['seleniumgrid']['chrome_source']
end

# Install the package
package 'google-chrome' do
  source "/tmp/google-chrome-stable_x86_64.rpm"
  action :install
end

execute 'rename_google_chrome' do
  command "mv #{node['aet']['seleniumgrid']['chrome_path']}/google-chrome #{node['aet']['seleniumgrid']['chrome_path']}/google-chrome-base"
  cwd '/tmp'
  not_if { File.exists?("#{node['aet']['seleniumgrid']['chrome_path']}/google-chrome-base") }
end

template "#{node['aet']['seleniumgrid']['chrome_path']}/google-chrome" do
  source 'content/chrome/google-chrome.erb'
  owner 'root'
  group 'root'
  cookbook node['aet']['seleniumgrid']['node_ch']['src_cookbook']['init_script']
  mode '0755'
end

# Get Selenium Grid file name from link
seleniumgrid_filename = get_filename(node['aet']['seleniumgrid']['source'])

# Download Selenium Grid jar to temporary folder
remote_file "/tmp/#{seleniumgrid_filename}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0644'
  source node['aet']['seleniumgrid']['source']
end

# Copy Selenium Grid jar to chrome node folder
remote_file "#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/#{seleniumgrid_filename}" do
  source "file:///tmp/#{seleniumgrid_filename}"
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0755'
end

# Create symlink from Selenium Grid jar
link "#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/selenium-server-standalone.jar" do
  to "#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/#{seleniumgrid_filename}"

  #notifies :restart, 'service[seleniumgrid-node-ch]', :delayed
end

# Get chromedriver file name from link
chromedriver_filename = get_filename(node['aet']['seleniumgrid']['chromedriver_source'])

# Download chromedriver to temporary folder
remote_file "/tmp/#{chromedriver_filename}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0644'
  source node['aet']['seleniumgrid']['chromedriver_source']
end

# Unzip chromedriver to node_ch folder
execute 'unzip_chromedriver' do
  command "unzip -o /tmp/#{chromedriver_filename} && mv ./chromedriver #{node['aet']['seleniumgrid']['node_ch']['root_dir']}/chromedriver-#{node['aet']['seleniumgrid']['node_ch']['chrome_driver_version']}"
  cwd '/tmp'
  not_if { File.exists?("#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/chromedriver-#{node['aet']['seleniumgrid']['node_ch']['chrome_driver_version']}") }
  notifies :create, 'link[chromedriver_link]', :immediately
end

# Create symlink from chromedriver
link "chromedriver_link" do
  target_file "/usr/bin/chromedriver"
  to "#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/chromedriver-#{node['aet']['seleniumgrid']['node_ch']['chrome_driver_version']}"
  only_if { File.exists?("#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/chromedriver-#{node['aet']['seleniumgrid']['node_ch']['chrome_driver_version']}") }
  action :nothing
end


# Create a config file

template "#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/config.json" do
  source 'content/seleniumgrid/node_ch/config.json.erb'
  owner 'root'
  group 'root'
  cookbook node['aet']['seleniumgrid']['node_ch']['src_cookbook']['init_script']
  mode '0755'

  notifies :restart, 'service[seleniumgrid-node-ch]', :delayed
end

# Create Selenium Grid Chrome starting script

template "#{node['aet']['seleniumgrid']['node_ch']['root_dir']}/start-selenium-node.sh" do
  source 'content/seleniumgrid/node_ch/bin/start-selenium-node.sh.erb'
  owner 'root'
  group 'root'
  cookbook node['aet']['seleniumgrid']['node_ch']['src_cookbook']['init_script']
  mode '0755'

  notifies :restart, 'service[seleniumgrid-node-ch]', :delayed
end

# Create Selenium Grid Chrome node service

template '/etc/systemd/system/seleniumgrid-node-ch.service' do
  source 'etc/systemd/system/seleniumgrid-node-ch.service.erb'
  owner 'root'
  group 'root'
  cookbook node['aet']['seleniumgrid']['node_ch']['src_cookbook']['init_script']
  mode '0755'

  notifies :restart, 'service[seleniumgrid-node-ch]', :delayed
end

service 'seleniumgrid-node-ch' do
  supports status: true, restart: true
  action [:start, :enable]
end
