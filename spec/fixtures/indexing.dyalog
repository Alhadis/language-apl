(JOHN PAUL)←()()
JOHN.Children←()()
⍴JOHN.Children

JOHN.Children[1].FirstName←'Andy'
JOHN.Children[1].Age←23

JOHN.Children[2].FirstName←'Katherine'
JOHN.Children[2].Age←19               

PAUL.Children←()()
PAUL.Children[1].(FirstName Age←'Tom' 25)
PAUL.Children[2].(FirstName Age←'Jamie' 22)

EMP←JOHN PAUL
⍴EMP

(⊃EMP).Children.(FirstName Age)
]display (2⊃EMP).Children.(FirstName Age)
EMP.Children ⍝ Is an array of refs
EMP.Children.(FirstName Age)


FOO.A[2;3 2;4 1]
FOO.A[;2;]
FOO.G←('ABC' 1)('DEF' 2)('GHI' 3)('JKL' 4)
FOO.G←2 3⍴G,('MNO' 5)('PQR' 6)
FOO.G
FOO.G[((1 2)1)((2 3)2)]
FOO.G[2 2⍴⊂(2 2)2]
FOO.G[⊂⊂1 1]
FOO.G[⊂1 1]
FOO.V←,BAR.G
FOO.V[⊂⊂1]
FOO.V[⊂1]
FOO.V[1]
PAUL.PLOT←{(⍵,¨1)⍴¨'⎕'}
#.VAR
