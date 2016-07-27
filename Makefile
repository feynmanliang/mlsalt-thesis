LATEX=latex
BIBTEX=bibtex
DVIPS=dvips
PS2PDF=ps2pdf

all: dissertation.pdf
watch:
	latexmk -pdf -pvc dissertation.tex

dissertation.pdf: dissertation.ps
	$(PS2PDF) -dEmbedAllFonts=true dissertation.ps test.pdf
	ps2pdf13 -dPDFSETTINGS=/prepress test.pdf dissertation.pdf
	rm -f test.pdf

dissertation.ps: dissertation.dvi
	$(DVIPS) -Pdownload35 -ta4 dissertation.dvi

#dissertation.dvi: dissertation.tex refs.bib
dissertation.dvi: dissertation.tex titlepage.tex declaration.tex abstract.tex
	$(LATEX) dissertation
	$(BIBTEX) dissertation
	$(LATEX) dissertation
	$(LATEX) dissertation

clean:
	$(RM) -f dissertation.pdf dissertation.ps dissertation.dvi
	$(RM) -f *.log *.aux *.toc *.bbl *.lot *.lof *.acn *.acr *.alg *.glg *.glo *.gls *.ist *.sbl *.xdy
	latexmk -c

