#!/usr/bin/env bash
# ONLY FOR THE NEW BETA BUILD 5.12.6 -- 2023.09.04
# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y gnupg
$STD apt-get install -y jsvc
msg_ok "Installed Dependencies"

msg_info "Installing Azul Zulu"
wget -qO /etc/apt/trusted.gpg.d/zulu-repo.asc "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xB1998361219BD9C9"
wget -q https://cdn.azul.com/zulu/bin/zulu-repo_1.0.0-3_all.deb
$STD dpkg -i zulu-repo_1.0.0-3_all.deb
$STD apt-get update
$STD apt-get -y install zulu8-jdk
msg_ok "Installed Azul Zulu"

msg_info "Installing MongoDB"
wget -qL http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.19_amd64.deb
$STD dpkg -i libssl1.1_1.1.1f-1ubuntu2.19_amd64.deb
wget -qL https://repo.mongodb.org/apt/ubuntu/dists/bionic/mongodb-org/3.6/multiverse/binary-amd64/mongodb-org-server_3.6.23_amd64.deb
$STD dpkg -i mongodb-org-server_3.6.23_amd64.deb
msg_ok "Installed MongoDB"

latest_url=$('https://static.tp-link.com/upload/beta/2023/202309/20230904/Omada_SDN_Controller_v5.12.6_Linux_x64.deb(Beta).zip')
latest_version=$('beta 5.12.6')

msg_info "Installing Omada Controller ${latest_version}"
wget -qL ${latest_url}
unzip 'omada_v5.12.6_linux_x64_20230822180516.deb'
$STD dpkg -i omada_v5.12.6_linux_x64_20230822180516.deb
echo "bash -c \"\$(wget -qLO - https://github.com/mainkowitsch/Proxmox/raw/main/ct/${app}.sh)\"" >/usr/bin/update
chmod +x /usr/bin/update
msg_ok "Installed Omada Controller ${latest_version}"

motd_ssh
customize

msg_info "Cleaning up"
rm -rf omada_v5.12.6_linux_x64_20230822180516.deb 'Omada_SDN_Controller_v5.12.6_Linux_x64.deb(Beta).zip' mongodb-org-server_3.6.23_amd64.deb zulu-repo_1.0.0-3_all.deb libssl1.1_1.1.1f-1ubuntu2.19_amd64.deb
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
