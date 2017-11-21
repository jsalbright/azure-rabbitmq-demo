# Start of inspec recipe.
remote_file "/tmp/inspec.rpm" do
  source node['base']['inspec_installation_url']
end

rpm_package 'inspec' do
  source '/tmp/inspec.rpm'
  action :install
end
