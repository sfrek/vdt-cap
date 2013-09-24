require 'yaml'

nodes = YAML.load_file( "nodes.yml" )

nodes['roles'].each do |roles|
  roles.each do |rol, nodes|
    puts "role :#{rol}, #{nodes}"
  end
end
