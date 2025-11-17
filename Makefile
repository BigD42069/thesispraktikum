TARGET = thesis
FLAGS = -synctex=1 -shell-escape

LUALATEX := $(shell command -v lualatex 2>/dev/null)
BIBER := $(shell command -v biber 2>/dev/null)
MAKEGLOSSARIES := $(shell command -v makeglossaries 2>/dev/null)
LATEX = $(LUALATEX)

ifeq ($(strip $(LUALATEX)),)
$(error "Das Kommando 'lualatex' wurde nicht gefunden. Bitte installiere eine LaTeX-Distribution (z. B. TeX Live mit dem Paket texlive-luatex). Weitere Hinweise findest du in der README.")
endif

ifeq ($(strip $(BIBER)),)
$(error "Das Kommando 'biber' wurde nicht gefunden. Bitte stelle sicher, dass die Bibliographie-Werkzeuge deiner LaTeX-Distribution installiert sind.")
endif

ifeq ($(strip $(MAKEGLOSSARIES)),)
$(error "Das Kommando 'makeglossaries' wurde nicht gefunden. Installiere die entsprechenden Glossaries-Werkzeuge deiner LaTeX-Distribution.")
endif

.PHONY: all tidy clean

all: $(TARGET).pdf

$(TARGET).pdf: fiwthesis.cls $(TARGET).tex anlagen/ kapitel/ verzeichnisse/ quellen.bib
	$(LATEX) $(FLAGS) $(TARGET)
	biber $(TARGET)
	makeglossaries $(TARGET)
	$(LATEX) $(FLAGS) $(TARGET)
	$(LATEX) $(FLAGS) $(TARGET)
	$(LATEX) $(FLAGS) $(TARGET)

tidy:
	rm -rf $(TARGET).acn $(TARGET).acr $(TARGET).alg $(TARGET).bbl \
		  $(TARGET).glg $(TARGET).glo $(TARGET).gls $(TARGET).ist \
		  $(TARGET).aux $(TARGET).blg $(TARGET).idx $(TARGET).ilg \
		  $(TARGET).ind $(TARGET).lof $(TARGET).lot $(TARGET).out \
		  $(TARGET).lol $(TARGET).run.xml $(TARGET).slg $(TARGET).syg \
		  $(TARGET).syi $(TARGET).nlo $(TARGET).bcf $(TARGET).log \
		  $(TARGET).toc _minted-$(TARGET) $(TARGET).loa \
		  $(TARGET).synctex.gz

clean: tidy
	rm -f $(TARGET).pdf
