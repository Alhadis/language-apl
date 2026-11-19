X.NUMB ← 88
88 UTIL.FOO 99

WSDOC.PAGE.NO +← 1            ⍝ Increment WSDOC page count
#.⎕NL 2                       ⍝ Variables in root space
UTIL.⎕FX 'Z←DUP A' 'Z←A A'    ⍝ Fix remote function
##.⎕ED'FOO'                   ⍝ Edit function in parent space
⎕SE.RECORD ← PERS.RECORD      ⍝ Copy from PERS to ⎕SE
UTIL.(⎕EX ⎕NL 2)              ⍝ Expunge variables in UTIL
(⊃⎕SE #).(⍎⊃↓⎕NL 9).(⎕NL 2)   ⍝ Vars in first ⎕SE namespace.
UTIL.⍎STRING                  ⍝ Execute STRING in UTIL space

2 3 ∘.× 4 5      ⍝ Outer product
2 3 +.× 4 5      ⍝ Inner product
2 3 x.foo 4 5    ⍝ Namespace reference
(x y).⎕NC⊂'foo'  ⍝ Reference array expansion
)NS NS1
