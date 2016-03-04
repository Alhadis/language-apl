⍝ HTML
text ← ⎕INP "END-OF-HTML"
<header id="top">
	Heading
</header>
END-OF-HTML


  aaa text ← ⎕INP "END-OF-XHTML"
<div id="top">
	Heading
</div>
END-OF-XHTML



 aatext ← ⎕INP "END-OF-HTML"
<header id="top">Heading</header>
========== END-OF-HTML ===============





⍝ XML
tree ← ⎕INP "END-OF-XML"
<?xml version="1.0" encoding="utf-8"?>
<svg><!-- Fancy lines, etc --></svg>
END-OF-XML

svg ← ⎕INP "SVG"
<?xml version="1.0" encoding="utf-8"?>
<svg><!-- Fancy lines, etc --></svg>
End of SVG



⍝ JavaScript
js ← ⎕INP "ENDJS"
"use strict";
let light = "shine";
function fn(){
	return Math.max(...[5, 6, 8]);
}
JSON.stringify({});
const $ = s => document.querySelector(s);
ENDJS


⍝ JSON
json ← ⎕INP "JSON"
{
	"name": "language-apl",
	"version": "0.0.1",
	"description": "APL language support for Atom",
	"keywords": ["APL", "Dyalog"],
	"repository": "https://github.com/Alhadis/language-apl",
	"license": "ISC",
	"engines": {
		"atom": "*"
	},
	"dependencies": {}
}
JSON


⍝ CSS
styles ← ⎕INP "END-CSS"
html{
	background: #f00;
}
END-CSS



⍝ Plain text
text ← ⎕INP "Plain Text"
Z←Z←81 9⍴1 ◊ F1←0
Plain Text
