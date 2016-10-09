## docker-lempfony: workspace demo

This an example of a workspace working with docker-lempfony.  

To run the container you can directly execute ./lempfony-run.sh, then the project 'my-project' will be accessible at my-project.dev. For Windows hosts or Firefox browser, you might need to [configure your host](https://github.com/naei/docker-lempfony#troubleshooting) first.

Here more information about the files and volumes: 

### conf/lempfony
This folder is linked with /opt/lempfony/volume.  
Its main purpose is to provide an optional init.sh script, which will be executed at container start.

### conf/nginx-sites
This folder is linked with /etc/nginx/sites-available.  
It must contain all Nginx server blocks for the projects.

### log
This folder is linked with /var/log and will be automatically populated.  
It contains server logs.

### mysql
This folder is linked with /var/lib/mysql and will be automatically populated.  
It contains MySQL databases of the projects and PhpMyAdmin.

### www
This folder is linked with /var/www.  
It contains the projects sources.

### ./lempfony-run.sh
Start the lempfony Docker with data volumes.  
To launch the script, make sure to have execution rights on this file.