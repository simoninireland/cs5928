# Makefile for CS5928 Comles systems and simulation



# ----- Sources -----

# Source code
SOURCES_SETUP_IN = setup.py.in
SOURCES_CODE_INIT = \
	epydemic/__init__.py \
	epydemic/gf/__init__.py \
	epydemic/archive/__init__.py
SOURCES_CODE = \
	epydemic/types.py \
	epydemic/bbt.py \
	epydemic/drawset.py \
	epydemic/networkexperiment.py \
	epydemic/newmanziff.py \
	epydemic/nz_extended.py \
	epydemic/networkdynamics.py \
	epydemic/synchronousdynamics.py \
	epydemic/stochasticdynamics.py \
	epydemic/generator.py \
	epydemic/standard_generators.py \
	epydemic/plc_generator.py \
	epydemic/coreperiphery_generator.py \
	epydemic/modular_generator.py \
	epydemic/loci.py \
	epydemic/process.py \
	epydemic/processsequence.py \
	epydemic/compartmentedmodel.py \
	epydemic/sir_model.py \
	epydemic/sir_model_fixed_recovery.py \
	epydemic/sir_model_variable_infection.py \
	epydemic/sis_model.py \
	epydemic/sis_model_fixed_recovery.py \
	epydemic/sirs_model.py \
	epydemic/seir_model.py \
	epydemic/adddelete.py \
	epydemic/percolate.py \
	epydemic/monitor.py \
	epydemic/statistics.py \
	epydemic/shuffle.py \
	epydemic/newmanziff.py \
	epydemic/opinion_model.py \
	epydemic/vaccinate_model.py \
	epydemic/sivr_model.py \
	epydemic/pulsecoupled.py \
	epydemic/gf/gf.py \
	epydemic/gf/interface.py \
	epydemic/gf/function_gf.py \
	epydemic/gf/discrete_gf.py \
	epydemic/gf/continuous_gf.py \
	epydemic/gf/sum_gf.py \
	epydemic/gf/product_gf.py \
	epydemic/gf/standard_gfs.py \
	epydemic/archive/builder.py
SOURCES_TESTS_INIT = test/__init__.py
SOURCES_TESTS = \
	test/test_bitstream.py \
	test/test_networkdynamics.py \
	test/test_stochasticrates.py \
	test/test_compartmentedmodel.py \
	test/compartmenteddynamics.py \
	test/test_loci.py \
	test/test_sir.py \
	test/test_sir_fixedrecovery.py \
	test/test_sir_variable_infection.py \
	test/test_sis.py \
	test/test_sis_fixedrecovery.py \
	test/test_sirs.py \
	test/test_seir.py \
	test/test_process.py \
	test/test_processsequence.py \
	test/test_adddelete.py \
	test/test_adddeletesir.py \
	test/test_percolate.py \
	test/test_shuffle.py \
	test/test_newmanziff.py \
	test/test_opinion.py \
	test/test_vaccination.py \
	test/test_generators.py \
	test/test_coreperiphery.py \
	test/test_modular.py \
	test/test_gf.py \
	test/test_gof.py \
	test/test_events.py \
	test/test_sto_sync.py \
	test/test_pulsecoupled.py
TESTSUITE = test

# Extras for building diagrams etc
SOURCES_UTILS = \
	utils/make-powerlaw-cutoff.py \
	utils/make-monitor-progress.py \
	utils/make-percolation.py \
	utils/make-networks.py \
	utils/make-compare-time-series.py \
	utils/make-compare-syn-sto.py \
	utils/profile-simulation.py


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

# Requirements for running the library and for the development venv needed to build it
VENV = venv3
REQUIREMENTS = requirements.txt
DEV_REQUIREMENTS = dev-requirements.txt

# Requirements for setup.py
# Note we elide dependencies to do with backporting the type-checking
PY_REQUIREMENTS = $(shell $(SED) -e '/^typing_extensions/d' -e 's/^\(.*\)/"\1",/g' $(REQUIREMENTS) | $(TR) '\n' ' ')

# Constructed commands
RUN_SERVER = PYTHONPATH=. $(JUPYTER) notebook
RUN_TESTS = $(TOX)
RUN_COVERAGE = $(COVERAGE) erase && $(COVERAGE) run -a setup.py test && $(COVERAGE) report -m --include '$(PACKAGENAME)*'
RUN_SETUP = $(PYTHON) setup.py


# ----- Top-level targets -----

# Default prints a help message
help:
	@make usage

# Run the notebook server
live: env
	$(ACTIVATE)  && $(RUN_SERVER)

# Run tests
test: env Makefile
	$(ACTIVATE) && $(RUN_TESTS)

# Run coverage checks over the test suite
coverage: env
	$(ACTIVATE) && $(RUN_COVERAGE)

# Run lint checks
lint: env
	$(ACTIVATE) && $(FLAKE8) $(SOURCES_CODE) --count --statistics --ignore=E501,E303,E301,E302,E261,E741,E265,E402

# Build a development venv from the requirements in the repo
.PHONY: env
env: $(VENV)

$(VENV):
	$(VIRTUALENV) $(VENV)
	$(ACTIVATE) && $(PIP) install -U pip wheel && $(PIP) install -r $(REQUIREMENTS)
	$(ACTIVATE) && $(MYPY) --install-types --non-interactive

# Build the diagrams for the documentation
diagrams:
	$(ACTIVATE) && PYTHONPATH=$(ROOT) $(PYTHON) utils/make-monitor-progress.py
	$(ACTIVATE) && PYTHONPATH=$(ROOT) $(PYTHON) utils/make-powerlaw-cutoff.py
	$(ACTIVATE) && PYTHONPATH=$(ROOT) $(PYTHON) utils/make-percolation.py
	$(ACTIVATE) && PYTHONPATH=$(ROOT) $(PYTHON) utils/make-compare-time-series.py
	$(ACTIVATE) && PYTHONPATH=$(ROOT) $(PYTHON) utils/make-compare-syn-sto.py

# Clean up everything, including the computational environment (which is expensive to rebuild)
reallyclean:
	$(RM) $(VENV)


# ----- Usage -----

define HELP_MESSAGE
Available targets:
   make test         run the test suite
   make env          create a development virtual environment
   make coverage     run coverage checks of the test suite
   make lint         run lint style checks
   make diagrams     create the diagrams for the API documentation
   make reallyclean  clean up the virtualenv as well

endef
export HELP_MESSAGE

usage:
	@echo "$$HELP_MESSAGE"
