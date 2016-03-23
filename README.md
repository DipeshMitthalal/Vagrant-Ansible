# Vagrant-Ansible
This project uses vagrant to create N virtual machines. Ansible is used for Provisioning the same. Multiple webservers are created and load balancer is configured.

Vagrant script creates N number of virtual machines and 1 load balancer. 
Load balancer IP: 10.0.15.11
Webserver ip address starts from 10.0.15.21

Improvements: With the supplied vagrant file it cannot create more than 235 machines. In order to accomodate more machines,
a logic needs to written which can generate range of  IP address. If needed, we can use DHCP to generate IP address and we will get N nodes. In this case, usage of DHCP with exclusion (Load balancer's IP). I have not investigated this further as in real life, machines are created and specific range of IP address is allocated.

Ansible:
The inventory along with right group is dynamically generated. I have also supplied ansible.config file which links to generated inventory. 

Ansible playbook pb_web provisons the created web servers by installing git, nginx and copy index.html template to webnodes.
One can also pull in code from git and same is tested , But that part of task is commented out for now.

Ansible playbook pb_lb provisions the load balancer and also updates the config file for load balancer as per the number of webnodes created. It uses facts from ansible to get the ip address of the hosts and add them in load balancer config of nginx.

I have used the concept of ansible roles to avoid big playbook file and also to have reusable pieces of code.
Primary roles are common, lb and web. 
common holds tasks and handlers which is common to both load balancer and web server
lb - task and handlers for loadbalancers. It also has config template for ngnix loadbalancer setup
web - task and handlers for web servers. It also has sample html and config template for webserver setup

