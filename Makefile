# global variables
PRODUCT_NAME := $(shell basename -s .git `git config --get remote.origin.url`)
PRODUCT_VERSION := $(shell git describe --tags --abbrev=0)
PRODUCT_COMMIT := $(shell git rev-parse --short @)

# target-specific variables
build-dev: RELEASE_STRING := dev (${PRODUCT_COMMIT})
build-release: RELEASE_STRING := ${PRODUCT_VERSION} (${PRODUCT_COMMIT})


all: run

build-release:
	GOOS=linux GOARCH=amd64 go build -ldflags="-X 'main.appName=${PRODUCT_NAME}' -X 'main.appVersion=${RELEASE_STRING}'" -o ${PRODUCT_NAME}-linux-amd64 main.go
	GOOS=darwin GOARCH=arm64 go build -ldflags="-X 'main.appName=${PRODUCT_NAME}' -X 'main.appVersion=${RELEASE_STRING}'" -o ${PRODUCT_NAME}-darwin-arm64 main.go
	tar cvfz ${PRODUCT_NAME}-${PRODUCT_VERSION}.tar.gz ${PRODUCT_NAME}-*

build-dev:
	go build -ldflags="-X 'main.appName=${PRODUCT_NAME}' -X 'main.appVersion=${RELEASE_STRING}'" -o ${PRODUCT_NAME} main.go

run: build-dev
	./${PRODUCT_NAME}

clean:
	-@rm ./${PRODUCT_NAME}*

#.PHONY: run build-dev build-release
