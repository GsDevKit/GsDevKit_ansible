# Administer GemStone + Nginx on Ubuntu

1. Rent servers from linode.com or aws or wherever.
2. Get the DNS details of those servers and enter the domains in the `ansible_hosts` file in this repo.
3. Run `sendPublicSSHkeyToServer.sh my.server.ip.address mydomain.com` to push your public SSH keys (e.g. ~/.ssh/id_rsa.pub) to the remote servers
4. Run

```
ansible-playbook -i ansible_hosts site.yml
```

## The roles

Each role is driven by the YAML file found in their respective `tasks/main.yml` file which is further customized by the variables in the `vars/main.yml` file. They're readable and each step has a one sentence description of what its gonna do.  You should definitely look at the files in the `vars`, `group_vars`, and `host_vars` directories in the root of this repo and the `vars/main.yml` file in each role. 

### Initial-Setup
Takes a bare server, create a user, shut off root access, installs a bunch of packages, turn on a firewall, and then reboots.  
### GemStone
Install the GemStone version specified in the `gemstone_vers` variable (found in `roles/gemstone/vars/main.yml`) using GsDevKit_home and get 3 fastcgi servers running in addition to the maintenance and service gems.  That all runs under daemontools so when a gem dies it is automatically restarted.  It can be set up to copy up an existing repo or load a Metacello project into a bare repo.  
### StaticFileServer
Sets up some git repos so you can push HTML,JS, and CSS to a webserver root from your laptop as described in  http://toroid.org/ams/git-website-howto
### Nginx
Installs the latest stable nginx from the ppa, adds geoip, letsencrypt, copies up and creates the configuration files for the seaside gems, makes sure the firewall is open on port 80 & 443, then restarts nginx.  The nginx configuration files are designed to make the site run with HTTPS by default so you'll need to do some work to use plain old HTTP.
### Tarsnap
This is a git submodule. I'm not sure thats the best thing to do for this.  Downloads and installs tarnsap as a cron job.  You need a tarsnap.com account so this doesn't run by default.  
### Logging
At one time I was using elasticsearch, logstash, and kibana to manage all the logs but lost interest in maintaining my set up and so this role kind of does that but there are probably better ways to get that done that have been invetned in the few years since I last had it working.

# Todo
 - nagios or monit to watch for out of disk errors with tranlogs and 1-second/60-second stats.
 - I think the letsencrypt stuff works but am not positive
 - finish/verify tarsnap backup install
 - hot standby
 - rent servers and get their DNS info automatically using some ansible modules
 - log aggregation
 - add RHEL/CentOS
 	- at least need to change the package install stuff which is now all apt commands
