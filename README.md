##docker-lempfony

A Dockerfile for developers, with Ubuntu 16.04, Nginx, MySQL, PHP 7.0, Composer & Symfony.

###Build
<pre><code>docker build --build-arg mysql_root_pwd=<b>custom_password</b> -t lemp-symfony .</pre></code>

###Run in shell
<pre><code>docker run -it -p 80:80 -v / <b>local_project_folder</b>:/var/www lemp-symfony:latest</pre></code>

###Run in detached mode
<pre><code>docker run -dit -p 80:80 -v / <b>local_project_folder</b>:/var/www lemp-symfony:latest</pre></code>