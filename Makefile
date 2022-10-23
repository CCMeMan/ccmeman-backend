.PHONY: default

default:
	@echo "no default rule"


# Init
# Reference:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-the-yarn-package-manager-for-node-js

install-yarn-global:
	npm install --global yarn
install-yarn-local:
	yarn set version berry

# Note
# Add new dependencies by "yarn add package-name"





# =====================================================
# One Time Usage
yarn-brand-new-project-init:
	yarn init
