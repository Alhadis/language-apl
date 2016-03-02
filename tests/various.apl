#!/usr/local/bin/apl --script --

⍝ Space before comments
]sampleb xyz -TZ=123 ⍝COMMENT
]COLOR OFF
)LIST vars ⍝COMMENT


⍝ No whitespace
]sampleb xyz -TZ=123⍝COMMENT
]COLOR OFF
)LIST vars⍝COMMENT
