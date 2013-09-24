# vim: set filetype=ruby: # 

require 'yaml'

user_configs = YAML.load_file( "users.yml" )
nodes = YAML.load_file( "nodes.yml" )

role :all do
  hosts = nodes['nodes']
end

nodes['roles'].each do |roles|
  roles.each do |rol, nodos|
    role rol.to_sym do
      hosts = nodos
    end
  end
end

namespace :basic do
  desc "instalación de paquetería esencia"
  task :install_basic, :roles => :pro do
    run "apt-get install git-core build-essential nmap vim lsscsi htop iotop tcpdump nmap traceroute -y"
  end

  desc "Actualización básica"
  task :dist_upgrade do
    run "apt-get update"
    run "apt-get -y dist-upgrade"
  end

  desc "ip info"
  task :ip_info do
    run "ip a"
    run "ip r"
  end

  desc "iscsi rescan"
  task :iscsi_rescan do
    run "iscsiadm --mode session --rescan"
  end

  desc "Install ocfs2"
  task :ocfs2_install, :roles => :compute do
    # apt-get install ocfs2-tools ocfs2console
    run "hostname -f"
  end

  task :solo_computos, :roles => :compute, :only => { :pro => true } do
    run "hostname"
  end
end

namespace :users do
  users = user_configs['users']
  groups = user_configs['groups']
  task :remove_all do
    users.each do |user, options|
      run "if grep ^#{user} /etc/passwd >> /dev/null;then userdel #{user};fi"
    end

    groups.each do |group, gid|
      run "if grep ^#{group} /etc/group >> /dev/null;then groupdel #{group};fi"
    end
  end

  task :create_group do
      run "echo 'create grouo/user controller'", :roles => :controller
      run "hostname"
  end
  
end
      
task :show_info, :hosts => "admin@10.90.0.60" do
  run "show cimc detail"
end

task :show_luns, :hosts => "abada@10.90.25.45" do
  run "lun show"
end

desc "Hostname de la máquina"
task :hostname, :roles => :all do
  run "hostname -f"
end

desc "Listado de dispositivos scsi"
task :lsscsi, :roles => :all do
  run "lsscsi"
end

desc "Prueba de ENV"
task :prub, :roles => :pre do
  run "uptime"
end  

desc "Upload multipath NetAPP default options"
task :upload_multipath, :role => :pre do
  upload("/home/operador/configs/multipath.netapp.conf", "/etc/multipath.conf")
  run "service multipath-tools restart"
end
  
desc "Usuarios para.."
task :fullusers, :roles => :pre do
commands = 
"groupadd -g 600 nova;" + 
"groupadd -g 650 libvirtd;" + 
"groupadd -g 700 kvm;" + 
"groupadd -g 113 ntp;" + 
"groupadd -g 114 quantum;" + 
"groupadd -g 660 glance;" + 
"groupadd -g 670 cinder;" + 
"useradd -u 660 -g 660 -s /bin/false -d /var/lib/glace -m glance;" + 
"useradd -u 670 -g 670 -s /bin/false -d /var/lib/cider -m cinder;" + 
"useradd -u 600 -g 600 -G 650 -s /bin/sh -d /var/lib/nova -m nova;" + 
"useradd -u 650 -g 650 -G 700 -s /bin/false -d /var/lib/libvirt -m libvirt-qemu;"
"useradd -u 108 -g 108 -G 114 -s /bin/false -d /var/lib/quantum -m quantum;"
"useradd -u 106 -g 106 -G 113 -s /bin/false -d /home/ntp ntp;"
"useradd -u 107 -g 107 -G 650 -s /bin/false -d /var/lib/libvirt/dnsmasq -m libvirt-dnsmasq;"

  run commands
end

desc "Info de usuarios"
task :user_info, :roles => :pre do
  commands = "id nova;id libvirtd;id kvm;id ntp;id quantum;id glance;id cinder"
  run commands
end


desc "Report Uptimes"
task :uptime do
  on :roles => :pre do |host|
    info "Host #{host} (#{host.roles.join(', ')}):\t#{capture(uptime)}"
  end
end

task :illustrate_run, :roles => :pre do 
  run "hostname" do |c,s,d|
    puts d
  end
end



def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :remote do
  namespace :file do
    desc "test existence of missing file"
    task :missing do
      if remote_file_exists?('/dev/mull')
        raise "It's there!?"
      end
    end

    desc "test existence of present file"
    task :exists do
      unless remote_file_exists?('/dev/null')
        raise "It's missing!?"
      end
    end
  end
end

namespace :openstack_deploy do
  task :apt_sources_list, :roles => :pro do
    run "echo 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main' > /etc/apt/sources.list.d/grizzly.list"
    run "echo 'deb http://www.rabbitmq.com/debian/ testing main' > /etc/apt/sources.list.d/rabbitmq.list"
    run "gpg --keyserver subkeys.pgp.net --recv-keys 5EDB1B62EC4926EA; gpg -a --export 5EDB1B62EC4926EA | apt-key add -"
    run "gpg --keyserver subkeys.pgp.net --recv-keys F7B8CEA6056E8E56; gpg -a --export F7B8CEA6056E8E56 | apt-key add -"
    run "apt-get update"
  end

  task :dist_upgrade, :roles => :pro do
    run "apt-get update;apt-get -y dist-upgrade"
  end
  
end


