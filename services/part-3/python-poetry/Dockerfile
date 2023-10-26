
# ---------------------------------------------------------------------------- #
#                            global build arguments                            #
# ---------------------------------------------------------------------------- #

# Global ARG, available to all stages (if renewed)
ARG WORKDIR="/app"

# global username
ARG USERNAME=somenergia
ARG USER_UID=1000
ARG USER_GID=1000

# tag used in all images
ARG PYTHON_VERSION=3.10.9

# ---------------------------------------------------------------------------- #
#                                  build stage                                 #
# ---------------------------------------------------------------------------- #

FROM python:${PYTHON_VERSION}-slim AS builder

# Renew args
ARG WORKDIR
ARG USERNAME
ARG USER_UID
ARG USER_GID

# Poetry version
ARG POETRY_VERSION=1.5.1

# Pipx version
ARG PIPX_VERSION=1.2.0

# prepare the $PATH
ENV PATH=/opt/pipx/bin:${WORKDIR}/.venv/bin:$PATH \
  PIPX_BIN_DIR=/opt/pipx/bin \
  PIPX_HOME=/opt/pipx/home \
  PIPX_VERSION=$PIPX_VERSION \
  POETRY_VERSION=$POETRY_VERSION \
  PYTHONPATH=${WORKDIR} \
  # Don't buffer `stdout`
  PYTHONUNBUFFERED=1 \
  # Don't create `.pyc` files:
  PYTHONDONTWRITEBYTECODE=1 \
  # make poetry create a .venv folder in the project
  POETRY_VIRTUALENVS_IN_PROJECT=true

# ------------------------------ add user ----------------------------- #

RUN groupadd --gid $USER_GID "${USERNAME}" \
  && useradd --uid $USER_UID --gid $USER_GID -m "${USERNAME}"

# -------------------------- add python dependencies ------------------------- #

# Install Pipx using pip
RUN python -m pip install --no-cache-dir --upgrade pip pipx==${PIPX_VERSION}
RUN pipx ensurepath && pipx --version

# Install Poetry using pipx
RUN pipx install --force poetry==${POETRY_VERSION}

# ---------------------------- add code specifics ---------------------------- #

# Copy everything to the container
# we filter out what we don't need using .dockerignore
WORKDIR ${WORKDIR}

# make sure the user owns /app
RUN chown -R ${USER_UID}:${USER_GID} ${WORKDIR}

# Copy only the files needed for installing dependencies
COPY --chown=${USER_UID}:${USER_GID} pyproject.toml poetry.lock README.md ${WORKDIR}/
COPY --chown=${USER_UID}:${USER_GID} src ${WORKDIR}/

RUN poetry install

USER ${USERNAME}

CMD [ "greeter-cli" ]