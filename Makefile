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
				resume-make \
				resume-eng-make \
				.fetch-resume \
				.generate-site-config

resume-make:
	RESUME_FILE=consulting $(MAKE) build

resume-eng-make:
	RESUME_FILE=eng $(MAKE) build

resume-wip-make:
	RESUME_FILE=wip $(MAKE) build

build: .fetch-resume .generate-config-toml
build:
	if test -z "$$RESUME_FILE" ; \
	then \
		>&2 echo "ERROR: Please define the type of resume to make, like 'consulting' or 'eng'"; \
		exit 1; \
	fi; \
	export RESUME_FILE; \
	output_dir=$(PWD)/output/$$RESUME_FILE; \
	test -d "$$(dirname "$$output_dir")" || mkdir -p "$$(dirname "$$output_dir")"; \
	test -d "$(PWD)/pdf" || mkdir -p "$(PWD)/pdf"; \
	test -d "$$output_dir" && rm -rf "$$output_dir"; \
	docker-compose run --rm generate-resume && \
		docker-compose run --build --rm generate-pdf

test: .fetch-resume .generate-config-toml
test:
	docker-compose run --rm see-resume

.fetch-resume:
	test -d "$(PWD)/theme" && exit 0; \
	test -d "$(PWD)/theme/resources/_gen" && rm -rf "$(PWD)/theme/resources/_gen"; \
	git clone --branch "$(THEME_VERSION)" "$(THEME_URL)" "$(PWD)/theme"

.generate-config-toml:
	docker-compose run --rm generate-resume-config > $(PWD)/config.toml
	
apply_pre_transforms:
	sh /scripts/apply_pre_transforms.sh "$(RESUME_FILE)"

pdf: init
	FILE_NAME=`basename $(RESUME_FILE) | sed 's/.md//g'`; \
	echo "[PDF] Resume being generated: $$FILE_NAME.html"; \
	weasyprint -v -p $(OUT_DIR)/$$FILE_NAME.html $(OUT_DIR)/$$FILE_NAME.pdf;

html: init
	FILE_NAME=$$(basename $(RESUME_FILE) | sed 's/.md//g'); \
	echo "[HTML] Resume being generated: $${FILE_NAME}.html"; \
	pandoc --standalone --include-in-header include/header.html \
		--lua-filter=pdc-links-target-blank.lua \
		--from markdown --to html \
		--metadata pagetitle=$(RESUME_TILE) \
		--output $(OUT_DIR)/$$FILE_NAME.html $(IN_DIR)/$${FILE_NAME}_post.md &&  \
	sh /scripts/apply_transforms.sh "$(IN_DIR)/$${FILE_NAME}_post.md"

init: dir version

dir:
	mkdir -p $(OUT_DIR)

version:
	PANDOC_VERSION=`pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`; \
	if [ "$$PANDOC_VERSION" -eq "2" ]; then \
		SMART=-smart; \
	else \
		SMART=--smart; \
	fi \

clean:
	rm -f $(OUT_DIR)/*
