# Building and publishing your project

Make sure you have a valid account at [pypi](https://pypi.org/). You can create one [here](https://pypi.org/account/register/).

Run `poetry build` (at the level where a valid `pyproject.toml` is present). From this point on, you have two options:

## Publish to pypi

Run `poetry publish --username myprivaterepo --password <password> --repository pypi`

## Publish to a private repository

if you wish to publish to a private repository, say, `pypi.myprivaterepo.org`:

- Add repository to the `config` in poetry, with `poetry config repositories.myprivaterepo https://pypi.myprivaterepo.org/`
- Careful to not add the `/simple` bit if your privare repo is using [`pypiserver`](https://hub.docker.com/r/pypiserver/pypiserver), see <https://github.com/pypiserver/pypiserver/issues/329#issuecomment-688883871>
- now your private pypi \*\*\*\*repository is aliased with `myprivaterepo`

Now you can run `poetry publish --username myprivaterepo --password <password> --repository myprivaterepo`. See <https://python-poetry.org/docs/libraries#publishing-to-pypi> for more documentation

## Creating your own private repository using docker compose

Launch your own pypi repository with <https://github.com/pypiserver/pypiserver> and <https://github.com/pypiserver/pypiserver/blob/master/docker-compose.yml>

## Adding dependencies from private repositories to pyproject.toml

You may also want to add dependencies from private repositories. These repos normally need keys to access them. Make sure to follow the instructions from your private repository to add credentials to your `pyproject.toml` file. Generally, the process is as follows:

1. Add a `source` to `pyproject.toml` file

   1. `poetry source add myprivaterepo [https://pypi.](https://pypi.datuma.aiguasol.coop/simple)myprivaterepo.org`
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

!!! info "Managing virtual environments inside docker"

	People tend to argue over such scenario. _Is isolation within isolation necessary? Is a virtual environment needed inside a docker container?_ See

	- <https://github.com/python-poetry/poetry/discussions/1879#discussioncomment-346113>
	- <https://github.com/python-poetry/poetry/pull/3209#issuecomment-710678083>

	Answer is “_it depends_”, but it gives more control over dependencies and their state. I prefer it using docker multistage builds. I will cover this in a next post hopefully soon.

