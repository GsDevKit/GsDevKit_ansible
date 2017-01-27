---
#domain: example.com
net_ldi_main: 60377
net_ldi_range: 60378:60379
tarsnap_name: example1
tarsnap_backup_dirs: home var/www mnt/extents/backups mnt/tranlogs
backup_frequency: hourly
extent_path: /opt/extents
tranlog_path: /opt/tranlogs
tranlog_size: 500
gemstone_primary: true

