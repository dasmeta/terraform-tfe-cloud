# Why
We needed way to run terraform modules using yaml files as it is much simpler.

## How
We have decided to use terraform cloud to execute terraform code.
We have decided that it is right to have workspace per module as we do not want giant module dependencies.
We have created terraform module that can parse yaml files, create workspaces and make TFC to execute code / modules.

Current implementation si very basic:
1. accepts module source/version, variables, dependencies and uses variables from other workspaces if allowed.

## Caviats
Modules does generate terraform code from yamls and sets up workspaces but since the code is not yet in git repository first run will fail.
After another apply is run from local and resulting code is comitted to git repo it will pick up code and executel.

## How to use
0. Create workspace in terrqform cloud
1. Create folder and place yaml files in the folder
2. Yaml files point to modules and provide variables like done in tests/basic/example-infra folder
3. Supply variables to the module like done in basic tests
4. Terraform apply will create workspaces and code (by default in _terraform folder).
5. Commit the code and TFC will pick up and apply changes as requested.

## ToDo
1. Modify module to not create workspace immidiately but only when code is comitted (this might create issue with race condition, workspaces can be creared but TFC mighhave had already tried to execute code).
2. There is an issue with some providers (more details in jira).
3. Currently some generated code is escaped which is wrong.
4. Get this repo be managed by terraform module manager terraform repo.
