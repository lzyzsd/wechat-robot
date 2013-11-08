TIMEOUT = 5000
SLOW = 500
MOCHA_OPTS = --compilers coffee:coffee-script --timeout $(TIMEOUT) --slow $(SLOW)

test:
	@NODE_ENV=test ./node_modules/mocha/bin/mocha \
		--reporter spec \
		$(MOCHA_OPTS) \
		test/**/*.test.coffee \
		test/**/*.test.coffee \
		test/**/*.test.coffee

test-file:
	@NODE_ENV=test ./node_modules/mocha/bin/mocha \
		--reporter  spec \
		$(MOCHA_OPTS) \
		${FILE}

test-cov:
	@NODE_ENV=test ./node_modules/mocha/bin/mocha \
		--require blanket -R html-cov > coverage.html \
		$(MOCHA_OPTS) \
		test/**/*.test.coffee \
		test/**/*.test.coffee \
		test/**/*.test.coffee


.PHONY: test