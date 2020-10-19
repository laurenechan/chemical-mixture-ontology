## Customize Makefile settings for cmixo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

TEMPLATESDIR=../templates
TEMPLATES=$(patsubst %.tsv, $(TEMPLATESDIR)/%.owl, $(notdir $(wildcard $(TEMPLATESDIR)/*.tsv)))
$(TEMPLATESDIR)/%.owl: $(TEMPLATESDIR)/%.tsv $(SRC)
	$(ROBOT) merge -i $(SRC) template --template $< --prefix "CMIXO: http://purl.obolibrary.org/obo/CMIXO_" --prefix "SIO: http://semanticscience.org/resource/SIO_" --output $@ && \
	$(ROBOT) annotate --input $@ --ontology-iri $(ONTBASE)/components/$*.owl -o $@
templates: $(TEMPLATES)
	echo $(TEMPLATES)


components/alltemplates.owl: $(TEMPLATES)
	$(ROBOT) merge $(patsubst %, -i %, $^) \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ \
		--output $@.tmp.owl && mv $@.tmp.owl $@