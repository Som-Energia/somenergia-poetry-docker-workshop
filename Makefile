.DEFAULT_GOAL := help
.PHONY: help

include .env
export

# Document all targets with ## comments, these comments will be used in `make help`. Don't use `-` as these will be ignored in `make help`.

help: ## Print this help
	@grep -E '^[0-9a-zA-Z_\-\.]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------- #
#                                mkdocs commands                               #
# ---------------------------------------------------------------------------- #

mkdocs.serve: ## serve the mkdocs documentation
	@docker compose -f docker-compose.mkdocs.yml up

mkdocs.build-image: ## build the mkdocs image
	@docker compose -f docker-compose.mkdocs.yml build mkdocs

mkdocs.push-image: ## push the mkdocs image with tag: latest
	@docker compose -f docker-compose.mkdocs.yml push mkdocs

mkdocs.build-docs: ## build the mkdocs documentation
	@docker compose -f docker-compose.mkdocs.yml run --rm mkdocs build

mkdocs.logs: ## show the logs of the mkdocs container
	@docker compose -f docker-compose.mkdocs.yml logs -ft mkdocs
