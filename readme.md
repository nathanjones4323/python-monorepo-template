<h1 align="center">Python Monorepo Template</h1>


<p align="center"> Projects, Services, and Tooling that lives in a Monorepo </p>
    <br> 
</p>

---

## 🧐 About

This is a template for a Python monorepo that uses Docker, Poetry, and Black/iSort for formatting.

We are using a monorepo structure for our projects, where each project is it's own folder under the `./apps` directory, and each package is it's own folder under the `./libs` directory.

**Repository Structure**

```bash
.
├── README.md
├── apps
│   ├── app-1 # Project 1
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── app_1 # Project 1's source code
│   │   │   ├── __init__.py
│   │   │   ├── ...
│   │   │   ├── main.py
│   │   ├── poetry.lock
│   │   ├── pyproject.toml # Project 1's dependencies
│   │   └── tests # Unit tests
│   ├── app-2 # Project 2
│   │   ├── Dockerfile
│   │   ├── README.md
│   │   ├── app_2 # Project 2's source code
│   │   │   ├── __init__.py
│   │   │   ├── ...
│   │   │   ├── main.py
│   │   ├── poetry.lock
│   │   ├── pyproject.toml # Project 2's dependencies
│   │   └── tests # Unit tests
│   └── app-3 # Project 3
...
├── create_package.sh
├── create_project.sh
├── docker-compose.yml
└── libs # Internal packages go in the libs folder
    ├── package-1 # Package 1's source code
    │   ├── namespace # Optional namespace folder (used for internal packages and to make imports like `from namespace.package_1 import function` possible)
    │   │   └── package_1
    │   │       ├── __init__.py
    │   │       ├── module_1.py
    │   │       └── module_2.py
    │   ├── poetry.lock
    │   ├── pyproject.toml
    │   └── tests
    ├── package-2 # Package 2's source code. Create package-2 without the namespace folder
    │   ├── package_2
    │   │   ├── __init__.py
    │   │   ├── module_1.py
    │   │   └── module_2.py
    │   ├── poetry.lock
    │   ├── pyproject.toml
    │   └── tests
...
```


## 🛠️ Setting Up Your Environment

You need to install the following to get your (opinionated) development environment set up:

- Docker -- [Installation Instructions](https://www.docker.com/products/docker-desktop/)
- Python 3.11 -- [Installation Instructions](https://www.python.org/downloads/)
- `pipx` -- [Installation Instructions](https://pipxproject.github.io/pipx/installation/)
- Poetry -- [Installation Instructions](https://python-poetry.org/docs/#installation)
- Black VSCode Extension -- [Installation Instructions](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)

**Install Docker**

Docker -- [Installation Instructions](https://www.docker.com/products/docker-desktop/)

**Install Python 3.11**

Python 3.11 -- [Installation Instructions](https://www.python.org/downloads/)

**Make sure you have xcode installed and updated**

```zsh
xcode-select --install
```

**Install pipx**

```zsh
brew install pipx
pipx ensurepath
```

**Install [poetry](https://python-poetry.org/docs/#installation)**

```zsh
pipx install poetry
```

You can check that poetry is installed correctly by running `poetry --version`

**Add [auto-completion for poetry with Oh My Zsh](https://python-poetry.org/docs/#oh-my-zsh)**

```zsh
mkdir $ZSH_CUSTOM/plugins/poetry
poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
```

You must then add poetry to your plugins array in `~/.zshrc`:

```zsh
plugins(
	poetry
	...
	)
```

**Configure Poetry to create virtual environments in the project directory**

```zsh
poetry config virtualenvs.in-project true
```

## 🏛️ Project Structure

Each project is a folder in the root directory of the repository. 

Each project folder should contain the following: 

1. A subfolder with the same name as the project folder but with underscores instead of dashes (e.g. `project-name` folder should have a `project_name` subfolder that contains the project's source code)
1. A `README.md` with documentation for the project
1. A `Dockerfile` for building the project's container
1. A `.dockerignore` file for ignoring files when building the project's container
1. A `pyproject.toml` file for managing the project's dependencies. (Created by `./create_project.sh` and updated by `poetry add`)
1. A `poetry.lock` file for managing the project's dependencies. (Created by `./create_project.sh` and updated by `poetry add`)
1. A `/tests` folder for unit tests
1. A `.gitignore` file
1. An `.env` file for defining environment variables for the project (Created by `./create_project.sh` and manually updated)

All of these files and folders are created automatically when you run `./create_project.sh` from the root of the repository (/data).

## 📦 Creating a New Package

We store all of our packages inside of the `./libs` folder. To create a new package, you can use the helper shell script `create_package.sh`:


(First make sure you have the correct permissions to run the script)
```zsh
+chmod +x create_package.sh
```

Run the script and follow the prompts to create a new package:

```zsh
./create_package.sh
```

## 📐 Creating a New Project

We store all of our projects inside of the `./apps` folder. To create a new project, you can use the helper shell script `create_project.sh`:


(First make sure you have the correct permissions to run the script)

```zsh
chmod +x create_project.sh
```


Run the script and follow the prompts to create a new project:

```zsh
./create_project.sh
```

**Installing internal `namespace` packages inside of your project**

From the root of your project, run this command to install an internal `namespace` namespace package:

```zsh
poetry add --editable ../../libs/{{package_name}}
```

*The `--editable` flag means this package will be installed in editable mode. This means that any changes you make to the package will be reflected in your project immediately without having to reinstall the package.*

Here is an example of installing the namespace-db package
  
```zsh
poetry add --editable ../../libs/db
```

You should now be able to import modules and functions from the `namespace-db` package inside your project like so:

```python
from namespace.db.utils import init_read_connection
```

You can follow the same steps for any other internal `namespace` packages you want to install, given there is an existing directory for the package in the `libs` folder.

**Adding Dependencies to a Project or Package**

You can add depdencies with poetry using the `poetry add` command (similar to `pip install`).

```zsh
poetry add {{package_1}} {{package_2}} ... {{package_n}}
```

This will add the packages to the `pyproject.toml` file (and create `pyproject.toml` if it doesn't exist). 

This command will also update or create the `poetry.lock` file. The `poetry.lock` file is used to lock the versions of the packages you are using. This ensures we avoid dependency conflicts/hell.

`pyproject.toml` replaces the `requirements.txt` file.

**[Activating the Project's Virtual Environment](https://python-poetry.org/docs/basic-usage/#activating-the-virtual-environment)**

From your project's directory, run the following command to activate the project's virtual environment:

```zsh
poetry shell
```

In VSCode, make sure you have the project's virtual environment selected as your Python interpreter.

*This is useful when you want to run your project's code interactively inside of VSCode.*

To deactivate the virtual environment and exit this new shell type `exit`. To deactivate the virtual environment without leaving the shell use `deactivate`.

## 🏗️ Installing Dependencies From an Existing Project

*This is useful when you did not create the project and want to run it interactively inside of VSCode on your local machine.*

Activate the project's virtual environment

```zsh
poetry shell
```

Install the dependencies from the `poetry.lock` file

```zsh
poetry install
```

This will install the dependencies listed in your `poetry.lock` file if it exists. If it doesn't exist, it will install the dependencies listed in your `pyproject.toml` file and create a `poetry.lock` file.

## ⬛ Install and Set Black/iSort as the Default Formatters in VSCode

1. Install the Black VSCode extension -- [Installation Instructions](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)
1. Install the iSort VSCode extension -- [Installation Instructions](https://marketplace.visualstudio.com/items?itemName=ms-python.isort)
1. Open the command palette `cmd + shift + p` and run the `Preferences: Open Settings (JSON)` command.
1. Add the following to your `settings.json` file:

```json
"[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "analysis.autoImportCompletions": true
  },
  "isort.args":["--profile", "black"],
```

## 🏃 Running Services Locally

**Using VSCode**

Open VSCode in the root of the monorepo. Open the command palette `cmd + shift + p` and select `Docker Compose: Up - Selected Services`. Select the service you want to run.

**Using the Terminal**

From the root of the monorepo, run the following command:

```zsh
docker compose -f "docker-compose.yml" up -d --build {service_name}
```

Replacing `{service_name}` with the name of the service you want to run.

## 🚀 Deploying to Production <a name = "deployment"></a>

TODO

## 🗒️ TODO <a name = "todo"></a>

- [ ] Set up GH Action runners for linting
- [ ] Set up GH Action runners for testing
- [ ] Add `create_project.sh` and `create_package.sh` to the `scripts` section of the `pyproject.toml` file


### Note on Poetry and Monorepo set up with autoamted packages/project structure creation

Poetry can run any script `.py`, `.sh`, or even a method `def main()` in a `.py` file. Once you have a script that you want to run, you can add it to the `pyproject.toml` file under the `scripts` section.

```toml
[tool.poetry.scripts]
script_name = "create_package.sh" # This is the format for running a shell script
```


```toml
[tool.poetry.scripts]
script_name = "package_name.module_name:function_name" # This is the format for running a function in a module
```