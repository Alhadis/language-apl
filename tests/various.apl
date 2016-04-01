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
