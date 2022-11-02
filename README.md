# PHP builds

This directory contains a number of dockerfiles that can be used to generate local PHP containers.
Use `make help` to get a list of available targets.

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

The script `bin/runphp` will essentially do this for you, and the above becomes:

```bash
runphp 8.1 vendor/bin/phpcs
```

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

The script `bin/runcomposer` will essentially do this for you, and the above becomes:

```bash
runcomposer 8.1 install
```
