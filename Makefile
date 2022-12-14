help:
	@echo "yarn add package-name  - Add new dependencies"
	@echo "yarn                   - Install dependencies"
	@echo "make run               - Run local server"

run:
	yarn server

db-generate:
	npx prisma generate

db-migrate:
	yarn db-migrate

clean-yarn:
	-rm -r .yarn
	-rm -r .yarnrc.yml
	-rm -r node_modules
	-rm -r package-lock.json
	-rm -r yarn.lock


# =====================================================
# Init
# Reference:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-the-yarn-package-manager-for-node-js

install-yarn-global:
	#npm install --global yarn
	corepack enable
install-yarn-local:
	yarn set version berry


# =====================================================
# One Time Usage
yarn-brand-new-project-init:
	yarn init

