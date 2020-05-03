npm:
	docker-compose run ganache npm run $(run)

compile: run=compile
compile: npm

test: run=test
test: npm

migrate: run=migrate
migrate: npm
