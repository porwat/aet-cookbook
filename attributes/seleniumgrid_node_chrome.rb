#
# Cookbook Name:: aet
# Attributes:: seleniumgrid
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

default['aet']['seleniumgrid']['user'] = 'seleniumgrid'
default['aet']['seleniumgrid']['group'] = 'seleniumgrid'

default['aet']['seleniumgrid']['node_ch']['root_dir'] = '/opt/aet/seleniumgrid/node-ch'

default['aet']['seleniumgrid']['node_ch']['log_dir'] = '/var/log/seleniumgrid'

default['aet']['seleniumgrid']['node_ch']['chrome_driver_version'] = '83.0.4103.39'

default['aet']['seleniumgrid']['node_ch']['chrome_version'] = 'current'
# default['aet']['seleniumgrid']['node_ch']['chrome_version'] = '83.0.4103.61'

default['aet']['seleniumgrid']['chrome_source'] = "https://dl.google.com/linux/direct/google-chrome-stable_#{node['aet']['seleniumgrid']['node_ch']['chrome_version']}_x86_64.rpm"
default['aet']['seleniumgrid']['chrome_path'] = "/opt/google/chrome"

default['aet']['seleniumgrid']['chromedriver_source'] = "https://chromedriver.storage.googleapis.com/#{node['aet']['seleniumgrid']['node_ch']['chrome_driver_version']}/chromedriver_linux64.zip"

default['aet']['seleniumgrid']['node_ch']['src_cookbook']['init_script'] = 'aet'

default['aet']['seleniumgrid']['node_ch']['NODE_MAX_INSTANCES'] = '1'
default['aet']['seleniumgrid']['node_ch']['NODE_MAX_SESSION'] = '1'
default['aet']['seleniumgrid']['node_ch']['NODE_HOST'] = '0.0.0.0'
default['aet']['seleniumgrid']['node_ch']['NODE_PORT'] = '5555'
default['aet']['seleniumgrid']['node_ch']['NODE_REGISTER_CYCLE'] = '5000'
default['aet']['seleniumgrid']['node_ch']['NODE_POLLING'] = '5000'
default['aet']['seleniumgrid']['node_ch']['NODE_UNREGISTER_IF_STILL_DOWN_AFTER'] = '6000'
default['aet']['seleniumgrid']['node_ch']['NODE_DOWN_POLLING_LIMIT'] = '2'
default['aet']['seleniumgrid']['node_ch']['DBUS_SESSION_BUS_ADDRESS'] = '/dev/null'
default['aet']['seleniumgrid']['node_ch']['HUB_HOST'] = 'localhost'
default['aet']['seleniumgrid']['node_ch']['HUB_PORT'] = '4444'
