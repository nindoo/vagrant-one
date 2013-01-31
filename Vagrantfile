Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.host_name = "testserver"
  config.ssh.max_tries = 150
#  config.vm.boot_mode = :gui
#  config.vm.network :bridged, :mac => "0000C0CAC01A", :bridge => 'en1: WLAN (AirPort)'
  config.vm.network :hostonly, "33.33.33.20"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet"
    puppet.manifest_file = "default.pp"
    puppet.module_path = "puppet"
  end
#  config.vm.forward_port 80, 8080
#  config.vm.forward_port 443, 8443
  config.vm.customize ["modifyvm", :id, "--memory", 1024] 
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  config.vm.share_folder("v-root", "/vagrant", ".", :extra => 'dmode=777,fmode=777', :nfs => true)
  config.vm.forward_port 22, 2222, :name => "ssh", :auto => true
#  config.ssh.port = 22
#  config.ssh.guest_port = 22
end
