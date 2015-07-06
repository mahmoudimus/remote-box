# -*- mode: ruby -*-
# vi: set ft=ruby :

BRIDGE_NETWORK = '10.2.0.10'
BRIDGE_NETMASK = '255.255.0.0'

REGION = "us-west-1"
USERNAME = "mahmoud"
UBUNTU_14_04 = "ami-df6a8b9b"
HOST_PROJECT_PATH = File.expand_path('../', __FILE__)


unless Vagrant.has_plugin?('nugrant')
  warn "[\e[1m\e[31mERROR\e[0m]: Please run: vagrant plugin install nugrant"
  exit -1
end


Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

    # http://aws.amazon.com/ec2/pricing/#spot
    aws.instance_type = "m4.large"
    aws.keypair_name = "mahmoud"
    aws.ami = UBUNTU_14_04
    aws.region = REGION
    aws.subnet_id = "subnet-e4a41a81"
    aws.associate_public_ip = true

    aws.tags = {
      'Name' => 'rdevbox',
    }

    aws.security_groups = [
      "sg-a99d12cc"
    ]

    aws.region_config REGION do |region|
        region.spot_instance = true
        region.spot_max_price = "0.019"
    end

    # aws.block_device_mapping = [
    #   {
    #     'DeviceName' => "/dev/sdl",
    #     'VirtualName' => "mysql_data",
    #     'Ebs.VolumeSize' => 100,
    #     'Ebs.DeleteOnTermination' => true,
    #     'Ebs.VolumeType' => 'io1',
    #     'Ebs.Iops' => 1000
    #   }
    # ]

    aws.user_data = <<EOF
#!/bin/bash
###
# NOTE: if you want to use rsync, uncomment the below and disable pty
# sed -i -e 's/^Defaults.*requiretty/# Defaults requiretty/g' /etc/sudoers
###

# install unison
sudo apt-get update -qq
sudo apt-get install make ocaml exuberant-ctags git htop
cd /tmp
curl http://www.seas.upenn.edu/~bcpierce/unison/download/releases/stable/unison-2.48.3.tar.gz | tar xz
cd /tmp/unison-2.48.3 && make UISTYLE=text
cp -p /tmp/unison-2.48.3/unison /tmp/unison-2.48.3/unison-fsmonitor /usr/local/bin/

# install user
useradd -m -d /home/#{USERNAME} -s /bin/bash #{USERNAME}
usermod -a -G admin #{USERNAME}
echo '#{USERNAME}:#{USERNAME}' | chpasswd
cp -pR ~ubuntu/.ssh ~#{USERNAME}
chown -R #{USERNAME}: ~#{USERNAME}/.ssh/
EOF

    override.ssh.username = USERNAME
    override.ssh.pty = true  # http://stackoverflow.com/a/17436026/133514
    override.ssh.private_key_path = "#{File.expand_path('~')}/.ssh/id_rsa"
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = '/Users/mahmoud/code/ops/docker/docker-host-osx/docker-host.yml'
    ansible.host_key_checking = false
    ansible.verbose = 'vvv'
    ansible.extra_vars = {
      :bridge_network => BRIDGE_NETWORK,
      :bridge_netmask => BRIDGE_NETMASK,
      :local_user => ENV['USER']
    }
  end

  # use unison instead
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
