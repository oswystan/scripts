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
define all-mk-files-under
$(call all-files-under,$(1),*.mk)
endef
define all-go-files-under
$(call all-files-under,$(1),*.go)
endef
define all-h-files-under
$(call all-files-under,$(1),*.h)
endef

#####################################################
## add -L for each $(1) for ld lib searching
#####################################################
define add-ld-lib-path
$(strip \
	$(foreach p,$(1),\
		$(addprefix -L,$(p))\
	)\
)
endef

#####################################################
## add -I for each $(1) for header file searching
#####################################################
define add-header-path
$(strip \
	$(foreach p,$(1),\
		$(addprefix -I,$(p))\
	)\
)
endef

all:


#######################################################################
