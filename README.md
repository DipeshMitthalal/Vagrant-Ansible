# Vagrant-Ansible
This project uses vagrant to create N virtual machines. Ansible is used for Provisioning the same. Multiple webservers are created and load balancer is configured.

Vagrant:
Vagrant script creates N number of virtual ubuntu boxes to be used as web servers and 1 extra box to be used as load balancer. 
variables in vagrant file: 
NUMBER_OF_MACHINES = N //
Load balancer IP: 10.0.15.11
Webserver ip address starts from 10.0.15.21

Ansible:
The inventory along with right group is dynamically generated. I have also supplied ansible.config file which links to generated inventory. 

I have used the concept of ansible roles to avoid big playbook file and also to have reusable pieces of code.
Primary roles are common, lb and web. 

common - holds tasks and handlers which is common to both load balancer and web server. It installs nginx and git
lb - task and handlers for loadbalancers. It also has config template for ngnix loadbalancer setup (roundrobin).
web - task and handlers for web servers. It also has sample html and config template for nginx webserver setup

Ansible playbook pb_web provisons the created web servers by installing git, nginx and copy index.html template to webnodes.
One can also pull in code from git and same is tested , But that part of task is commented out for now. I have also configued nginx to add a custom response header to include name of hosts.

Ansible playbook pb_lb provisions the load balancer and also updates the config file for load balancer as per the number of webnodes created. It uses facts from ansible to get the ip address of the hosts and add them in load balancer config of nginx.

For during production deployment of web sites, I am aware that one can use pre tasks in ansible to bring out one node at a time from loadbalancer, deploy  web application and  after deployment, add the node back to loadbalancer. So that we roll out deployment to one node at a time with zero downtime for customers.

To test the load balancer,testlb.rb file is included which sends N requests to loadbalanced host and reads the host name (from response header) and stores the count of different hosts  it has received response from.

Usage - $ruby testlb.rb -u "10.0.15.11" -n 100
    -u, --hostname                   Specify the name of the host
    -n, --requests                   Specify the numbeer of requests
    -v, --version                    Display the version
    -h, --help                       Display this help
Please note that order of supplied arguments cannot be changed. That means it is always host name(-u) followed by number of requests(-n)

