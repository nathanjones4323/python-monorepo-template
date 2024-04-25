#!/bin/zsh

# Define color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;96m"
YELLOW="\033[0;33m"
NC="\033[0m" # No Color

# Prompt for the package folder name with default value
echo -en "${YELLOW}Enter the package folder name (default: my-new-package): ${NC}"
read package_folder_name
package_folder_name=${package_folder_name:-my-new-package}

# Replace '-' with '_' for package_name and convert to lowercase
package_name=${package_folder_name//-/_}
package_name=${package_name:l}

# Check if the package directory already exists
package_directory="./libs/$package_folder_name"
if [ -d "$package_directory" ]; then
    echo -e "${RED}Could not create package ${package_name}.${NC}"
    echo -e "${RED}The package directory ${package_directory} already exists, exiting.${NC}"
    exit 1
fi

# Prompt for the internal package option with a default value
echo -en "${YELLOW}Is this an internal package? ( [Y]es / [N]o, default: Y ): ${NC}"
internal_package="y"
read -k1 user_input
echo # move to a new line
if [[ "$user_input" =~ [Nn] ]]; then
    internal_package="n"
    echo -e "${BLUE}Creating the "${package_name}" package as a regular package "${package_name}"${NC}"
else
    echo -e "${BLUE}Creating the "${package_name}" package as an internal package under the 'namespace' namespace${NC}"
fi

# Convert 'y' to true and anything else to false
if [ "$internal_package" = "y" ]; then
    internal_package=true
else
    internal_package=false
fi

# Always run this command
poetry new "libs/$package_folder_name"

# Run these commands if internal_package is true
if [ "$internal_package" = true ]; then
    mkdir -p "./libs/$package_folder_name/namespace"
    mv "./libs/$package_folder_name/$package_name" "./libs/$package_folder_name/namespace/"
    
    # Modify the pyproject.toml file
    toml_path="./libs/$package_folder_name/pyproject.toml"
    awk -v package_path="namespace/$package_name" '/^readme = "README.md"/{print;print "packages = [\n    { include = \""package_path"\" }\n]\n";next}1' $toml_path > temp.toml && mv temp.toml $toml_path

    echo -e "${GREEN}Internal package setup completed.${NC}"
else
    echo -e "${BLUE}Skipped internal package setup.${NC}"
fi

# Let the user know that we are going to install black and isort
echo -e "${BLUE}Installing black and isort for standardized code formatting${NC}"

# Let the user know that we are going to install pytest
echo -e "${BLUE}Installing pytest for testing${NC}"

echo # move to a new line

# Change directory to the package folder
cd "./libs/$package_folder_name"

# Add black formatter and isort to the package dependencies
poetry add black isort pytest

# Install the package (need to run from the `libs/package_folder_name` directory)
poetry install


echo -e "${GREEN}Poetry install completed.${NC}"