# ML_HW_4

## Setup environment

1. Создайте .env файл в корневой директории проекта (в репозитории представлен .env_test, который вы можете взять в качестве основы);
2. Затем поднимите minio в контейнере с помощью команды:
   ```
   make setup
   ```
3. Затем создадите бакет и загрузите тестовый файл (weather_forecast_data.csv) в minio с помощью команды:
   ```
   make upload-data
   ```
4. С помощью данной команды вы обработаете тестовый файл и положите его новую обработанную версию (weather_forecast_data_processed.csv) в minio:
   ```
   make process-data
   ```
   (Вы можете изменить файл с данными в data/raw и затем изменить название файла в Makefile)
5. Затем сбилдите Dockerfile
   ```
   make build-trainer-image
   ```
6. Переносим обработанный датасет в data/process 
   ```
   make download processed-data
   ```
7. Затем запускаем обучение модели на разных параметрах 
   ```
   make run-experiments
   ```
   (в данном примере взята обычная LogisticRegression)
   Мои эксперименты: https://wandb.ai/savelij-tatarinov-urfu/ml_experiments/workspace

8. В конце загружаем все эксперименты в s3
   ```
   make upload-results
   ```
   
<a target="_blank" href="https://cookiecutter-data-science.drivendata.org/">
    <img src="https://img.shields.io/badge/CCDS-Project%20template-328F97?logo=cookiecutter" />
</a>

hw3

## Project Organization

```
├── LICENSE            <- Open-source license if one is chosen
├── Makefile           <- Makefile with convenience commands like `make data` or `make train`
├── README.md          <- The top-level README for developers using this project.
├── data
│   ├── external       <- Data from third party sources.
│   ├── interim        <- Intermediate data that has been transformed.
│   ├── processed      <- The final, canonical data sets for modeling.
│   └── raw            <- The original, immutable data dump.
│
├── docs               <- A default mkdocs project; see www.mkdocs.org for details
│
├── models             <- Trained and serialized models, model predictions, or model summaries
│
├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
│                         the creator's initials, and a short `-` delimited description, e.g.
│                         `1.0-jqp-initial-data-exploration`.
│
├── pyproject.toml     <- Project configuration file with package metadata for 
│                         ml_hw_1 and configuration for tools like black
│
├── references         <- Data dictionaries, manuals, and all other explanatory materials.
│
├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
│   └── figures        <- Generated graphics and figures to be used in reporting
│
├── requirements.txt   <- The requirements file for reproducing the analysis environment, e.g.
│                         generated with `pip freeze > requirements.txt`
│
├── setup.cfg          <- Configuration file for flake8
│
└── ml_hw_1   <- Source code for use in this project.
    │
    ├── __init__.py             <- Makes ml_hw_1 a Python module
    │
    ├── config.py               <- Store useful variables and configuration
    │
    ├── dataset.py              <- Scripts to download or generate data
    │
    ├── features.py             <- Code to create features for modeling
    │
    ├── modeling                
    │   ├── __init__.py 
    │   ├── predict.py          <- Code to run model inference with trained models          
    │   └── train.py            <- Code to train models
    │
    └── plots.py                <- Code to create visualizations
```

--------

