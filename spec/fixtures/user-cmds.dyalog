⎕←
]OFF
]cmd             ⍝ Execute Cmd command
]⎕←cmd           ⍝ Display Cmd's result line-by-line
]var←cmd         ⍝ Capture Cmd's result in var

]grp -?          ⍝ Brief information on commands in group "GRP"
]grp.cmd -?      ⍝ Brief information on command "Cmd" of the "GRP" group
]grp.cmd -??     ⍝ Detailed information on command
]grp.cmd -???    ⍝     add question marks for more info

]                ⍝ This help message
] -?             ⍝ List all commands
] -??            ⍝ List all commands with summaries

]X*YZ* -?        ⍝ List commands or groups that match a pattern
]/path/dir -?    ⍝ List commands in /path/dir
]ucmd -?         ⍝ List commands for working with user commands

]NEXTFILE
