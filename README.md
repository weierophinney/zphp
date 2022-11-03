# PHP builds

This directory contains a number of dockerfiles that can be used to generate local PHP containers.
Use `make help` to get a list of available targets.

## Preparing images

You can run `make help` to get a list of targets.
`make all` will build all images.

### ZendPHP LTS Credentials

For LTS versions, you will need to provide credentials.
You can do this via a `.env` file, with the following contents:

```bash
ZENDPHP_REPO_USERNAME={ORDER ID or account ID}
ZENDPHP_REPO_PASSWORD={password}
```

### GitHub credentials

In order to provide extended GitHub API limits when using Composer, you may want to build the images such that they contain your GitHub credentials.
These are controlled by the `.env` variables:

- GITHUB_USERNAME
- GITHUB_TOKEN

## Usage

### Executing the PHP binary or running PHP scripts

If you want to run a script that is installed locally, you will want to:

- Map the local directory to a directory in the container.
- Make that container directory the working directory.
- Run interactively, and ensure the container is removed on exit.

As an example, the following runs `vendor/bin/phpcs` using the PHP 8.1 container:

```bash
docker run --rm -it -v "$(pwd):/app" -w /app zendphp:8.1 vendor/bin/phpcs
```

The script `phpc` will essentially do this for you, and the above becomes:

```bash
phpc --php 8.1 vendor/bin/phpcs
```

> If you have set a default PHP version via `phpc switch 8.1`, you can omit the `--php` flag.

### Executing Composer

If you want to run Composer for the current directory, you will want to:

- Map the local directory to a directory in the container.
- Make that container directory the working directory.
- Run interactively, and ensure the container is removed on exit.
- Change the entrypoint to reference `/usr/local/sbin/composer`.

As an example, the following runs Composer using the PHP 8.1 container:

```bash
docker run --rm -it -v "$(pwd):/app" -w /app --entrypoint /usr/local/sbin/composer zendphp:8.1 install
```

The script `phpc` will essentially do this for you, and the above becomes:

```bash
phpc composer --php 8.1 install
```

> If you have set a default PHP version via `phpc switch 8.1`, you can omit the `--php` flag.

### Executing a PHP-based webserver

The `--expose-port` flag to `phpc run` will expose that port to the host.
This allows you to run PHP-based web servers, including the built-in web server:

```bash
phpc run --expose-port 8080 -S 0.0.0.0:8080 -t .
```
