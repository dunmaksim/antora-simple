CC=docker

.PHONY: build

build:
	$(CC) build -f Containerfile -t antora-simple:latest .
