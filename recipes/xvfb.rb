#
# Cookbook Name:: aet
# Recipe:: xvfb
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

# This recipe is dependency for any browser running on linux machine

# INSTALLATION
###############################################################################

# Install required packages
%w(
  Xvfb
  libXfont
  Xorg
).each do |p|
  package p do
    action :install
  end
end 
