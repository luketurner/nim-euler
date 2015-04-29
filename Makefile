src = $(wildcard *.nim)
out = $(src:%.nim=%)

build: $(out)

%: %.nim
	nim compile $^

.PHONY: clean
clean:
	rm -r nimcache $(out)
