# you WILL want to change these to match your desired output
ARCH_FLAGS=-mcpu=cortex-m3 -mthumb -msoft-float
CFLAGS+=-DARM_MATH_CM3

LIBNAME=libcmsisdsp

PREFIX  ?= arm-none-eabi-
#PREFIX         ?= arm-elf
CC              = $(PREFIX)gcc
AR              = $(PREFIX)ar

CFLAGS+= -ggdb3 -Os -Wall -Wextra -fno-common $(ARCH_FLAGS)
CFLAGS+=-ffunction-sections -fdata-sections
CFLAGS+= -Isrc

OBJDIR=objs
SRCS = $(notdir $(wildcard src/*/*.c))
OBJS = $(SRCS:%.c=$(OBJDIR)/%.o)

vpath %.c $(sort $(dir $(wildcard src/*/*.c)))
VPATH+=src

# Be silent per default, but 'make V=1' will show all compiler calls.
ifneq ($(V),1)
Q := @
endif

all: $(LIBNAME).a

$(LIBNAME).a: $(OBJS)
	@printf "  AR		$(subst $(shell pwd)/,,$(@))\n"
	$(Q)$(AR) $(ARFLAGS) $@ $^

$(OBJDIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@printf "  CC      $(subst $(shell pwd)/,,$(@))\n"
	$(Q)$(CC) $(CFLAGS) -o $@ -c $<

clean:
	@printf "  CLEAN\n"
	$(Q)rm -rf $(OBJDIR)
	$(Q)rm -rf $(LIBNAME).so
	$(Q)rm -rf $(LIBNAME).a

.PHONY: all clean
	

