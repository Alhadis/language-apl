#!/usr/local/bin/apl --script --

⍝ Scientific notation
29.e¯2
29e2
2.9e2
2.9e¯2

⍝ NOT scientific notation
29e-2
2. DModel
2.5DModel
3DModel
33.333(DModel)
Another3DModel ← Mesh


⍝ Space before comments
]sampleb xyz -TZ=123 ⍝COMMENT
]COLOR OFF
)LIST vars ⍝COMMENT


⍝ No whitespace
]sampleb 23 -TZ=123⍝COMMENT
]COLOR OFF
)LIST vars⍝COMMENT


⍝ Function: Monadic
∇R ← FUNCTION X
	R ← X + X
∇

∇R ← FUNCTION X ;A;B
	R ← X + X
∇


⍝ Function: Dyadic
∇R ← X FUNCTION Y
	R ← X + Y
∇

∇R ← X FUNCTION Y;A;B
	R ← X + Y
∇



⍝ Operator: Valid
∇R ← X (LOP OPERATOR ROP) Y ;A;B
	R ← X + Y
∇

∇R ← (LOP OPERATOR ROP) X ;A;B
	R ← X + Y
∇

⍝ Operator: Invalid
∇R ← X (LOP OPERATOR ROP) Y ;A;B;
	R ← X + Y
∇

∇R ← X (LOP OPERATOR ROP) Y Whoops;L;E;;;L
	R ← X + Y
∇

∇R ← X (LOP OPERATOR ROP) Y Whoops;k;e;k
	R ← X + Y
∇

∇R ← (LOP OPERATOR ROP) Y Invalid;B;R;U;H;
	R ← X + Y
∇




⍝ Dyalog/NARS2000-style headers
∇ Z ← FUNCTION (X Y)
	Z ← R1 + R2
∇

∇ Z ← X (A FUNCTION B) (X Y)
	Z ← R1 + R2
∇

∇ Z←FOO R;g1 g2 g3 g4;h1 h2 h3
∇

∇ Z←(LO MonOp) R
∇


⍝ "Shy"/non-displayable return values
∇ {Y Z} ← FUNCTION X
∇

∇ ({Y Z}) ← FUNCTION X
∇

∇ {(Y Z)} ← FUNCTION X
∇

⍝ Altogether now:
∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO DyadicOp RO) (R1 R2 R3 R4)
∇

∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO MonadicOp) (R1 R2 R3 R4)
∇

∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO DydadicOp[X] RO) (R1 R2 R3 R4)
∇

∇ {(Z1 Z2)}←{(L1 L2 L3)} (LO MonadicOp[X]) (R1 R2 R3 R4)
∇
