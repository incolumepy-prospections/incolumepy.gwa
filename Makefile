.DEFAULT_GOAL := help
DIRECTORIES = $$(find -wholename ./src -o -wholename ./incolumepy -o -wholename ./tests)
PKGNAME := "incolumepy.gwa"

.PHOMY: setup
setup: ## setup environment python with poetry
	@poetry env use 3.10
	@git config core.hooksPath .git-hooks
	@poetry shell
	@poetry install

#.PHOMY: install
#install:  ## Install this package using poetry
#install: setup
#	@poetry add $(PKGNAME)

.PHONY: help
help:  ## Show this instructions
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: check-mypy
check-mypy: ## mypy checking
	@echo "mypy checking .."
	@poetry run mypy $(DIRECTORIES)

.PHONY: check-flake8
check-flake8: ## flake8 checking
	@echo "flake8 checking .."
	@poetry run flake8 --config pyproject.toml $(DIRECTORIES)

.PHONY: check-isort
check-isort:  ## check isort
	@echo "isort checking .."
	@poetry run isort --check --atomic --py all $(DIRECTORIES)

.PHONY: check-pylint
check-pylint: ## pylint checking
	@echo "pylint checking .."
	@poetry run pylint $(DIRECTORIES)

.PHONY: check-black
check-black: ## black checking
	@echo "Black checking .."
	@poetry run black --check $(DIRECTORIES)

.PHONY: check-docstyle
check-docstyle: ## docstring checking
	@echo "docstyle checking .."
	@poetry run pydocstyle $(DIRECTORIES)

.PHONY: isort
isort:  ## isort apply
	@poetry run isort --atomic --py all $(DIRECTORIES) && git commit -m "style: Applied Code style isort format automaticly at `date +"%F %T"`" . || echo
	@echo ">>>  Applied code style isort format automaticly  <<<"

.PHONY: black
black:  ##Apply code style black format
	@poetry run black $(DIRECTORIES) && git commit -m "style: Applied Code style Black format automaticly at `date +"%F %T"`" . || echo
	@echo ">>>  Applied code style Black format automaticly  <<<"

.PHONY: lint
lint:  ## Run all linters (check-isort, check-black, flake8, pylint, mypy, docstyle)
lint: check-mypy check-pylint check-flake8 check-docstyle check-isort check-black

.PHONY: test
test: ## Run all tests avaliable and generate html coverage
test: lint
	@poetry run pytest  tests/ -vv --cov=$$(PKGNAME) --cov-report='html'

.PHONY: clean
clean: ## Shallow clean into environment (.pyc, .cache, .egg, .log, et all)
	@echo -n "Starting cleanning environment .."
	@find ./ -name '*.pyc' -exec rm -f {} \;
	@find ./ -name '*~' -exec rm -f {} \;
	@find ./ -name 'Thumbs.db' -exec rm -f {} \;
	@find ./ -name '*.log' -exec rm -f {} \;
	@find ./ -name '*.log.*' -exec rm -f {} \;
	@find ./ -name ".cache" -exec rm -fr {} \;
	@find ./ -name "*.egg-info" -exec rm -rf {} \;
	@find ./ -name "*.coverage" -exec rm -rf {} \;
	@rm -rf docs/_build
	@echo " finished!"

.PHONY: clean-all
clean-all: clean   ## Deep cleanning into environment (dist, build, htmlcov, .tox, *_cache, et all)
	@echo "Starting Deep cleanning .."
	@rm -rf dist
	@rm -rf build
	@rm -rf htmlcov
	@rm -rf .tox
	@find ./ -name "*_cache" -exec rm -rf {} 2> /dev/null \;
	@#fuser -k 8000/tcp &> /dev/null
	@poetry env list|awk '{print $$1}'|while read a; do poetry env remove $${a} && echo "$${a} removed."|| echo "$${a} not removed."; done
	@echo "Deep cleaning finished!"

.PHONY: premajor
premajor: test format  ## Generate new premajor commit version default semver
	@v=$$(poetry version premajor); poetry run pytest tests/ && git commit -m "$$v" pyproject.toml $$(find -name version.txt)  #sem tag

.PHONY: premajor-force
premajor-force: test format  ## Generate new premajor commit version default semver and your tag forcing merge into main branch
	@msg=$$(poetry version premajor); poetry run pytest -m fasttest tests/; \
git commit -m "$$msg" pyproject.toml $$(find -name version.txt) \
&& git tag -f $$(poetry version -s) -m "$$msg"; \
git checkout main; git merge --no-ff dev -m "$$msg" \
&& git tag -f $$(poetry version -s) -m "$$msg" \
&& git checkout dev    #com tag

.PHONY: preminor
preminor: test format  ## Generate new preminor commit version default semver
	@v=$$(poetry version preminor); poetry run pytest -m fasttest tests/ && git commit -m "$$v" pyproject.toml $$(find -name version.txt)  #sem tag

.PHONY: preminor-force
preminor-force: test format  ## Generate new preminor commit version default semver and your tag forcing merge into main branch
	@msg=$$(poetry version preminor); poetry run pytest -m fasttest tests/; \
git commit -m "$$msg" pyproject.toml $$(find -name version.txt) \
&& git tag -f $$(poetry version -s) -m "$$msg"; \
git checkout main; git merge --no-ff dev -m "$$msg" \
&& git tag -f $$(poetry version -s) -m "$$msg" \
&& git checkout dev    #com tag

.PHONY: prerelease
prerelease: test format   ## Generate new prerelease commit version default semver
	@v=$$(poetry version prerelease); poetry run pytest -m fasttest tests/ && git commit -m "$$v" pyproject.toml $$(find -name version.txt)  #sem tag

.PHONY: prerelease-force
prerelease-force: test format   ## Generate new prerelease commit version default semver and your tag forcing merge into main branch
	@msg=$$(poetry version prerelease); poetry run pytest -m fasttest tests/; \
git commit -m "$$msg" pyproject.toml $$(find -name version.txt) \
&& git tag -f $$(poetry version -s) -m "$$msg"; \
git checkout main; git merge --no-ff dev -m "$$msg" \
&& git tag -f $$(poetry version -s) -m "$$msg" \
&& git checkout dev    #com tag

.PHONY: release
release: test ## Generate new release commit with version/tag default semver
	@msg=$$(poetry version patch); poetry run pytest -m fasttest tests/; \
git commit -m "$$msg" pyproject.toml $$(find -name version.txt) \
&& git tag -f $$(poetry version -s) -m "$$msg"; \
git checkout main; git merge --no-ff dev -m "$$msg" \
&& git tag -f $$(poetry version -s) -m "$$msg" \
&& git checkout dev    #com tag

.PHONY: publish-testing
publish-testing: ## Publish on test.pypi.org
	@poetry publish -r testpypi --build

.PHONY: format
format: ## Formate project code with code style (isort, black)
format: clean isort black

.PHONY: tox
tox: ## Run tox completly
	@poetry run tox
