LATEX=latex
BIBTEX=bibtex
DVIPS=dvips
PS2PDF=ps2pdf

all: mlsalt-dissertation.pdf
watch:
	latexmk -pdf -pvc mlsalt-dissertation.tex

mlsalt-dissertation.pdf: mlsalt-dissertation.ps
	$(PS2PDF) -dEmbedAllFonts=true mlsalt-dissertation.ps test.pdf
	ps2pdf13 -dPDFSETTINGS=/prepress test.pdf mlsalt-dissertation.pdf
	rm -f test.pdf

mlsalt-dissertation.ps: mlsalt-dissertation.dvi
	$(DVIPS) -Pdownload35 -ta4 mlsalt-dissertation.dvi

#mlsalt-dissertation.dvi: mlsalt-dissertation.tex dissertation.bib
mlsalt-dissertation.dvi: mlsalt-dissertation.tex titlepage.tex declaration.tex abstract.tex
	$(LATEX) mlsalt-dissertation
#       $(BIBTEX) mlsalt-dissertation
	$(LATEX) mlsalt-dissertation
	$(LATEX) mlsalt-dissertation

clean:
	$(RM) -f mlsalt-dissertation.pdf mlsalt-dissertation.ps mlsalt-dissertation.dvi
	$(RM) -f *.log *.aux *.toc *.bbl *.lot *.lof *.acn *.acr *.alg *.glg *.glo *.gls *.ist *.sbl *.xdy
	latexmk -c

