
ubuntu2004-liveserver:
	@cd templates/ubuntu-2004-live-server && \
		packer init . && \
		packer build -force .

ubuntu2004-liveserver-debug:
	@cd templates/ubuntu-2004-live-server && \
		packer init . && \
		PACKER_LOG=1 packer build -on-error=ask -force .

ubuntu2004-liveserver-lint:
	@cd templates/ubuntu-2004-live-server && \
		packer validate . && \
		packer fmt .

ubuntu2204-liveserver:
	@cd templates/ubuntu-2204-live-server && \
		packer init . && \
		packer build -force .

ubuntu2204-liveserver-debug:
	@cd templates/ubuntu-2204-live-server && \
		packer init . && \
		PACKER_LOG=1 packer build -on-error=ask -force .

ubuntu2204-liveserver-lint:
	@cd templates/ubuntu-2204-live-server && \
		packer validate . && \
		packer fmt .
