CC=gcc
CFLAGS=-O3 -g

TARGET=test mandel

all: $(TARGET)

libppm.so: ppm.c
	$(CC) $(CFLAGS) -fpic -shared $^ -o $@

test: main.c libppm.so
	$(CC) $(CFLAGS) $(LDFLAGS) main.c -lppm -L. -o $@

mandel: mandel.c libppm.so
	$(CC) $(CFLAGS) $(LDFLAGS) $< -lppm -L. -o $@ -lm

clean:
	rm -f $(TARGET) *.so
