################################################################################
#
# custom-package
#
################################################################################

# This is an example of a custom Go package.

CUSTOM_PACKAGE_VERSION = ba5f4379d78b0dbf4f58b0aec7af9bb7f645fa2e
CUSTOM_PACKAGE_SITE = $(call github,go-training,helloworld,$(CUSTOM_PACKAGE_VERSION))
CUSTOM_PACKAGE_LICENSE = MIT
CUSTOM_PACKAGE_LICENSE_FILES = LICENSE

$(eval $(golang-package))
