CC=gcc
CXX=g++
PROJECT = modelo8
PRGFILES = main.prg adiciona.prg auxiliar.prg edita.prg imprime.prg pdf.prg winprint.prg lstscr.prg nifs.prg
GENCFILES = $(PRGFILES:.prg=.c)
CFILES = 
OBJFILES = $(CFILES:.c=.o) $(GENCFILES:.c=.o)
HARBOURFLAGS = -a -m -w0 -n -q -i/harbour/include -i. -i/Users/oscar/opt/include
CFLAGS = -I/harbour/include -Wall -I/Users/oscar/opt/include
LFLAGS =-static -gtxwc -L/harbour/lib -L/d/HARBOUR/lib -L/Users/oscar/opt/lib -lpdf
#LFLAGS =-static -gtwvt -L/harbour/lib -L/d/HARBOUR/lib -L/Users/oscar/opt/lib -lpdf
HRB = harbour
LINKER = xhblnk
ALLOBJ = $(OBJFILES)
 
.PHONY: all clean
 
.SUFFIXES:

.SUFFIXES: .o .c .prg .cpp

%.o : %.cpp
	$(CXX) $(CFLAGS) -c -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) -I. -c -o $@ $<
 
%.c : %.prg 
	$(HRB) $< $(HARBOURFLAGS) -gc -o$@
 
#BUILD
all : $(PROJECT)
 
clean:
	-$(RM) $(ALLOBJ) $(PROJECT) $(GENCFILES) $(PROJECT) $(PROJECT).exe

$(PROJECT) : $(CFILES) $(OBJFILES) 
	$(LINKER) -o $(PROJECT) $(ALLOBJ)  $(LFLAGS)  $(ALLLIB)  

