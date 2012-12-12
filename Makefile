CATEGORIES:=$(wildcard *-*)
EBUILDS:=$(wildcard *-*/*)
MANIFESTS:=$(addsuffix /Manifest, $(EBUILDS))

all: $(MANIFESTS) profiles/categories

$(MANIFESTS): *-*/*/*.ebuild
	ebuild $(firstword $(wildcard $(dir $@)*.ebuild)) digest

profiles/categories: ${CATEGORIES}
	echo -e $(addprefix '\n', ${CATEGORIES}) > $@

clean: 
	rm -f profiles/catagories
	rm -f ${MANIFESTS}

.PHONY: clean
