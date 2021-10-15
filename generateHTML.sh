pandoc main.tex -f latex --mathjax --toc --extract-media=pandocConversionMedia --number-sections -t html -s -o output/main.html --bibliography bibliography.bib --metadata title="El libro Azul de la Inteligencia Artificial" --citepro

sed -i 's:<p><span>-4ex -1ex -.4ex</span> <span>1ex .2ex </span> <span><strong></strong></span><span>\(.*\)</span></p>:<strong>\1</strong>:g' output/main.html

sed -i 's:<p><span>-3ex -0.1ex -.4ex</span> <span>0.5ex .2ex </span> <span><strong></strong></span><span>\(.*\)</span></p>:<strong>\1</strong>:g' output/main.html

sed -i 's:<span>-4ex -1ex -.4ex</span> <span>1ex .2ex </span> <span><strong></strong></span><span>\(.*\)</span>:<strong>\1</strong>:g' output/main.html

sed -i 's:<span>-3ex -0.1ex -.4ex</span> <span>0.5ex .2ex </span> <span><strong></strong></span><span>\(.*\)</span>:<strong>\1</strong>:g' output/main.html

sed -i 's:<p><span>\(.*\)<span>Articles</span></p>:<p>Las referencias se pueden encontrar bien listadas y ordenadas en la versión pdf del libro</p>:g' output/main.html

sed -i 's:<p>\(.*\)*<span>Books</span></p>: :g' output/main.html

rm -r output/pandocConversionMedia

mv pandocConversionMedia output/pandocConversionMedia

