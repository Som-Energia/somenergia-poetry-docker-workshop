# Part 3: Publishing your package to PyPI

!!! info "PyPi account needed"

    Make sure you have a valid account at [pypi](https://pypi.org/). You can create one [here](https://pypi.org/account/register/).

Run `poetry build` (at the level where a valid `pyproject.toml` is present). From this point on, you have two options:

- Publish to pypi
- Publish to a private repository

We will cover both options

## Prepare your package for publishing

```bash
mkdir -p services/part-3/greeter
cp -r services/part-2/python-poetry/* services/part-3/greeter
```

## Publish to pypi

Run `poetry publish --username myprivaterepo --password <password> --repository pypi`. Here, `myprivaterepo` is the name of the repository you want to publish to. If you want to publish to the public pypi, you can omit the `--repository` argument.

## Publish to a private repository

if you wish to publish to a private repository, say, `pypi.myprivaterepo.org`:

- Add repository to the `config` in poetry, with `poetry config repositories.myprivaterepo https://pypi.myprivaterepo.org/`
- Careful to not add the `/simple` bit if your privare repo is using [`pypiserver`](https://hub.docker.com/r/pypiserver/pypiserver), see <https://github.com/pypiserver/pypiserver/issues/329#issuecomment-688883871>
- now your private pypi \*\*\*\*repository is aliased with `myprivaterepo`

Now you can run `poetry publish --username myprivaterepo --password <password> --repository myprivaterepo`. See <https://python-poetry.org/docs/libraries#publishing-to-pypi> for more documentation

## Creating your own private repository using docker compose

Launch your own pypi repository with <https://github.com/pypiserver/pypiserver> and <https://github.com/pypiserver/pypiserver/blob/master/docker-compose.yml>.

## Adding dependencies from private repositories to pyproject.toml

You may also want to add dependencies from private repositories. These repos normally need keys to access them. Make sure to follow the instructions from your private repository to add credentials to your `pyproject.toml` file. Generally, the process is as follows:

1. Add a `source` to `pyproject.toml` file

   1. `poetry source add myprivaterepo https://pypi.myprivaterepo.org/simple`
   2. This should modify your `pyproject.toml` file and will add something like this

      ```toml
      [[tool.poetry.source]]
      name = "myprivaterepo"
      url = "https://pypi.myprivaterepo.org/"
      default = false
      secondary = false
      ```

2. Add credentials for that repository
   1. `poetry config http-basic.myprivaterepo <user> <password>`
3. Add dependencies using the `--source` argument

   ```bash
   poetry add --source myprivaterepo my-private-package=0.2.1
   ```
