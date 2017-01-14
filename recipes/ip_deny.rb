#
# Cookbook Name:: happy_filebeat_cookbook
# Recipe:: ip_deny
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template '/etc/httpd/sites-available/000-ip_deny.conf' do
  source 'ip_deny.conf.erb'
  mode '0440'
  owner 'root'
  group 'root'
  variables({
    cert_path: node['vhost']['cert'],
    key_path: node['vhost']['key'],
    cacert_path: node['vhost']['cacert']
  })
end

link '/etc/httpd/sites-enabled/000-ip_deny.conf' do
  to '/etc/httpd/sites-available/000-ip_deny.conf'
  only_if 'test -f /etc/httpd/sites-available/000-ip_deny.conf'
  not_if 'test -F /etc/httpd/sites-enabled/000-ip_deny.conf'
end

service 'httpd' do
  action :restart
end

