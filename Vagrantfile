# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

HOST_PROJECT_PATH = File.expand_path('../', __FILE__)
GUEST_PROJECT_PATH = '/home/vagrant/'

unless Vagrant.has_plugin?('nugrant')
  warn "[\e[1m\e[31mERROR\e[0m]: Please run: vagrant plugin install nugrant"
  exit -1
end


##
# This function configures custom port forwarding between the host and
# guest vm
#
# The yaml definition that it understands is this:
#
#     forwarded_ports:
#       - guest: 80
#         host: 8085
#
# @param config A vagrant config object
# @return nil
def setup_custom_forwarded_ports(config)
  return unless config.user.has_key?('forwarded_ports')
  config.user.forwarded_ports.each do |fp|
    config.vm.network :forwarded_port, {:guest => fp['guest'], :host => fp['host']}
  end
end

##
# This function creates synced folders and link them to the
# `GUEST_PROJECT_PATH` on the guest vm.
#
# The yaml definition that it understands is this:
#
#     synced_folders:
#       - folder_1
#       - folder_...
#
# @param config A vagrant config object
# @return nil
def setup_custom_synced_folders(config)
  return unless config.user.has_key?('synced_folders')
  config.user.synced_folders.each do |host_folder|
    target = File.join(GUEST_PROJECT_PATH, File.basename(host_folder))
    puts "Syncing #{host_folder} to #{target}"
    config.vm.synced_folder host_folder, target
  end
end

##
# This function returns the provider overrides in your user
# .vagrantuser file. An example is like this:
#
#    providers: {
#     virtualbox: {
#       memory: 4096,
#       cpus: 2
#     },
#     aws: {
#       region: us-west-1,
#       availability_zone: us-west-1a,
#       ssh_key: ~/.ssh/id_rsa.pub,
#       flavor_id: m3.2xlarge,
#       iam_profile_name: some-profile,
#     }
#   }
#
# @param provider the provider config (i.e. virtualbox, etc.)
# @param config the vagrant configuration
# @return the configuration provider
def get_provider_overrides(provider, config)
  return unless config.user.has_key?('providers')
  return unless config.user.providers.has_key?(provider)
  return config.user.providers[provider]
end


# Customfile - POSSIBLY UNSTABLE
#
# Use this to insert your own (and possibly rewrite) Vagrant config
# lines. Helpful for mapping additional drives. If a file
# 'Customfile' exists in the same directory as this Vagrantfile, it
# will be evaluated as ruby inline as it loads.
#
# **Note** that if you find yourself using a Customfile for anything
# crazy or specifying different provisioning, then you may want to
# consider a new Vagrantfile entirely.
#
# @param env_binding the calling binding object
# @return the object
def load_custom_file(env_binding)
  if File.exists?(File.join(HOST_PROJECT_PATH,'Customfile')) then
    eval(IO.read(File.join(HOST_PROJECT_PATH,'Customfile')), env_binding)
  end
end


# Vagrant Triggers
#
# If the vagrant-triggers plugin is installed, we can run various
# scripts on Vagrant state changes like `vagrant up`, `vagrant halt`,
# `vagrant suspend`, and `vagrant destroy`
#
# These scripts are run on the host machine, so we use `vagrant ssh`
# to tunnel back into the VM and execute things. By default, each of
# these scripts calls db_backup to create backups of all current
# databases.
#
# This can be overridden with custom scripting. See the individual
# files in config/homebin/ for details.
def setup_triggers()
  if Vagrant.has_plugin?('vagrant-triggers')
    # see   https://github.com/emyl/vagrant-triggers
  end
end


# Setup Defaults
#
# Sets up defaults for vagrant-nugrant
#
# @return hash with defaults
def setup_defaults()
  defaults = {
    'box' => 'ubuntu/trusty64',
    'hostname' => 'localhost',
    # providers
    'virtualbox' => {
      'memory' => '1024',
      'cpus' => '2'
    }
  }
  defaults
end


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.user.defaults = setup_defaults

  if Vagrant.has_plugin?('vagrant-cachier')
    # Configure cached packages to be shared between instances of the
    # same base box.  More info @ http://fgrehm.viewdocs.io/vagrant-cachier
    config.cache.scope = :box
  end

  config.vm.box = config.user.box

  config.vm.define :default, {:primary => true} do |default|
    default.user.defaults = config.user.defaults
    default.vm.hostname = default.user.hostname

    setup_custom_forwarded_ports(default)
    setup_custom_synced_folders(default)

    default.vm.synced_folder "#{HOST_PROJECT_PATH}", '/vagrant'

    default.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', default.user.virtualbox['memory']]
      vb.customize ['modifyvm', :id, '--cpus', default.user.virtualbox['cpus']]
    end

    default.vm.provision "shell", path: "setup.sh"

  end

  load_custom_file(binding)
  setup_triggers()
end
