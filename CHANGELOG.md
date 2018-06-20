Change Log
==========

This project adheres to [Semantic Versioning](http://semver.org).


[Staged]
--------------------------------------------------------------------------------
* __Added:__    First-line matching of modelines and APL symbols
* __Added:__    Recognition of `∇` and `∇∇` in lambda bodies
* __Added:__    Support for Dyalog's `#` and `##` namespace tokens
* __Added:__    Support for Dyalog's `⊆` and `@` primitives
* __Added:__    Support for mixed-case and lowercase system names
* __Fixed:__    Inconsistent highlighting of quad-quotes and control keywords
* __Improved:__ Syntax highlighting of numeric literals



[v1.1.0]
--------------------------------------------------------------------------------
**April 6th, 2016**  
Support for various language extensions has been added, and several bugs
related to grammar and highlighting have been fixed.

* __Added:__    Pattern-matching for axis operators and Dyalog classes
* __Added:__    Snippet to insert hashbang for GNU APL scripts
* __Added:__    Support for Dyalog/NARS2000-style function headers
* __Changed:__  `]NEXTFILE` and `)OFF` commands suppress subsequent highlighting
* __Changed:__  `<?apl ?>` snippet restricted to embedded heredocs only
* __Fixed:__    Incorrect error highlighting applied to function headers
* __Improved:__ Recognition and scoping of punctuation characters
* __Improved:__ Syntax highlighting of embedded heredocs


[v1.0.1]
--------------------------------------------------------------------------------
**March 8th, 2016**  
This release fixes the broken banner image in the package's readme file.
As of this writing, Atom.io is still having problems displaying embedded
images in package readme files.


[v1.0.0]
--------------------------------------------------------------------------------
**March 8th, 2016**  
Initial release. Adds highlighting support and snippets for APL.


[Referenced links]:_____________________________________________________________
[Staged]: https://github.com/Alhadis/language-apl/compare/v1.1.0...HEAD
[v1.1.0]: https://github.com/Alhadis/language-apl/releases/tag/v1.1.0
[v1.0.1]: https://github.com/Alhadis/language-apl/releases/tag/v1.0.1
[v1.0.0]: https://github.com/Alhadis/language-apl/releases/tag/v1.0.0
