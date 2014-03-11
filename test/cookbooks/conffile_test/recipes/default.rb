file = ::File.join(Chef::Config[:file_cache_path], 'conffile_test')
owner = 'test'
user owner

conffile_ini 'create conffile test' do
  path file
  parameters(
    'section' => {
      'key' => 'value'
    }
  )
  owner owner
  group owner
end

file file do
  action :delete
end

conffile_ini file do
  parameters(
    'section1' => {
      'key1' => 'value1'
    },
    'section2' => {
      'key2' => 'value2'
    }
  )
  action :install
end
