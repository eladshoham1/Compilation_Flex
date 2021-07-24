build:
	flex olympics.lex
	gcc -o olympics lex.yy.c

clean:
	rm -rf *.c *.o olympics
