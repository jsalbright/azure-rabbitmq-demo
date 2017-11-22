directory '/tmp/inspec' do
  action :create
end

cb.manifest['files'].each do |manifest|
  inspec_test_file_path = manifest['path']
  inspec_test_file_name = manifest['name']
  cookbook_file "/tmp/inspec/#{inspec_test_file_name}" do
    source inspec_test_file_path
    action :create
  end
end

execute "Run inspec tests" do
  command "inspec exec /tmp/inspec/*.rb"
end
