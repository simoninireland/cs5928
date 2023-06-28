# Makefile for CS5928 Complex systems and simulation


# ----- Sources -----

# Notebooks
SOURCE_NOTEBOOKS = \
	notebooks/03-simulation/03-networks-in-python.ipynb


# ----- Tools -----

# Base commands
PYTHON = python3
IPYTHON = ipython
JUPYTER = jupyter
TOX = tox
COVERAGE = coverage
PIP = pip
TWINE = twine
FLAKE8 = flake8
MYPY = mypy
GPG = gpg
GIT = git
ETAGS = etags
VIRTUALENV = $(PYTHON) -m venv
ACTIVATE = . $(VENV)/bin/activate
TR = tr
CAT = cat
SED = sed
RM = rm -fr
CP = cp
CHDIR = cd
ZIP = zip -r

# Root directory
ROOT = $(shell pwd)

# Requirements
VENV = venv3
REQUIREMENTS = requirements.txt
DEV_REQUIREMENTS = dev-requirements.txt

# Constructed commands
RUN_SERVER = PYTHONPATH=. $(JUPYTER) notebook


# ----- Top-level targets -----

# Default prints a help message
help:
	@make usage

# Run the notebook server
live: env
	$(ACTIVATE) && $(RUN_SERVER)

# Build a development venv from the requirements in the repo
.PHONY: env
env: $(VENV)

$(VENV):
	$(VIRTUALENV) $(VENV)
	$(ACTIVATE) && $(PIP) install -U pip wheel && $(PIP) install -r $(REQUIREMENTS)

# Clean up everything, including the computational environment (which is expensive to rebuild)
reallyclean:
	$(RM) $(VENV)


# ----- Usage -----

define HELP_MESSAGE
Available targets:
   make live         run a Jupyter notebook server
   make env          create a development virtual environment
   make reallyclean  clean up the virtualenv as well

endef
export HELP_MESSAGE

usage:
	@echo "$$HELP_MESSAGE"
