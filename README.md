APL language support in Atom
============================

This package adds Atom support for everybody's favourite array-wrangling crypto-language.



Known Limitations
---------------------------------------------
... which aren't worth fixing:

### Heredocs (GNU APL)
1. Strings with escaped quotes can't be used as terminators:
```apl
text ← ⎕INP 'This won''t work'
```
Obviously, the solution is simple: choose a sane identifier:
```apl
text ← ⎕INP 'EOF'
```
