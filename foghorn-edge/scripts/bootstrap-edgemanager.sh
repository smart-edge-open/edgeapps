yes n | cp -i /fh_vol/fh/tmp/certs/license-ca.crt /fh_vol/fh/certs/ca/ 
yes n | cp -i /fh_vol/fh/tmp/certs/key.pem /fh_vol/fh/license/edge/ 
yes n | cp -i /fh_vol/fh/tmp/certs/cert.pem /fh_vol/fh/license/edge/ 
yes n | cp -i /fh_vol/fh/tmp/certs/ca-cert.pem /fh_vol/fh/license/edge/ 
yes n | cp -i /fh_vol/fh/tmp/configs/edge_properties.json /fh_vol/fh/configs/ 
yes n | cp -i /fh_vol/fh/tmp/configs/em-container-list.txt /fh_vol/fh/configs/ 
yes n | cp -i /fh_vol/fh/tmp/logrotate/fh-log-rotate /fh_vol/fh/assets/logrotate/
yes n | cp -i /fh_vol/fh/tmp/logrotate/logrotate /fh_vol/fh/assets/logrotate/logrotate.sh
yes n | cp -i /fh_vol/fh/tmp/logrotate/logrotate-daemon /fh_vol/fh/assets/logrotate/logrotate_daemon.sh
chmod +x /fh_vol/fh/assets/logrotate/logrotate_daemon.sh
chmod +x /fh_vol/fh/assets/logrotate/logrotate.sh
echo n | cp -iR /fh_vol/fh/tmp/logger/. /fh_vol/fh/configs/logger/
