#
# Make -- the OG build tool.
# Add any build tasks here and abstract complex build scripts into `lib` that
# can be run in a Makefile task like `coffee lib/build_script`.
#
# Remember to set your text editor to use 4 size non-soft tabs.
#

BIN = node_modules/.bin

# Start the server
s:
	foreman start

sp:
	REDIS_URL=redis://127.0.0.1:6379 foreman start

# Start the server using forever
sf:
	$(BIN)/forever $(BIN)/coffee --nodejs --max_old_space_size=960 index.coffee

# Run all of the project-level tests, followed by app-level tests
test: assets
	$(BIN)/mocha $(shell find test -name '*.coffee' -not -path 'test/helpers/*')
	$(BIN)/mocha $(shell find apps/*/test -name '*.coffee' -not -path 'test/helpers/*')

# Generate minified assets from the /assets folder and output it to /public.
assets:
	$(BIN)/ezel-assets

deploy:
	$(BIN)/ezel-assets
	$(BIN)/bucket-assets --bucket median-production
	heroku config:set COMMIT_HASH=$(shell git rev-parse --short HEAD) --app=azone-terminal
	git push --force git@heroku.com:azone-terminal.git

.PHONY: test assets
