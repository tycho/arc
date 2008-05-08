OUTFILE=../GenerateBuildNumber

CC=gcc
CXX=g++
LINK=$(CXX)

CXXFLAGS=-Wall -Winvalid-pch -march=pentium2 -mtune=pentium2 -O3 -g -pipe
CPPFLAGS=-D_DEBUG

STRIP=:strip
NM=nm

INCLUDE=-I.

# find . -name '*.cpp' | sed 's%^\./\(.*\)%\1 \\%'
SOURCES = \
GenerateBuildNumber.cpp \
crc.cpp

CXXFLAGS+=$(INCLUDE)

OBJDIR=.linux-objs
OBJECTS=$(SOURCES:%.cpp=$(OBJDIR)/%.o)

all: $(OUTFILE)

clean:
	@echo -n "Cleaning... "
	@rm -f $(OUTFILE)
	@rm -rf $(OBJDIR)
	@echo done.

$(OUTFILE): $(OBJECTS)
	@echo -n "Linking... "
	@$(LINK) $+ $(LIBS) -o $@ 
	@echo done.

.linux-objs/%.o: %.cpp
	@echo Compiling $<
	@mkdir -p $(dir $@)
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.linux-objs/%.o: %.c
	@echo Compiling $<
	@mkdir -p $(dir $@)
	@$(CC) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

