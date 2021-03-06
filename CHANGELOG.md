Change Log
==========

This project adheres to [Semantic Versioning](http://semver.org).


[Staged]
--------------------------------------------------------------------------------
* __Added:__ Auto-indentation of functions, Dyalog keywords, and `<?apl`…`?>`
* __Fixed:__ Missing colons in Dyalog keyword snippets
* __Fixed:__ [Various inaccuracies](https://github.com/github/linguist/pull/5271)
related to Emacs and Vim modeline recognition.



[v1.2.2]
--------------------------------------------------------------------------------
**May 6th, 2019**  
* __Added:__ Highlighting of local variable lists declared on separate lines
* __Fixed:__ Catastrophic backtracking when typing function headers



[v1.2.1]
--------------------------------------------------------------------------------
**April 25th, 2019**  
Added support for another 8 file-extensions: `.apla`, `.aplc`, `.aplf`, `.apli`,
`.apln`, `.aplo`, `.dyapp`, and `.mipage`. Sourced from @OptimaSystems's port of
this package for [VSCode](https://github.com/OptimaSystems/vscode-apl-language).
Snippets for various Dyalog-specific constructs were also ported from said repo.



[v1.2.0]
--------------------------------------------------------------------------------
**June 27th, 2018**  
Substantial improvements to the grammar's accuracy and coverage, courtesy of
@jayfoad. Extensive snippets have also been added to allow users without APL
keyboards to enter APL symbols with "ASCII-fied" representations (`|O`→`⌽`).

* __Added:__    First-line matching of modelines and APL symbols
* __Added:__    Highlighting of function/operator names in definition headers
* __Added:__    Recognition of `∇` and `∇∇` in lambda bodies
* __Added:__    Support for Dyalog's `#` and `##` namespace tokens
* __Added:__    Support for Dyalog's `⊆` and `@` primitives
* __Added:__    Support for mixed-case and lowercase system names
* __Fixed:__    Dyalog switches without arguments not being highlighted
* __Fixed:__    Inconsistent highlighting of quad-quotes and control keywords
* __Fixed:__    Partial Unicode support in name tokens
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
[Staged]: https://github.com/Alhadis/language-apl/compare/v1.2.2...HEAD
[v1.2.2]: https://github.com/Alhadis/language-apl/releases/tag/v1.2.2
[v1.2.1]: https://github.com/Alhadis/language-apl/releases/tag/v1.2.1
[v1.2.0]: https://github.com/Alhadis/language-apl/releases/tag/v1.2.0
[v1.1.0]: https://github.com/Alhadis/language-apl/releases/tag/v1.1.0
[v1.0.1]: https://github.com/Alhadis/language-apl/releases/tag/v1.0.1
[v1.0.0]: https://github.com/Alhadis/language-apl/releases/tag/v1.0.0
