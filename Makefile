all:
	bib && pdf

bib:
	bibtex refs.bib

pdf:
	pdflatex writeup.tex

watch:
	latexmk -pdf -pvc writeup.tex
