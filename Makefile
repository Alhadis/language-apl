all: json

json: grammars/apl.json
.SILENT: json


# Generate a flattened JSON file from CSON source
grammars/%.json: grammars/%.js
	@node -e 'console.log(JSON.stringify(require("./$<"), "", "\t"))' > $@
	
grammars/%.js: grammars/%.cson
	@coffee --print $< | perl -0777 -pe '\
		s/^.*?(name:)/module.exports = {$$1/ms; \
		s/\);?\s*\}\).call\(this\);?/;/ms; \
	' > $@


# Delete previously-generated JSON files
clean:
	@rm -rf grammars/apl.json

.PHONY: clean
