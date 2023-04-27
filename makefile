IMAGE_NAME := $(shell cat Jenkinsfile | grep '\[ name: ' | sed "s/.\+['\"]\(.\+\)['\"].\+/\1/")

default:
	@echo "Usage:"
	@echo "  make build"
	@echo
	@echo "    Builds the docker image \"$(IMAGE_NAME):latest\" for local use."
	@echo
	@echo "  make run"
	@echo
	@echo "    Runs an already built docker image ($(IMAGE_NAME):latest)."
	@echo
	@echo "  make shell"
	@echo
	@echo "    Opens a bash session in a container built from $(IMAGE_NAME):latest."

build:
	@docker build -t veupathdb/$(IMAGE_NAME):latest .

run:
	@docker run -it --rm --env-file=.env -p 8080:8080 veupathdb/$(IMAGE_NAME):latest

shell:
	@docker run -it --rm --env-file=.env -p 8080:8080 veupathdb/$(IMAGE_NAME):latest bash
