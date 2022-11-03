# ZendPHP CLI containers

This project provides:

- A mechanism to quickly build CLI containers using ZendPHP, with common extensions used during testing.
- A CLI utility that can be used for
  - running PHP and/or PHP scripts using these containers, including the ability to expose ports for PHP-based servers.
  - running Composer in the container.

## Preparing images

This directory contains a number of dockerfiles that can be used to generate local PHP containers.
Use `make help` to get a list of available targets.

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

## zphp CLI Command Usage

The `zphp` script is a bash script that provides the following subcommands:

- completions: generates command completions for your shell
- run: run PHP or a PHP script, optionally using a specific PHP minor version, and optionally exposing a port
- composer: run Composer, optionally using a specific PHP minor version
- switch: switch the default PHP version used with `run` and `composer`

All commands allow the `--help` or `-h` flag to get detailed help.
Running the script with no scommand specified will list the available commands.

### Manually executing the PHP binary or running PHP scripts via Docker

If you want to run a script that is installed locally, you will want to:

- Map the local directory to a directory in the container.
- Make that container directory the working directory.
- Run interactively, and ensure the container is removed on exit.

As an example, the following runs `vendor/bin/phpcs` using the PHP 8.1 container:

```bash
docker run --rm -it -v "$(pwd):/app" -w /app zendphp:8.1 vendor/bin/phpcs
```

### Executing Composer manually via Docker

If you want to run Composer for the current directory, you will want to:

- Map the local directory to a directory in the container.
- Make that container directory the working directory.
- Run interactively, and ensure the container is removed on exit.
- Change the entrypoint to reference `/usr/local/sbin/composer`.

As an example, the following runs Composer using the PHP 8.1 container:

```bash
docker run --rm -it -v "$(pwd):/app" -w /app --entrypoint /usr/local/sbin/composer zendphp:8.1 install
```
