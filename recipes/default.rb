#
# Cookbook Name:: kioskuser
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

USERNAME = node['kioskuser']['username']

# CREATE THE USER
user USERNAME do
  comment 'A kiosk user'
  home "/home/#{ USERNAME }"
  manage_home true
  shell '/bin/bash'
  password 'password'
end

# MAKE SURE THE HOME DIR HAS CORRECT OWNERSHIP
directory "/home/#{ USERNAME }" do
  group USERNAME
  user  USERNAME
end

# MAKE SURE THE CONFIG DIR HAS CORRECT OWNERSHIP
directory "/home/#{ USERNAME }/.config" do
  group USERNAME
  user  USERNAME
end

# CREATE AN UPSTART CONFIG DIRECTORY
directory "/home/#{ USERNAME }/.config/upstart" do
  recursive true
  group     USERNAME
  user      USERNAME
  action    :create
end

# SET THE KIOSKUSER TO AUTOLOGIN
directory "/etc/lightdm/lightdm.conf.d" do
  recursive true
  action :create
end

template "/etc/lightdm/lightdm.conf.d/50-myconfig.conf" do
  source    '50-myconfig.conf.erb'
  group     'root'
  user      'root'
  mode      '0755'
  variables username: USERNAME
  action    :create
end
