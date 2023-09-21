OUT_DIR=output
IN_DIR=.
STYLE=chmduquesne
MAKEFLAGS += --silent
THEME_URL = https://github.com/carlosonunez/hugo-devresume-theme
THEME_VERSION = main
DNS_ZONE ?= resume.carlosnunez.me

export RESUME_FILE
export DNS_ZONE

.PHONY: test \
				build \
				pdf \
				resume-make \
				resume-eng-make \
				.fetch-resume \
				.generate-site-config \
				.ensure-resume-type \
				.clean

resume-make:
	RESUME_FILE=consulting $(MAKE) build

resume-eng-make:
	RESUME_FILE=eng $(MAKE) build

resume-wip-make:
	RESUME_FILE=wip $(MAKE) build

build: .clean .ensure-resume-type .fetch-resume .generate-config-toml
build:
	export RESUME_FILE; \
	output_dir=$(PWD)/output/$$RESUME_FILE; \
	test -d "$$(dirname "$$output_dir")" || mkdir -p "$$(dirname "$$output_dir")"; \
	test -d "$(PWD)/pdf" || mkdir -p "$(PWD)/pdf"; \
	test -d "$$output_dir" && rm -rf "$$output_dir"; \
	trap 'rc=$$?; docker-compose down; exit $$?' INT HUP EXIT; \
	docker-compose run --rm generate-resume && \
		docker-compose up --wait -d see-resume

test: .ensure-resume-type .fetch-resume .generate-config-toml
test:
	docker-compose down; \
	docker-compose up --wait -d see-resume && \
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
	docker-compose run --rm generate-resume-config > $(PWD)/config.toml

.clean:
	rm -rf $(PWD)/output/*
