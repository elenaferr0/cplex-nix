CC = g++
CPPFLAGS = -g -Wall -O2

# Use environment variables set by the Nix shell if available, otherwise use defaults
CPX_BASE    = $(if $(CPLEX_STUDIO_DIR2211),$(CPLEX_STUDIO_DIR2211),/opt/ibm/ILOG/CPLEX_Studio2211)
CPX_INCDIR  = $(CPX_BASE)/cplex/include
CPX_LIBDIR  = $(CPX_BASE)/cplex/lib/x86-64_linux/static_pic

# Allow specifying the source file as an argument
# If no source is specified, use all .cpp files in the directory
SRC = $(if $(src),$(src),$(wildcard *.cpp))

# If SRC is a list of files, use the first one as the target
# Otherwise use the basename of the specified source file
ifeq ($(words $(SRC)),1)
    TARGET = $(basename $(SRC))
else
    TARGET = $(basename $(firstword $(SRC)))
endif

# Object files from source files
OBJS = $(SRC:.cpp=.o)

# Default target
all: $(TARGET)

# Rule for compiling .cpp files to .o files
%.o: %.cpp
	$(CC) $(CPPFLAGS) -I$(CPX_INCDIR) -c $< -o $@

# Rule for linking the executable
$(TARGET): $(OBJS)
	$(CC) $(CPPFLAGS) $(OBJS) -o $(TARGET) -L$(CPX_LIBDIR) -lcplex -lm -pthread -ldl

# Clean up - remove all object files and executables built from cpp files
clean:
	rm -f $(OBJS) $(basename $(wildcard *.cpp))

# Show help
help:
	@echo "Generic CPLEX Makefile"
	@echo "Usage:"
	@echo "  make              - Builds the first .cpp file found (alphabetically)"
	@echo "  make src=file.cpp - Builds the specified source file"
	@echo "  make clean        - Removes all object files and executables"
	@echo "  make help         - Shows this help message"

# Phony targets
.PHONY: all clean help
