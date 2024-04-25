#!/bin/zsh

# Define color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;96m"
YELLOW="\033[0;33m"
NC="\033[0m" # No Color

# Prompt for the app folder name with default value
echo -en "${YELLOW}Enter the project folder name (default: my-new-project): ${NC}"
read project_folder_name
project_folder_name=${project_folder_name:-my-new-project}

# Replace '-' with '_' for project_name and convert to lowercase
project_name=${project_folder_name//-/_}
project_name=${project_name:l}

# Check if the app directory already exists
project_directory="./apps/$project_folder_name"
if [ -d "$project_directory" ]; then
    echo -e "${RED}Could not create project ${project_name}.${NC}"
    echo -e "${RED}The project directory ${project_directory} already exists, exiting.${NC}"
    exit 1
fi

# Always run this command
poetry new "apps/$project_folder_name"

# Let the user know that we are going to install black and isort
echo -e "${BLUE}Installing black and isort for standardized code formatting${NC}"

# Let the user know that we are going to install pytest
echo -e "${BLUE}Installing pytest for testing${NC}"

echo # move to a new line

# Change directory to the apps folder
cd "./apps/$project_folder_name"

# Add .env file to the project
touch .env

# Add black formatter, isort, and pytest to the project dependencies
poetry add black isort pytest

# Install the project (need to run from the `apps/project_folder_name` directory)
poetry install


echo -e "${GREEN}Poetry install completed.${NC}"

# Update README.md file
cat << EOF > README.md
<h1 align="center">${project_name}</h1>

<p align="center"> Description of ${project_name}
    <br> 
</p>

## 📝 Table of Contents

* [📝 Table of Contents](#-table-of-contents-)
* [🧐 About](#-about-)
* [🏃 Running the App Locally](#-running-locally-)
* [🚀 Deployment ](#-deployment-)
* [🗒️ TODO](#-todo-)


## 🧐 About <a name = "about"></a>

TODO

## 🏃 Running the App Locally <a name = "running-locally"></a>

TODO

## 🚀 Deployment <a name = "deployment"></a>

TODO

## 🗒️ TODO <a name = "todo"></a>

### In Progress

TODO

### Future

TODO

### Completed

TODO

#### Notes

TODO
EOF


# Create Dockerfile
cat << EOF > Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.11

# Install Poetry and pin the version
RUN pip install poetry==1.7.1

# Copy the application and local packages into the container
# COPY ./apps/conversational-ai . #### CHANGE THIS TO THE NAME OF THE PROJECT FOLDER
# COPY ./libs/api ./libs/api #### CHANGE THIS TO THE NAME OF THE PACKAGE YOU WANT TO COPY
# COPY ./libs/intercom ./libs/intercom #### CHANGE THIS TO THE NAME OF THE PACKAGE YOU WANT TO COPY

### Configure Poetry and install dependencies
# Set the environment variable to disable virtualenv creation
ENV POETRY_VIRTUALENVS_CREATE=false
ENV POETRY_CACHE_DIR=/tmp/poetry_cache

 # Configure Poetry
RUN poetry config virtualenvs.in-project false

# Install dependencies and remove the cache (don't need in docker image and this makes the image smaller)
RUN poetry install --no-interaction --no-ansi && rm -rf \$POETRY_CACHE_DIR
EOF

# Create .dockerignore file
cat << EOF > .dockerignore
__pycache__
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
pip-log.txt
pip-delete-this-directory.txt
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.log
.git
.gitignore
.mypy_cache
.pytest_cache
.hypothesis
.idea
EOF

# Create .gitignore file
cat << EOF > .gitignore
# Custom
*.log
./.vscode

# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Mac OS
.DS_Store

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.
#Pipfile.lock

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
#poetry.lock

# pdm
#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
#pdm.lock
#   pdm stores project-wide configurations in .pdm.toml, but it is recommended to not include it
#   in version control.
#   https://pdm.fming.dev/#use-with-ide
.pdm.toml

# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# PyCharm
#  JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#  be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
#  and can be added to the global gitignore or merged into this file.  For a more nuclear
#  option (not recommended) you can uncomment the following to ignore the entire idea folder.
#.idea/
EOF
echo -e "${GREEN}Created the following files: [Dockerfile, .dockerignore, .gitignore]${NC}"

# Change directory to the root of the project
cd && cd "./python-monorepo-template"

# Add the new service to the docker-compose.yml file
docker_compose_file="./docker-compose.yml" # Adjust the path as necessary
new_service_config="
  $project_name:
    build:
      context: .
      dockerfile: ./apps/$project_folder_name/Dockerfile
    command: python $project_name/main.py  # Override the default command if needed
    env_file:
      - ./apps/$project_folder_name/.env
"

# Check if docker-compose.yml file exists
if [ -f "$docker_compose_file" ]; then
    echo -e "${BLUE}Adding the new service to docker-compose.yml${NC}"
    # New line
    echo >> "$docker_compose_file"
    # Add the new service to the docker-compose.yml file
    echo "$new_service_config" >> "$docker_compose_file"
    # Success message
    echo -e "${GREEN}The service $project_name has been added to monorepo docker-compose.yml file ($(pwd)/docker-compose.yml)${NC}"
else
    # Error message
    echo -e "${RED}docker-compose.yml file not found at $docker_compose_file. Please check the path and try again.${NC}"
fi