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
