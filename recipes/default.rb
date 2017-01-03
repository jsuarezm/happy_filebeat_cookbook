#
# Cookbook Name:: happy_filebeat_cookbook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


execute "install elastic public signed key" do
 command "sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch"
 action :run
end


yum_repository 'elastic-5.x' do
  description "Elastic repository for 5.x packages"
  baseurl "https://artifacts.elastic.co/packages/5.x/yum"
  gpgcheck true
  gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  enabled true
  action :create
end

package 'filebeat' do
  action :install
end

service 'filebeat' do
  action [:start, :enable]
end


template '/etc/filebeat/filebeat.yml' do
  source 'filebeat.yml.erb'
  mode '0440'
  owner 'root'
  group 'root'
  variables({
    elastic_env: node['filebeat']['environment'],
    elastic_url: node['filebeat']['elastic']['url'],
    elastic_user: node['filebeat']['elastic']['user'],
    elastic_pass: node['filebeat']['elastic']['pass']
  })
end

service 'filebeat' do
  action :restart
end

