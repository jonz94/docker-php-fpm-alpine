VERSION = $(shell cat VERSION)

release:
	@git tag -a $(VERSION) -m $(VERSION)
	@git push --tags
