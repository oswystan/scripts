#######################################################################
##                     Copyright (C) 2017 wystan
##
##       filename: makefile
##    description: 
##        created: 2017-09-28 13:37:39
##         author: wystan
## 
#######################################################################

define mk-one-dir
$(1):
	@echo "mkdir" $$@
	@mkdir -p $$@
endef

#####################################################
## $(eval $(call mk-dirs,a b c d))
#####################################################
define mk-dirs
$(foreach d,$(1),\
	$(eval $(call mk-one-dir,$(d)))	\
)
endef

#####################################################
## enumerate different types of files under $1
#####################################################
define all-files-under
$(patsubst ./%,%,\
	$(wildcard $(1)/$(2))\
)
endef
define all-c-files-under
$(call all-files-under,$(1),*.c)
endef
define all-cpp-files-under
$(call all-files-under,$(1),*.cpp)
endef

c-files := $(call all-c-files-under,.)
cpp-files := $(call all-cpp-files-under,.)
cpp-files += $(call all-cpp-files-under,src)

all:
	@echo $(c-files)
	@echo $(cpp-files)

#######################################################################
