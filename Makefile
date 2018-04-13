C=gcc
FRAMEWORKS=-framework cocoa

all: monky

monky: monky.m
	$(C) $(FRAMEWORKS) $^ -o $@

clean:
	- rm -f monky
