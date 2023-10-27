# Part 1: A demonstration using Docker

!!! tip "In case you do not have Docker installed already" 

    You can get free containers using [play-with-docker](https://labs.play-with-docker.com/). You can tell if you have docker installed by running `docker run --rm hello-world`. You may need root access.

Start by launching a new container named `poetry-ws-part-1` with the latest version of ubuntu and run a bash shell. The `--rm` flag will remove the container after you exit it so it won't clutter your system.

```bash
docker run -it --name poetry-ws-part-1 ubuntu:latest bash`
```

You can remove the container afterwards after you've exited it with

```bash
docker container rm poetry-ws-part-1
```

!!! tip "Editing files inside a container"

    At this point you are now starting from a clean slate. Next steps require that you create and edit files using a terminal. A different, more comfortable approach is to attach a visualstudiocode instance to the container and treat it as a normal project. You will need the `Remote Explorer` extension.

## Installing `pyenv`

Install pyenv dependencies and other utilities.

```bash
apt update && apt install curl git vim build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
```

```bash
curl https://pyenv.run | bash
```

You will now have `pyenv` installed. Let's configure it. As per the instructions, we need to add the following to our `~/.bashrc` file:

```bash
vim ~/.bashrc
```

Go to the end of the file and add the following:

```bash
# Load pyenv automatically by appending
# the following to
#~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

Save and quit (`:wq` in vim). Now we need to refresh our shell to load the new configuration:

```bash
exec "$SHELL"
```

## Installing python with `pyenv`

You can now use `pyenv` to install a new version of python. Let's install version `3.10.9`:

```bash
pyenv install 3.10.9
```

Let's make it available globally:

```bash
pyenv global 3.10.9
```

We can also install different versions of python and switch between them:

```bash
pyenv install 3.8.12
```

## Installing `pipx`

We have now python 3.10.9 installed globally. Let's install `pipx` with it:

```bash
python3 -m pip install --upgrade pip
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```

Again, we need to refresh our shell to load the new configurations:

```bash
exec "$SHELL"
```

## Installing `poetry`

Let's install `poetry` with `pipx`:

```bash
pipx install poetry==1.4.2 --force
```

And confirm it's installed with:

```bash
$ poetry --version
Poetry (version 1.4.2)
$ whereis poetry
poetry: /root/.local/bin/poetry
```

### Configure `poetry`

We want to configure poetry to not create virtual environments by default:

```bash
# configure poetry
poetry config virtualenvs.create false`
poetry config virtualenvs.in-project false`
```

## Creating a new project with `poetry`

We can create a new project with poetry named `part-1`:

```bash
# create project
mkdir ~/part-1
cd ~/part-1
```

We will now create a virtual environment for this project only

```bash
pyenv virtualenv 3.10.9 poetry-ws-part-1
pyenv activate poetry-ws-part-1
pyenv rehash # refresh pyenv shims
```

!!! tip "Sourcing environment automatically"

    At the project level, type `pyenv local poetry-ws-part-1` to tell `pyenv` to source this environment every time you cd into the directory. `pyenv` will do so by creating a file `.python-version` at the directory. It does not need to be the name of a virtual environment, a version number e.g. 3.10.9 could also be used.

use poetry to create new project with

```bash
poetry init
```

The dialog will ask you a few questions. You can skip them by pressing enter or by passing `--no-interaction` to the previous command. Skip the part poetry asks you about defining dependencies using the prompt. The dialog will then create a `pyproject.toml` file.

Have a look at it! It should look something like this:

```toml
[tool.poetry]
name = "part-1"
version = "0.1.0"
description = ""
authors = ["You <you@mail.something>"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^3.10"


[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

## Manage dependencies in your project

```bash
poetry add pandas
```

and remove dependencies

```bash
poetry remove pandas
```

Every time you `add` or `remove` packages with poetry, two things happen:

- the `pyproject.toml` file is updated and a new line is added under the dependencies section
- a `poetry.lock` file is created or updated, containing the exact versions of the dependencies you are using and their relations.

Let's install `cowsay` with `poetry`:

```bash
poetry add cowsay
poetry add --group dev black
pyenv rehash # to update shims
cowsay hola # a cow should greet you, in spanish
  ____
| hola |
  ====
    \
     \
       ^__^
       (oo)\_______
       (__)\       )\/\
           ||----w |
           ||     ||

```

Go check your `pyproject.toml` file again with the changes.

## Writing your project as a CLI with `poetry`

```bash
cd ~/part-1
mkdir part-1
touch part-1/__init__.py
touch part-1/cli.py
```

Open `part-1/cli.py` and add the following:

```bash
import cowsay

def cli():
    return cowsay.cow('Hello World')

if __name__ == "__main__":
    cli()
```

!!! info "What is a CLI?"

    _CLI_ stands for _command line interface_. It is a type of software that acts as an interface to another software, and is designed to be executed from a terminal and interact with the user through text. A common example is the `git` CLI.

Confirm that your program works by running it with `python part-1/cli.py`:

```bash
$ python part-1/cli.py
___________
| Hello World |
  ===========
           \
            \
              ^__^
              (oo)\_______
              (__)\       )\/\
                  ||----w |
                  ||     ||
```

We can now update our `pyproject.toml` file to include a CLI entrypoint:

```toml
[tool.poetry]
name = "part-1"
version = "0.1.0"
description = "some description"
authors = ["Your Name <youremail@yopmail.com>"]
readme = "README.md"
packages = [{include = "part-1"}] # new

[tool.poetry.dependencies]
python = "^3.10"
pandas = "^2.0.0"
cowsay = "^5.0"

[tool.poetry.scripts]
part-1-cli = "part-1.cli:cli" # new

[tool.poetry.group.dev.dependencies]
black = "^23.3.0"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

And now we can install our package with `poetry` and run our little CLI by calling `part-1-cli`:

```bash
poetry install  # install package along with its CLI
pyenv rehash # refresh python shims
```

Try it out!

```bash
part-1-cli # launch cli
```
