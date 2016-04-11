# BridgeConX ldock

A suite of Docker images, Rancher Catalog Templates, and documentation for running a Laravel-centric web stack in Docker.

> Inspired by [Laravel Forge](https://forge.laravel.com)

## ldock phpnginx

![](http://dockeri.co/image/bridgeconx/ldock-phpnginx)

A production PHP & Nginx environment inspired by Laravel Forge's provisioning scripts. Thanks, Taylor!

### Usage

To start a container:

```
sudo docker run -itd bridgeconx/ldock-phpnginx
```

Nginx is configured to listen on port 80. The `-p` flag is formatted `{port_on_host}:{port_in_container}`.

```
sudo docker run -itd \
    -p 80:80 \
    bridgeconx/ldock-phpnginx
```

Mount a data volume into `/var/www/public`, where nginx is directing PHP requests to.

```
sudo docker run -itd \
    -v /path/on/host/laravel:/var/www \
    bridgeconx/ldock-phpnginx
```

### Running a Queue Worker

This behavior is still very primitive, but you are able to run a queue worker (`php /var/www/artisan queue:listen`) in a separate container. Use the volumes from your main container. On boot, the container will wait for confirmation that Laravel has been installed (again, primitive), and then start your worker.

```
sudo docker run -itd \
    -v /path/on/host/laravel:/var/www \
    bridgeconx/ldock-phpnginx \
    /bin/bash /root/schedule-run.sh
```

> I can't emphasize enough... PRIMITIVE! I would not consider this usable in production.

### Environment Variables

#### **COMPOSER_HOME**

Sets the home directory for Composer. default: `/root/.composer`

#### **COMPOSER_INSTALL**

Set to a non-empty string to *disable* `composer install --no-dev`. Only applies when **GIT_URL** is defined.

#### **GIT_URL**

Full Git URL to a repository. If provided, this will trigger the following actions:

- Run **PRE_INSTALL** script, if defined..
- Empty the `/var/www` directory!
- Clone the **GIT_URL** into `/var/www`.
- Install Composer Dependencies, unless disabled with **COMPOSER_INSTALL**
- Chown the `/var/www/storage` directory to `www-data:www-data`, unless disabled with **STORAGE_WRITABLE**.
- Run **POST_INSTALL** script, if defined.

#### **GITHUB_TOKEN**

GitHub Personal Access Token. Used to prevent GitHub API Rate Limiting. Get one here: [https://github.com/settings/tokens](https://github.com/settings/tokens).

#### **ID_RSA** - Incredibly insecure!! Do not use in production!!

Not even going to document this. Do not use it.

#### **POST_INSTALL**

Command to be executed after Composer dependencies are installed. Executed as `sh -c "$POST_INSTALL"`.

#### **PRE_INSTALL**

Command to be executed before Composer dependencies are installed. Executed as `sh -c "$PRE_INSTALL"`.

#### **SCHEDULE_ARTISAN_RUN**

Set to a non-empty string to *disable* `php /var/www/artisan schedule:run` scheduling. This will effectively schedule the following cron: `* * * * * * php /var/www/artisan schedule:run`. Only applies when **GIT_URL** is defined.

#### **STORAGE_WRITABLE**

Set to a non-empty string to *disable* `chmod -R www-data:www-data /var/www/storage`. Only applies when **GIT_URL** is defined.

#### **TORAN_HOST**

Hostname of a private [Toran Proxy](https://toranproxy.com/). When provided, Composer will be configured for HTTP Basic Auth on your toran proxy using the provided **TORAN_HTTP_USER** and **TORAN_HTTP_PASS** (both required). Your `composer.json` file will still need to reference the Toran Proxy in the `repositories` [config](https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md#setup).

#### **TORAN_HTTP_USER**

HTTP Basic Auth Username for a Toran Proxy located at **TORAN_HOST**. *sometimes required*

#### **TORAN_HTTP_PASS**

HTTP Basic Auth Password for a Toran Proxy located at **TORAN_HOST**. *sometimes required*
