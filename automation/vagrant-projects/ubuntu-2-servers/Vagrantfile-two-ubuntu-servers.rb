Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-17.10"

  config.vm.define :server1 do |server|
    server.vm.network "private_network", ip: "192.168.50.100"
    server.vm.hostname = "server1"
  end

  config.vm.define :server2 do |server|
    server.vm.network "private_network", ip: "192.168.50.101"
    server.vm.hostname = "server2"
  end

end