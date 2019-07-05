#!/bin/bash
apt-get install facter ruby -y 
mkdir -p /tmp/facter
facter -j --show-legacy > /tmp/facter/facterj
cat <<EOF >> /etc/telegraf/telegraf.conf
#####################################
##      Facter from Json            #
####################################

[[inputs.file]]
  files = ["/tmp/facter/facterj"]
  name_override = "facter_metrics"
  data_format = "json"
  tag_keys = [
    "lsbdistdescription",
    "operatingsystemrelease",
    "hostname",
    "os.distro.description"
]
EOF
service telegraf restart

echo "facter -j --show-legacy > /tmp/facter/facterj" > etc/cron.daily/facter-update
chmod +x /etc/cron.daily/facter-update
