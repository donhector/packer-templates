.PHONY: build
build:
	@packer build -force templates/ubuntu-20.04-live-server.json
