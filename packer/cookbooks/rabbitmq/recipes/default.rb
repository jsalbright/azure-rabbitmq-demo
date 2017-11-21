%w{erlang rabbitmq libonig jq}.each do |package_name|
  package_uri = node['rabbitmq']["#{package_name}_installation_url"]
  remote_file "/tmp/#{package_name}.rpm" do
    source "#{package_uri}"
  end

  execute "install package #{package_name} with dependencies" do
    command "sudo yum -y install /tmp/#{package_name}.rpm"
  end
end

%w{python}.each do |package_name|
  package "#{package_name}"
end

# install rabbitmq admin python utility script
remote_file 'rabbitmqadmin script' do
  path '/opt/rabbitmqadmin'
  source 'https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_6_14/bin/rabbitmqadmin'
end

service 'rabbitmq-server' do
  action :start
end
