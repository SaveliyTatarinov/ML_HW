#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = ML_HW
PYTHON_VERSION = 3.10
PYTHON_INTERPRETER = python
DOWNLOAD_SCRIPT=bucket_s3/download_s3.py
DOWNLOAD_PATH=data/processed/weather_forecast_data_processed.csv

#################################################################################
# COMMANDS                                                                      #
#################################################################################
setup:
	poetry install
	docker-compose up -d

build-trainer-image:
	docker build -f Dockerfile -t trainer:latest .

upload-data:
	poetry run python bucket_s3/create_bucket.py ; \
	poetry run python bucket_s3/upload_to_s3.py --bucket data-bucket --file_path data/raw/weather_forecast_data.csv

process-data:
	poetry run python ml_hw_4/modeling/process_data.py --bucket data-bucket --input_path weather_forecast_data.csv --output_path weather_forecast_data_processed.csv

download processed-data:
	poetry run python $(DOWNLOAD_SCRIPT) --bucket data-bucket --object_name weather_forecast_data_processed.csv --download_path $(DOWNLOAD_PATH)

run-experiments:
	bash ml_hw_4/modeling/train_exp.sh models/model_config.json experiment_name

upload-results:
	poetry run python ml_hw_4/modeling/upload_results.py --bucket data-bucket --directory output


## Lint using flake8 and black (use `make format` to do formatting)
.PHONY: lint
lint:
	flake8 ml_hw_1
	isort --check --diff --profile black ml_hw_1
	black --check --config pyproject.toml ml_hw_1

## Format source code with black
.PHONY: format
format:
	black --config pyproject.toml ml_hw_1


## Download Data from storage system
.PHONY: sync_data_down
sync_data_down:
	aws s3 sync s3://s3://my-bucket/data/ \
		data/ 
	

## Upload Data to storage system
.PHONY: sync_data_up
sync_data_up:
	aws s3 sync data/ \
		s3://s3://my-bucket/data 
	



## Set up python interpreter environment
.PHONY: create_environment
create_environment:
	pipenv --python $(PYTHON_VERSION)
	@echo ">>> New pipenv created. Activate with:\npipenv shell"
	



#################################################################################
# PROJECT RULES                                                                 #
#################################################################################


## Make Dataset
.PHONY: data
data: requirements
	$(PYTHON_INTERPRETER) ml_hw_1/dataset.py


#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys; \
lines = '\n'.join([line for line in sys.stdin]); \
matches = re.findall(r'\n## (.*)\n[\s\S]+?\n([a-zA-Z_-]+):', lines); \
print('Available rules:\n'); \
print('\n'.join(['{:25}{}'.format(*reversed(match)) for match in matches]))
endef
export PRINT_HELP_PYSCRIPT

help:
	@$(PYTHON_INTERPRETER) -c "${PRINT_HELP_PYSCRIPT}" < $(MAKEFILE_LIST)
