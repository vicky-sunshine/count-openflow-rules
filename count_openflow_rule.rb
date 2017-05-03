# `gem install net-ssh` first
require 'net/ssh'

ssh = Net::SSH.start('192.168.2.200', 'admin', :password=> '123456')

# # sync time with ntp server
# ssh.exec!("ntpdate time.stdtime.gov.tw")
# # write to bios time
# ssh.exec!("hwclock -w")

open('rule.tsv', 'w') do |f|

  count = 0
  boundary = 70
  while count < boundary
    time = ssh.exec!('date').split()
    rules = ssh.exec!("/ovs/bin/ovs-ofctl dump-flows br0 | grep table | wc -l")
    puts "#{time[3]}\t#{rules}"
    f << "#{time[3]}\t#{rules}"
    sleep 0.9
    count = count + 1
  end
end
