CC=gcc
CFLAGS=-O3 -g

TARGET=test mandel

all: $(TARGET)

libppm.so: ppm.c
	$(CC) -o $@ $< $(CFLAGS) -fpic -shared

test: main.c libppm.so
	$(CC) -o $@ $< $(CFLAGS) -L. -lppm

mandel: mandel.c libppm.so
	$(CC) -o $@ $< $(CFLAGS) -L. -lppm -lm

clean:
	rm -f $(TARGET) *.so
