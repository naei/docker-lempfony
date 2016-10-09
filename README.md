## docker-lempfony

Set up a development environment in a single container.

Ubuntu 16.04 | Nginx | MySQL | PHP 7.0 | phpMyAdmin | Composer | Symfony  


### Get the image

#### ...by building it

Clone the project, access it from your terminal, then build it:

```shell
docker build \
  --build-arg mysql_root_pwd=<custom_pwd> \
  -t naei/lempfony .
```
If ```--build-arg [...]``` is not set, MySQL credentials will be root:development.

#### ...by pulling it from the Docker Hub Registry:
```shell
docker pull naei/lempfony
```


### Run the container

```shell
docker run -it --rm --name lempfony -p 80:80 \
  -v <workspace/conf/lempfony>:/etc/opt/lempfony/volume \
  -v <workspace/conf/nginx-sites>:/etc/nginx/sites-available \
  -v <workspace/log>:/var/log \
  -v <workspace/mysql>:/var/lib/mysql \
  -v <workspace/www>:/var/www \
  naei/lempfony:latest
```
For detached mode, replace the first line by:  
```docker run -dit --name lempfony -p 80:80 \```

The data volumes are optionals and can be added or removed depending on the needs.  
For detailled information about it, you can take a look at the [example](example/workspace) workspace.


### Create a new Symfony app
From the container shell, you can quickly setup a functionnal new Symfony app:
```shell
symfony-create <app-name> [symfony-version]
```
Your project will be immediately accessible at &lt;app-name>.dev .


### Troubleshooting

#### Windows host: the Symfony project creation script crash after "Preparing project..."
The Symfony project creation process works with symlinks. By default on Windows,  only an administrator can create symlink, so be sure that the Docker terminal is launched as an administrator. 

#### Windows host: the local domain names are accessible from inside the container but not from a web browser
Each domain name must be binded to the Docker container's IP in the C:\Windows\System32\drivers\etc\hosts file:
```
192.168.99.100 project.dev
192.168.99.100 otherproject.dev
```

#### Linux host: the local domain name is not accessible from Firefox
You might need to add the local domain name into about:config > network.dns.localDomains