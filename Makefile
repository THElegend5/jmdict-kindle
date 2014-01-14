default: jmdict.mobi

edict2.gz enamdict.gz JMdict_e.gz JMnedict.xml.gz:
	wget -N http://ftp.monash.edu.au/pub/nihongo/$@

%.txt: %.gz edict_to_txt.py
	python edict_to_txt.py $< > $@

jmdict.opf: jmdict.py dictionary.py inflections.py kana.py JMdict_e.gz
	python jmdict.py

cover.jpg: cover.py
	python cover.py

# XXX: The Kindle Publishing Guidelines recommend -c2 (huffdic compression),
# but it is excruciantly slow.
COMPRESSION ?= 1

jmdict.mobi: jmdict.opf cover.jpg style.css frontmatter.html
	kindlegen $< -c$(COMPRESSION) -verbose -o $@

publish: jmdict.mobi
	scp -p jmdict.mobi annarchy.freedesktop.org:public_html/jmdict/

clean:
	rm -f jmdict.opf
	rm -f entry-*.html
	rm -f cover.jpg

.PHONE: default publish clean
