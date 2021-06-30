Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 8
    vb.memory = 4096
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provision "shell", inline: <<-SHELL
    yum groupinstall -y 'Development Tools'
    yum install -y zlib-devel
  SHELL

  config.vm.provision "shell", privileged: false, path: "setup.sh"
end
