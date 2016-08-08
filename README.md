## docker-lempfony

Set up a development environment in a single container.

- Ubuntu 16.04
- Nginx
- MySQL
- PHP 7.0
- phpMyAdmin
- Composer
- Symfony

### Build
<pre><code>docker build --build-arg mysql_root_pwd=<i>custom_pwd</i> -t lempfony .</code></pre>

### Run in shell
<pre><code>docker run -it -p 80:80 -v <i>~/projects/log</i>:/var/log -v <i>~/projects/mysql</i>:/var/lib/mysql -v <i>~/projects/www</i>:/var/www lempfony:latest</code></pre>

### Run in detached mode
<pre><code>docker run -dit -p 80:80 -v <i>~/projects/log</i>:/var/log -v <i>~/projects/mysql</i>:/var/lib/mysql -v <i>~/projects/www</i>:/var/www lempfony:latest</code></pre>