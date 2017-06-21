# `gem install net-ssh` first
require 'net/ssh'

ssh = Net::SSH.start('192.168.2.201', 'admin', :password=> '123456')

# # sync time with ntp server
# ssh.exec!("ntpdate time.stdtime.gov.tw")
# # write to bios time
# ssh.exec!("hwclock -w")
open("2017_0523/#{ARGV[0]}.tsv", 'w') do |f|

  puts "time\t    rules\tiperf_rules"
  f << "time\t    rules\tiperf_rules"
  while true
    time = `date +%H:%M:%S`.delete("\n")
    rules = ssh.exec!("/ovs/bin/ovs-ofctl dump-flows br0 | grep table | wc -l").delete("\n")
    rules140 = ssh.exec!("/ovs/bin/ovs-ofctl dump-flows br0 | grep 140.114.71.176 | wc -l")

    puts "#{time}\t#{rules}\t#{rules140}"
    f << "#{time}\t#{rules}\t#{rules140}"
    sleep 1
  end
end
