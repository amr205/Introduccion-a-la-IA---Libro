pandoc main.tex -f latex --gladtex --toc --extract-media=pandocConversionMedia --number-sections -t epub3 -o output/mainMobi.epub3 --bibliography bibliography.bib --metadata title="El libro Azul de la Inteligencia Artificial" --citepro

rm -r output/pandocConversionMedia

mv pandocConversionMedia output/pandocConversionMedia

