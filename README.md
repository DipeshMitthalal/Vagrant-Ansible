Vagrant-Ansible
This project uses vagrant to create N virtual machines and configure loadbalancer on another virtual machine. Ansible is used for Provisioning the virtual machines.

Focus area: 
In this assignment I focused more on making solution more generic (dynamic inventory, N machines, reusable tasks, config templates, usage of ansible facts).

Vagrant: Vagrant script creates N number of virtual ubuntu boxes to be used as web servers and 1 extra box to be used as load balancer. 
variables in vagrant file - 
NUMBER_OF_WEBSERVERS = N // Number of required web servers
Load balancer IP: 10.0.15.11 
Webserver ip address starts from 10.0.15.21

Ansible: The inventory along with right group is dynamically generated. I have also supplied ansible.cfg file which links to generated inventory and useful to run ansible locally.
I have used the concept of ansible roles to avoid big playbook file and have it organized and to have reusable pieces of code. Primary roles are common, lb and web.

Ansible roles:
common - holds tasks and handlers which is common to both load balancer and web server. It installs nginx and git 
lb - task and handlers for loadbalancers. It also has config template for ngnix loadbalancer setup (roundrobin). 
web - task and handlers for web servers. It also has sample html and config template for nginx webserver setup.

Ansible playbook pb_web provisions the created web servers by installing git, nginx and copy index.html template to webnodes. One can also pull in code from git and same is tested , But that part of task is commented out for now. I have also configured nginx to add a custom response header to include name of hosts.

Ansible playbook pb_lb provisions the load balancer and also updates the config file for load balancer based on number of web nodes created. It uses facts from ansible to get the ip address of the hosts and add them in load balancer config of nginx.

During production deployment of web sites, I am aware that one can use pre tasks in ansible to bring out one node at a time from load balancer, deploy web application on that node and after deployment, add the node back to loadbalancer. So that once can do rolling deployment to one node at a time with zero downtime for customers.

Test the loadbalancer
To test the load balancer,testlb.rb file is included which sends N requests to loadbalanced host and reads the host name (from response header) and stores the count of different hosts it has received response from.

How to run:

$ vagrant up 

This will start the VM, and run the provisioning playbook (on the first VM startup).
To re-run a playbook on an existing VM, just run:

$ vagrant provision

$ ansible-playbook pb_web.yml 

To run ansible manually inside the project directory, I have included ansible.cfg file which links the generated host file. 

Usage of ruby script to test load balancer
-u, --hostname Specify the name of the host 
-n, --requests Specify the number of requests 
-v, --version Display the version 
-h, --help Display this help 

- \$ ruby testlb.rb -u "10.0.15.11" -n 100 
web1  34
web2  33
web3  33

Please note that order of supplied arguments cannot be changed. That means it is always host name(-u) followed by number of requests(-n)

Improvements: With the supplied vagrant file it cannot create more than 235 machines. In order to accommodate more machines, a logic needs to written which can generate range of IP address. If needed, we can use DHCP to generate IP address and we will get N nodes. In this case, usage of DHCP with exclusion (Load balancer's IP) might be required. I have not investigated this further as in real life, machines are created and specific range of IP address is allocated.

Remarks:
I have used vagrant before but this is first time I used ansible and I thoroughly enjoyed learning it. Same goes with nginx as I never used it before. I did not focus on security aspect for the web server.

Most time taking issues faced:
Nginx config 4 hours
Error: connection refused
Reason: I forgot to link config files from sites-available to  sites-enabled

Ansible Nginx configuration 3 hours:
Config is updated but ansible is somehow skipping the restart nginx handler
Reason: I did not enable sudo option  hence it was unable to restart nginx and silently failed






