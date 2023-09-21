OUT_DIR=output
IN_DIR=.
STYLE=chmduquesne
MAKEFLAGS += --silent
THEME_URL = https://github.com/carlosonunez/hugo-devresume-theme
THEME_VERSION = 2023.09.21
DNS_ZONE ?= resume.carlosnunez.me
DOCKER_COMPOSE = docker-compose --log-level ERROR
PERCENT := %

export RESUME_FILE
export DNS_ZONE

.PHONY: clean test build pdf \
				.fetch-resume .generate-site-config .ensure-resume-type .current-version

clean:
	rm -rf $(PWD)/output/*

build: .ensure-resume-type .fetch-resume .generate-config-toml
build:
	export RESUME_FILE; \
	output_dir=$(PWD)/output/$$RESUME_FILE; \
	test -d "$$(dirname "$$output_dir")" || mkdir -p "$$(dirname "$$output_dir")"; \
	test -d "$(PWD)/pdf" || mkdir -p "$(PWD)/pdf"; \
	$(DOCKER_COMPOSE) run --rm generate-resume

test: .ensure-resume-type .fetch-resume .generate-config-toml
test:
	$(DOCKER_COMPOSE) down; \
	$(DOCKER_COMPOSE) up --wait -d see-resume && \
		>&2 echo "INFO: Resume is now available at http://localhost:8080"

.ensure-resume-type:
	if test -z "$$RESUME_FILE" ; \
	then \
		>&2 echo "ERROR: Please define the type of resume to make, like 'consulting' or 'eng'"; \
		exit 1; \
	fi; \

.fetch-resume:
	test -d "$(PWD)/theme" && exit 0; \
	test -d "$(PWD)/theme/resources/_gen" && rm -rf "$(PWD)/theme/resources/_gen"; \
	git clone --branch "$(THEME_VERSION)" "$(THEME_URL)" "$(PWD)/theme"

.generate-config-toml:
	export VERSION=$$($(MAKE) .current-version); \
	$(DOCKER_COMPOSE) run --rm generate-resume-config > $(PWD)/config.toml

.current-version:
	echo $$(git log -1 --format='$(PERCENT)h' $(PWD)/resumes);

