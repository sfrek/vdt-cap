require 'yaml'



module Commands

user_configs = YAML.load_file( "users.yml" )
nodes = YAML.load_file( "nodes.yml" )
roles_users = YAML.load_file( "roles_users.yml" )

# def search_gid (group)
#  user_configs['groups'].fetch(group)
# end

users = user_configs['users']
groups = user_configs['groups']

nodes['roles'].each do |roles|
  roles.each do |rol, nodes|
    puts "role :#{rol}, #{nodes}"
  end
end

puts
puts nodes
puts
puts roles_users
puts
puts user_configs
puts

# ---- create all group ----- #
user_configs['groups'].each do |group, gid|
  puts "groupadd --gid #{gid} #{group}"
end

# ---- create all user ------ #
user_configs['users'].each do |user, params|
  command = "useradd "
  puts "# #{user} ---> #{params}"
  params.each do |param, value|
    option = case param
      when 'uid' then "--uid #{value} "
      when 'home' then "--create-home --home-dir #{value} " 
      when 'shell' then "--shell #{value} "
      when 'gids' then "--groups #{value.join(',')} "
    end
  command = command + option
  end
  puts "#{command}--gid #{user} #{user}"
end

# ---- create one user ------ #
# user = "nova"
# command = "useradd "
# user_configs['users'].fetch(user).each do |key, value|
#   option = case key
#     when 'uid' then "--uid #{value} "
#     when 'home' then "--create-home --home-dir #{value} " 
#     when 'shell' then "--shell #{value} "
#     when 'gids' then "--groups #{value.join(',')} "
#   end
#   command = command + option
# end
# command = command + user
# puts "#{command}"
# search_gid "nova"

end
