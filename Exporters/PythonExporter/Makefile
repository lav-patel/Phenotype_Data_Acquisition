venv_clear:
	# "deleting python virtual env"
	rm -rf venv

venv: venv_clear
	# "creating python virtual env"
	python -m venv venv
	. ./venv/bin/activate && \
	pip install --upgrade pip  && \
	pip install -r requirements.txt  && \
	pip install -r requirements_dev.txt  && \
	pip freeze >  requirements_pip_freeze.txt  && \
	which pip && which python && python --version

autopep:
	# "converting python code to PEP formate"
	autopep8 .

autoblack:
	# "converting python code to BLACK formate"
	black .

# Need to install flake8-docstrings package to use this
# lint-doctstring:
# 	flake8 --docstring-convention numpy . #

lint-import:
	# this does import sorting for you, where flak8-isort will check it for you
	isort .

lint: lint-import
	# "linting python code"
	flake8

cc :
	# "code compaxity of paython code"
	radon cc . -s

security:
	# "check possible security issuses, also runs with flake8"
	bandit -r .

nosetest-and-doctest:
	# "nosetest-and-doctest of paython code"
	nosetests --with-doctest

static:
	# "static check of paython code"
	mypy --strict .

check: autopep autoblack lint cc nosetest-and-doctest

run:
	. venv/bin/activate && \
	which python && \
	mkdir -p ~/n3c/output/DATAFILES && \
	python db_exp.py --config config.ini --database oracle  \
	--phenotype  ../../PhenotypeScripts/N3C_phenotype_pcornet_oracle.sql \
	--extract ../../ExtractScripts/N3C_extract_pcornet6_oracle.sql \
	--output_dir ~/n3c/output  --zip \
	--debug
	#--sftp

clean: venv_clear
