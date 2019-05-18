SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON:=python3
NLM_LINUX_VERSION=19.0403
NLM_URL:=https://scrubber.nlm.nih.gov/files/linux/scrubber.19.0403L.zip
NLM_WINDOWS_VERSION=19.0411
NLM_WINDOWS_URL:=https://scrubber.nlm.nih.gov/files/windows/scrubber.19.0411W.zip
IMAGE_NAME:=radaisystems/nlm-scrubber


all: test_build

get_scrubber:
	mkdir -p ${ROOT_DIR}/build
	if [ ! -f ${ROOT_DIR}/build/nlm_scrubber ]; then \
    curl -s ${NLM_URL} --output ${ROOT_DIR}/build/nlm_scrubber.zip; \
		unzip ${ROOT_DIR}/build/nlm_scrubber.zip -d build; \
		mv ${ROOT_DIR}/build/scrubber.${NLM_LINUX_VERSION}L/scrubber.${NLM_LINUX_VERSION}.lnx ${ROOT_DIR}/build/nlm_scrubber; \
		rm ${ROOT_DIR}/build/nlm_scrubber.zip; \
		rm -rf ${ROOT_DIR}/build/scrubber.${NLM_LINUX_VERSION}L; \
  fi

test_build: get_scrubber
	docker build -f docker/Dockerfile .

build: get_scrubber
	docker build -f docker/Dockerfile -t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${NLM_LINUX_VERSION} .

docker_hub: build
	docker push ${IMAGE_NAME}:latest
	docker push ${IMAGE_NAME}:${NLM_LINUX_VERSION}


get_windows_scrubber:
	mkdir -p ${ROOT_DIR}/build
	if [ ! -f ${ROOT_DIR}/build/nlm_scrubber_win ]; then \
    curl ${NLM_WINDOWS_URL} --output ${ROOT_DIR}/build/nlm_scrubber_win.zip; \
		unzip ${ROOT_DIR}/build/nlm_scrubber_win.zip -d build; \
		find . -name scrubber.exe -exec mv '{}' build/ \;; \
  fi

test_build_windows: get_windows_scrubber
	docker build -f docker/Dockerfile .

build_windows: get_windows_scrubber
	docker build -f docker/Dockerfile -t ${IMAGE_NAME}:windows_${NLM_WINDOWS_VERSION} .

docker_hub_windows: build_windows
	docker push ${IMAGE_NAME}:windows

clean:
	rm -Rf ${ROOT_DIR}/build

test_bash: build
	docker run -ti ${IMAGE_NAME} /bin/bash
