# PHP builds

This directory contains a number of dockerfiles that can be used to generate local PHP containers.
Use `make help` to get a list of available targets.

## Usage

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
