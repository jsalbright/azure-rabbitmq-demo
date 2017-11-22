directory '/tmp/inspec' do
  action :create
end

# Kind of a hacky way of doing this.
# In a real-life scenario, these tests would live elsewhere and be copied
# via `git` or some other tool.
[ 'should_be_running',
  'ports_should_be_open' ].each do |test|
  full_test_name = "rabbitmq_#{test}"
  cookbook_file "/tmp/inspec/#{full_test_name}.rb" do
    source "#{full_test_name}.rb"
    action :create
  end
end

execute "Run inspec tests" do
  command "inspec exec /tmp/inspec/*.rb"
end
