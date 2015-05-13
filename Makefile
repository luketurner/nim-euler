src = $(wildcard *.nim)

build: $(src)
	nim compile euler.nim

.PHONY: clean
clean:
	rm -r nimcache euler
