OUT_DIR=output
IN_DIR=.
STYLE=chmduquesne
MAKEFLAGS += --silent
THEME_URL = https://github.com/carlosonunez/hugo-devresume-theme
THEME_VERSION = 2023.09.22
DNS_ZONE ?= resume.carlosnunez.me
DOCKER_COMPOSE = docker-compose --log-level ERROR
PERCENT := %

export PERSONA
export DNS_ZONE

.PHONY: clean test build pdf \
				encrypt-wip decrypt-wip \
				encrypt-specific decrypt-specific \
				.fetch-resume .generate-site-config .ensure-resume-type .current-version .verify-build \
				.build-images

clean:
	rm -rf $(PWD)/output/*

build: .ensure-resume-type .build-images .fetch-resume .generate-config-toml
build:
	export PERSONA; \
	output_dir=$(PWD)/output/$$PERSONA; \
	test -d "$$(dirname "$$output_dir")" || mkdir -p "$$(dirname "$$output_dir")"; \
	test -d "$(PWD)/pdf" || mkdir -p "$(PWD)/pdf"; \
	$(DOCKER_COMPOSE) run --rm generate-resume && \
		$(MAKE) .verify-build

test: .ensure-resume-type .fetch-resume .generate-config-toml
test:
	$(DOCKER_COMPOSE) down; \
	$(DOCKER_COMPOSE) up --wait -d see-resume && \
		>&2 echo "INFO: Resume is now available at http://localhost:8080"

encrypt-wip: .ensure-resume-password
encrypt-wip:
	RESUME_PASSWORD="$$RESUME_PASSWORD" $(DOCKER_COMPOSE) run --rm encrypt-wip

decrypt-wip: .ensure-resume-password
decrypt-wip:
	RESUME_PASSWORD="$$RESUME_PASSWORD" $(DOCKER_COMPOSE) run --rm decrypt-wip

encrypt-specific: .ensure-resume-password
encrypt-specific:
	RESUME_PASSWORD="$$RESUME_PASSWORD" $(DOCKER_COMPOSE) run --rm encrypt-specific-resume

decrypt-specific: .ensure-resume-password
decrypt-specific:
	RESUME_PASSWORD="$$RESUME_PASSWORD" $(DOCKER_COMPOSE) run --rm decrypt-specific-resume

.ensure-resume-password:
	test -z "$$RESUME_PASSWORD" || exit 0; \
	>&2 echo "ERROR: Please define RESUME_PASSWORD to encrypt and decrypt resumes."; \
	exit 1; \

.ensure-resume-type:
	test -z "$$PERSONA" || exit 0; \
	>&2 echo "ERROR: Please define the type of resume to make, like 'consulting' or 'eng'"; \
	exit 1;

.fetch-resume:
	test -d "$(PWD)/theme" && exit 0; \
	test -d "$(PWD)/theme/resources/_gen" && rm -rf "$(PWD)/theme/resources/_gen"; \
	git clone --branch "$(THEME_VERSION)" "$(THEME_URL)" "$(PWD)/theme"

.generate-config-toml:
	export VERSION=$$($(MAKE) .current-version); \
	$(DOCKER_COMPOSE) run --rm generate-resume-config > $(PWD)/config.toml

.current-version:
	echo $$(git log -1 --format='$(PERCENT)h' $(PWD)/resumes);

.verify-build: .ensure-resume-type
.verify-build:
	for file in index.html index.xml; \
	do \
		f="$(PWD)/output/$$PERSONA/$$file"; \
		test -f "$$f" && continue; \
		>&2 echo "ERROR: Required file post-build is missing: $$f"; \
		exit 1; \
	done;
	>/dev/null find "$(PWD)/output/$$PERSONA/assets/css/devresume"*".css" && exit 0; \
	>&2 echo "ERROR: CSS not generated."; \

.build-images:
	$(DOCKER_COMPOSE) build
