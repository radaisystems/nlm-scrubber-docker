SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON:=python3
NLM_URL:=https://scrubber.nlm.nih.gov/files/linux/scrubber_16.0512.lnx
IMAGE_NAME:=radaisystems/nlm-scrubber


all: test_build

get_scrubber:
	mkdir -p ${ROOT_DIR}/build
	if [ ! -f ${ROOT_DIR}/build/nlm_scrubber ]; then \
    curl ${NLM_URL} --output ${ROOT_DIR}/build/nlm_scrubber; \
  fi

test_build: get_scrubber
	docker build -f docker/Dockerfile .

build: get_scrubber
	docker build -f docker/Dockerfile -t ${IMAGE_NAME} .

clean:
	rm -Rf ${ROOT_DIR}/build

test_bash: build
	docker run -ti IMAGE_NAME /bin/bash

docker_hub: build
	docker push ${IMAGE_NAME}:latest
