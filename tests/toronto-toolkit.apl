⍝
⍝ Author:      Toronto ACM Special Interest Group (SIG) on APL and others
⍝ Date:        2015-7-19 and see toolkit.txt below
⍝ Copyright:   see files after ]NEXTFILE below
⍝ License:     see files after ]NEXTFILE below
⍝ Support email: 
⍝ Portability:   L1 (ISO APL portability)
⍝
⍝ Purpose:
⍝ A collection of useful APL functions
⍝
⍝ Description:
⍝ This workspace is an adaptation of the Toronto Toolkit to GNU APL, kindly
⍝ provided by Fred Weigel. See also Fred's notes after ]NEXTFILE below
⍝

 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝
⍝ ./toolkit 2015-07-19 06:19:28 (GMT-4)
⍝
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⎕PW←10000

∇y←x adjust d;⎕IO;ex;i;line;lmrg;pw;w
 ⍝adjust each row of matrix <d> according to parameters <x>
 ⍝.e ('/' ∆box 'please do not  / enter') = 15 adjust 'please do not enter'
 ⍝.k formatting
 ⍝.n rml
 ⍝.t 1992.4.24.14.4.17
 ⍝.v 1.0 / 05jan82
 ⍝.v 2.0 / 05apr88 / change order of <x>, use subroutines
 ⍝.v 2.1 / 24apr92 / using signalerror
 ⍝ x[1] width of result in columns
 ⍝ x[2] width of left margin (i.e. number of blank columns)
 ⍝ x[3] number of blank lines to insert between each row
 ⎕IO←1
 'adjust' checksubroutine '∆dtb split'
 →(2<⍴⍴d)signalerror '/y/adjust rank error/right arg has rank greater than 2'
 d←(¯2↑1 1,⍴d)⍴d
 x←3↑x
 pw←x[1]
 lmrg←x[2]
 ex←x[3]
 ⍝result will have w columns
 w←pw-lmrg
 →(w<1)signalerror '/y/adjust domain error/text width (',(⍕w),') should be greater than 0'
 y←(0,w)⍴''
 i←0
 l1:→((1↑⍴d)<i←i+1)/end
 ⍝remove blanks at end of line
 line←∆dtb d[i;]
 ⍝if line is empty, treat as line (with one blank)
 y←y,[1]w split line,(0=⍴line)⍴' '
 →l1
 end:
 ⍝prepend lmrg blank columns
 y←(((1↑⍴y),lmrg)⍴' '),y
 ⍝insert ex blank lines between each row (except at bottom)
 y←(((-ex)+(1↑⍴y)×1+ex)⍴1,ex⍴0)⍀y
∇

∇Y←Funs after Ts;⎕IO;g∆sort∆columns;B;Tags
 ⍝get all functions in <Funs> with timestamp greater than <Ts>
 ⍝.e 'after' = ,'after' after 1989 1 1
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.23.0.31.11
 ⍝.v 1.0 / 19oct83
 ⍝.v 2.0 / 02may88 / added left argument
 ⍝.v 2.1 / 27mar92 / localized g∆sort∆columns and ⎕IO, simplified conversion
 ⍝<Funs> is namelist of functions
 ⎕IO←1
 Y←0 0⍴''
 Funs←'' ∆box ∆db,' ',Funs
 →L10 ∆if∼0∈⍴Funs
 Funs←⎕NL 3
 L10:
 ⍝-----get functions with non-empty t taglines
 Tags←'t' gettag Funs
 B←∨/Tags≠' '
 ⍝quit if all taglines are empty
 →(∼∨/B)/0
 Tags←B⌿Tags
 Funs←B⌿Funs
 ⍝-----make numeric, compare, and sort
 ⍝assume that all timestamps are well-formed (i.e. each with 6 numbers only)
 Tags←(10000,5⍴100)⊥⍉((1↑⍴Tags),6)⍴⍎,' ',(⍴Tags)⍴(Tags='.')⊖Tags,[0.5]' '
 Ts←(10000,5⍴100)⊥6↑Ts
 Y←(' ',⎕AV)sort(Ts≤Tags)⌿Funs
∇

∇y←amortize w;amortized;debt;i;interest;m;months;payment;rate;⎕IO
 ⍝amortization schedule based on <w> = debt, rate, months
 ⍝.e 1 50000 50625 50000 625 = ,amortize 50000 .15 1
 ⍝.k computation
 ⍝.t 1985.8.8.16.46.11
 ⍝source: adapted from the handbook of techniques (ibm)
 ⍝w[1] debt in total units (e.g. dollars)
 ⍝w[2] rate as yearly interest expressed as fraction
 ⍝       e.g. 10.5 per cent is .15
 ⍝w[3] time period in months
 ⍝<y> is 5 column matrix:
 ⍝(1)period (2)current debt (3)monthly payment (4)amortized (5)debt
 ⎕IO←1
 debt←w[1]
 rate←w[2]÷12
 months←w[3]
 m←(months,5)⍴i←0
 payment←debt×rate÷1-÷(1+rate)⋆months
 l10:→((debt≤0)∨i=1↑⍴m)/end
 i←i+1
 amortized←payment-interest←debt×rate
 m[i;]←i,debt,payment,amortized,interest
 debt←debt-amortized
 →l10
 end:
 y←m
∇

∇y←arabic x;⎕IO;a
 ⍝returns arabic (base 10) equivalent for character roman numeral <x>
 ⍝.e 14 = arabic 'xiv'
 ⍝.k translation
 ⍝.t 1992.3.28.18.15.14
 ⍝.v 1.0 / 04apr88
 ⍝.v 1.1 / 28may92 / signalerror used
 ⎕IO←1
 →(∼(⍴⍴x)∈0 1)signalerror '/y/arabic rank error'
 x←∆db x
 →(∼∧/x∈'ivxlcdm')signalerror '/y/arabic domain error'
 a←(1 5 10 50 100 500 1000)['ivxlcdm'⍳x]
 y←a+.×¯1+2×a≥(a,0)[1+⍳⍴a]
∇

∇r←del array str;⎕IO;mask;p;shape
 ⍝general vector reshape. reshape vector <str> using delimiters <del>
 ⍝.e  2 3 4 = ⍴'/,' array 'fred,2,xx/joe,,zzz'
 ⍝.k reshape
 ⍝.n andreas werder
 ⍝.t 1988.4.8.3.11.42
 ⍝.v 1.0 / 15dec79
 ⎕IO←0
 r←0,(,del)∘.=str
 p←∨⍀((¯1↑⍴r)↑1),[0]r
 r←+\r,[0]∼(¯1,¯1↑⍴r)↑p
 r←r-⌈\p×0 ¯1↓0,r
 shape←1+⌈/r
 mask←(⍳×/shape)∈shape⊥r
 r←((-⍴shape)↑1)↓shape⍴mask\' ',str
∇

∇Z←J bal N;⎕IO;M;T
 ⍝display balance (nesting levels) in lines <J> of function <N>
 ⍝.e 'bal[21]'=7⍴21 bal 'bal'
 ⍝.k programming-tools
 ⍝.t 1992.4.4.14.52.37
 ⍝.v 1.0 / 18apr88
 ⍝.v 2.0 / 04apr92 / switched args, simplified function, using signalerror
 ⎕IO←1
 'bal' checksubroutine 'on balance'
 ⍝ ----- left argument
 →(' '≠1↑0⍴N)signalerror '/Z/bal domain error/right arg not character.'
 →(3≠⎕NC N)signalerror '/Z/bal domain error/(',N,') not a function.'
 M←⎕CR N
 →(0∈⍴M)signalerror '/Z/bal domain error/function (',N,') locked.'
 ⍝ ----- right argument
 J←,J
 →((⌈/J)>¯1+1↑⍴M)signalerror '/bal index error/right arg greater than last line number ',⍕¯1+1↑⍴M
 Z←0 1⍴''
 L10:
 →(0=⍴J)/Lend
 Z←Z on(N,'[',(⍕J[1]),']')on(balance M[1+J[1];])on ' '
 J←1↓J
 →L10
 Lend:
 ⍝remove separator line after last display
 Z←¯1 0↓Z
∇

∇y←balance n;⎕IO;k;km;l;m;ma;mb;t;xt
 ⍝display balance (nesting levels) in text vector <n>
 ⍝.e (2 13⍴'(...)⍴(...),x 5,2   2↑y   ') = balance '(5,2)⍴(2↑y),x'
 ⍝.k formatting
 ⍝.t 1992.4.4.15.15.42
 ⍝.v 1.0 / 18apr88
 ⍝.v 1.1 / 04apr92 / improved arg checking
 ⎕IO←0
 →(0 1∧.≠⍴⍴n)signalerror '/y/balance rank error/right arg not rank 0 or 1.'
 n←,n
 n←(-(' '≠⌽n)⍳1)↓n
 l←n
 k←l=''''
 l[(≠\k)/⍳⍴l]←' '
 ⍝
 t←l∈'(['
 m←(+\t)-+\l∈')]'
 xt←k\(+/k)⍴1 ¯1
 ma←((-1=xt)++\xt)+m-t
 mb←ma-⌊/ma
 ⍝
 km←⌈/mb
 n←(-mb)⊖n,[0](km,⍴n)⍴'.'
 y←(⍴n)⍴((⍳1+km)∘.>mb)⊖n,[¯0.5]' '
∇

∇r←cs base text;⎕IO
 ⍝encodes <text> to an integer using collating sequence <cs>
 ⍝.e 13='abcd' base 'cd'
 ⍝.k translation
 ⍝.t 1992.3.28.18.26.54
 ⍝.v 1.0 / 15jul83
 ⍝.v 1.1 / 15apr88 / matrix argument allowed for <text>
 ⍝,v 1,2 / 28mar92 / signalerror used.
 ⍝each row of <text> will be encoded into an integer
 ⎕IO←1
 →(2<⍴⍴text)signalerror '/r/base rank error'
 r←text
 →(0∈⍴text)/0
 text←(¯2↑1 1,⍴text)⍴text
 ⍝collating sequence <cs> defaults to ⎕AV
 cs←((0∈⍴cs)/⎕AV),(∼0∈⍴cs)/cs
 ⍝allow for unknown characters to be mapped into 1+⍴cs
 r←(1+⍴cs)⊥⍉¯1+cs⍳text
∇

∇y←a beside b;row
 ⍝catenate array <a> to array <b> (maximum rank 2) on last coordinate
 ⍝.e (4 3⍴'abbabba  a  ') = 'aaaa' beside 2 2⍴'b'
 ⍝.k catenation
 ⍝.t 1989.7.23.21.57.52
 ⍝.v 1.1 / 24apr88 (vector treated as 1-column matrix, not 1-row)
 a←(2↑(⍴a),1 1)⍴a
 b←(2↑(⍴b),1 1)⍴b
 row←⌈/1 0 1 0/(⍴a),⍴b
 y←((row,¯1↑⍴a)↑a),(row,¯1↑⍴b)↑b
∇

∇r←sep box1 x;len;m;pos;⎕IO
 ⍝return matrix <r> from vector <x> delimited by separator <sep>
 ⍝.e (3 5⍴'applebettycat  ') = '/' box1 'apple/betty/cat'
 ⍝.k reshape
 ⍝.t 1985.9.22.11.21.22
 ⍝.v 1.1 / 13jul83
 ⍝note: <sep> is a one-character vector specifying separator character
 ⍝      box1 always fills with blank/zero
 ⎕IO←1
 r←0 0⍴x
 →(0∈⍴x)/0
 ⍝sep=separator character; default is blank/zero
 sep←(1 0=0∈⍴sep)/(1↑0⍴x),1↑sep
 ⍝append separator only if no ending separator
 ⍝one trailing sep (e.g. 'apple/betty/cat/') does not make extra line
 x←x,(sep≠¯1↑x)/sep
 pos←(x=sep)/⍳⍴x
 m←⌈/len←¯1+pos-0,¯1↓pos
 r←((⍴len),m)⍴(,len∘.≥⍳m)\(x≠sep)/x
 ⍝note:  append this line to delete 'extra' rows caused by multiple sep
 ⍝ r←(∨/len∘.≥⍳m)/[1]r
∇

∇y←w boxf v;m;⎕IO
 ⍝box fields. <y[i;]> is a field of vector <v> specifed by width <w[i]>
 ⍝.e (3 5⍴'applebettycat  ') = 5 5 3 boxf 'applebettycat'
 ⍝.k reshape
 ⍝.t 1989.7.23.23.32.16
 ⍝.v 1.1 / 14jul83
 ⎕IO←1
 ⍝ensure v has +/w elements, else algorithm fails.
 v←(+/w)↑v
 m←⌈/w
 y←((⍴,w),m)⍴(,w∘.>(⍳m)-⎕IO)\v
∇

∇y←bp x
 ⍝search for 'break points' based on beginning of identical sequences in <x>
 ⍝.e 1 0 1 0 0 1 0 0 0 0 = bp 'aabbbccccc'
 ⍝.k searching
 ⍝.t 1992.3.19.11.48.59
 ⍝.v 1.0 / 18jul83
 ⍝treat vector as n×1 matrix (each element is a row)
 x←(2↑(⍴x),1 1)⍴x
 y←1,¯1↓∨/x≠1⊖x
∇

∇Y←S browse X;⎕IO;C;Flag;I;J;Text
 ⍝list occurrences of string <S> (name or any string) in functions <X>
 ⍝.k programming-tools
 ⍝.n rml
 ⍝.t 1992.4.22.23.12.1
 ⍝.v 1.0 / 22apr92
 ⍝format of search string <S> is: n=string, s=string, string
 ⍝example:  'n=X' browse 'ff'; 'abc' browse 'ff'
 ⍝result <Y> is report showing function lines containing string <S>
 ⎕IO←1
 'browse' checksubroutine 'on ss ssn ∆dtb'
 X←'' ∆box ∆db,' ',X
 ⍝browse type is arbitrary string (s=) or name (n=)
 C←2 2⍴'s=n='
 ⍝compute browse type <Flag> (default is S)
 Flag←1↑(,(C∧.=2↑S)⌿C),'s'
 ⍝remove browse type specification if present
 S←(2×∨/C∧.=2↑S)↓S
 Y←('... browsing with (',Flag,'=',S,')')on ''
 J←0
 L10:
 →((1↑⍴X)<J←J+1)/Lend
 Text←⎕CR X[J;]
 →((3≠⎕NC X[J;]),0∈⍴Text)/Err1,Err2
 ⍝find locations <I> of search string <S> in ravelled <Text>
 ⍝<ssn> and <ss> take vector args. delimiter ⎕AV[1] avoids line run-on.
 →('ns'=Flag)/Ln,Ls
 Ln:I←(,Text,⎕AV[1])ssn S
 →Lsend
 Ls:I←(,Text,⎕AV[1])ss S
 →Lsend
 Lsend:
 ⍝ignore 'not found'. not necessary, confusing when common, report too long
 →(0=⍴I)/L10
 ⍝convert to row numbers (subtract 1, encode, add 1 to rows - ignore columns)
 I←(1+(1+⍴Text)⊤¯1+I)[1;]
 ⍝remove duplicate row numbers
 I←((I⍳I)=⍳⍴I)/I
 ⍝select rows and label with line number
 Text←(⍕((⍴I),1)⍴I-1),' ',Text[I;]
 L30:
 ⍝label result <Text> with function name, search type, and search string
 Y←Y on('... ',X[J;],'  (',Flag,'=',S,')')on Text on 1 0⍴''
 →L10
 Lend:
 ⍝remove trailing blank lines after last Text, and trailing blanks
 Y←∆dtb ¯1 0↓Y
 →0
 Err1:Text←'... not a defined function.'
 →L30
 Err2:Text←'... locked function.'
 →L30
∇

∇Y←catoffun X;g∆sort∆columns;T
 ⍝return categories represented by functions <X>
 ⍝.e 'library-utility' = ,catoffun 'catoffun'
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.23.0.33.25
 ⍝.v 1.0 / 22may85
 ⍝.v 1.1 / 22apr92 / using new version of <sort>
 ⍝<X> is a vector or matrix of function names
 X←'' ∆box ∆db,' ',X
 T←'k' gettag X
 Y←(' ',⎕AV)sort(bp T)⌿T
∇

∇y←cdays n;⎕IO;d;m;p;r
 ⍝convert Gregorian day counts <n> to date format (mm dd yyyy)
 ⍝.e 5 13 1988 = ,cdays 725870
 ⍝.k date
 ⍝.t 1992.4.9.16.47.9
 ⍝.v 1.0 / 17may77
 ⍝.v 2.0 / 09apr92 / changed name from <dates> to <cdays>
 ⍝convert a day count (starting from 1/1/1) to format (mm dd yyyy)
 ⍝assume use of Gregorian calendar from 1/1/1
 ⎕IO←1
 d←,n
 y←(⌊(364+d)÷365.242499999999893)∘.+0 1
 m←(0,[0.0999999999999999778]4 100 400)⊤y
 p←=⌿0=m[2;;;]
 m←(365×y-1)+-⌿m[1;;;],[1]p
 r←d>m[;2]
 d←d-,0 ¯1↓r⌽m
 p←(r⌽p)[;1]
 d←30+d+(d>59+p)×2-p
 m←⌊d÷30.5599999999999916
 d←d-⌊30.5599999999999916×m
 y←((⍴n),3)⍴m,d,0 ¯1↓r⌽y
∇

∇Y←S change X;⎕IO;C;Flag;J;Text;Z
 ⍝change occurrences of Text (name or any string) in functions <X>
 ⍝.k programming-tools
 ⍝.n rml
 ⍝.t 1992.4.22.23.12.51
 ⍝.v 1.0 / 25apr88 / change names only, one function only
 ⍝.v 2.0 / 22apr92 / args switched, name or substring, many functions
 ⍝format of change specification <S> is: n=/old/new, S=/old/new, /old/new
 ⍝example:  'n=/X/y' change 'ff'; '/abc/xyz' change 'ff'
 ⍝result <Y> is summary report of changes
 ⍝underscored variable names to avoid name shadowing
 ⎕IO←1
 'change' checksubroutine 'on sr srn ss ssn'
 X←'' ∆box ∆db,' ',X
 ⍝change type is arbitrary string (s=) or name (n=)
 C←2 2⍴'s=n='
 ⍝compute change type <Flag> (default is 's')
 Flag←1↑(,(C∧.=2↑S)⌿C),'s'
 ⍝remove change type specification if present
 S←(2×∨/C∧.=2↑S)↓S
 ⍝define first line of report
 Y←'... changing with (',Flag,'=',S,')'
 J←0
 L10:
 →((1↑⍴X)<J←J+1)/0
 Text←⎕CR X[J;]
 →((3≠⎕NC X[J;]),0∈⍴Text)/Err1,Err2
 ⍝substitute new Text for old (name or arbitrary substring)
 ⍝<ssn> and <ss> have vector arguments, ⎕AV[1] is line delimiter
 →('ns'=Flag)/Ln,Ls
 Ln:Text←(,Text,⎕AV[1])srn S
 →Lsend
 Ls:Text←(,Text,⎕AV[1])sr S
 →Lsend
 Lsend:
 Z←⎕FX ⎕AV[1]∆box Text
 →(0=1↑0⍴Z)/Err3
 Text←'... ok (',Z,')'
 L30:
 ⍝report with function name and result
 Y←Y on X[J;],' ',Text
 →L10
 Err1:Text←'... not a defined function.'
 →L30
 Err2:Text←'... locked function.'
 →L30
 Err3:Text←'... not changed (⎕FX = ',(⍕Z),')'
 →L30
∇

∇Y←checksize List;⎕IO;Data;I;T
 ⍝return report showing sizes of objects in <List>, sorted by size
 ⍝.e 1=4⍴=⌿checksize 'checksize'
 ⍝.k programming-tools
 ⍝.n rml
 ⍝.t 1989.7.27.23.19.7
 ⎕IO←1
 'checksize' checksubroutine 'vtype'
 Y←⍳0
 →(2=⍴⍴List)/L10
 List←'' ∆box ∆db(,' ',List)
 L10:
 →(0∈⍴List)/0
 I←0
 L20:→((1↑⍴List)<I←I+1)/L20end
 →((2=⎕NC List[I;])∧2≠⎕SVO List[I;])/L20a
 →(3=⎕NC List[I;])/L20b
 ⍝some other object. assign size 0.
 Y←Y,0
 →L20
 L20a:
 Data←⍎List[I;]
 Y←Y,0.125 1 4 8[vtype Data]××/⍴Data
 →L20
 L20b:
 ⍝this is a close-enough approximation for our purposes
 Y←Y,+/' '≠,⎕CR List[I;]
 →L20
 L20end:
 ⍝compute total line and label it
 Y←(+/Y),Y
 List←'-',[1]List
 ⍝sort
 T←⍒Y
 ⍝report
 Y←(⍕((1↑⍴List),1)⍴Y[T]),' ',List[T;]
∇

∇N checksubroutine L;B;F
 ⍝check workspace for subroutines <L> used by function <N>
 ⍝.k programming
 ⍝.t 1988.4.28.1.42.16
 ⍝.v 1.0 / 28apr88
 ⍝.v 2.0 / 03apr92 / function suspends within itself, issues )pcopy message
 ⍝example:  'func' checksubroutine 'f1 f2 f3'
 B←3=⎕NC F←'' ∆box ∆db,' signalerror ',L
 →(∧/B)/0
 ⎕←'... ',N,' subroutine warning'
 ⎕←'... (1) please copy the toolkit functions listed below into this workspace.'
 ⎕←'... (2) resume execution.'
 ⎕←'      )pcopy toolkit ',∆db,' ',(∼B)⌿F
 ⎕←'      →⎕LC'
 ⍝the next line may have to be modified with ⎕stop in this APL system
 s∆checksubroutine←1+1↑⎕LC
 Suspend: ⍝suspend here, copy functions, resume execution here
∇

∇z←cjulian js;c;d;j;k;m;s;y
 ⍝convert Julian day numbers <js> to (mm dd yyyy style)
 ⍝.e (2 4⍴5 12 1988 1 5 17 1977 1) = cjulian 2447294 2443281
 ⍝.k date
 ⍝.t 1992.4.6.2.34.29
 ⍝.v 1.0 / 15apr78
 ⍝<js>
 ⍝   scalar or vector of julian dates
 ⍝   an n×2 array, where js[;1]=julian dates, js[;2]=styles
 js←(2↑(⍴js),1 1)⍴js
 j←js[;⎕IO]
 s←(j>2423434)∨(j>2299171)∧(js,2361221<j)[;⎕IO+1]
 j←j-1684595
 c←⌊j÷36524.25
 j←j+((∼s)×(2-c)+⌈c÷4)-⌈36524.25×c
 y←⌊(j+1)÷365.25024999999988
 j←j+31-⌊365.25×y
 d←j-⌊30.5874999999999915×m←⌊j÷30.5874999999999915
 m←m+2-12×k←⌊m÷11
 z←m,d,(k+y+100×c-1),[⎕IO+0.5]s
∇

∇Y←comments X;⎕IO;M
 ⍝return header and header comments (i.e. initial comments) in function <X>
 ⍝.e 9 = 1↑⍴comments 'comments'
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.16.17.31.3
 ⍝.v 1.0 / 24jul89
 ⍝.v 2.0 / 16apr92 / formerly function <header>
 ⍝underscored variables to avoid shadowed names
 ⎕IO←1
 'header' checksubroutine '∆dtb on'
 →(∼(⍴⍴X)∈0 1)signalerror '/Y/comments rank error/right arg not rank 0 or 1'
 →(3≠⎕NC X)signalerror '/Y/comments domain error/function (',X,') not in workspace.'
 M←⎕CR X
 Y←(∧\M[1;]≠';')/M[1;]
 M←1 0↓M
 Y←∆dtb Y on(∧\M[;1]='⍝')⌿M
∇

∇y←d condense v;b
 ⍝remove redundant blanks and blanks around characters specified in <d>
 ⍝.d 1985.6.20.10.10.10
 ⍝.e 'apple,betty,cat,,dog' = ',' condense '  apple, betty, cat, , dog'
 ⍝.k delete-characters
 ⍝.t 1992.3.10.20.19.23
 ⍝.v 1.1
 ⍝v is character vector (rank 1) only
 ⍝remove leading, trailing, and multiple internal blanks
 y←∆db,v
 ⍝remove blanks around characters specified in <d>
 ⍝e.g. if <d> =<,>, blanks are removed around commas in 'a , b , d'
 b←y∈d
 y←(∼(y=' ')∧(1⌽b)∨¯1⌽b)/y
∇

∇y←d condense1 x;b
 ⍝remove redundant blanks and blanks around characters specified in <d>
 ⍝.d 1985.6.20.10.10.10
 ⍝.e 'apple,''betty  ,  cat'',,dog' = ',' condense1 'apple, ''betty  ,  cat'', , dog'
 ⍝.k delete-characters
 ⍝.t 1992.3.10.20.28.58
 ⍝.v 1.1
 ⍝note: same as condense, but does not remove blanks within quotes
 ⍝remove leading, trailing, multiple internal blanks, but not in quotes
 b←' '≠x←' ',x
 ⍝note: ≠\ is the same as 2|+\
 y←1↓((≠\''''=x)∨b∨1⌽b)/x
 ⍝remove blanks around delimiters, not in quotes
 b←y∈d
 y←((≠\''''=y)∨∼(y=' ')∧(1⌽b)∨¯1⌽b)/y
∇

∇Y←contents X;⎕IO;BL;Heads;How;I;J;Keys;N;Purpose;S;T
 ⍝formatted report of functions <X> by category (with line 1 and header)
 ⍝.e (100⍴'-') ∧.= 100↑(contents '∆box')[2;]
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.16.12.3.17
 ⍝.v 1.0 / 20jul83
 ⍝.v 1.1 / 15may89 / ⎕IO localized, checksubroutine added
 ⍝.v 1.2 / 16apr92 / name changes, simplifications, performance improvements
 ⍝report is useful for any functions (even without category information)
 ⎕IO←1
 'contents' checksubroutine 'bp gettag gradeup on ∆dtb'
 Y←0 1⍴''
 X←'' ∆box ∆db,' ',X
 →(0∈⍴X)/0
 Keys←'k' gettag X
 ⍝first sort by X
 S←'' gradeup X
 X←X[S;]
 Keys←Keys[S;]
 ⍝second sort by Keys (ensure that blank is sorted to the beginning)
 S←(' ',⎕AV)gradeup Keys
 X←X[S;]
 Keys←Keys[S;]
 ⍝now get headers and purpose line for report (in order of X)
 Heads←0 gettag X
 Purpose←1 gettag X
 ⍝clean Heads (remove characters after ';', i.e. list of local variables)
 I←,∧\Heads≠';'
 Heads←(⍴Heads)⍴I\I/,Heads
 ⍝compute breakpoints of Keys
 N←bp Keys
 ⍝for each function determine if how variable is in workspace.
 ⍝then change to ⋆ or blank.
 How←2=⎕NC(((1↑⍴X),3)⍴'how'),X
 How←' ⋆'[1+How]
 ⍝now prepare report
 I←0
 l10:→((⍴N)<I←I+1)/End
 →(∼N[I])/l20
 ⍝print title of category. precede each title by <BL> blank lines
 BL←2
 Y←Y on((BL,0)⍴'')on Keys[I;]on 100⍴'-'
 l20:
 ⍝delete trailing blanks from name of function.
 ⍝extend name to 10 spaces or nearest multiple of 3 if
 ⍝not enough space to fit name
 T←⍴∆dtb X[I;]
 J←10⌈((T+2)>10)×3×⌈(2+T)÷3
 Y←Y on '  ',How[I],' ',(J↑X[I;]),(∆dtb Heads[I;]),'.  ',1↓Purpose[I;]
 →l10
 End:
 ⍝remove blank lines before title of first category
 Y←(BL,0)↓Y
∇

∇Y←contents1 X;⎕IO;How;I;Keys;S
 ⍝quick condensed report of functions <X> by category (with line 1)
 ⍝.e 5=1↑⍴contents1 '∆box ∆db foofunc'
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.16.11.22.1
 ⍝.v 1.0 / 23may85
 ⍝.v 1.1 / 14apr92 / function rewritten, comments clarified, how var ⋆ added
 ⍝report lists (category, function, purpose) sorted by function within category
 ⎕IO←1
 'contents1' checksubroutine 'bp expandbe gettag gradeup on ∆dtb'
 Y←0 0⍴''
 X←'' ∆box ∆db,' ',X
 →(0∈⍴X)/0
 Keys←'k' gettag X
 ⍝sort by function
 S←(' ',⎕AV)gradeup X
 X←X[S;]
 Keys←Keys[S;]
 ⍝sort again by category. (data will be sorted by function within category.)
 S←(' ',⎕AV)gradeup Keys
 X←X[S;]
 Keys←Keys[S;]
 ⍝find break points (beginning of each category)
 I←bp Keys
 ⍝determine if how variable is in workspace. then change to ⋆ or blank.
 How←' ⋆'[1+2=⎕NC(((1↑⍴X),3)⍴'how'),X]
 ⍝now get line 1 (purpose line) and remove leading comment symbol,
 ⍝catenate with function names, and category names without duplicates,
 ⍝insert a blank line before each new category, remove first blank line
 Y←1 0↓(expandbe I)⍀(I⍀I⌿Keys),How,X,' ',0 1↓1 gettag X
∇

∇z←cpucon;ot
 ⍝returns elapsed cpu and connect time since function last executed
 ⍝.e 1 ∆ cpucon
 ⍝.k timing
 ⍝.t 1992.3.28.15.21.51
 ⍝.v 1.0 / 20oct83
 ⍝check for old time (ot)
 ⍎(0=⎕NC 'g∆cpucon∆ot')/'g∆cpucon∆ot←⎕AI'
 ot←g∆cpucon∆ot
 ⍝cpu,connect is ⎕AI[2 3]
 ⍝find cpu and connect since last call
 z←(2↑1↓⎕AI)-2↑1↓ot
 ⍝reset global
 g∆cpucon∆ot←⎕AI
∇

∇y←date
 ⍝return today's date in format (monthname dd, yyyy)
 ⍝.e 1 ∆ date
 ⍝.k date
 ⍝.t 1992.4.9.10.28.25
 ⍝.v 1.0 / 19nov86
 ⍝.v 1.1 / 09apr92 / replace detailed code with call to <fdate>
 'date' checksubroutine 'fdate'
 y←'e' fdate ⎕TS[2 3 1]
∇

∇y←days d;⎕IO;n;p
 ⍝compute Gregorian day count for dates <d> = (mm dd yyyy)
 ⍝.e 725870 = days 5 13 1988
 ⍝.k date
 ⍝.t 1992.4.9.16.30.9
 ⍝.v 1.0 / 17may77
 ⍝.v 1.1 / 09apr92 / using signalerror
 ⍝<d> can be 3-element vector (1 date), or matrix of dates
 ⍝<y> is number of days elapsed from 1/1/1 to <d>
 ⎕IO←1
 d←(¯2↑1 1,⍴d)⍴d
 →(3≠¯1↑⍴d)signalerror '/y/days length error/last coordinate of right arg not equal to 3.'
 n←(0,[0.0999999999999999778]4 100 400)⊤d[;3]
 p←=⌿0=n[2;;]
 n←(365×d[;3]-1)+-⌿n[1;;],[1]p
 y←n+d[;2]+(⌊30.5599999999999916×d[;1])-30+(d[;1]≥3)×2-p
∇

∇y←ddup x
 ⍝delete duplicate elements from vector or matrix <x>
 ⍝.e 'abcd' = ddup 'aabbccddaabb'
 ⍝.k delete-elements
 'ddup' checksubroutine 'first'
 y←(first x)⌿x
∇

∇Y←Code deltag Fns;⎕IO;Fn;I;J;Mat;T
 ⍝delete tag line labelled with <Code> from functions <Fns>
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1989.7.24.18.17.10
 ⍝.v 1.0 / 04nov83
 ⍝.v 1.1 / 24jul89 / error message changes, ⎕IO localized
 ⎕IO←1
 Y←⍳0
 ⍎(2≠⍴⍴Fns)/'Fns←'' '' ∆box ∆db Fns'
 ⍝----- do it for every function
 J←0
 L10:→((J←J+1)>1↑⍴Fns)/End
 Mat←⎕CR Fn←Fns[J;]
 ⍝----- make sure Mat has at least one line
 →((0=1↑⍴Mat)/L15),L0
 ⍝no line. cannot get cr.
 L15:
 ⎕←'...deltag domain error.'
 ⎕←'...cannot get canonical form for ',Fn
 →Blend
 L0: ⍝this Mat has at least one line. search for tag line
 I←Mat[;⍳4]∧.='⍝.',2↑Code
 →(0=∨/I)/L1
 ⍝found it. so remove it and fix function
 T←⎕FX(∼I)⌿Mat
 →(0≠1↑0⍴T)/Lend
 ⎕←'...deltag error'
 ⎕←'...error when fixing function = ',Fn,'  line = ',(⍕T),'  ',Mat[T;]
 →Blend
 L1: ⍝did not find it. so skip it
 →Lend
 Lend:
 Y←Y,1
 →L10
 Blend:
 Y←Y,0
 →L10
 End:
∇

∇describe;⎕IO;x
 ⍝driver menu function for overall description of toolkit workspace
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.27.14.50.40
 ⍝.v 1.0 / 27apr92
 ⎕IO←1
 l10:
 ⎕←' '
 ⎕←howdescribeindex
 x←⎕
 →l10 ∆if 0=(∼x∈0,⍳9)signalerror '//Please enter a listed topic number.'
 →0 ∆if x=0
 ⍝delete potential leading blank (in case APL implementation appends it)
 ⎕←⍎'howdescribe',∆db⍕x
 →l10
∇

∇describe∆cr2lf
 'cr2lf string'
 ' '
 'converts cr (13) characters in string to lf (10). Old APL2'
 'used cr to terminate lines, while GNU APL needs lf (unix'
 'convention).'
∇

∇y←dfh x;⎕IO;n
 ⍝return decimal values of hex numbers <x>
 ⍝.e 10 274 = dfh 2 3⍴'00a112'
 ⍝.k translation
 ⍝.t 1992.4.16.21.9.44
 ⍝.v 1.0 / 00sep85
 ⍝.v 1.1 / 12apr88 / arg checking and reshaping improved
 ⍝.v 1.2 / 16apr92 / signalerror used
 ⍝each hex number is one row of a matrix
 ⍝warning: hex numbers must be zero-padded on the right if necessary
 ⎕IO←0
 →((⍴⍴x)>2)signalerror '/y/dfh rank error/right arg greater than rank 2'
 →(0∈⍴y←x)/0
 x←(¯2↑1 1,⍴x)⍴x
 y←16⊥'0123456789abcdef'⍳⍉x
∇

∇r←rcm dimension m;⎕IO;c;j;k;l;z
 ⍝compute (n-1) dimension array from coordinate/data matrix <m>
 ⍝.k reshape
 ⍝.n dan king
 ⍝.t 1992.4.25.17.36.18
 ⍝.v 1.0 / 23may85
 ⍝.v 1.1 / 25apr92 / using signalerror
 ⍝<m> has (n-1) attribute columns and 1 data column
 ⎕IO←1
 →((¯1↑⍴m)<2)signalerror '/r/dimension length error/last coordinate of right arg < 2'
 →((1↑⍴rcm)≠¯1+¯1↑⍴m)signalerror '/r/dimension length error/left and right args not conformable.'
 c←1
 z←0 1⍴0
 do:
 m←(m[;c]∈rcm[c;])⌿m
 j←rcm[c;]⍳m[;c]
 ⍝
 j←(¯2↑1 1,⍴j)⍴j
 z←(¯2↑1 1,⍴z)⍴z
 k←⌈/(⍴j)[2],(⍴z)[2]
 z←(((1↑⍴z),k)↑z),[1]((1↑⍴j),k)↑j
 ⍝
 →((¯1↑⍴m)≥1+c←c+1)/do
 z←z-1
 z[1↑⍴z;]←z[1↑⍴z;]+1
 j←+/rcm≠0
 k←j⊥z
 l←(×/j)⍴0
 l[k]←(0,¯1+¯1↑⍴m)↓m
 r←j⍴l
∇

∇y←e displayfunction a;⎕IO;b;n;r;z
 ⍝display of canonical matrix <a> using exdents <e>
 ⍝.e 'display'=7↑13↓20⍴4 displayfunction ⎕CR 'displayfunction'
 ⍝.k formatting
 ⍝.t 1992.3.13.20.59.55
 ⍝.v 1.0 / 13may88
 ⍝.v 2.0 / 13mar92 / new left argument, more comments, removed displayfunction1
 ⍝<e> = exdents for comments, branches, labels respectively
 ⎕IO←1
 y←0 0⍴''
 →(0∈⍴a)/0
 a←(¯2↑1 1,⍴a)⍴a
 ⍝compute left argument with defaults (defaults are usual system settings)
 e←e,(×/⍴e)↓1 0,1↑e,1
 ⍝compute location b of labelled lines (contains : not in quotes or comment)
 z←a=':'
 b←∨/z
 b←(a[;1]≠'⍝')∧b\(+/∨\b⌿z)>+/∨\''''=b⌿a
 ⍝compute rotations for comment lines, branch lines, labelled lines
 r←(e[1]×a[;1]='⍝')+(e[2]×a[;1]='→')+e[3]×b
 ⍝compute line numbers and rotations for 1-digit, 2-digit, etc.
 n←¯1+1↑⍴a
 z←n↑((n⌊9)⍴2),(0⌈90⌊n-9)⍴1
 ⍝form the complete function display
 y←((' ',[1]'[',z⌽(3 0⍕(n,1)⍴⍳n),']'),r⌽(((1↑⍴a),⌈/e)⍴' '),a),[1]' '
 y[1,n+2;5]←'∇'
∇

∇r←u dround v;e;n;⎕CT;⎕IO
 ⍝distributive rounding of a vector <v> to arbitrary scalar unit <u>
 ⍝.e (.01 dround +/100.982 100.973 100.966) = +/.01 dround 100.982 100.973 100.966
 ⍝.k computation
 ⍝.t 1989.7.23.22.15.9
 ⎕CT←⎕IO←0
 v←,v÷u
 e←1|v
 n←(⌊0.5++/v)-+/⌊v
 r←u×(⌊v)+n>⍋⍒e
∇

∇z←ds x;⎕IO
 ⍝set of descriptive statistics for data <x>
 ⍝.e 5.5 = (ds ⍳10)[2]
 ⍝.k computation
 ⍝.n k.w.smillie
 ⍝.t 1992.4.14.21.21.1
 ⍝.v 1.0 / 15feb69 / original Statpack2 version slightly modified
 ⎕IO←1
 z←10⍴0
 z[1]←⍴x←x[⍋x]
 z[2]←(+/x)÷z[1]
 z[3]←(+/(x-z[2])⋆2)÷z[1]-1
 z[4]←z[3]⋆0.5
 z[5]←z[4]÷z[1]⋆0.5
 z[6]←(+/|x-z[2])÷z[1]
 z[7]←0.5×+/x[(⌈z[1]÷2),1+⌊z[1]÷2]
 z[8 9]←x[z[1],1]
 z[10]←-/z[8 9]
∇

∇dstat x;z
 ⍝labelled set of descriptive statistics for data <x>
 ⍝.k computation
 ⍝.n k. w. smillie
 ⍝.t 1992.4.14.21.26.39
 ⍝.v 1.0 / 15feb69 / original Statpack2 version slightly modified
 'dstat' checksubroutine 'ds'
 z←ds x
 'sample size.......... ',⍕z[1]
 'mean................. ',⍕z[2]
 'variance............. ',⍕z[3]
 'standard deviation... ',⍕z[4]
 'standard error....... ',⍕z[5]
 'mean deviation....... ',⍕z[6]
 'median............... ',⍕z[7]
 'maximum.............. ',⍕z[8]
 'minimum.............. ',⍕z[9]
 'range................ ',⍕z[10]
∇

∇y←a duparray m;⎕IO;newarray;shape
 ⍝duplicate array <m>.  duplicate <a[1]> times along coordinate <a[2]>
 ⍝.e (2 6⍴'abababcdcdcd') = 3 2 duparray 2 2⍴'abcd'
 ⍝.k reshape
 ⍝.n rml
 ⍝.t 1992.4.25.17.28.1
 ⍝.v 1.0 / 14feb84
 ⍝.v 1.1 / 25apr92 / using signalerror
 ⍝a[2] must be in the range (1,⍴⍴m)
 ⍝note: the algorithm consists of applying <reparray> to
 ⍝ (1,⍴m)⍴m and then reshaping the result.
 ⎕IO←1
 'duparray' checksubroutine 'reparray'
 ⍝default a[2] to last coordinate
 a←2↑a,⍴⍴m
 →(∼(1≤a[2])∧a[2]≤⍴⍴m)signalerror '/y/duparray domain error/coordinate specification (',(⍕a[2]),') outside range (1,',(⍕⍴⍴m),')'
 newarray←a reparray(1,⍴m)⍴m
 shape←×/(⍴m),[1.5](a[2]≠⍳⍴⍴m)+(a[2]=⍳⍴⍴m)×a[1]
 y←shape⍴newarray
∇

∇y←n duparray1 m
 ⍝duplicate array <m>. duplicate <n> times along coordinate 1
 ⍝.e (6 2⍴'abcdabcdabcd') = 3 duparray1 2 2⍴'abcd'
 ⍝.k reshape
 ⍝.n rml
 ⍝.v 1.0 / 10feb84
 ⍝simplified version of duparray which handles first dimension only
 y←((n×1↑⍴m),1↓⍴m)⍴(n,⍴m)⍴m
∇

∇z←easter ys;c;epact;g;n;s;x;y
 ⍝compute date of Easter (mm dd yyyy) for years <ys> = (yyyy style)
 ⍝.e 4 15 1990 = ,easter 1990
 ⍝.k date
 ⍝.t 1992.4.5.23.19.47
 ⍝.v 1.0 / 05may88
 ⍝.v 1.1 / 05apr92 / matrix result in format (mm dd yyyy), signalerror used
 ⍝ys can be a vector of years or an array of years and styles.
 ys←(2↑(⍴ys),1 1)⍴ys
 y←ys[;⎕IO]
 →(y∨.<33)signalerror '/z/easter domain error/Easter was not celebrated before 33 A.D.'
 s←(y>1922)∨(y>1583)∧(ys,1752<y)[;⎕IO+1]
 c←1+⌊0.00999999999999999674×y
 x←s×2-⌊0.75×c
 g←1+19|y
 epact←30|20+(s×10+⌊0.319999999999999896×c-15)+x+11×g
 n←44-epact+s×(epact=24)∨(epact=25)∧g>11
 n←n+30×n<21
 n←n+7-7|n+7|x+⌊1.25×y
 ⍝n[i] represents day of easter within march or april for ys[i;]
 ⍝return decoded matrix with z[i;] in format mm dd yyyy
 z←⍉(3,⍴n)⍴((3×n≤30)+4×n≥31),(1+31|¯1+n),y
∇

∇Y←X example N;⎕IO;B;C;I;L;Name;R;Result;Trace
 ⍝display and execute an example for functions <N>. <X> specifies options.
 ⍝.e '1' = (2 example '∆box')[1;1]
 ⍝.k library-utility
 ⍝.t 1992.4.16.20.11.31
 ⍝.v 1.0 / 12apr88 / terminal output and result of example line of one function
 ⍝.v 2.0 / 15jul89 / first version of example with explicit result
 ⍝.v 3.0 / 16apr92 / combined <test> and <example>, new left arg
 ⍝<example> executes the .e example for each function in the list <N>.
 ⍝<X> specifies options for trace messages and result.
 ⍝X=1 -- display trace, X=2 -- return report, X=3 -- do both, X=0 -- do neither
 ⍝Note two situations:
 ⍝(1) if execution suspends, the function or the example could be wrong.
 ⍝(2) if an error is noted, then something is wrong enough to give an
 ⍝    incorrect result, but not bad enough to cause suspension.
 ⍝in either case, the example in question caused the problem and should be
 ⍝reviewed.  either the example or the function code could be the
 ⍝cause of the problem.  if <example> successfully executed examples for other
 ⍝functions, it is unlikely that there is an error in <example> itself.
 ⎕IO←1
 ⍝check and decode left arg (an encoding of 2-element binary vector)
 X←1↑X,1
 →(∼∧/X∈0,⍳3)signalerror '/Y/example domain error/left arg not a member of 0 1 2 3'
 X←,2 2⊤X
 Trace←X[2]
 Result←X[1]
 ⍝
 Y←0 1⍴''
 N←'' ∆box ∆db,' ',N
 I←0
 L10:
 →((1↑⍴N)<I←I+1)/0
 Name←N[I;]
 ⍝L is blank line if function locked, not found, or no example 'e' found
 L←,'e' gettag Name
 →Skip1 ∆if∼Trace
 ⎕←Name
 →Skip1 ∆if∧/L=' '
 ⍝example text indented 6 positions in apl terminal style
 ⎕←'      ',L
 Skip1:
 →L15 ∆if 3≠⎕NC Name
 →L20 ∆if∧/L=' '
 ⍝execute exampleline.  exampleline should have form: result = expression
 ⍝∧/,examplelline  returns 1 if the expression gives the result we expect
 ⍝if it returns 0 or suspends, check it out!  function or example may be wrong.
 B←⍎L
 →(1 0=∧/,B)/Lok,Lnok
 Lok:
 R←'1: ',L
 C←'... ok'
 →L99
 Lnok:
 R←'0: ',L
 C←'... example returns unexpected result.  review function ',Name
 →L99
 L15:
 R←'9: function ',Name,' not found.'
 C←'... ',3↓R
 →L99
 L20:
 R←'8: no .e example found in ',Name
 C←'... ',3↓R
 →L99
 L99:
 ⍝non-empty explicit result depends on option chosen
 →L100 ∆if∼Result
 Y←Y on R
 L100:
 ⍝do not display ending message if trace is off
 ⍝note: to suppress display of ok ending message, append ∨'1'=1↑R to line
 →L10 ∆if∼Trace
 ⎕←'      ',C
 →L10
∇

∇r←expandaf w
 ⍝<r> is expansion vector to insert <w[i]⍴0> after the i-th position
 ⍝.e 1 0 2 0 0 3 0 0 0 = (expandaf 1 2 3 )\1 2 3
 ⍝.k expansion
 ⍝.t 1988.4.5.18.44.4
 ⍝.v 1.0 / 12may88
 'expandaf' checksubroutine 'expandbe'
 r←¯1↓expandbe 0,w
∇

∇r←expandbe w
 ⍝<r> is expansion vector to insert <w[i]⍴0> before the i-th position
 ⍝.e 0 1 0 0 2 0 0 0 3 = (expandbe 1 2 3 )\1 2 3
 ⍝.k expansion
 ⍝.t 1988.4.5.18.44.4
 ⍝.v 1.0 / 12may88
 r←(⍳⍴w)++\w
 r←(⍳¯1↑r+∼⎕IO)∈r
∇

∇Y←explain X;⎕IO;I
 ⍝explain functions <x>. return how documents for specified functions
 ⍝.e 1 ∆ explain '∆box'
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.1.23.59.18
 ⍝.v 2.0 / 22may85 / first published version
 ⍝.v 2.1 / 14jul89 / revised based on explain and makedoc
 ⍝.v 3.0 / 01apr92 / no longer using <script> and script documents
 ⍝underscored variables to avoid shadowing function names
 ⍝how documents are vectors delimited by returns (<g∆cr>)
 ⎕IO←1
 Y←''
 X←'' ∆box ∆db,' ',X
 I←0
 L10:
 →((1↑⍴X)<I←I+1)/Lend
 →((3≠⎕NC X[I;]),(2≠⎕NC 'how',X[I;]),1)/L2nf,L2nh,L2ok
 L2nf:
 Y←Y,X[I;],': function not in workspace.'
 →L2end
 L2nh:
 Y←Y,X[I;],': how document not in workspace.'
 →L2end
 L2ok:
 Y←Y,⍎'how',X[I;]
 →L2end
 L2end:
 ⍝2 blank lines after each document
 Y←Y,2⍴g∆cr
 →L10
 Lend:
 ⍝remove the two blank lines after last document
 Y←¯2↓Y
∇

∇Buffer←fagl X;⎕IO;B
 ⍝find all global referents in function <X> and functions called by <X>
 ⍝.e '⎕EX'=3⍴fagl 'signalerror'
 ⍝.k programming-tools
 ⍝.t 1992.4.4.13.31.48
 ⍝.v 1.0 / 30jul89
 ⍝.v 1.1 / 04apr92 / improved arg checking and passing to fglr, signalerror used
 ⍝requires ⎕IO←1 because of <gradeup>
 ⎕IO←1
 'fagl' checksubroutine 'fgl fglr global gradeup on ∆rowmem'
 →(0 1∧.≠⍴⍴X)signalerror '/Buffer/fagl rank error/right arg not rank 0 or 1.'
 →(3≠⎕NC X)signalerror '/Buffer/fagl domain error/(',X,') not a function.'
 →(0∈⍴⎕CR X)signalerror '/Buffer/fagl domain error/function (',X,') locked.'
 Buffer←0 0⍴''
 ⍝<fglr> requires matrix argument
 fglr(1,⍴X)⍴X
 Buffer←Buffer['' gradeup Buffer;]
∇

∇z←fcpucon x;a;b;con;cpu;⎕IO
 ⍝format cpu and connect time integers <x>
 ⍝.e 1 ∆ fcpucon cpucon
 ⍝.k timing
 ⍝.t 1989.7.31.9.6.27
 ⍝.v 1.0 / 20oct83
 ⎕IO←1
 cpu←,0 60000⊤x[1]
 con←,0 60000⊤x[2]
 ⍝format minutes to a minimum of two spaces (99)
 a←(-2⌈⍴a)↑a←,⍕cpu[1]
 b←(-2⌈⍴b)↑b←,⍕con[1]
 z←'cpu=',a,' m  ',(6 3⍕cpu[2]÷1000),' s       connect=',b,' m  ',(6 3⍕con[2]÷1000),' s'
∇

∇y←lc fdate t;⎕IO;mo
 ⍝format dates <t> = (mm dd yyyy) as <y> = (monthname dd, yyyy)
 ⍝.e 'november 19, 1986' = ,'e' fdate 11 19 1986
 ⍝.k date
 ⍝.t 1992.4.5.23.15.29
 ⍝.v 1.0 / 19nov86
 ⍝.v 2.0 / 05apr92 / right arg now matrix (mm dd yyyy), added language code
 ⍝<t> is vector or matrix of dates in format (mm dd yyyy)
 ⍝<lc> is language code. 'e'=english, 'f'=french
 ⎕IO←1
 ⍝reshape arg <t> to matrix (possibly one-row)
 t←(¯2↑1 1,⍴t)⍴t
 ⍝check months (for one argument check, this is as good as any!)
 →(∼∧/t[;1]∈⍳12)signalerror '/y/fdate domain error/right arg (month) not in the set ⍳12'
 →(∼lc∈'ef')signalerror '/y/fdate domain error/left arg (language code) not in the set (ef).'
 ⍝define month names in specified language.
 mo←'january/february/march/april/may/june/july/august/september/october/november/december'
 →(lc='e')/next
 mo←'janvier/fevrier/mars/avril/mai/juin/juillet/aout/septembre/octobre/novembre/decembre'
 next:mo←'/' ∆box mo
 ⍝create character matrix, ravel, remove redundant blanks, recreate matrix
 y←'/' ∆box ∆db,mo[t[;⎕IO];],' ',(⍕t[;,⎕IO+1]),',',' ',(⍕t[;,⎕IO+2]),'/'
∇

∇y←fdmy t;⎕IO;mon
 ⍝format dates <t> = (mm dd yyyy) as <y> = (dd mon yy)
 ⍝.e '20 jun 47' = ,fdmy 6 20 1947
 ⍝.k date
 ⍝.n rml
 ⍝.t 1992.4.9.9.18.48
 ⍝.v 1.0 / 31oct83
 ⍝.v 2.0 / 09apr92 / right arg now matrix in format (mm dd yyyy)
 ⎕IO←1
 ⍝reshape arg <t> to matrix (possibly one-row)
 t←(¯2↑1 1,⍴t)⍴t
 ⍝check months (for one argument check, this is as good as any!)
 →(∼∧/t[;1]∈⍳12)signalerror '/y/fdmy domain error/right arg (month) not in the set ⍳12'
 mon←12 3⍴'janfebmaraprmayjunjulaugsepoctnovdec'
 ⍝get last 2 digits of each year (e.g. 1947 is 47). ensure 1-column matrix
 ⍝create character matrix, one row for each date, in new format
 y←(2 0⍕t[;,2]),' ',mon[t[;1];],' ',2 0⍕⍉(100 100⊤t[;3])[,2;]
∇

∇Z←fgl X;T
 ⍝find global referents of function <X>
 ⍝.e '⎕CR' = 3↑(fgl 'fgl')[⎕IO;]
 ⍝.k programming-tools
 ⍝.t 1992.3.27.21.34.19
 ⍝.v 1.0 / 05may88 / first version
 ⍝.v 1.1 / 30jul89 / better right arg checking
 ⍝.v 1.2 / 27mar92 / revised error checking, signalerror used
 'fgl' checksubroutine 'global'
 →(0 1∧.<⍴⍴X)signalerror '/Z/fgl rank error/right arg not rank 0 or 1.'
 →(3≠⎕NC X)signalerror '/Z/fgl domain error/(',X,') not a function.'
 T←⎕CR X
 →(0∈⍴T)signalerror '/Z/fgl domain error/function (',X,') locked.'
 ⍝X must be exactly the name of the function (no blanks)
 Z←((X≠' ')/X)global T
∇

∇fglr X;Y
 ⍝subroutine.  find global referents recursively for objects specified in <X>
 ⍝.k programming-tools
 ⍝.t 1992.4.4.13.44.53
 ⍝.v 1.0 / 30jul89
 ⍝.v 1.1 / 04apr92 / minor changes to arg passing and comments
 ⍝recursive subroutine for <fagl>
 ⍝<X> is always a matrix (possibly empty)
 →(0∈⍴X)/0
 →(1 0=1=1↑⍴X)/L1,L2
 L1:
 ⍝one name
 X←,X
 ⍝global referent may be a variable, not function.  quit now.
 →(3≠⎕NC X)/0
 ⍝global referent may be a locked function.  can't go further. quit now.
 →(0∈⍴⎕CR X)/0
 Y←fgl X
 ⍝if names already on buffer, remove them.
 ⍝this situation occurs if there is a recursive global referent, that is,
 ⍝some function calls another function recursively at some level.
 Y←(∼Y ∆rowmem Buffer)⌿Y
 Buffer←Buffer on Y
 ⍝a recursive step!
 ⍝get global referents for all the global objects found
 fglr Y
 →0
 L2:
 ⍝more than one name
 ⍝a recursive step!
 ⍝ (1) get global referents of first object
 ⍝ (2) get global referents of all the other objects
 fglr X[,⎕IO;]
 fglr 1 0↓X
∇

∇r←fi a;m;⎕IO
 ⍝fix (translate) text input <a> to numeric vector
 ⍝.e 1 2 0 0 123.35 = fi '1 2 1a 3.3.3 123.35'
 ⍝.k translation
 ⍝.n jeffrey multach
 ⍝.t 1989.7.27.23.11.43
 ⍝.v 1.0 / dec80
 ⎕IO←1
 'fi' checksubroutine 'vi'
 r←vi ' ',a
 →(∧/0=r)/0
 ⍝form mask for characters to convert
 m←a≠' '
 m←m>0,¯1↓m
 ⍝mask out and convert valid numbers
 r[r/⍳⍴r]←⍎(≠\m\r[1],(1↓r)≠¯1↓r)/a
∇

∇m←a fibspiral b;c
 ⍝fibonacci spiral. choose neighbouring pairs <a>,<b> from fibonacci series
 ⍝.e (3 5⍴' ○○  ○  ○ ○○  ○ ') = 3 fibspiral 5
 ⍝.k graphics
 ⍝.t 1985.9.20.19.37.50
 ⍝choose <a>,<b> ∈ 1 1 2 3 5 8 13 21 34 ... where a immediately precedes b
 c←'○'
 →(a>1)/l1
 m←1 2⍴c
 →0
 l1:m←(b-a)fibspiral a
 m←⊖⍉m
 m←m,(a,a)⍴c,a⍴' '
∇

∇a←n field m;i;j
 ⍝subroutine for <tower>
 ⍝.k plotting
 ⍝return 'ground' or 'field' for the tower chart
 a←((7×n)+1,17×m)⍴' '
 j←1+i←0
 l1:
 a[1+7×n-i;(i×7)+⍳m×17]←'_'
 →(n≥i←i+1)/l1
 l2:
 a[(7×n)+2-j;j,j+17×⍳m]←'/'
 →((7×n)≥j←j+1)/l2
∇

∇z←m findcoords s;coord;match
 ⍝find coordinates of sequence <s> in matrix <m>
 ⍝.e (6 2⍴1 2 1 3 3 1 4 2 4 3 6 1) = (6 5⍴'applebettypie  ') findcoords 'p'
 ⍝.k searching
 ⍝.t 1989.7.27.22.15.47
 ⍝use outer product to find every occurrence of substring present in matrix.
 ⍝if substring is present, there will be a sequence of 1's in the first
 ⍝dimension, that is, result[1;x;y], result[1;x;y+1], result[1;x;y+2] etc.,
 ⍝will be 1.
 match←(,s)∘.=m
 ⍝the phrase (...)⌽match lines up sequences.  each successive row is
 ⍝rotated one more than the previous row.
 ⍝the phrase ∧⌿ finds if there were any sequences.
 coord←∧⌿(⍉(⌽¯1↓⍴match)⍴-⎕IO-⍳⍴,s)⌽match
 z←⎕IO+⍉(⍴coord)⊤-⎕IO-(,coord)/⍳⍴,coord
∇

∇y←a findut b;z
 ⍝find position of unique truncation <b> in vector <a>
 ⍝.e 4=' apple betty cat boop' findut 'bo'
 ⍝.k searching
 ⍝.n j.p. benyi
 ⍝.t 1992.4.16.20.57.36
 ⍝.v 1.0 / 00xxx74
 ⍝<y> =¯1: not unique; =0: not found; >0: index of <b> in <a>
 ⍝<a> must contain fields each preceeded by a blank: ' xxx xxx xxxxx xx'
 b←,b
 z←(1-⍴b)↓a
 z←(z=1↑b)/⍳⍴z
 z←(a[z+y←¯1]=' ')/z
 z←(a[z∘.+¯1+⍳⍴b]∧.=b)/z
 →(1<⍴z)/0
 y←' '+.=(1↑z)↑a
∇

∇y←first x
 ⍝first occurrence of elements in scalar, vector or matrix <x>
 ⍝.e 1 1 1 0 0 0 = first 6 5⍴'applebettycat  '
 ⍝.k searching
 ⍝.t 1992.4.3.17.28.14
 ⍝.v 1.0 / 07apr88
 ⍝.v 1.1 / 03apr92 / improved comments, signalerror used, scalar arg allowed
 →(0 1 2∧.≠⍴⍴x)signalerror '/y/first rank error'
 →(0 1 2=⍴⍴x)/l1,l1,l2
 l1:
 ⍝ for vectors this is the often-used algorithm (x←,x allows scalar case)
 x←,x
 y←(x⍳x)=⍳⍴x
 →0
 l2:
 ⍝ x∧.=⍉x   compute comparison matrix
 ⍝     <⍀   turn off all 1's after first 1 in each column.
 ⍝          (first 1 in row i indicates x[i;] is first occurrence).
 ⍝          (all 1's after first 1 indicate second, etc. occurrence).
 ⍝     ∨/   select all rows containing a 1.
 ⍝ y[i]=1   indicates that x[i;] is first occurrence
 y←∨/<⍀x∧.=⍉x
 →0
∇

∇y←fisodate t;⎕IO
 ⍝format dates <t> = (mm dd yyyy) as <y> = (yyyy-mm-dd)
 ⍝.e '1992-04-09' = ,fisodate 4 9 1992
 ⍝.k date
 ⍝.t 1992.4.9.9.58.55
 ⍝.v 1.0 / 22sep85
 ⍝.v 2.0 / 09apr92 / added matrix right arg, name change (isodate->fisodate)
 ⍝iso format is yyyy-mm-dd, with leading zeros if necessary
 ⎕IO←1
 ⍝reshape arg <t> to matrix (possibly one-row)
 t←(¯2↑1 1,⍴t)⍴t
 ⍝check months (for one argument check, this is as good as any!)
 →(∼∧/t[;1]∈⍳12)signalerror '/y/fisodate domain error/right arg (month) not in the set ⍳12'
 y←(4 0⍕t[;,3]),'-',(2 0⍕t[;,1]),'-',2 0⍕t[;,2]
 ⍝replace spaces by zeros everywhere in matrix
 y←(⍴y)⍴(' '=y)⊖y,[0.5]'0'
∇

∇y←fixuparray data;⎕IO
 ⍝return character matrix representation of array <data>
 ⍝.e (5 2⍴'abcd  abcd') = fixuparray 2 2 2⍴'abcd'
 ⍝.k formatting
 ⍝.n rml
 ⍝.t 1992.3.19.3.32.14
 ⍝.v 1.0 / 23may85
 ⍝.v 1.1 / 04apr88 / remove trailing blank row
 ⍝.v 1.2 / 19mar92 / clarify comments and replace <matrix> with statement
 ⎕IO←1
 y←⍕data
 →(0 1 2=⍴⍴y)/l10,l10,end
 ⍝y has rank 3 or greater. append blank row to each plane of y.
 y←y,[¯1+⍴⍴y]' '
 ⍝reshape y to the equivalent matrix (this is the algorithm of <matrix>)
 y←((×/¯1↓⍴y),¯1↑1,⍴y)⍴y
 ⍝drop trailing blank row
 y←¯1 0↓y
 →end
 l10:y←(¯2↑1 1,⍴y)⍴y
 end:
∇

∇Y←E fnlist T;⎕IO;I;Name;Text
 ⍝function lister. display functions in list <T> using spacing parameters <E>
 ⍝.k programming-tools
 ⍝.t 1992.4.4.11.50.32
 ⍝.v 2.0 / 20sep85
 ⍝.v 2.1 / 02may88 / spacing between functions in report changed
 ⍝.v 2.2 / 04apr92 / ⎕ output changed to explicit result, left arg added
 ⍝<T> namelist of functions
 ⍝<E> (1) lines between functions, (2)- parameters for <displayfunction>
 ⍝example:  '' fnlist 3  ⍝display all functions in workspace using defaults
 ⎕IO←1
 ⍝default E[1]=1; let <displayfunction> compute its own defaults if needed
 E←E,(×/⍴E)↓1
 Y←0 0⍴''
 ⍝ Text is list of <fnlist> subroutines used twice below
 'fnlist' checksubroutine Text←'displayfunction gradeup on ∆rowmem'
 T←'' ∆box ∆db,' ',T
 →(∼0∈⍴T)/Lnext
 ⍝ get list of ⎕NL 3 and remove all <fnlist> toolbox functions from list
 Text←'' ∆box Text,' fnlist checksubroutine signalerror ∆box ∆db'
 T←⎕NL 3
 T←(∼T ∆rowmem Text)⌿T
 Lnext:
 ⍝ sort function list
 T←T['' gradeup T;]
 ⍝ display all functions in list
 I←0
 L1:
 →((1↑⍴T)<I←I+1)/Lend
 Text←⎕CR Name←∆db T[I;]
 →((3≠⎕NC Name),(0∈⍴Text),1)/L2nf,L2nd,L2f
 L2nf:Text←'... name (',Name,') not a function.'
 →L2end
 L2nd:Text←'... function (',Name,') not displayable (probably locked).'
 →L2end
 L2f:Text←(1↓E)displayfunction Text
 →L2end
 L2end:
 ⍝ append specified number of blank lines after each function listing
 Y←Y on Text on(E[1],0)⍴''
 →L1
 Lend:
 ⍝ remove appended blank lines after last function
 Y←(-E[1],0)↓Y
∇

∇y←frame x
 ⍝frame (i.e. surround) an array <x> with a character
 ⍝.k library-utility
 ⍝.t 1992.3.10.20.44.14
 y←'(',x,')'
∇

∇t←ftime ts;⎕IO
 ⍝return time of day <ts> (⎕TS format) in format hh:mm:ss (am/pm)
 ⍝.e '06:20:21 am' = ftime 6 20 21
 ⍝.k time
 ⍝.t 1992.4.22.22.14.5
 ⍝.v 1.0 / 31oct83
 ⍝.v 1.1 / 22apr92 / clarified comments
 ⎕IO←1
 ⍝ts[1 2 3] = hh mm ss
 ⍝change ts[1] to t[1 2] where t[1]=0(morning) or 1(afternoon)
 ⍝and t[2]=0 to 11 hours in morning or afternoon.
 t←(2 12⊤ts[1]),ts[2 3]
 ⍝change hour 0 to 12 (12 noon or 12 midnight).
 t[2]←t[2]+12×t[2]=0
 t←1+10,(2,6⍴10)⊤(⍳0)⍴100⊥t
 ⍝format minutes and seconds with zeros before single-digit numbers
 t←'0123456789:'[t[3 4 1 5 6 1 7 8]],' ','ap'[t[2]],'m'
∇

∇Y←N funsincat X;⎕IO;g∆sort∆columns;B;Keys;Rc
 ⍝list of functions in <n> belonging to categorys specified in <x>
 ⍝.e 'funsincat' ∧.= ('funsincat' funsincat 'library-utility')[1;]
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.23.0.51.34
 ⍝.v 1.0 / 22may85
 ⍝.v 2.0 / 02may88 / added left argument
 ⍝.v 2.1 / 23apr92 / sort blank first, internal rewrite, enhanced right arg
 ⍝<X> is one wildcard name specification for the category names
 ⍝<N> is namelist of functions
 ⎕IO←1
 'funsincat' checksubroutine 'gettag gradeup on sort vnames wildcard ∆dtb'
 ⍝empty N defaults to ⎕NL 3 (since ⎕NL 3 and maybe N are large matrices, use ⍎)
 ⍝N all blanks will become empty
 N←'' ∆box ∆db,' ',⍎((0∈⍴N)/'⎕NL 3'),(∼0∈⍴N)/'N'
 Rc←vnames X←∆db,' ',X
 →(1≠⍴Rc)signalerror '/Y/funsincat domain error/right arg contains more than one name specification.'
 →(0∈Rc)signalerror '/Y/funsincat domain error/right arg contains invalid wildcard specification.'
 Y←0 0⍴''
 →(0∈⍴N)/0
 Keys←'k' gettag N
 ⍝B[i]=1 means the .k tag-line for function i is non-blank
 B←' '∨.≠⍉Keys
 →(∼∨/B)/0
 ⍝sort the functions whose .k key belongs to list <X>
 ⍝consider only non-blank keys to avoid unnecessary computation
 ⍝ensure blank comes first in collating sequence when sorting function names
 ⍝all columns will be sorted
 Keys←B⌿Keys
 N←B⌿N
 Y←(' ',⎕AV)sort ∆db(Keys wildcard X)⌿N
∇

∇Y←X gettag M;⎕IO;Cr;I;L;Tag
 ⍝get line containing tag X (or line X if numeric) for functions in M
 ⍝.e  'library-utility' = ,'k' gettag 'gettag'
 ⍝.k library-utility
 ⍝.t 1992.3.30.1.12.22
 ⍝.v 1.0 / 28apr88
 ⍝.v 1.1 / 24jul89 / ensure cr has sufficient columns for processing
 ⍝.v 1.2 / 30mar92 / return last occurrence of a tag line (esp for v tags)
 ⎕IO←1
 'gettag' checksubroutine 'on ∆dtb'
 Y←0 0⍴''
 M←'' ∆box ∆db,' ',M
 ⍝compute actual tag phrase (⍝.k  ⍝.n  ... ) allow for numeric X
 Tag←'⍝.',(⍕X),' '
 L1:→(0∈⍴M)/End
 Cr←⎕CR M[1;]
 →(∼0∈⍴Cr)/Lok
 ⍝return blank line if function not found or locked
 L←' '
 →L10
 Lok:
 ⍝do special processing for numeric X
 →(0=1↑0⍴X)/Tagn
 ⍝----- search for position of (last occurrence of) Tag line
 ⍝Cr may not have sufficient columns.  extend using ↑
 ⍝editor's note:  the next line is a good line to inspect using <bal>!
 I←(⌽<\⌽(((1↑⍴Cr),⍴Tag)↑Cr)∧.=Tag)⍳1
 →(1 0=I≤1↑⍴Cr)/L03,L04
 L03:L←4↓Cr[I;]
 →L10
 L04:L←' '
 →L10
 ⍝----- get line X
 Tagn:
 ⍝does canonical form contain line X? (refer to header as line X=0)
 →(1 0=(1↑⍴Cr)≥1+X)/L06,L05
 L05: ⍝this function does not have line X
 L←' '
 →L10
 L06:L←Cr[1+X;]
 →L10
 ⍝----- append tagline L to matrix of tag lines
 L10:
 Y←Y on L
 M←1 0↓M
 →L1
 End:
 Y←∆dtb Y
 ⍝if Y is empty, then extend Y with a column of blanks
 Y←((1↑⍴Y),(1 0=0∈⍴Y)/1,¯1↑⍴Y)↑Y
∇

∇Y←getvtag M;⎕IO;Cr;Tag
 ⍝get tag lines identified by .v for function <M>
 ⍝.e  1=1⍴⍴getvtag 'getvtag'
 ⍝.k library-utility
 ⍝.t 1992.4.16.21.57.39
 ⍝.v 1.0 / 16apr92
 ⎕IO←1
 Y←0 0⍴''
 Tag←'⍝.v '
 Cr←⎕CR M
 ⍝return empty if function not found or locked
 →(0∈⍴Cr)/0
 ⍝Cr may not have sufficient columns.  extend using ↑
 Y←∆db 0 4↓((((1↑⍴Cr),4)↑Cr)∧.=Tag)⌿Cr
∇

∇g←f global m;⎕IO;b;l;w;x
 ⍝global referents in canonical form <m> of function <f>
 ⍝.e '⎕CR'=3⍴'fgl' global ⎕CR 'fgl'
 ⍝.k programming-tools
 ⍝.n roger hui
 ⍝.t 1988.4.30.18.24.1
 ⍝.v 1.0 / jun80
 ⎕IO←1
 g←',',m
 l←g[1;]
 l←(-+/∧\⌽l∈' ')↓l
 x←⌽(¯1+l⍳';')↑l
 l[(⍳⍴f)+(⍴x)-(⍴f)+(' '∈x)×x⍳' ']←' '
 b←≠\g∈''''
 b←b⍱∨\b<g∈'⍝'
 l←l,';⎕;',(,⌽∨\⌽b∧g∈':')/,g
 w←' ⎕abcdefghijklmnopqrstuvwxyz∆ABCDEFGHIJKLMNOPQRSTUVWXYZ⍙0123456789'
 g←l,(1↓⍴g)↓(,b)/,g
 x←g∈1↓w
 g←1↓(x∨1⌽x)/g
 f←(∼b←g∈1↓w)/⍳⍴g
 x←¯1+⌈/f←(f,1+⍴g)-0,f
 g←((⍴f),x)⍴(,f∘.>⍳x)\b/g
 b←⍳1↑⍴g←(g[;1]∈¯10↓w)⌿g
 l40:
 b←b[⍋w⍳g[b;x]]
 →(×x←x-1)⍴l40
 g←g[b;]
 f←l∈1↓w
 g←((b>f+.>1⌽f)∧∨/g≠¯1⊖g)⌿g
 g←(' '∨.≠g)/g
∇

∇y←cs gradeup m;⎕IO;c;i
 ⍝gradeup vector for character <m> based on collating sequence <cs>
 ⍝.e 4 3 2 1 = '' gradeup 4 5⍴'dog  cat  bettyapple'
 ⍝.k sorting
 ⍝.t 1992.4.14.22.2.49
 ⍝.v 1.0 / 15sep85
 ⍝.v 1.1 / 27jul89 / rank error check, minor name changes
 ⍝.v 1.2 / 14apr92 / signalerror used
 ⍝sorts vector or matrix <m> column by column
 ⎕IO←1
 y←⍳0
 →(0∈⍴m)/0
 →(∼(⍴⍴m)∈1 2)signalerror '/y/gradeup rank error/right arg not rank 1 or 2'
 cs←((0=×/⍴cs)/⎕AV),(0≠×/⍴cs)/cs
 ⍝a vector is treated as a one-column matrix
 m←(2↑(⍴m),1 1)⍴m
 ⍝assign columns on which to sort (sort on last column first)
 c←⌽⍳¯1↑⍴m
 ⍝this algorithm sorts the indices, not the complete matrix
 y←⍳1↑⍴m
 i←0
 l10:
 →((1↑⍴c)<i←i+1)/0
 y←y[⍋cs⍳m[y;c[i]]]
 →l10
∇

∇y←cs gradeup1 m
 ⍝gradeup vector for character <m> based on collating sequence <cs>
 ⍝.e 4 3 2 1 = '' gradeup1 4 5⍴'dog  cat  bettyapple'
 ⍝.k sorting
 ⍝.t 1989.7.27.22.47.57
 ⍝encode each row as an integer, then grade up
 'gradeup1' checksubroutine 'base'
 →(∼(⍴⍴m)∈1 2)/err1
 y←m
 →(0∈⍴m)/0
 ⍝the following line allows for scalar <cs>
 cs←((0∈⍴cs)/⎕AV),(∼0∈⍴cs)/cs
 ⍝treat vector <m> as n×1 matrix
 y←⍋cs base(2↑(⍴m),1 1)⍴m
 →0
 err1:
 ⎕←'gradeup1 rank error'
∇

∇gf←codes grafd x;ax;c;n;pds;s;y;⎕IO
 ⍝histogram of data <x> specified by <codes>
 ⍝.e 19 24 = ⍴16 4 grafd 20 22 24 19 15 16 14 30 15 19 26 24
 ⍝.k plotting
 ⍝.n eike kaiser
 ⍝.v 1.0 / 12 may 83
 ⍝codes[1] c = number of cells to be used along y axis
 ⍝codes[2] pds = periods per cycle in data
 ⎕IO←1
 n←1
 c←codes[1]
 pds←codes[2]
 l1:
 y←⌈((⌈/x)-⌊/x)÷c
 →(y>1)/l2
 x←x×10
 n←n×10
 →l1
 l2:
 s←(⌊/x)+(-y)+y×⍳c+1
 gf←⊖((c+1),⍴x)⍴(,s∘.≤x)\'⎕'
 s←s÷n
 s←⊖12 2⍕((⍴s),1)⍴s
 ax←(1↓⍴gf)⍴⌽¯1↓'○',pds⍴'-'
 gf←ax,[1]gf,[1]ax
 s←'∘',[1](((1↑⍴s),-+/∨/[1]s≠' ')↑s),[1]'∘'
 gf←(s,' '),gf,' ',s
∇

∇y←n hfd d;⎕IO
 ⍝return hex equivalent of integers <d> to <n> hex positions
 ⍝.e (1 3⍴'011') = 3 hfd 17
 ⍝.k translation
 ⍝.t 1988.4.12.19.49.28
 ⎕IO←0
 →((⍴⍴d)>1)/err1
 d←,d
 y←⍉'0123456789abcdef'[(n⍴16)⊤d]
 →0
 err1:⎕←'hfd rank error'
∇

∇y←hist x
 ⍝simple histogram of data vector <x>
 ⍝.e 10 10 = ⍴hist ⍳10
 ⍝.k plotting
 y←'⎕ '[1+(⌽⍳⌈/x)∘.≥x]
∇

∇r←jc x
 ⍝justify centre: centre all rows of left-justified character array <x>
 ⍝.e (2 6⍴'  ab    cd  ') = jc 2 6⍴'ab    cd    '
 ⍝.k formatting
 r←(-⌊0.5×+/∧\' '=⌽x)⌽x
∇

∇r←jl x
 ⍝justify left: justify character array <x>
 ⍝.e (2 6⍴'ab    cd    ') = jl 2 6⍴'ab    cd    '
 ⍝.k formatting
 r←(+/∧\' '=x)⌽x
∇

∇r←jr x
 ⍝justify right: justify character array <x>
 ⍝.e (2 6⍴'    ab    cd') = jr 2 6⍴'ab    cd    '
 ⍝.k formatting
 r←(-+/∧\⌽' '=x)⌽x
∇

∇z←julian date;c;d;jf;m;s;y
 ⍝compute Julian day number for dates <date> = (mm dd yyyy style)
 ⍝.e 2443281 2447295 = julian 2 3⍴5 17 1977 5 13 1988
 ⍝.k date
 ⍝.t 1992.4.6.2.35.28
 ⍝.v 1.0 / 17may77
 ⍝<date> = n×3 matrix (or n×4 matrix where date[;⎕IO+3] is optional style)
 ⍝       = 3-(or 4) element vector (treated as 1-row matrix)
 date←(¯2↑1,⍴date)⍴date
 m←date[;⎕IO]
 d←date[;1+⎕IO]
 y←date[;2+⎕IO]
 z←100⊥y,[⎕IO]m,[⎕IO-0.5]d
 s←(z>19230114)∨(z>15821025)∧(date,z>17520902)[;3+⎕IO]
 jf←2≥m
 c←(2×∼s)+0.75×s×⌊0.00999999999999999674×y-jf
 z←31+d+(⌊367×jf+(m-2)÷12)-⌈c-⌊365.25×4712+y-jf
∇

∇loop x;i;m;n
 ⍝perform computations for each element (or row) of <x>
 ⍝.k programming-tools
 ⍝.t 1992.3.18.11.57.1
 ⍝reshape vector to matrix
 m←(2↑(⍴x),1 1)⍴x
 ⍝if needed, line to reshape character namelist to matrix is below
 ⍝   m←'' ∆box ∆db,' ',x
 n←1↑⍴m
 i←0
 l1:
 →(n<i←i+1)/lend
 ⍝ --- insert computations using m[i;] here
 →l1
 lend:
∇

∇y←pw matacross m;cols;mat;rows
 ⍝format matrix <m> in columns across a page of width <pw>
 ⍝.e ' apple betty' = (15 matacross '/' ∆box 'apple/betty/cat/dog')[⎕IO;]
 ⍝.k formatting
 ⍝.t 1989.7.24.22.5.52
 ⍝.v 1.0 / 26jan84
 ⍝.v 2.0 / 05may88 / added left argument
 pw←pw,(×/⍴pw)↓⎕PW
 mat←' ',⍕m
 rows←⌈(1↑⍴mat)÷cols←⌊pw÷¯1↑⍴mat
 y←(rows,cols×¯1↑⍴mat)⍴((rows×cols),¯1↑⍴mat)↑mat
∇

∇y←a matdown m;⎕IO;cols;mat;rows;w
 ⍝format matrix <m> in columns down a page according to <a>
 ⍝.e 'apple  cat  '=12⍴15 2 matdown '/' ∆box 'apple/betty/cat/dog'
 ⍝.k formatting
 ⍝.t 1988.4.24.22.9.20
 ⍝.v 1.2 / 5nov83
 ⍝ a[1]=width of page(:⎕PW),  [2]=spaces between columns(:1)
 ⎕IO←1
 ⍝get defaults for a
 a←a,(×/⍴a)↓⎕PW,1
 ⍝compute as though there are a[2] extra spaces on right
 w←+/a
 mat←(⍕m),((1↑⍴m),a[2])⍴' '
 ⍝do 1⌈ to prevent cols=0 if w is specified too small
 rows←⌈(1↑⍴mat)÷cols←1⌈⌊w÷¯1↑⍴mat
 mat←2 1 3⍉(cols,rows,¯1↑⍴mat)⍴((rows×cols),¯1↑⍴mat)↑mat
 mat←((1↑⍴mat),×/1↓⍴mat)⍴mat
 ⍝now drop trailing blank columns on right
 y←(0,-a[2])↓mat
∇

∇y←matrix x
 ⍝reshape any array <x> (rank 0 - n) to a matrix
 ⍝.e 6 2 = ⍴matrix 3 2 2 ⍴'a'
 ⍝.k reshape
 ⍝.t 1992.3.18.11.11.30
 ⍝.v 1.0 / 20sep85 / first version
 ⍝.v 1.1 / 18mar92 / simplified computation of first dimension of result
 ⍝compute a=product of all dimensions except last (=1 if x is scalar or vector)
 ⍝compute b=last dimension (=1 if x is scalar)
 ⍝shape of result is (a,b)
 y←((×/¯1↓⍴x),¯1↑1,⍴x)⍴x
∇

∇r←mdyoford x;⎕IO;d;day;leap;m;md;month;n;year
 ⍝compute the (mm dd yyyy) format for ordinal dates <x>
 ⍝.e 5 12 1988 = ,mdyoford 88133
 ⍝.k date
 ⍝.t 1988.5.11.23.58.2
 ⍝.v 1.1 / 11may88 / corrected and enhanced version of <jul2ymd>
 ⎕IO←1
 md←0 31 59 90 120 151 181 212 243 273 304 334
 n←⍴x←,x
 d←1000 1000⊤x
 year←1900+d[1;]
 ⍝compute leap year flag for each x[i]
 leap←(0=400|year)∨(0=4|year)∧(0≠100|year)
 ⍝add 1 to months after february if leap year
 m←md[1],md[2],leap∘.+md[2↓⍳12]
 ⍝month of each x[i]
 month←+/(⍉(12,n)⍴d[2;])>m
 ⍝ ----- month day of each element in d[2;]
 ⍝md[month] is number of days in year up to beginning of month <month>.
 ⍝adjust <day> (days in this month) if d[2;] (ordinal date) is in march
 ⍝or greater in a leap year.
 day←d[2;]-md[month]+leap×month≥3
 ⍝return year,month,day as n÷3 matrix
 r←⍉(3,n)⍴month,day,year
∇

∇r←moonphase d
 ⍝compute phase of moon <r> for dates <d> = (mm dd yyyy style)
 ⍝.e 1 ∆ moonphase 1989 7 27
 ⍝.k date
 ⍝.t 1992.4.6.1.14.56
 ⍝.v 1.0 / 15apr78
 ⍝<d> is vector (1 date), or matrix of dates (passed to <julian>)
 ⍝<r> 0 is new moon, .5 is full moon, .75 is last quarter, etc.
 'moonphase' checksubroutine 'julian'
 r←1|÷29.530589999999993÷¯9+julian d
∇

∇Nly←Nls nl Nlc;⎕IO
 ⍝namelist of functions or variables <Nlc> within specification <Nls>
 ⍝.e 'nl' ∆rowmem 'm-p' nl 3
 ⍝.k programming-tools
 ⍝.t 1992.3.8.11.18.0
 ⍝.v 1.0 / 27jul89
 ⍝.v 1.1 / 02mar92 / localized ⎕IO, definition of right arg changed
 ⍝.v 1.2 / 06mar92 / replace matdown with matacross for formatting output
 ⍝.v 1.3 / 08mar92 / specify gradeup collating sequence to put blank first
 ⎕IO←1
 'nl' checksubroutine 'gradeup matacross pick range vnames wildcard'
 →(0∈vnames Nls)signalerror '/Nly/nl domain error/left arg contains invalid name specification.'
 Nly←⎕NL|Nlc
 ⍝sort after picking from objects
 Nly←(Nly pick Nls)⌿Nly
 Nly←∆db Nly[(' ',⎕AV)gradeup Nly;]
 ⍝reformat if at least one of Nlc is negative
 →(∼¯1∈×Nlc)/0
 Nly←'' matacross Nly
∇

∇y←a on b;col;⎕IO
 ⍝catenate array <a> to array <b> (maximum rank 2) on first coordinate
 ⍝.e (3 4⍴'aaaabb  bb  ') = 'aaaa' on 2 2⍴'b'
 ⍝.k catenation
 ⍝.t 1989.7.23.21.59.7
 ⍝note: (0 1⍴''),[1]2 1⍴'a'  same as  (0 1⍴'') on 2 1⍴'a'
 ⍝note: '',[1]1 0⍴'a' same as '' on 1 0⍴'a'
 ⎕IO←1
 a←(¯2↑1 1,⍴a)⍴a
 b←(¯2↑1 1,⍴b)⍴b
 col←⌈/0 1 0 1/(⍴a),⍴b
 y←(((1↑⍴a),col)↑a),[1]((1↑⍴b),col)↑b
∇

∇y←ordofmdy d;⎕IO;day;leap;md;month;year
 ⍝compute the ordinal format for dates <d> = (mm dd yyyy)
 ⍝.e 92061 = ordofmdy 3 1 1992
 ⍝.k date
 ⍝.t 1992.4.14.16.1.27
 ⍝.v 1.0
 ⍝.v 1.1 / 14apr92 / using signalerror, simplified function
 ⍝<d> can be a 3-element vector, or a matrix of dates
 ⍝ordinal date format is (yyddd). e.g. 85036 means 36th day of 1985
 ⎕IO←1
 d←(¯2↑1 1,⍴d)⍴d
 →(3≠¯1↑⍴d)signalerror '/y/ordofmdy length error/last coordinate of right arg not 3'
 ⍝md[i]+1 is first ordinal day of month[i]
 md←0 31 59 90 120 151 181 212 243 273 304 334
 month←d[;1]
 day←d[;2]
 year←d[;3]
 ⍝To compute leap year:
 ⍝   non-century years -- must be evenly divisible by 4
 ⍝       century years -- must be evenly divisible by 400
 ⍝in other words -- every 4 years, except only every 4 century years
 leap←(0=400|year)∨(0=4|year)∧(0≠100|year)
 ⍝add 1 if month[i] is in march or later and year is a leap year
 y←1000⊥(100|year),[0.5]day+md[month]+leap×month≥3
∇

∇out x;i;sink
 ⍝put text <x> to output device
 ⍝.k output
 ⍝.t 1992.4.25.21.9.3
 →g∆outf/skip
 g∆outh←g∆outf←1
 outheader
 skip:
 →g∆outh/skip01
 g∆outh←1
 outheader
 skip01:
 x←(¯2↑1 1,⍴x)⍴x
 i←0
 l0:→((1↑⍴x)<i←i+1)/0
 →(g∆outline<g∆outlimit)/ok
 ⍝too many lines. go to new page and print header
 outpage
 g∆outh←1
 outheader
 ok:
 g∆outline←g∆outline+1
 →(g∆outdevice='afptz')/a,f,p,t,z
 a:
 g∆outbuffer←g∆outbuffer on x[i;]
 →l0
 f:
 g∆outbuffer←g∆outbuffer on x[i;]
 →l0
 p:
 ⍝⎕←g∆outpagechar,(132⌊⍴x[i;])↑x[i;]
 g∆outpagechar←' '
 →l0
 t:
 ⎕←⎕PW↑x[i;]
 →l0
 z:
 ∆out x[i;]
 →l0
∇

∇outclose;sink
 ⍝close output device
 ⍝.k output
 ⍝.t 1989.7.30.15.44.8
 →(g∆outdevice='afptz')/a,f,p,t,z
 a:
 ⍝pad with blank lines if last page is partially full
 →(g∆outline=0)/a10
 g∆outbuffer←g∆outbuffer,[1]((g∆outlimit-g∆outline),¯1↑⍴g∆outbuffer)⍴' '
 a10:
 ⍝reshape buffer to rank-3 array (each plane is a page)
 g∆outbuffer←(((1↑⍴g∆outbuffer)÷g∆outlimit),g∆outlimit,¯1↑⍴g∆outbuffer)⍴g∆outbuffer
 ⍝define array.  important not to choose a name that is shadowed
 ⍎g∆outname,'←g∆outbuffer'
 →lend
 f:
 ⍝define component for text on last page (if any)
 →(g∆outline=0)/lend
 ⍎g∆outname,(⍕g∆outpageno),'←g∆outbuffer'
 →lend
 p:
 ⍝close printer as required (insert code here)
 →lend
 t:
 ⍝print ready text unless last page is empty
 →(g∆outline=0)/lend
 ⍞←g∆outreadytext
 sink←⍞
 →lend
 z:
 ⍝close as already defined for this device
 ∆outreset
 →lend
 lend:
 sink←⎕EX 'g∆outbuffer'
 ⍝if desired ⎕EX various other 'g∆out' variables here
∇

∇outheader
 ⍝print header
 ⍝.k output
 ⍎g∆outheader
∇

∇header outopen x;parms
 ⍝open output device specified by <x>. use heading function <header>
 ⍝.k output
 ⍝.t 1992.4.25.21.8.51
 ⍝note: if heading feature not used, define <header> as ''
 ⍝<x> has format:  device,parameter1,parameter2
 ⍝ the meaning depends on the device
 g∆outheader←header
 parms←',' ∆box x
 g∆outdevice←∆db parms[1;]
 g∆outline←0
 g∆outpageno←1
 g∆outlimit←⌊/⍳0
 g∆outbuffer←0 0⍴''
 →((g∆outdevice='afptz'),1)/a,f,p,t,z,err1
 a: ⍝array. <x>='a',name,limit
 g∆outname←∆db parms[2;]
 g∆outlimit←⍎parms[3;]
 g∆outbuffer←0 0⍴''
 →lend
 f: ⍝file. <x>='f',limit
 g∆outlimit←⍎parms[2;]
 ⍝initialize buffer
 g∆outbuffer←0 0⍴''
 ⍝define base name of matrix used to define components
 g∆outname←'component'
 →lend
 p: ⍝printer (skeleton). <x>='p',limit
 g∆outlimit←⍎parms[2;]
 ⍝page format character. 1=go to top of page before printing text
 g∆outpagechar←'1'
 →lend
 t: ⍝terminal. <x>='t',limit
 g∆outlimit←⍎parms[2;]
 g∆outreadytext←'press <enter> key to continue.'
 →lend
 z: ⍝z-device. <x>='z',limit
 g∆outlimit←⍎parms[2;]
 ∆outset
 →lend
 lend:
 g∆outh←g∆outf←0
 →0
 err1:
 ⎕←'out domain error'
 ⎕←'unknown device code (',g∆outdevice,')'
 ∘
∇

∇outpage;sink
 ⍝advance device to new page
 ⍝.k output
 g∆outh←0
 ⍝no page advance if already at top
 →(g∆outline=0)/0
 →(g∆outdevice='afptz')/a,f,p,t,z
 a:
 ⍝pad buffer with empty lines to end of 'page'
 g∆outbuffer←g∆outbuffer,[1]((g∆outlimit-g∆outline),¯1↑⍴g∆outbuffer)⍴' '
 →lend
 f:
 ⍝define this component (as a variable)
 ⍎g∆outname,(⍕g∆outpageno),'←g∆outbuffer'
 g∆outbuffer←0 0⍴''
 →lend
 p:
 ⍝in ibm environment simply reset page format character
 g∆outpagechar←'1'
 →lend
 t:
 ⍞←g∆outreadytext
 sink←⍞
 →lend
 z:
 ∆outpage
 →lend
 lend:
 g∆outline←0
 ⍝advance page counter to 'this page'
 g∆outpageno←g∆outpageno+1
∇

∇z←m patterng c;⎕IO
 ⍝random rearrangement of text <c> based on <m>
 ⍝.e 4 9 = ⍴ 2 3 2 3 patterng ' sun ⋆ moon '
 ⍝.k graphics
 ⍝.n roger frey
 ⍝.t 1989.7.27.23.42.49
 ⍝.v 1.0 / aug68
 ⎕IO←1
 z←((2↑m)×2↓m)⍴2 4 1 3⍉((m[3 4],⍴c)⍴c)[;;?m[1 2]⍴⍴c]
∇

∇y←payday d
 ⍝<y> is the closest Friday on or before dates <d> = (mm dd yyyy)
 ⍝.e 7 21 1989 = ,payday 7 27 1989
 ⍝.k date
 ⍝.t 1992.4.9.17.27.59
 ⍝.v 1.0 / 15apr78
 ⍝.v 1.1 / 09apr92 / left arg extended to matrix; use <days> not <julian>
 ⍝<d> can be vector (1 date), or matrix of dates, in format (mm dd yyyy)
 'payday' checksubroutine 'days cdays'
 ⍝for each date compute day counts starting from <d> and going back a week
 y←(days d)∘.-¯1+⍳7
 ⍝pick out the day count for friday (day 5) in each row and convert to dates
 y←cdays(,5=7|y)/,y
∇

∇y←m pick v;⎕IO;b;i;mv;r;tc;tf;token
 ⍝select (pick) rows from character <m> using name specification <v>
 ⍝.e 1 1 0 0 1 = ('/' ∆box 'apple/betty/cat/dog/zebra') pick 'a-b z⋆'
 ⍝.k searching
 ⍝.n rml
 ⍝.t 1988.5.12.21.11.46
 ⍝.v 1.8 / 23jan84
 ⍝.v 2.0 / 26nov85
 ⍝.v 2.1 / 06may88 (rewritten, use enhanced name specifications)
 ⍝.v 2.2 / 23apr92 / using signalerror
 ⍝<m> character matrix of names
 ⍝<v> character vector containing name specifications
 ⎕IO←1
 'pick' checksubroutine 'vnames wildcard range'
 →(∼(⍴⍴v)∈0 1)signalerror '/y/pick rank error/right arg not rank 0 or 1'
 ⍝mv is needed in one of the early error messages
 mv←'' ∆box v←∆db v
 →(2≠⍴⍴m)signalerror '/y/pick rank error/left arg not rank 2'
 y←(1↑⍴m)⍴0
 →((0∈⍴m),0∈⍴v)/0
 ⍝compute class of each name specification in <mv>
 tc←vnames v
 →(0∈tc)signalerror '/y/pick domain error/right arg has invalid items (',(∆db,' ',(tc=0)⌿mv),')'
 ⍝translate a token class into its positive equivalent
 r←(1 12 21 121 212 2 13 31 131 3,tc)[(41 412 421 4121 4212 42 413 431 4131 43,tc)⍳tc]
 ⍝for each token in <mv> remove trailing blanks, compute tilde
 ⍝flag, remove tilde, get corresponding compression vector.
 i←0
 l20:→((1↑⍴mv)<i←i+1)/0
 tf←'∼'=1↑token←∆db mv[i;]
 token←tf↓token
 →(r[i]=1 12 21 121 212 2 13 31 131 3)/(6⍴l30a),(4⍴l30b)
 l30a:b←m wildcard token
 →l30
 l30b:b←m range token
 →l30
 l30:
 ⍝treat <b> differently depending on <tf> (tilde flag)
 →(1 0=tf)/l50a,l50b
 ⍝tilde specification. turn off a subset of the items already picked.
 ⍝but if first one, start with universe.
 l50a:y←(y∨i=1)×∼b
 →l20
 ⍝no tilde. add to subset of items already picked.
 l50b:y←y∨b
 →l20
∇

∇y←v pickn n;⎕IO;b;i;mv;r;t;x
 ⍝pick ('select') numbers from <n> using positive integer specification <v>
 ⍝.e 1 1 1 1 0 0 0 0 1 1 = '1-4 9-' pickn ⍳10
 ⍝.k searching
 ⍝.t 1992.4.25.17.18.49
 ⍝.v 1.0 / 23nov83 / uses vfpi
 ⍝.v 1.1 / 13nov85 / uses vpis
 ⍝.v 1.2 / 25apr92 / uses signalerror
 ⍝<n> is vector of numbers
 ⍝<v> is positive integer specification as defined by <vpis>
 ⍝<y> is compression vector for <n>
 ⎕IO←1
 'pickn' checksubroutine 'vpis'
 →(∼(⍴⍴n)∈0 1)signalerror '/y/pickn rank error/right arg not rank 0 or 1'
 n←,n
 mv←'' ∆box v←∆db,' ',v
 y←(⍴n)⍴0
 →((0∈⍴n),0∈⍴v)/0
 ⍝find token class <r> of each specification
 r←vpis v
 t←∆db,' ',(∼r[;1])⌿mv
 →(0∈r[;1])signalerror '/y/pickn domain error/left arg contains invalid items (',t,')'
 ⍝for each token, get the compression vector
 i←0
 l20:
 →((⍴r)<i←i+1)/0
 →(r[i;2]=1 12 21 2 121)/exact,prefix,suffix,all,range
 exact: ⍝number
 b←n=⍎mv[i;]
 →endloop
 prefix: ⍝n-
 b←n≥⍎(mv[i;]≠'-')/mv[i;]
 →endloop
 suffix: ⍝-n
 b←n≤⍎(mv[i;]≠'-')/mv[i;]
 →endloop
 all: ⍝ -  all the matrix
 b←(⍴n)⍴1
 →endloop
 range: ⍝n-m
 x←⍎b\(b←mv[i;]≠'-')/mv[i;]
 b←(x[1]≤n)∧n≤x[2]
 →endloop
 endloop:
 y←y∨b
 →l20
∇

∇z←a pnrot n;i;j
 ⍝permutation vector <a> for partitioned <n>-rotate on partitions <a>
 ⍝.e 2 1 5 3 4 8 9 6 7 ∧.= 1 0 1 0 0 1 0 0 0 pnrot 1 ¯1 2
 ⍝.k uncategorized
 ⍝.t 1988.4.13.1.38.6
 ⍝returns the permutation vector to perform a partitioned <n>-rotate
 ⍝on a vector whose partitions are designated by <a>
 ⍝<n> must satisfy (⍴,n)∈1,+/a and will be scalar-extended if necessary
 i←(1⌽a)/⍳⍴a
 j←+\a
 i←i-¯1↓0,i
 z←⍋j+(i|n)[j]≥+\1-a\¯1↓0,i
∇

∇print text
 ⍝example print cover function to print <text> on printer
 ⍝.k output
 '' outopen 'z,34'
 out text
 outclose
∇

∇y←prompt msg
 ⍝simple prompt with <msg> and request input on same line
 ⍝.k input
 ⍞←msg,'  '
 y←,⍞
 y←(¯1+(y≠' ')⍳1)↓y
∇

∇Y←Text puttag Fns;⎕IO;Alpha;Code;Fn;I;J;Line;Mat;T
 ⍝put tag line <text> on functions <fns>
 ⍝.k library-utility
 ⍝.t 1989.7.24.18.17.10
 ⍝.v 1.2 / 31oct83
 ⍝<text> has the form:  c xxxxx    where c is a tag character
 ⎕IO←1
 Y←⍳0
 ⍎(2≠⍴⍴Fns)/'Fns←'' '' ∆box ∆db Fns'
 ⍝remove leading '.' if necessary
 Text←(∼∧\Text='.')/Text
 Code←1↑Text
 ⍝ensure for new tag line that space follows code
 Line←'⍝.',(2↑Code),2↓Text
 J←0
 L10:→((J←J+1)>1↑⍴Fns)/End
 Mat←⎕CR Fn←Fns[J;]
 ⍝----- make sure Mat has at least two lines with first line comment
 →((0 1=1↑⍴Mat)/L15,L20),L0
 ⍝no line. cannot get cr.
 L15:⎕←'puttag error. cannot get canonical matrix for ',Fn
 →Blend
 L20: ⍝one line. add a line for first line comment
 Mat←Mat,[1](¯1↑⍴Mat)↑'⍝'
 →L2
 L0: ⍝this Mat has at least two lines. check for first line comment
 →('⍝'=Mat[2;1])/L2
 ⍝add line for first line comment
 Mat←Mat[1;],[1]((¯1↑⍴Mat)↑'⍝'),[1]1 0↓Mat
 L2: ⍝now Mat has at least 2 lines with first line comment
 ⍝skip next part if Text is empty
 →(0=⍴Text)/L3
 ⍝----- put in new tag line
 ⍝pad mat with trailing blanks (if necessary) to accommodate Line
 Mat←((1↑⍴Mat),((¯1↑⍴Mat)⌈⍴Line))↑Mat
 ⍝now search for tag line
 I←(Mat[;⍳4]∧.='⍝.',2↑Code)/⍳1↑⍴Mat
 →(0=⍴I)/L1
 ⍝found it. so replace (first occurrence of) it.
 Mat[1↑I;]←(¯1↑⍴Mat)↑Line
 →L3
 L1: ⍝did not find it. so insert new Line after line 1
 Mat←Mat[⍳2;],[1]((¯1↑⍴Mat)↑Line),[1]2 0↓Mat
 L3:
 ⍝----- now reorder lines with ⍝.x<blank>  (where x is alphabetic)
 I←(Mat[;1 2 4]∧.='⍝. ')/⍳1↑⍴Mat
 Alpha←'abcdefghijklmnopqrstuvwxyz∆ABCDEFGHIJKLMNOPQRSTUVWXYZ⍙'
 I←(Mat[I;3]∈Alpha)/I
 Mat[I;]←Mat[I[⍋Alpha⍳Mat[I;3]];]
 →(0≠1↑0⍴T←⎕FX Mat)/Lend
 ⎕←'puttag error'
 ⎕←'error when fixing function = ',Fn,'  line = ',(⍕T),'  ',Mat[T;]
 →Blend
 Lend:
 Y←Y,1
 →L10
 Blend:
 Y←Y,0
 →L10
 End:
∇

∇Y←L qstop N
 ⍝set stop vector for functions <N> on lines <L>, but not comments
 ⍝.k programming-tools
 ⍝.t 1988.4.8.3.47.42
 ⍝example:  (⍳10) qstop 'func'  ⍝stop function 'func' at lines 1 tthrough 10
 'qstop' checksubroutine 'stoptrace'
 →((∼0∈⍴L)∧0≠1↑0⍴L)/Err1
 Y←L stoptrace 's',,' ',⍕N
 →0
 Err1:⎕←'stop domain error'
∇

∇Y←L qtrace N
 ⍝set trace for functions <N> on lines <L>, optionally avoid comments
 ⍝.k programming-tools
 ⍝.t 1988.4.8.3.47.42
 ⍝example:  (⍳10) qtrace 'func'  ⍝trace function 'func' at lines 1 tthrough 10
 'qtrace' checksubroutine 'stoptrace'
 →((∼0∈⍴L)∧0≠1↑0⍴L)/Err1
 Y←L stoptrace 't',,' ',⍕N
 →0
 Err1:⎕←'trace domain error'
∇

∇y←m range s;⎕CT;⎕IO;cs;lh;n;nn;x
 ⍝select names in matrix <m> using 'range' search specification <s>
 ⍝.e  1 1 1 0 0 = (5 5⍴'appleanniebettycat  dog  ') pick 'a-b'
 ⍝.k searching
 ⍝.t 1989.7.27.22.20.17
 ⍝.v 1.0 / 06may88
 ⍝assume <s> belongs to set of valid specifications  (a-z, a-, -z, -)
 ⍝<s> can contain ? search character
 ⎕IO←1
 ⎕CT←0
 ⍝assume collating sequence <cs> includes all characters in nn and m.
 ⍝blank will also appear as a pad character and we set it so it
 ⍝is first in collating sequence.
 cs←' abcdefghijklmnopqrstuvwxyz∆ABCDEFGHIJKLMNOPQRSTUVWXYZ⍙0123456789⎕'
 ⍝the lowest and highest characters in collating sequence
 lh←cs[1,⍴cs]
 ⍝<nn[1;]> = first part of range specification, <nn[2;]> = second part
 ⍝e.g. if <s> is 'ax-d', nn[1;]='ax' and nn[2;]='d '
 ⍝<s,'-'> ensures that nn has 2 rows if <s>='a-'
 nn←'-' ∆box s,'-'
 ⍝ensure that m has as many columns as nn
 m←((1↑⍴m),(¯1↑⍴nn)⌈¯1↑⍴m)↑m
 ⍝replace blank in low limit with lh[1].
 ⍝replace blank in high limit with lh[2].
 ⍝this also assigns defaults to empty limits.
 ⍝'?' in range specification (e.g.  a?-b, ?-, etc.) is allowed but
 ⍝essentially irrelevant.  it is replaced by low or high character in
 ⍝collating sequence, depending on if it appears in the first or second
 ⍝part of the range specification, respectively.
 nn[1;]←(lh[1 1],nn[1;])[(' ?',nn[1;])⍳nn[1;]]
 nn[2;]←(lh[2 2],nn[2;])[(' ?',nn[2;])⍳nn[2;]]
 ⍝compute numeric values up to precision of specified phrases
 x←(⍴cs)⊥⍉cs⍳nn
 n←(⍴cs)⊥⍉cs⍳m[;⍳¯1↑⍴nn]
 y←(x[1]≤n)∧n≤x[2]
∇

∇y←a reformat m;⎕IO;i;v
 ⍝reformat <m> to matrix a[1] characters wide, including a[2] initial blanks
 ⍝.e 2 35 = ⍴35 4 reformat 'the quick brown fox jumped over the lazy red hen'
 ⍝.k formatting
 ⍝.t 1988.4.27.22.14.51
 ⎕IO←1
 'reformat' checksubroutine 'jl ss expandaf split'
 ⍝<a[2]> defaults to 0
 a←2↑a
 ⍝delete redundant blanks after appending blank for words ending on last column
 v←∆db,m,' '
 ⍝<ss>       find occurrences in <v> of period or ? followed by blank
 ⍝<expandaf> put extra blank in <v> after these occurrences
 ⍝<split>    split text into several lines within specified text width
 ⍝<jl>       move any leading blanks in each row to end of row
 y←jl(a[1]-a[2])split(expandaf(⍳⍴v)∈(v ss '. '),v ss '? ')\v
 ⍝preceed text by a[2] blank columns
 y←(((1↑⍴y),a[2])⍴' '),y
∇

∇y←a reparray m;⎕IO;c;n;shape;x
 ⍝replicate array <m>.  replicate <a[1]> times along coordinate <a[2]>
 ⍝.e ((3 2 2⍴'abcd'),[1] 3 2 2⍴'1234') = 3 1 reparray 2 2 2⍴'abcd1234'
 ⍝.k reshape
 ⍝.n rml
 ⍝.t 1992.4.25.17.1.8
 ⍝.v 1.0 / 10feb84
 ⍝.v 1.1 / 25apr92 / using signalerror
 ⍝note: each 'slice' of the array along the specified coordinate
 ⍝is replicated <a[1]> times.
 ⎕IO←1
 ⍝default to last coordinate
 a←2↑a,⍴⍴m
 →(∼(1≤a[2])∧a[2]≤⍴⍴m)signalerror '/y/reparray domain error/coordinate specification (',(⍕a[2]),') outside range (1,',(⍕⍴⍴m),')'
 n←a[1]
 c←a[2]
 x←(c+1),((c+1)≠⍳1+⍴⍴m)/⍳1+⍴⍴m
 shape←(⍴m)×(c≠⍳⍴⍴m)+(c=⍳⍴⍴m)×n
 y←shape⍴x⍉(n,⍴m)⍴m
∇

∇y←a reparray1 m;c;n;⎕IO
 ⍝replicate matrix <m>. replicate <a[1]> times along coordinate <a[2]>
 ⍝.e ((3 2⍴'ab'),[1] 3 2⍴'cd') = 3 1 reparray1 2 2⍴'abcd'
 ⍝.k reshape
 ⍝.n rml
 ⍝.t 1989.7.27.22.10.15
 ⍝.v 1.0 / 10feb84
 ⍝simplified version of reparray restricted to rank 2 arrays
 ⎕IO←1
 ⍝default to last coordinate
 a←2↑a,2
 n←a[1]
 c←a[2]
 ⍝replicate coordinate 1 (rows) or coordinate 2 (columns)
 →(c=1 2)/l1,l2
 l1:
 y←((n×(⍴m)[1]),(⍴m)[2])⍴2 1 3⍉(n,⍴m)⍴m
 →0
 l2:
 y←((⍴m)[1],n×(⍴m)[2])⍴3 1 2⍉(n,⍴m)⍴m
∇

∇report parms;n
 ⍝example of using the output functions
 ⍝.k output
 ⍝.t 1992.4.25.20.38.47
 'reportheader' outopen parms
 out 'first line of sample report - using the output functions'
 ⍝here's one way to make two blank lines
 out 'two blank lines follow ...'
 out 2 1⍴' '
 out 'it is ok to output a matrix'
 out 6 6⍴'matrix'
 ⍝numerics must be in character form
 out 'to output numeric data, put in character form first ...'
 out⍕⍳3
 outpage
 out 'first line of next page'
 out 'the quick brown fox jumped over the lazy black hen'
 out 'now two successive calls to outpage (advances one page only)'
 ⍝two calls to outpage (advances one page only)
 outpage
 outpage
 out 'this should be top of next page (after quick brown fox)'
 out 'print ',(⍕n←16),' lines ...'
 out((n,5)⍴'line '),⍕(n,1)⍴⍳n
 outclose
∇

∇reportheader
 ⍝example of report header function (used in <report>)
 ⍝.k output
 ⍝.t 1992.4.25.20.39.35
 out jc 78↑'sample report page ',⍕g∆outpageno
 out 78⍴'-'
∇

∇r←x riota y;⎕IO
 ⍝in matrix <x> where is each row of matrix <y>?
 ⍝.e 2=('/' ∆box 'apple/betty/cat') riota 'betty'
 ⍝.k searching
 ⍝.n dave macklin
 ⍝.t 1992.4.16.22.20.19
 ⍝.v 1.0 / 00apr78
 ⎕IO←1
 y←(¯2↑1 1,⍴y)⍴y
 x←(¯2↑1 1,⍴x)⍴x
 r←1++/∼∨\(((0 1×⍴x)⌈⍴y)↑y)∧.=⍉((0 1×⍴y)⌈⍴x)↑x
∇

∇r←n rnd x
 ⍝round numbers <x> to <n> decimal places
 ⍝.e 45.35 10.13 2.14 = 2 rnd 45.345 10.134 2.136
 ⍝.k computation
 ⍝.t 1989.7.23.22.16.56
 r←(10⋆-n)×⌊0.5+x×10⋆n
∇

∇r←rnde x;t
 ⍝round <x> to nearest integer (.5 case goes to nearest even integer)
 ⍝.e 12 12 14 14 = rnde 11.5 12.5 13.5 14.5
 ⍝.k computation
 ⍝.t 1989.7.23.22.18.18
 t←¯1⋆⌈2|x
 r←t×⌊0.5+x×t
∇

∇y←roman x;a;⎕IO
 ⍝character roman numeral equivalent of arabic (base 10) number <x>
 ⍝.e 'xiv' = roman 14
 ⍝.k translation
 ⍝.t 1988.4.13.1.6.8
 ⎕IO←1
 x←,x
 a←,(10 4⍴3 3 3 3 1 3 3 3 1 1 3 3 1 1 1 3 1 0 3 3 0 3 3 3 0 1 3 3 0 1 1 3 0 1 1 1 1 ¯1 3 3)[1+(4⍴10)⊤x;]
 y←'mdclxvi'[(a≠3)/a+2×⌊0.25×¯1+⍳16]
∇

∇mat←y scatter x;pos;shape;⎕IO
 ⍝simple scatter plot of vectors <y> (y-axis) against <x> (x-axis)
 ⍝.e 11 21 =  ⍴((⍳10),⌽⍳10) scatter(⍳20)
 ⍝.k plotting
 ⎕IO←1
 mat←,(shape←(⌈/y),⌈/x)⍴' '
 pos←1+shape⊥¯1+y,[0.5]x
 mat[pos]←'⋆'
 mat←⊖'+','+',[1]shape⍴mat
∇

∇Y←script Text;⎕IO;BB;C;Codes;I;J;KK;L;Scriptbuffer;Sink;Tokens;X
 ⍝compute document <Y> using script in character matrix <Text>
 ⍝.e (¯9↑'⎕←x') = 9⍴script '/' ∆box '.t ⎕←x←2 2⍴⍳4/abcdefg/.r 3 3⍴⍳4/.x x'
 ⍝.k library-utility
 ⍝.n rml
 ⍝.t 1992.4.25.18.28.6
 ⍝.v 1.0 / 15oct83
 ⍝.v 1.1 / 15may85 / various modifications
 ⍝.v 1.2 / 04apr88 / added and improved definitions of codes
 ⍝.v 1.3 / 15jul89 / ∆rowmem used, .b added
 ⍝.v 1.4 / 25apr92 / comments and algorithms improved, .p added, .s removed
 ⍝local variables start with underscore to avoid shadowed values. do not
 ⍝use these names in executable expressions in <text>.
 ⍝if <script> suspends ...
 ⍝   - to display the row index of the bad line in the script, display I
 ⍝   - to display the text of the bad line, display Text[I;]
 ⍝   - to display the result so far, display Y
 ⎕IO←1
 'script' checksubroutine 'fixuparray on ∆dlb ∆dtb ∆if ∆rowmem'
 →(∼(⍴⍴Text)∈0 1 2)signalerror '/Y/script rank error/right arg has rank > 2'
 →L02 ∆if 2=⍴⍴Text
 ⍝vector. assume delimited by 'return' characters and reshape to matrix
 Text←g∆cr ∆box Text
 L02: ⍝argument <Text> is now a matrix
 Y←Scriptbuffer←0 0⍴''
 ⍝each code is in a 3-character format <.x > (period, code, blank)
 Codes←'drpenctxb'
 Tokens←'.',Codes,[1.5]' '
 J←3
 I←0
 ⍝find indices of all lines starting with codes
 BB←(((1↑⍴Text),J)↑Text)∆rowmem Tokens
 L10:
 →Lend ∆if(1↑⍴Text)<I←I+1
 →(L15f,L15nf)∆if BB[I]
 L15f: ⍝found code on this line
 C←Text[I;2]
 ⍝use everything after code for expression
 L←J↓Text[I;]
 →L15
 L15nf: ⍝did not find code on this line. use entire line for result.
 ⍝KK is used to improve performance.  Find the next run of no-code lines and
 ⍝append to result in one operation.  Avoids looping over many lines.
 KK←¯1+(I↓BB)⍳1
 Y←Y on Text[I,I+⍳KK;]
 I←I+KK
 →L10
 L15:
 ⍝comment code .c is ignored (go to L10)
 →(Ld,Lr,Lp,Le,Ln,L10,Lt,Lx,Lb)∆if C=Codes
 Ld: ⍝display text
 Y←Y on L
 →L10
 Lr: ⍝display computed result
 Y←Y on fixuparray⍎L
 →L10
 Lp: ⍝capture statements and results
 ⍝display all statements (including comments) as on terminal
 ⍝capture and show output of all statements, including assignments
 ⍝treat like .t except show output of assignment statements
 ⍝note: there will be double output for ⎕ statements
 →Lt
 Le: ⍝execute
 Sink←⍎L
 →L10
 Ln: ⍝niladic execute
 ⍎L
 →L10
 Lt: ⍝terminal
 ⍝remove leading blanks before further processing
 L←∆dlb L
 ⍝adjust 6 spaces for typical APL terminal display
 Y←Y on(6⍴' '),L
 ⍝exit now if L is an APL comment statement
 →L10 ∆if '⍝'=1↑L
 ⍝do not special-case assignment if processing a .p code
 →Lt01 ∆if C='p'
 ⍝test if assignment symbol in line
 →Lt01 ∆if∼'←'∈L
 ⍝there is assignment symbol. get text (quad or name) preceeding symbol.
 X←(¯1+L⍳'←')↑L
 ⍝test if text before assignment is a quad
 →Lt03 ∆if∧/X∈'⎕'
 ⍝test if text is valid name (assignment statement, no terminal output)
 →(Lt02,Lt01)∆if∧/X∈'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890∆⍙'
 Lt01:
 ⍝L does not need special treatment. execute and capture result for display.
 Y←Y on fixuparray⍎L
 →L10
 Lt02:
 ⍝L has form: name←expression
 ⍝execute but do not show result in document,
 ⍎L
 →L10
 Lt03:
 ⍝assume L has form: ⎕←expression  or ⎕←name←expression
 ⍝execute script recursively using .r code with the text without the ⎕
 ⍝result of ⎕←expression will be embedded in document.
 Y←Y on script '.r ',(L⍳'←')↓L
 →L10
 Lx: ⍝expunge
 Sink←⎕EX '' ∆box ∆db L
 →L10
 Lb: ⍝build
 ⍝fix scriptbuffer if L = '∇'
 →(Lbf,Lba)∆if 1=+/'∇'=∆db L
 Lbf:
 Sink←⎕FX Scriptbuffer
 →(' '≠1↑0⍴Sink)signalerror '/Y/script error/(⎕FX Scriptbuffer)=',(⍕Sink),' on line ',⍕I
 Scriptbuffer←0 0⍴''
 →L10
 Lba:
 Scriptbuffer←Scriptbuffer on L
 →L10
 Lend:
 Y←∆dtb Y
∇

∇y←m search s;⎕IO;c;i;x
 ⍝y[i]=1 if row <m[i;]> contains the search sequence <s>
 ⍝.e  0 1 0 = (3 5⍴'appleanniecat  ') search 'nn'
 ⍝.k searching
 ⍝.t 1989.7.27.22.22.10
 ⍝.v 1.0 / 06may88
 ⎕IO←1
 s←,s
 c←(¯1↑⍴m)⌈⍴s
 x←((1↑⍴m),c)↑m
 i←(⍳1+(⍴x)[2]-⍴s)∘.+¯1+⍳⍴s
 ⍝pick rows that contain <s>
 y←∨/x[;i]∧.=s
∇

∇y←shares
 ⍝return names of shared variables
 ⍝.e 1 ∆ shares
 ⍝.k programming-tools
 y←(2=⎕SVO ⎕NL 2)/[1]⎕NL 2
∇

∇Y←C signalerror T;M;Sink
 ⍝display message <T> if condition <C> is true
 ⍝.e 0=1 signalerror '/y'
 ⍝.k programming
 ⍝.t 1992.4.27.13.54.40
 ⍝.v 1.0 / 27apr92
 Y←⍳0
 ⍝c=0: quit now (error did not occur)
 →(∼C)/0
 ⍝c=1: display message, erase variable specified in first row, return vector 0
 Y←,0
 M←(1↑T)∆box 1↓T
 Sink←⎕EX M[⎕IO;]
 M←1 0↓M
 ⍝quit if no message, otherwise display non-empty message on quad device
 →(0∈⍴M)/0
 ⎕←(((1↑⍴M),3)⍴'.'),' ',M
∇

∇plt←sixline v;a;b;ma;mi;nc;x;xd;yd;⎕IO
 ⍝return sixline plot given x and y data in <v> = n×2 matrix
 ⍝.e 6 33 = ⍴sixline (⍳11),[1.5] (.5×¯5+⍳10),0
 ⍝.k plotting
 ⍝.n rml
 ⍝.t 1989.7.27.20.0.48
 ⍝.v 1.0 / jun75
 ⍝<v[;1]> is x-coordinate, <v[;2]> is y-coordinate
 ⎕IO←1
 →(2≠⍴⍴v)/err1
 →(0∈⍴v)/err2
 →(2≠¯1↑⍴v)/err3
 nc←30⌈(1↑⍴v)⌊60
 x←v[;1]
 v←v[;2]
 mi←⌊/x
 ma←⌈/x
 xd←⌈1+(x-mi)×(nc-1)÷ma-mi
 yd←1⌈37⌊19+(×v)×⌊1+4×|v
 a←((10⍴6),(4⍴5),(4⍴4),(5⍴3),(4⍴2),(10⍴1))[yd]
 b←'x98765432143214321012341234123456789x'[yd]
 plt←(6×nc)⍴' '
 plt[nc⊥(a-1),[0.5]xd]←b
 plt←(6 3⍴'+2|+1|+0|-0|-1|-2|'),(6,nc)⍴plt
 →0
 err1:
 ⎕←'sixline rank error'
 ⎕←'right argument does not have rank 2'
 →0
 err2:
 ⎕←'sixline domain error'
 ⎕←'right argument is empty'
 →0
 err3:
 ⎕←'sixline length error'
 ⎕←'right argument does not have 2 columns.'
 →0
∇

∇y←cs sort m;⎕IO;c;shape
 ⍝sort character vector or matrix <m> using collating sequence <cs>
 ⍝.e 'dee' = ('' sort 3 3⍴'eggdogeat')[;1] ∆ g∆sort∆columns←1
 ⍝.k sorting
 ⍝.n rml
 ⍝.t 1992.4.23.0.12.46
 ⍝.v 1.3 / 22may85
 ⍝.v 1.4 / 19jun86 / fixed bug in computing <c>
 ⍝.v 1.5 / 04may88 / minor corrections, use gradeup
 ⍝.v 2.0 / 22apr92 / better comments and arg checking, global arg now columns
 ⎕IO←1
 'sort' checksubroutine 'gradeup'
 →(∼(⍴⍴m)∈1 2)signalerror '/y/sort rank error/right arg not rank 1 or 2'
 y←m
 →(0∈⍴y)/0
 ⍝ --- right argument
 ⍝vector <m> is treated as a one-column matrix
 shape←⍴m
 m←(2↑(⍴m),1 1)⍴m
 ⍝ --- global argument
 ⍝define columns from global parameter (default is all columns)
 ⍎(0=⎕NC 'g∆sort∆columns')/'g∆sort∆columns←⍳0'
 c←g∆sort∆columns
 c←((0∈⍴c)/⍳¯1↑⍴m),(∼0∈⍴c)/c
 →(∨/(c<1),c>¯1↑⍴m)signalerror '/y/sort index error/column numbers not in domain (1,',(⍕¯1↑⍴m),')'
 ⍝ --- left argument
 ⍝defaults to implementation atomic vector
 cs←((0∈⍴cs)/⎕AV),(∼0∈⍴cs)/cs
 ⍝
 ⍝get specified columns of data, then sort and reshape to original shape
 y←shape⍴m[cs gradeup m[;c];]
∇

∇Z←sortl X;G
 ⍝sort local names in header of function <X> and fix result
 ⍝.k programming-tools
 ⍝.t 1992.4.3.13.25.24
 ⍝.v 1.0 / 05may88
 ⍝.v 1.1 / 03apr92 / signalerror used
 →(3≠⎕NC X)signalerror '/Z/sortl domain error/(',X,') not a function.'
 G←⎕CR X
 →(0∈⍴G)signalerror '/Z/sortl domain error/function (',X,') locked.'
 Z←⎕FX sortlocal G
∇

∇y←sortlocal x;⎕IO;c;header;i;t
 ⍝sort local variables in first line of <x> = canonical matrix
 ⍝.e 'y←sortlocal x;⎕IO;c;header;i;t' = ∆db (sortlocal ⎕CR 'sortlocal')[1;]
 ⍝.k formatting
 ⍝.t 1992.3.3.20.50.4
 ⍝.v 1.0 / 12jun85 / first version
 ⍝.v 1.1 / 03mar92 / ensure that special characters sort before letters
 ⎕IO←1
 'sortlocal' checksubroutine 'gradeup'
 →(2≠⍴⍴x)signalerror '/y/sortlocal rank error/left arg not rank 2'
 ⍝do nothing if empty argument
 →(0∈⍴y←x)/0
 c←¯1↑⍴y
 header←y[1;]
 ⍝do nothing if no locals (no semicolon)
 →(c<i←header⍳';')/0
 ⍝sort locals and reconstruct list of local names
 t←';' ∆box i↓header
 ⍝ensure that special characters and blank sort before letters and numbers
 t←t[(' ⎕∆⍙',⎕AV)gradeup t;]
 t←1↓,';',t
 ⍝assign new line 1 (header)
 y[1;]←c↑(i↑header),(t≠' ')/t
∇

∇y←w split line;⎕IO;g;p;t
 ⍝split text vector <line> into <w>-size pieces
 ⍝.e 'please read the cat '=(20 split 'please read the cat in the hat')[1;]
 ⍝.k formatting
 ⍝.t 1992.4.25.16.55.44
 ⍝.v 1.0 / 30oct81
 ⍝.v 1.1 / 25apr92 / using signalerror
 ⎕IO←1
 →(w<1)signalerror '/y/split domain error/left arg (',(⍕w),') should be greater than 0'
 line←,line
 y←(0,w)⍴''
 g←⍴line
 →(g=0)/0
 l2:
 →((g=0),g≤w)/0,l4
 ⍝find last blank in line. if no blanks, take whole piece
 t←(w+1)-(' '=⌽w↑line)⍳1
 p←(0 1=×t)/w,t
 ⍝t=0 if there were no blanks
 →(t=0)/l3
 ⍝all blank or partially blank. if all blank, take whole piece
 t←(p+1)-(' '≠⌽p↑line)⍳1
 p←(0 1=×t)/w,t
 l3:y←y,[1]w↑p↑line
 g←⍴line←p↓line
 →l2
 l4:y←y,[1]w↑line
 →0
∇

∇l←v sr s;⎕IO;i;n;o;r;rl;rn;ro;rr;w
 ⍝search for 'old' sequence and replace by 'new' in <v>.  <s>=/old/new
 ⍝.e 'annie had a little lamb' = 'mary had a little lamb' sr '/mary/annie'
 ⍝.k substitution
 ⍝.t 1992.3.27.20.7.30
 ⍝.v 1.0 / 15mar83
 ⍝.v 2.0 / 02may88 / order of arguments reversed to conform to <ss>
 ⍝.v 2.1 / 27mar92 / better error messages, signalerror used, renamed variables
 ⍝the first element in <s> is the delimiter.
 ⎕IO←1
 'sr' checksubroutine 'ss'
 ⍝left argument
 →(∼0 1∨.=⍴⍴v)signalerror '/l/sr rank error/left arg not rank 0 or 1.'
 l←,v
 ⍝right argument
 →(1≠⍴⍴s)signalerror '/l/sr rank error/right arg not rank 1.'
 →(2≠+/s=1↑s)signalerror '/l/sr domain error/delimiter in right arg must occur exactly twice.'
 ⍝get old and new sequences
 i←(s[1]=s)/⍳⍴s
 o←1↓(¯1+i[2])↑s
 n←i[2]↓s
 ⍝determine number and locations of 'old' string
 rr←⍴r←v ss o
 →(0=rr)/0
 ro←⍴o
 ⍝check for overlapping occurrences of 'old'
 →(∨/ro>¯1↓(1⌽r)-r)signalerror '/l/sr domain error/overlapping search sequence = ',⍕o
 ⍝replace 'old' by 'new'
 rl←⍴l
 rn←⍴n
 r←r-1
 w←,(r+(rn-ro)×¯1+⍳rr)∘.+⍳rn
 l←(∼(⍳rl+rr×rn-ro)∈w)\(∼(⍳rl)∈r∘.+⍳ro)/l
 l[w]←(rr×rn)⍴n
∇

∇l←text srn s;⎕IO;i;n;o;r;rl;rn;ro;rr;w
 ⍝search and replace name by 'new' sequence in <text>. <s>=/name/new
 ⍝.e 'factor←a3×vara÷factor×2' = 'a←a3×vara÷a×2' srn '/a/factor'
 ⍝.k substitution
 ⍝.t 1992.4.3.14.30.8
 ⍝.v 1.0 / 05apr84
 ⍝.v 1.1 / 23oct85 / corrections made to v1.0
 ⍝.v 1.2 / 02may88 / ⎕IO added to header, ⎕-names added, ssn used
 ⍝.v 1.3 / 03apr92 / arg checking enhanced, signalerror used
 ⎕IO←1
 'srn' checksubroutine 'ss ssn'
 ⍝left argument
 →(∼0 1∨.=⍴⍴text)signalerror '/l/srn rank error/left arg not rank 0 or 1.'
 l←,text
 ⍝right argument
 →(1≠⍴⍴s)signalerror '/l/srn rank error/right arg not rank 1.'
 →(2≠+/s=1↑s)signalerror '/l/srn domain error/delimiter in right arg must occur exactly twice.'
 ⍝ --- get old and new sequences
 i←(s[1]=s)/⍳⍴s
 o←1↓(i[2]-1)↑s
 n←i[2]↓s
 →(0∈⍴o)/0
 ⍝ --- find positions of old sequence (name)
 r←l ssn o
 →(0∈⍴r)/0
 ⍝note: no need to check <r> for overlapping occurences of <o>
 ⍝      for further details see <ssn>.
 ⍝ --- replace name with new sequence
 ro←⍴o
 rl←⍴l
 rn←⍴n
 rr←⍴r
 r←r-1
 ⍝<w> is indices of all occurrences of new sequence in new line
 w←,(r+(rn-ro)×¯1+⍳rr)∘.+⍳rn
 ⍝remove occurrences of old sequence, and expand to allow new sequence
 l←(∼(⍳rl+rr×rn-ro)∈w)\(∼(⍳rl)∈r∘.+⍳ro)/l
 ⍝insert new sequence
 l[w]←(rr×rn)⍴n
∇

∇y←v ss s;⎕IO;a;f;r
 ⍝return all locations of sequence <s> in vector <v>
 ⍝.e 1 12 ='the cat in the hat' ss 'the'
 ⍝.k searching
 ⍝.t 1992.3.28.1.36.58
 ⍝.v 1.0 / 21feb83
 ⍝.v 1.1 / 21apr88 / ⎕IO added to header, rank check added
 ⍝.v 1.2 / 28mar92 / signalerror used
 ⎕IO←1
 ⍝left argument
 →(1≠⍴⍴v)signalerror '/y/ss rank error'
 s←,s
 f←⍴s
 a←⍴v
 y←⍳0
 →(f>a)/0
 →(f=0)/0
 →(1 0=f=1)/l1,l2
 l1:
 y←(s=v)/⍳a
 →0
 l2:
 r←s∧.=(0,1-f)↓(¯1+⍳f)⌽(f,a)⍴v
 y←r/⍳⍴r
 →0
∇

∇y←text ssn s;⎕IO;b;vc
 ⍝return locations of occurrences of the name <s> in vector <text>
 ⍝.e 1 11 = 'a←a3×vara÷a×2' ssn 'a'
 ⍝.k searching
 ⍝.n rml
 ⍝.t 1992.3.28.1.39.29
 ⍝.v 1.2 / 02may88 / change name to ssn; use subroutine <ss>
 ⍝.v 1.3 / 28mar92 / clarify comments, sequence <s> checked, signalerror used
 ⎕IO←1
 'ssn' checksubroutine 'ss'
 ⍝special check for invalid character=blank. (difficult error to notice)
 →(' '∈s)signalerror '/y/ssn domain error/blanks in name specified in right arg.'
 ⍝check for invalid characters. <vc> is valid characters allowed in a name
 vc←'⎕abcdefghijklmnopqrstuvwxyz∆ABCDEFGHIJKLMNOPQRSTUVWXYZ⍙0123456789'
 →(∼∧/s∈vc)signalerror '/y/ssn domain error/invalid characters in name specified in right arg.'
 y←⍳0
 →(0∈⍴s)/0
 b←text∈vc
 ⍝ note on overlapping occurrences when using <ss>:
 ⍝ <ss> returns locations of overlapping occurrences. a name by
 ⍝ definition will not overlap itself.
 ⍝ ' ',s,' ' may overlap itself (e.g. <s>='x' with ' x x ' in text)
 ⍝ but s will not because s does not contain blanks.
 y←(' ',(b\b/text),' ')ss ' ',s,' '
∇

∇sl←stemleaf z;i;leaf;leafn;maxl;n;nleaf;stem;stemn;zn;zp;⎕IO
 ⍝stem and leaf plot of data <z>
 ⍝.e 12 17 = ⍴stemleaf ¯2 ¯23 23 34, (⍳10), (4×⍳10), 45 86 44
 ⍝.k plotting
 ⍝.t 1989.7.27.20.8.29
 ⎕IO←1
 z←,z
 z←z[⍋z]
 n←⍴z
 zp←⌊(0≤z)/z
 zn←⌊-(0>z)/z
 stemn←⌊(zn,zp)÷10
 leafn←⌊(zn,zp)-10×stemn
 stemn←(⌊-(zn+1)÷10),⌊zp÷10
 stem←stemn[1]+¯1+⍳1+stemn[n]-stemn[1]
 nleaf←+/stem∘.=stemn
 maxl←⌈/nleaf
 leaf←((⍴stem),maxl)⍴' '
 i←⍴stem
 l:leaf[i;⍳nleaf[i]]←'0123456789'[1+(-nleaf[i])↑leafn]
 leafn←(-nleaf[i])↓leafn
 →(0≠i←i-1)/l
 stem←(stem<0)+stem
 sl←(5 0⍕((⍴stem),1)⍴stem),(((⍴stem),1)⍴'|'),leaf
 →(0=⍴zn)/0
 n←stem⍳¯1
 →(n<⍴stem)/l1
 →(n=⍴stem)/0
 →(0=stem[i])/l2
 →0
 l1:sl[n+1;sl[n;]⍳'¯']←'¯'
 →0
 l2:sl[1;¯1+sl[1;]⍳'0']←'¯'
∇

∇Y←L stoptrace Names;Code;Fname;I;Ll;Mat;N;⎕IO
 ⍝subroutine for qstop and qtrace
 ⍝.k programming-tools
 ⍝.n rml
 ⍝.t 1988.4.23.14.36.24
 ⍝.v 1.2 / 28dec83
 ⍝.v 2.0 / 08apr88 / left arg changed: negative means no comment trace
 ⍝ L[I] positive means to trace line L[I]
 ⍝ L[I] negative means to trace if line L[I] is not a comment
 ⍝ L    0 means to remove trace
 ⍝ L    empty defaults to negative numbers for all lines
 ⍝ 1↑Names is Code -- 't' or 's', for trace or stop
 ⍝ 1↓Names is namelist of functions
 ⎕IO←1
 ⍝function is trace or stop?
 Code←1↑Names
 Fname←(((Code='t')/'trace'),(Code='s')/'stop')
 ⍝right argument
 Names←'' ∆box ∆db 1↓Names
 →(0∈⍴Names)/0
 →(∼3∧.=⎕NC Names)/Err1
 ⍝left argument
 L←,L
 I←0
 L10:→((1↑⍴Names)<I←I+1)/0
 Mat←⎕CR Names[I;]
 N←1↑⍴Mat
 ⍝L is empty? default to all negative lines
 Ll←((0=⍴L)/-⍳N-1),(0≠⍴L)/L
 ⍝if Ll[I] is negative and |Ll[I] is comment line, don't trace it. i.e. remove from list
 ⍝note that line 0 (header) never is a comment line
 Ll←(∼(¯1=×Ll)∧(|Ll)∈('⍝'=Mat[;1])/¯1+⍳N)/Ll
 ⍝any other negative numbers are non-comment lines, so trace anyway
 Y←Ll←|Ll
 ⍝duplicate line numbers don't matter.
 ⍝next line becomes something like:  t∆xxxx←1 2 3
 ⍎Code,'∆',Names[I;],'←',⍕Ll
 →L10
 Err1:
 ⎕←Fname,' domain error'
 ⎕←'cannot find function(s) = ',∆db,' ',(3≠⎕NC Names)⌿Names
 →
∇

∇r←p subtotal m;⎕IO
 ⍝compute and merge subtotals of <m> determined by positions <p>
 ⍝.e (7 2⍴1 2 1 2 2 4 10 20 10 20 20 40 22 44) = (3 2⍴1 2 3 4 1 4) subtotal 4 2⍴1 2 1 2 10 20 10 20
 ⍝.k computation
 ⍝.t 1989.7.23.23.49.42
 ⍝.v 1.0 jan82
 ⍝<p> is n×2 matrix
 ⍝ n is number of subtotal rows
 ⍝ p[;1] is subtotal row start positions, p[;2] is end positions
 ⎕IO←1
 r←(m,[1]-/[2](+\[1]0,[1]m)[⌽p+(⍴p)⍴0 1;])[⍋(⍳1↑⍴m),p[;2];]
∇

∇p←d suppress v;b;level;mask;shape;x;⎕IO
 ⍝suppress characters in matrix <v> delimited by delimiters <d>
 ⍝.e 'abc     def' = '()' suppress 'abc(xxx)def'
 ⍝.k delete-elements
 ⍝.t 1988.4.18.20.55.29
 ⍝ d[1] = d[2]  no nesting of delimiters is allowed
 ⍝ d[1] ≠ d[2]  nesting level is arbitrarily set to 1
 ⎕IO←1
 shape←⍴v
 v←(¯2↑1 1,⍴v)⍴v
 ⍝ensure that <d> has exactly 2 elements
 d←2⍴d
 →(0 1==/d)/different,same
 different:
 ⍝set level of nesting arbitrarily for this part
 level←1
 x←+\(v=d[1])-0 ¯1↓0,v=d[2]
 mask←level≤x
 →l10
 same:
 b←d[1]=v
 mask←b≥0 1↓≠\1,b
 →l10
 l10:
 p←mask⌽[1]v,[0.5]' '
 p←shape⍴p[1;;]
∇

∇r←f thru tb;⎕IO;b
 ⍝generate equal-interval vector from <f> to <1↑tb>, increment=¯1↑tb
 ⍝.e 1 1.5 2 2.5 3 3.5 4 4.5 5 = 1 thru 5 .5
 ⍝.k computation
 ⍝.n dave macklin
 ⍝.t 1992.4.22.22.28.22
 ⍝.v 1.0 / 06may88
 ⍝the interval is <1↓tb>
 ⎕IO←0
 b←|tb[1]
 r←(tb[0]-f)÷b
 r←f+(×r)×b×⍳1+⌊|r
∇

∇y←time
 ⍝return current time of day in format  hh:mm:ss (am/pm)
 ⍝.e 1 ∆ time
 ⍝.k time
 ⍝.t 1992.4.22.22.13.52
 ⍝.v 1.0 / 00oct80
 ⍝.v 1.1 / 00apr88
 ⍝.v 1.2 / 22apr92 / replaced all code with call to <ftime>
 'time' checksubroutine 'ftime'
 y←ftime ⎕TS[4 5 6]
∇

∇y←timer n;tt
 ⍝time <n> executions of an expression for cpu and connect time
 ⍝.k timing
 ⍝.t 1992.3.28.15.34.56
 ⍝.v 1.0 / 12apl82
 ⍝.v 1.1 / 28mar92 / clarified comments
 ⍝this function uses ⎕AI
 ⍝when using <timer> compute overhead first and ignore first timing test.
 ⍝ tt starts with current accumulated cpu and connect time
 tt←2↑1↓⎕AI
 l1:→(0>n←n-1)/l2
 ⍝put code here
 →l1
 l2:
 ⍝ result y is elapsed cpu and connect time
 y←(2↑1↓⎕AI)-tt
∇

∇interval timetrace msg;cp;now
 ⍝print <msg> after <interval> milliseconds of cpu time
 ⍝.k timing
 ⍝example:   2000 timetrace 'another 2 seconds has elapsed'
 now←1↑2↓⎕AI
 ⍝check for checkpoint time (cp)
 ⍎(0=⎕NC 'g∆timetrace∆cp')/'g∆timetrace∆cp←',⍕now
 cp←g∆timetrace∆cp
 →(interval>now-cp)/0
 ⎕←msg
 g∆timetrace∆cp←now
∇

∇y←timing
 ⍝cover function to call and format elapsed cpu and connect time
 ⍝.e 1 ∆ timing
 ⍝.k timing
 ⍝.t 1992.3.28.13.51.56
 ⍝.v 1.0 / 25may88
 y←fcpucon cpucon
∇

∇z←tower x;i;j;m;n;xx;y;z1;z2;z3;⎕IO
 ⍝tower chart (skyscraper diagram) for contingency table <x>
 ⍝.e 29 72 = ⍴tower 3 3⍴29 16 5 26 12 20 28 30 17
 ⍝.k plotting
 ⍝.n carina heiselbetz
 ⍝.t 1989.7.27.20.10.30
 ⎕IO←1
 'tower' checksubroutine 'field'
 z←(n←¯1↓⍴x)field m←1↓⍴x
 xx←100×x÷⌈/,x
 z1←¯4+⌈0.0999999999999999778×⌈/,xx
 z1←0⌈z1
 z←((z1,1↓⍴z)⍴' '),[1]z
 j←i←1
 loop:
 →(xx[i;j]<0)/l1
 z2←z1+¯1+7×i
 z3←(7×n-i+1)+17×j
 →(xx[i;j]<5)/l2
 y←1+⌊0.0999999999999999778×¯5+xx[i;j]
 z[z2-y;z3+¯1+⍳4]←1 4⍴'/¯¯/'
 z[z2;z3+3]←'/'
 z[z2-⍳y;z3+4]←'|'
 z[z2-⍳y-1;z3+3]←' '
 z[z2+1-⍳y;z3+¯2+⍳4]←(y,4)⍴'|⋆⋆|'
 l1:
 →(m≥j←j+1)/loop
 →(n≥i←i+j←1)/loop
 →end
 l2:
 z[z2;z3+¯1+⍳5]←'/___/'
 z[z2-1;z3+⍳5]←'/¯¯¯/'
 →l1
 end:
 z←z,[1]' '
 z[¯1↓⍴z;9+⍳17×m]←(17×m)↑,(⍉1 6⍴'abcdef'),6 16⍴' '
 i←1
 l5:
 z[z1+5+7×i-1;1+7×n-i]←⍕i
 →(n≥i←i+1)/l5
∇

∇y←triangle n;i;z
 ⍝print a pretty triangle using ≠\ where <n> is a power of 2
 ⍝.e 16 16 = ⍴triangle 16
 ⍝.k graphics
 ⍝.n larry smith
 ⍝note: if n is not a power of 2, the triangle is not pretty
 i←0
 y←''
 z←n⍴1
 l1:→(n<i←i+1)/end
 y←y,z\'⋆'
 z←≠\z
 →l1
 end:y←(n,n)⍴y
∇

∇r←c unbox x;b;chars;fill;sep;⎕IO
 ⍝unbox matrix <x>. remove trailing <c[2]>, delimit vector <x> by <c[1]>
 ⍝.e 'apple/betty/cat/' = '/' unbox 3 5⍴'applebettycat  '
 ⍝.k reshape
 ⍝.t 1988.4.6.1.25.34
 ⍝.v 1.0 / jul83
 ⍝c[1]=separator character (default is blank/zero)
 ⍝c[2]=fill character (default is blank/zero)
 ⍝remove trailing character c[2] from the end of each line of matrix
 ⍝then delimit end of each line with c[1] and return a vector
 ⎕IO←1
 r←0⍴x
 →(0=⍴,x)/0
 ⍝assign defaults to special characters
 chars←c,(⍴,c)↓2↑0⍴x
 ⍝get separator (to be put at end of each row)
 sep←(⍳0)⍴1↑chars
 ⍝get fill character (to be removed from end of each row)
 fill←1↑1↓chars
 r←x
 ⍝compute 0 for trailing fill in each row and append 1 for sep
 b←(⌽∨\⌽r≠fill),1
 ⍝append line separator to end of each row
 r←r,sep
 ⍝remove trailing fill (but not separator)
 r←(,b)/,r
∇

∇y←a union b;c
 ⍝set union <a> and <b> leaving order of result as in <a>
 ⍝.e (4 5⍴'applebettycat  peach') = (3 5⍴'applebettycat  ') union 3 5⍴'cat  bettypeach'
 ⍝.k uncategorized
 ⍝.t 1988.4.6.1.28.16
 c←⌈/0 1 0 1/(⍴a),⍴b
 a←((1↑⍴a),c)↑a
 b←((1↑⍴b),c)↑b
 ⍝get elements of b but not in a and put them after a
 y←a,[1](∼b ∆rowmem a)⌿b
∇

∇line←ved text;a
 ⍝vector edit.  edit vector <text> in a simple fashion
 ⍝.k text-editing
 ⍝.n jarry apsit
 ⍝.t 1992.4.16.22.37.59
 ⍝.v 1.0 / 23mar83
 line←⍞,0⍴⍞←('/'≠text)/a\(a←'\'≠text←(⍴text)↑⍞)/⍞←text←,text
∇

∇N vedit Name;Prompt;T;Text;Y
 ⍝vector edit. screen edit variable <name> from <n[1]> to <n[2]>
 ⍝.k text-editing
 ⍝.n rml
 ⍝.t 1985.8.8.11.21.40
 ⍝.v 1.1 / 8aug85
 ⍝this function can be used on a terminal with screen editing features
 Text←Y←⍎Name
 ⍝assign defaults (1,end of text) to N
 N←2↑N,(×/⍴N)↓1,×/⍴Text
 ⍝ensure N is between 1 and ⍴Text
 N←1⌈(⍴Text)⌊N
 ⍞←Prompt←(¯1+N[1])↓N[2]↑Text
 T←,⍞
 →(0≠⍴T)/L2
 →End,0⍴⎕←'empty result. no change'
 ⍝if first part of T is all blank, do not →L1
 L2:→(∼∧/' '=(1+N[2]-N[1])↑T)/L1
 ⍝all blank. assume prompt text was unchanged and must be kept
 ⍝reinsert Prompt into returned Text <T>
 T←Prompt,(⍴Prompt)↓T
 L1:Y←((N[1]-1)↑Text),T,N[2]↓Text
 End:⍎Name,'←Y'
∇

∇r←x veq y;c
 ⍝r←1 if vectors <x> and <y> are equal. trailing blanks ignored
 ⍝.e 1 = 'apple' veq 'apple     '
 ⍝.k programming
 ⍝scalar <x> or <y> treated as 1-element vector
 c←(⍴,x)⌈⍴,y
 r←(c↑x)∧.=c↑y
∇

∇r←vi a;t
 ⍝validate numeric input <a>
 ⍝.e 1 1 0 0 1 = vi '1 2 1a 3.3.3 123.35'
 ⍝.k validation
 ⍝.n gerald bamberger, apl quote-quad, mar 80
 ⍝.t 1989.7.27.23.11.44
 ⍝.v 1.0 / mar 80
 t←' 11111111112345'[' 0123456789.¯e'⍳'0 ',a]
 r←1↓⍎((t∈'234')∨t≠' ',¯1↓t)/t
 r←r∈(8 3⍴0 41 431)+1 12 121 21 31 312 3121 321∘.×1 100 1000
∇

∇y←vnames v;an;r;t;⎕IO
 ⍝validate name specifications in <v>
 ⍝.e 1 12 131 412 4131 0 = vnames 'a d?⋆ a-d ∼∆⋆ ∼d-e ⋆a⋆a'
 ⍝.k validation
 ⍝.n rml
 ⍝.t 1988.4.24.21.39.7
 ⍝.v 1.2 23jan84
 ⍝.v 2.0 26nov85 / add ? facility and remove escape chars
 ⍝.v 2.1 22apr88 / add valid specifications, allow general ?, add ∼
 ⍝valid name specifications:
 ⍝   x    x⋆    ⋆x    x⋆y   ⋆x⋆   ⋆   x-y     x-     -x     -
 ⍝   1    12    21    121   212   2   131     13     31     3
 ⍝also any of above prefaced by <∼>
 ⍝<an> contains characters allowed to form x and y
 ⎕IO←1
 an←'?⎕abcdefghijklmnopqrstuvwxyz∆ABCDEFGHIJKLMNOPQRSTUVWXYZ⍙0123456789'
 v←∆db v
 →(0∈⍴y←v)/0
 ⍝compute class of specifications in v
 t←(' ',((⍴an)⍴'1'),'2345')[(' ',an,'⋆-∼')⍳v]
 r←,⍎((t∈'234')∨t≠' ',¯1↓t)/t
 ⍝return invalid codes as 0
 y←r×r∈1 12 21 121 212 2 13 31 131 3 41 412 421 4121 4212 42 413 431 4131 43
∇

∇y←vpis v;a;cs;r;t
 ⍝validate positive integer specification <v>
 ⍝.e (2 2⍴1 12 1 121) = vpis '5- 1-10'
 ⍝.k validation
 ⍝.n rml
 ⍝.t 1992.4.25.22.43.44
 ⍝.v 1.0 / 23nov83
 ⍝.v 1.1 / 13nov85
 ⍝positive integer specification: sequence of integers and ranges
 ⍝integer  n to n   n to end   start to n   all
 ⍝  n       n-n       n-          -n         -
 ⍝  1       121       12          21         2
 y←⍳0
 a←∆db v
 →(0∈⍴a)/0
 ⍝character set for valid positive integer
 cs←'0123456789'
 t←(' ',((⍴cs)⍴'1'),'23')[(' ',cs,'-')⍳a]
 r←,⍎((t∈'2')∨t≠' ',¯1↓t)/t
 y←(r∈1 121 12 21 2),[1.5]r
∇

∇e←v vrepl a;i;j;l;m;v1;⎕IO
 ⍝replace in <v> single-character abbreviations defined in <a>
 ⍝.e 'dear bob how are you?' = '⎕ ○ how are ∆?' vrepl(3 5 ⍴'⎕dear○bob ∆you ')
 ⍝.k substitution
 ⍝.n k.h. glatting and g. osterburg
 ⍝.t 1989.7.27.22.54.26
 ⍝.v 1.0 / dec80
 ⎕IO←1
 v1←v∈a[;⎕IO]
 i←v1/⍳⍴v
 j←a[;⎕IO]⍳v[i]
 ⍝determine the length of the string to replace each code
 l←∼⌽∧\(1↑0⍴v)=⌽0 1↓a
 l←l[j;]
 m←0 1↓×\(i+0.5),l
 v1←(∼v1)/⍳⍴v
 e←(v[v1],(,l)/,0 1↓a[j;])[⍋v1,(,l)/,m]
∇

∇r←vtype x
 ⍝return <r> = 'type' of variable <x> (logical,character,integer,real)
 ⍝.e 4=vtype 10.456
 ⍝.k programming-tools
 ⍝.t 1983.10.31.17.40.29
 ⍝.v 1.0 / 12feb82
 ⍝warning: this is an implementation-dependent function
 ⍝ <r> -- 1=logical,2=char,3=integer,4=real
 x←64↑0⍴x
 r←70000
 r←⎕WA+70000
 x←128↑x
 r←0.125×r-⎕WA+70000
 r←(1 2 3 4 4)[1 8 32 64⍳r]
∇

∇b←m wildcard s;⎕IO;c;i;j;name;wp;x
 ⍝select names in matrix <m> using 'wildcard' search specification <s>
 ⍝.e  0 0 1 1 0 = (5 5⍴'appleanniebettybattydog  ') pick '⋆tt⋆'
 ⍝.k searching
 ⍝.t 1988.5.7.19.23.17
 ⍝.v 1.0 / 06may88
 ⍝<s> can contain ? search character
 ⎕IO←1
 s←,s
 ⍝assume <s> is one of the following --- ⋆  ⋆a⋆  ⋆a  a⋆  a⋆a  a
 →(('⋆'∧.=s),(2=+/'⋆'=s),('⋆'=1↑s),('⋆'=¯1↑s),('⋆'∈s),1)/all,mid,suff,pref,lr,exact
 all: ⍝everything phrase: s=⋆
 b←(1↑⍴m)⍴1
 →0
 mid: ⍝somewhere in between phrase: s=⋆name⋆
 name←1↓¯1↓s
 x←((1↑⍴m),(¯1↑⍴m)⌈⍴name)↑m
 i←(⍳1+(⍴x)[2]-⍴name)∘.+¯1+⍳⍴name
 →l50
 suff: ⍝suffix phrase: s=⋆name
 name←1↓s
 ⍝right justify, then take last (⍴name) columns
 x←((1↑⍴m),-⍴name)↑(-+/∧\⌽' '=m)⌽m
 i←(1,⍴name)⍴⍳⍴name
 →l50
 pref: ⍝prefix phrase: s=name⋆
 name←¯1↓s
 x←((1↑⍴m),⍴name)↑m
 i←(1,⍴name)⍴⍳⍴name
 →l50
 exact: ⍝exact phrase: s=name
 c←(¯1↑⍴m)⌈⍴s
 name←c↑s
 x←((1↑⍴m),c)↑m
 i←(1,c)⍴⍳c
 →l50
 l50:
 ⍝if question mark in <name>, replace all non-blanks in corresponding
 ⍝columns with '?'.  algorithm works fine even if no '?' present.  note
 ⍝that <name> and <x> are conformable in length at this point.  x is
 ⍝always a rank-4 array after the next line.
 x←x[;i],[0.5]'?'
 wp←'?'=name
 j←wp/⍳⍴wp
 x[;;;j]←(x[1;;;j]≠' ')⌽[1]x[;;;j]
 ⍝find rows that contain search string in specified columns
 b←∨/x[1;;;]∧.=name
 →0
 lr: ⍝left - right phrase: s=name⋆name
 b←(m wildcard(s⍳'⋆')↑s)∧m wildcard(¯1+s⍳'⋆')↓s
∇

∇r←s xfade c;c1;c2;⎕IO
 ⍝transform text in <c> using a 'fading' algorithm controlled by <s>
 ⍝.e 16 64 = ⍴16 64 xfade '/apple betty /is a dessert '
 ⍝.k graphics
 ⍝.n phil last
 ⍝.t 1989.7.27.23.42.49
 ⍝s[1] number of rows in result; s[2] number of columns
 ⍝<c> is /first text/second text
 ⍝.v 1.0 / 23jul82
 ⎕IO←1
 c2←,s⍴(1↓s←2⍴,s)⍴c2←(1⌈⍴c2)↑c2←1↓(2=c1←+\c∈1↑c)/c←(1⌈⍴c)↑c←,c
 c1←,s⍴(1↓s)⍴c1←(1⌈⍴c1)↑c1←1↓(1=c1)/c
 c2←,⊖s⍴c\(c,0⍴c[??⍳⍴c←,(×/s)⍴0]←1)/c2
 c2[c/⍳⍴c]←(c,0⍴c[??⍳⍴c,⍴c[]←0]←1)/c1
 r←s⍴c2
∇

∇y←l ∆ r
 ⍝glue function. return left argument <l>
 ⍝.e 101 = 101 ∆ 1+1 ∆ 2+2
 ⍝.k programming
 y←l
∇

∇y←chars ∆box x;fill;len;m;of;pos;s;sep;⎕IO
 ⍝'box' vector <x> using separator and fill character <chars>
 ⍝.e (3 5⍴'applebettycat  ') = '/' ∆box 'apple/betty/cat'
 ⍝.k reshape
 ⍝.t 1988.4.28.1.20.21
 ⍝.v 2.0 / 8jul83
 ⍝chars[1]=separator; chars[2]=fill; defaults are blank/zero
 ⍝<y>  matrix corresponding to a vector delimited into logical fields
 ⎕IO←1
 y←0 0⍴x
 →(0∈⍴x)/0
 chars←chars,(×/⍴chars)↓2↑0⍴x
 ⍝separator
 sep←chars[1]
 ⍝filler
 fill←chars[2]
 ⍝add sep to end if necessary
 x←x,(sep≠¯1↑x)/sep
 ⍝lengths
 pos←(x=sep)/⍳⍴x
 m←⌈/len←¯1+pos-0,¯1↓pos
 ⍝offsets
 of←(len+1)∘.⌊⍳m
 ⍝starting indices
 s←⍉(m,⍴len)⍴0,¯1↓pos
 ⍝replace separator with fill character
 x[(x=sep)/⍳⍴x]←fill
 ⍝return matrix
 y←x[s+of]
∇

∇y←fld ∆centh label;⎕IO;c;i;m;n
 ⍝centre column headings <label> within fields specified by <fld>
 ⍝.e '   a    bb    cc     d' = 4 ¯1 2 ∆centh '/a/bb/cc/d'
 ⍝.k formatting
 ⍝.n rml
 ⍝.t 1988.5.3.0.38.19
 ⍝.v 1.0 / nov83
 ⍝<fld>  vector of triplets
 ⍝[1] width;  [2] 1=lj, 0=centre, ¯1=rj;  [3] inter-column spacing
 ⎕IO←1
 y←''
 ⍝box labels and left justify
 m←(1↑label)∆box 1↓label
 m←(+/∧\' '=m)⌽m
 →(0=n←1↑⍴m)/0
 fld←,fld
 →((⍴fld)=1 3,3×n)/l1,l2,l2
 →1 signalerror '/y/∆centh length error/left arg must have 1, 3, or 3×n elements.'
 l1: ⍝1 number. extend to all fields, centred(0), 1 space
 fld←⍉(3,n)⍴(n⍴fld),(n⍴0),n↑(n-1)⍴1
 →l4
 l2: ⍝3 or 3n numbers. extend width, positioning, spacing to all fields
 fld←(n,3)⍴((¯1+3×n)⍴fld),0
 →l4
 l4:
 ⍝arguments have now been defined and shaped
 i←0
 l05:→((1↑⍴fld)<i←i+1)/0
 ⍝take as many columns as specified by fld[i]
 c←fld[i;1]↑m[i;]
 →(¯1 0 1=×fld[i;2])/l10,l20,l30
 l10: ⍝right justify (¯1⌽x)
 c←(-+/∧\' '=⌽c)⌽c
 →l40
 l20: ⍝centre
 c←(-⌊0.5×+/∧\' '=⌽c)⌽c
 →l40
 l30: ⍝it is already left-justified
 →l40
 l40: ⍝catenate to full header
 y←y,c,fld[i;3]⍴' '
 →l05
∇

∇y←w ∆centt text;d;f;l;mid;p;v;⎕IO
 ⍝centre <text> with left, middle, and right phrases in <w> spaces
 ⍝.e 'date      title    page 1' = 25 ∆centt '/date/title/page 1'
 ⍝.k formatting
 ⍝.n rml
 ⍝.t 1989.7.23.23.55.10
 ⍝.v 1.0 / 2nov83
 ⍝.v 2.0 / 23apr88 / remove 'feature' that specially handled one phrase
 ⍝<text> has the form /left/middle/right
 ⎕IO←1
 d←1↑text
 ⍝ensure 3 ending delimiters so there are three fields (phrases)
 v←text,3⍴d
 ⍝find positions p
 p←(v=d)/⍳⍴v
 ⍝lengths l
 l←¯1+1↓p-¯1⌽p
 ⍝we only want the first, second, and third phrases
 ⍝get second phrase and centre within w spaces
 mid←¯1↓p[2]↓p[3]↑v
 mid←w↑((⌈0.5×w-⍴mid)⍴' '),mid
 ⍝put them all together.  w↑ ensures exactly w spaces
 y←w↑(¯1↓1↓p[2]↑v),(l[1]↓(-l[3])↓mid),¯1↓p[3]↓p[4]↑v
∇

∇y←∆db v;b
 ⍝delete blanks (leading, trailing and multiple) from v (rank 0 - 2)
 ⍝.e 'apple betty cat' = ∆db '  apple  betty  cat  '
 ⍝.k delete-characters
 ⍝.v 1.1
 →((0 1 2=⍴⍴v),1)/l1,l1,l2,err1
 l1:
 b←' '≠v←' ',v
 y←1↓(b∨1⌽b)/v
 →0
 l2:
 b←∨⌿' '≠v←' ',v
 y←0 1↓(b∨1⌽b)/v
 →0
 err1:⎕←'∆db rank error'
∇

∇y←c ∆dc v;b
 ⍝delete characters (leading, trailing and multiple) from v (rank 0 - 2)
 ⍝.e 'apple.betty.cat' =  '.' ∆dc '...apple...betty...cat...'
 ⍝.k delete-characters
 ⍝.v 1.1
 ⍝note: same algortihm as ∆db (delete blanks)
 c←(⍳0)⍴1↑c
 →((0 1 2=⍴⍴v),1)/l1,l1,l2,err1
 l1:
 b←c≠v←c,v
 y←1↓(b∨1⌽b)/v
 →0
 l2:
 b←∨⌿c≠v←c,v
 y←0 1↓(b∨1⌽b)/v
 →0
 err1:⎕←'∆dc rank error'
∇

∇y←∆dlb v
 ⍝delete leading blanks from v (rank 0 - 2)
 ⍝.e 'apple betty cat' = ∆dlb '    apple betty cat'
 ⍝.k delete-characters
 ⍝.v 1.1
 →((0 1 2=⍴⍴v),1)/l1,l1,l2,err1
 l1:y←(¯1+(v≠' ')⍳1)↓v
 →0
 l2:y←(∨\∨⌿v≠' ')/v
 →0
 err1:⎕←'∆dlb rank error'
∇

∇y←c ∆dlc v
 ⍝delete leading character c from v (rank 0 - 2)
 ⍝.e 'apple betty cat' = '.' ∆dlc '.....apple betty cat'
 ⍝.k delete-characters
 ⍝.v 1.1
 ⍝note: same code as ∆dlb (delete leading blanks)
 c←1↑c
 →((0 1 2=⍴⍴v),1)/l1,l1,l2,err1
 l1:y←(¯1+(v≠c)⍳1)↓v
 →0
 l2:y←(∨\∨⌿v≠c)/v
 →0
 err1:⎕←'∆dlc rank error'
∇

∇y←∆dtb v
 ⍝delete trailing blanks from <v> (rank 0 - 2)
 ⍝.e 'a b c' = ∆dtb 'a b c     '
 ⍝.k delete-characters
 ⍝.v 1.1
 →((0 1 2=⍴⍴v),1)/l1,l1,l2,err1
 l1:y←(1-(⌽v≠' ')⍳1)↓v
 →0
 l2:y←(∨⌿⌽∨\⌽v≠' ')/v
 →0
 err1:⎕←'∆dtb rank error'
∇

∇y←c ∆dtc v
 ⍝delete trailing character c from v (rank 0 - 2)
 ⍝.e 'a b c' = '.' ∆dtc 'a b c.....'
 ⍝.k delete-characters
 ⍝.v 1.1
 ⍝note: same code as dtb (delete trailing blanks)
 c←1↑c
 →((0 1 2=⍴⍴v),1)/l1,l1,l2,err1
 l1:y←(1-(⌽v≠c)⍳1)↓v
 →0
 l2:y←(∨⌿⌽∨\⌽v≠c)/v
 →0
 err1:⎕←'∆dtc rank error'
∇

∇y←label ∆if condition
 ⍝if statement.  return <label[i]> if <condition[i]> = 1
 ⍝.e 20 = 10 20 ∆if 3 4 = 2+2
 ⍝.k programming
 ⍝.t 1992.4.27.14.39.33
 ⍝.v 1.0 / 00sep85
 ⍝.v 1.1 / 27apr92 / clarified comments, empty result if empty right arg
 y←⍳0
 ⍝if <condition> is empty, return ⍳o
 →(0∈⍴condition)/0
 ⍝if condition is boolean, return corresponding label vector or ⍳o
 ⍝note: if <label> is one element longer than <condition>, the last label
 ⍝ may be considered the label of an 'else' statement.
 y←((⍴,label)⍴condition,1)/label
∇

∇r←x ∆rowmem y;c
 ⍝r[i]=1 if <x[i;]> is a row in <y> (trailing blanks ignored)
 ⍝.e 1 0 = (2 5⍴'applezebra') ∆rowmem 4 5⍴'applebettycat  dog  '
 ⍝.k searching
 ⍝.t 1992.4.22.23.42.16
 ⍝.v 1.0 / 22sep85
 ⍝.v 1.1 / 13mar88 / revised error messages
 ⍝.v 1.2 / 22apr92 / using signalerror
 →(2<⍴⍴x)signalerror '/r/∆rowmem rank error/left arg has rank greater than 2'
 →(2<⍴⍴y)signalerror '/r/∆rowmem rank error/right arg has rank greater than 2'
 ⍝make x and y matrices
 x←(¯2↑1 1,⍴x)⍴x
 y←(¯2↑1 1,⍴y)⍴y
 ⍝c is maximum number of columns
 c←(¯1↑⍴x)⌈¯1↑⍴y
 ⍝pad with blank columns on right to make columns conformable
 r←∨/(((1↑⍴x),c)↑x)∧.=⍉((1↑⍴y),c)↑y
∇

examplescript←3226⍴0 ⍝ prolog ≡1
  (examplescript)[⍳54]←'------------------------------------------------------'
  (examplescript)[54+⍳38]←'------------------------',(,⎕UCS 10),'Example of a '
  (examplescript)[92+⍳36]←'''Script''',(,⎕UCS 10),'---------------------------'
  (examplescript)[128+⍳50]←'--------------------------------------------------'
  (examplescript)[178+⍳35]←'-',(,⎕UCS 10 10),'   This document, a character ve'
  (examplescript)[213+⍳42]←'ctor, is an example argument for <script>',(,⎕UCS 10)
  (examplescript)[255+⍳50]←'   that illustrates all the action codes.  The com'
  (examplescript)[305+⍳37]←'ments explain what is',(,⎕UCS 10),'   happening an'
  (examplescript)[342+⍳45]←'d include a discussion of the ''fine points''.',(,⎕UCS 10)
  (examplescript)[387+⍳40]←(,⎕UCS 10),'   In the toolkit workspace execute the'
  (examplescript)[427+⍳35]←' following statement:',(,⎕UCS 10 10),'   script ex'
  (examplescript)[462+⍳35]←'amplescript',(,⎕UCS 10 10),'   Then compare this d'
  (examplescript)[497+⍳34]←'ocument with the result.',(,⎕UCS 10 10),'Summary:'
  (examplescript)[531+⍳27]←(,⎕UCS 10),'-------',(,⎕UCS 10),'   b   build -- bu'
  (examplescript)[558+⍳49]←'ild a text matrix and optionally fix as function',(,⎕UCS 10)
  (examplescript)[607+⍳49]←'   c   comment -- comment within the script text',(,⎕UCS 10)
  (examplescript)[656+⍳43]←'   d   display -- ''display'' specified text',(,⎕UCS 10)
  (examplescript)[699+⍳43]←'   e   execute -- execute an APL statement',(,⎕UCS 10)
  (examplescript)[742+⍳50]←'   n   niladic execute -- execute a niladic APL st'
  (examplescript)[792+⍳35]←'atement',(,⎕UCS 10),'   p   capture -- ''display'''
  (examplescript)[827+⍳46]←' an APL statement and its result (including x',(,⎕UCS 8592)
  (examplescript)[873+⍳35]←'exp)',(,⎕UCS 10),'   r   result -- ''display'' the'
  (examplescript)[908+⍳37]←' result of an APL statement',(,⎕UCS 10),'   t   te'
  (examplescript)[945+⍳47]←'rminal -- ''display'' an APL statement and its ''t'
  (examplescript)[992+⍳36]←'erminal'' result',(,⎕UCS 10),'   x   expunge -- ex'
  (examplescript)[1028+⍳34]←'punge (erase) specified objects',(,⎕UCS 10 10),'E'
  (examplescript)[1062+⍳23]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'.c th'
  (examplescript)[1085+⍳49]←'is is a sequence of .b statements to define the f'
  (examplescript)[1134+⍳21]←'unction <foo>',(,⎕UCS 10),'.b y',(,⎕UCS 8592),'fo'
  (examplescript)[1155+⍳21]←'o x',(,⎕UCS 10),'.b ',(,⎕UCS 9053),'function buil'
  (examplescript)[1176+⍳24]←'t by .b statements',(,⎕UCS 10),'.b y',(,⎕UCS 8592)
  (examplescript)[1200+⍳33]←'''The shape of the variable is '',',(,⎕UCS 9045)
  (examplescript)[1233+⍳13]←(,⎕UCS 9076 120 10),'.b ',(,⎕UCS 8711 10 10),'.c A'
  (examplescript)[1246+⍳49]←'n example of using the local <script> variable Sc'
  (examplescript)[1295+⍳26]←'riptbuffer.',(,⎕UCS 10),'.b first line',(,⎕UCS 10)
  (examplescript)[1321+⍳29]←'.b second line',(,⎕UCS 10),'.b third line',(,⎕UCS 10)
  (examplescript)[1350+⍳44]←'.c Assign Scriptbuffer to another variable.',(,⎕UCS 10)
  (examplescript)[1394+⍳21]←'.e m',(,⎕UCS 8592),'Scriptbuffer',(,⎕UCS 10),'.c '
  (examplescript)[1415+⍳49]←'Initialize Scriptbuffer if you need to build anot'
  (examplescript)[1464+⍳28]←'her object.',(,⎕UCS 10),'.e Scriptbuffer',(,⎕UCS 8592)
  (examplescript)[1492+⍳17]←'0 0',(,⎕UCS 9076 48 10),'.t foo m',(,⎕UCS 10 10),'T'
  (examplescript)[1509+⍳47]←'he definition of the example function <foo> is',(,⎕UCS 10)
  (examplescript)[1556+⍳49]←'.c now execute an APL statement and include resul'
  (examplescript)[1605+⍳34]←'t in result text',(,⎕UCS 10),'.r '''' displayfunc'
  (examplescript)[1639+⍳17]←'tion ',(,⎕UCS 9109),'cr ''foo''',(,⎕UCS 10 10),'D'
  (examplescript)[1656+⍳49]←'isplay and execute a series of APL statements.  C'
  (examplescript)[1705+⍳33]←'apture any explicit results.',(,⎕UCS 10),'.t x'
  (examplescript)[1738+⍳22]←(,⎕UCS 8592),'''apple betty cat''',(,⎕UCS 10),'.t '
  (examplescript)[1760+⍳15]←'foo x',(,⎕UCS 10),'.t x',(,⎕UCS 8592),''''' ',(,⎕UCS 8710)
  (examplescript)[1775+⍳21]←'box x',(,⎕UCS 10),'.t foo x',(,⎕UCS 10 10),'Displ'
  (examplescript)[1796+⍳44]←'ay a number with print precision set to 10.',(,⎕UCS 10)
  (examplescript)[1840+⍳15]←'.t ',(,⎕UCS 9109 8592 120 8592),'2.33333',(,⎕UCS 10)
  (examplescript)[1855+⍳49]←'Display the same number with print precision set '
  (examplescript)[1904+⍳13]←'to 2.',(,⎕UCS 10),'.e ',(,⎕UCS 9109 112 112 8592)
  (examplescript)[1917+⍳24]←(,⎕UCS 50 10),'.t x',(,⎕UCS 10),'.c Reset print pr'
  (examplescript)[1941+⍳15]←'ecision.',(,⎕UCS 10),'.e ',(,⎕UCS 9109 112 112)
  (examplescript)[1956+⍳29]←(,⎕UCS 8592 49 48 10 10),'...Niladic execute (.n) '
  (examplescript)[1985+⍳49]←'might typically be used to execute a function tha'
  (examplescript)[2034+⍳36]←'t',(,⎕UCS 10),'...performs a complicated sequence'
  (examplescript)[2070+⍳36]←' of operations for the script, for',(,⎕UCS 10),'.'
  (examplescript)[2106+⍳49]←'..example, a function for copying from a file a s'
  (examplescript)[2155+⍳36]←'et of functions to be',(,⎕UCS 10),'...executed du'
  (examplescript)[2191+⍳49]←'ring script processing, using special features of'
  (examplescript)[2240+⍳28]←' the APL',(,⎕UCS 10),'...implementation.',(,⎕UCS 10)
  (examplescript)[2268+⍳32]←(,⎕UCS 10),'...Example of niladic execute:',(,⎕UCS 10)
  (examplescript)[2300+⍳36]←'.d .n setupoperations',(,⎕UCS 10),'...(Result not'
  (examplescript)[2336+⍳34]←' shown)',(,⎕UCS 10 10),'.c The following is an ex'
  (examplescript)[2370+⍳39]←'tended example of the .p action code.',(,⎕UCS 10),'.'
  (examplescript)[2409+⍳49]←'c we need the .d code to include action codes at '
  (examplescript)[2458+⍳36]←'the beginning of text',(,⎕UCS 10),'.d .p code is '
  (examplescript)[2494+⍳49]←'useful for showing statements and displaying resu'
  (examplescript)[2543+⍳19]←'lts.',(,⎕UCS 10 10),'.p ',(,⎕UCS 9053),'A more co'
  (examplescript)[2562+⍳49]←'mplex set of statements.  All results captured an'
  (examplescript)[2611+⍳21]←'d displayed.',(,⎕UCS 10),'.p ',(,⎕UCS 9053),'This'
  (examplescript)[2632+⍳39]←' is algorithm for the function <first>',(,⎕UCS 10)
  (examplescript)[2671+⍳16]←'.p m',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''a'
  (examplescript)[2687+⍳30]←'pple/betty/cat/cat/betty''',(,⎕UCS 10),'.p ',(,⎕UCS 9053)
  (examplescript)[2717+⍳32]←'compute comparison matrix.',(,⎕UCS 10),'.p a',(,⎕UCS 8592)
  (examplescript)[2749+⍳11]←(,⎕UCS 109 8743 46 61 9033 109 10),'.p ',(,⎕UCS 9053)
  (examplescript)[2760+⍳42]←'compute first one from top of each column',(,⎕UCS 10)
  (examplescript)[2802+⍳34]←'.p ',(,⎕UCS 9053),'(first occurence of each uniqu'
  (examplescript)[2836+⍳15]←'e row)',(,⎕UCS 10),'.p b',(,⎕UCS 8592 60 9024 97)
  (examplescript)[2851+⍳24]←(,⎕UCS 10),'.p ',(,⎕UCS 9053),'y[i]=1 means i-th r'
  (examplescript)[2875+⍳48]←'ow of <m> is first unique occurence of this row',(,⎕UCS 10)
  (examplescript)[2923+⍳22]←'.p y',(,⎕UCS 8592 8744 47 98 10 10),'...End of ex'
  (examplescript)[2945+⍳34]←'ample of .p code',(,⎕UCS 10 10),'...This is the e'
  (examplescript)[2979+⍳36]←'nd of the examples for <script>.',(,⎕UCS 10),'.c '
  (examplescript)[3015+⍳49]←'expunge (erase) objects created during the script'
  (examplescript)[3064+⍳23]←'.',(,⎕UCS 10),'.x foo m a b x y',(,⎕UCS 10),'.c w'
  (examplescript)[3087+⍳49]←'e could have achieved the same result with the fo'
  (examplescript)[3136+⍳24]←'llowing ...',(,⎕UCS 10),'.c      .e ',(,⎕UCS 9109)
  (examplescript)[3160+⍳27]←'ex '''' ',(,⎕UCS 8710),'box ''foo m a b x y''',(,⎕UCS 10)
  (examplescript)[3187+⍳39]←'.c but the .x code is more convenient.',(,⎕UCS 10)

g∆cpucon∆ot←1 706.3999999999999 359 32964

g∆cr←,(,⎕UCS 10)

g∆sort∆columns←0

howadjust←2075⍴0 ⍝ prolog ≡1
  (howadjust)[⍳58]←'----------------------------------------------------------'
  (howadjust)[58+⍳34]←'--------------------',(,⎕UCS 10 121 8592),'x adjust d',(,⎕UCS 10)
  (howadjust)[92+⍳55]←'adjust each row of matrix <d> according to parameters <'
  (howadjust)[147+⍳41]←'x>',(,⎕UCS 10),'--------------------------------------'
  (howadjust)[188+⍳42]←'----------------------------------------',(,⎕UCS 10 10)
  (howadjust)[230+⍳28]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),' '
  (howadjust)[258+⍳54]←'  This function returns a text matrix with width adjus'
  (howadjust)[312+⍳41]←'ted.  It is',(,⎕UCS 10),'   particularly useful for pr'
  (howadjust)[353+⍳43]←'eparing output for display on a screen or',(,⎕UCS 10),' '
  (howadjust)[396+⍳54]←'  printer where width restrictions apply.  The rows of'
  (howadjust)[450+⍳41]←' the matrix <d>',(,⎕UCS 10),'   typically represent th'
  (howadjust)[491+⍳52]←'e lines of a document whose lines must be preserved',(,⎕UCS 10)
  (howadjust)[543+⍳54]←'   in the output, for example, the display format of a'
  (howadjust)[597+⍳39]←' function.',(,⎕UCS 10 10),'   This function uses the a'
  (howadjust)[636+⍳49]←'lgorithm <split> to fold (or split) the lines of',(,⎕UCS 10)
  (howadjust)[685+⍳28]←'   the matrix.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howadjust)[713+⍳40]←'--------',(,⎕UCS 10),'<x>   3-element numeric vector',(,⎕UCS 10)
  (howadjust)[753+⍳41]←'   x[1]  width of result in columns',(,⎕UCS 10),'   x['
  (howadjust)[794+⍳54]←'2]  width of left margin (i.e. number of initial blank'
  (howadjust)[848+⍳41]←' columns)',(,⎕UCS 10),'   x[3]  number of blank lines '
  (howadjust)[889+⍳43]←'to insert between each line of the output',(,⎕UCS 10),' '
  (howadjust)[932+⍳48]←'  x[1] is required; x[2] and x[3] default to 0.',(,⎕UCS 10)
  (howadjust)[980+⍳29]←(,⎕UCS 10),'<d>   character matrix',(,⎕UCS 10 10),'Resu'
  (howadjust)[1009+⍳27]←'lt:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   character '
  (howadjust)[1036+⍳40]←'matrix',(,⎕UCS 10),'   The result is the matrix <d> w'
  (howadjust)[1076+⍳40]←'ith lines adjusted according to the',(,⎕UCS 10),'   s'
  (howadjust)[1116+⍳32]←'pecification in <x>.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howadjust)[1148+⍳40]←'--------',(,⎕UCS 10),'...Fit a document into lines of'
  (howadjust)[1188+⍳49]←' length 50, with 5 blanks in front of each line.',(,⎕UCS 10)
  (howadjust)[1237+⍳16]←'      d',(,⎕UCS 8592),'(2,2',(,⎕UCS 215 9076 118 41)
  (howadjust)[1253+⍳33]←(,⎕UCS 9076 118 8592),'''The Cat in the Hat is a book '
  (howadjust)[1286+⍳37]←'for children.  ''',(,⎕UCS 10),'      50 5 adjust d',(,⎕UCS 10)
  (howadjust)[1323+⍳48]←'     The Cat in the Hat is a book for children.',(,⎕UCS 10)
  (howadjust)[1371+⍳50]←'       The Cat in the Hat is a book for children.',(,⎕UCS 10)
  (howadjust)[1421+⍳48]←'     The Cat in the Hat is a book for children.',(,⎕UCS 10)
  (howadjust)[1469+⍳50]←'       The Cat in the Hat is a book for children.',(,⎕UCS 10)
  (howadjust)[1519+⍳43]←(,⎕UCS 10),'...Adjust the display form of a function <'
  (howadjust)[1562+⍳40]←'matrix> to fit 30-character lines.',(,⎕UCS 10),'     '
  (howadjust)[1602+⍳37]←' 30 adjust displayfunction ',(,⎕UCS 9109),'cr ''matri'
  (howadjust)[1639+⍳15]←'x''',(,⎕UCS 10),'    ',(,⎕UCS 8711 32 121 8592),'matr'
  (howadjust)[1654+⍳25]←'ix x',(,⎕UCS 10),'[1]  ',(,⎕UCS 9053),'reshape any ar'
  (howadjust)[1679+⍳34]←'ray <x>',(,⎕UCS 10),' (rank 0 - n) to a matrix',(,⎕UCS 10)
  (howadjust)[1713+⍳23]←'[2]  ',(,⎕UCS 9053),'.e 6 2 = ',(,⎕UCS 9076),'matrix '
  (howadjust)[1736+⍳17]←'3 2 2',(,⎕UCS 10 32 9076),'''a''',(,⎕UCS 10),'[3]  '
  (howadjust)[1753+⍳20]←(,⎕UCS 9053),'.k reshape',(,⎕UCS 10),'[4]   y',(,⎕UCS 8592)
  (howadjust)[1773+⍳14]←(,⎕UCS 40 40 215 47 175 49 8595),' 1 1',(,⎕UCS 10 32 44)
  (howadjust)[1787+⍳12]←(,⎕UCS 9076),'x),',(,⎕UCS 175 49 8593 49 44 9076 120 41)
  (howadjust)[1799+⍳17]←(,⎕UCS 9076 120 10),'    ',(,⎕UCS 8711 10 10),'...Inse'
  (howadjust)[1816+⍳53]←'rt 1 line between each row (i.e. double space the out'
  (howadjust)[1869+⍳28]←'put)',(,⎕UCS 10),'      70 0 1 adjust d',(,⎕UCS 10),'T'
  (howadjust)[1897+⍳53]←'he Cat in the Hat is a book for children.  The Cat in'
  (howadjust)[1950+⍳35]←' the Hat is a',(,⎕UCS 10 10),' book for children.',(,⎕UCS 10)
  (howadjust)[1985+⍳43]←(,⎕UCS 10),'The Cat in the Hat is a book for children.'
  (howadjust)[2028+⍳38]←'  The Cat in the Hat is a',(,⎕UCS 10 10),' book for c'
  (howadjust)[2066+⍳9]←'hildren.',(,⎕UCS 10)

howafter←1489⍴0 ⍝ prolog ≡1
  (howafter)[⍳59]←'-----------------------------------------------------------'
  (howafter)[59+⍳36]←'-------------------',(,⎕UCS 10 89 8592),'Funs after Ts',(,⎕UCS 10)
  (howafter)[95+⍳56]←'get all functions in <Funs> with timestamp greater than '
  (howafter)[151+⍳42]←'<Ts>',(,⎕UCS 10),'-------------------------------------'
  (howafter)[193+⍳43]←'-----------------------------------------',(,⎕UCS 10 10)
  (howafter)[236+⍳29]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'  '
  (howafter)[265+⍳55]←' <after> returns a list of all the functions in the lis'
  (howafter)[320+⍳40]←'t <Funs> whose ''.t''',(,⎕UCS 10),'   timestamp is afte'
  (howafter)[360+⍳49]←'r (i.e.  later than) the time specified in <ts>.',(,⎕UCS 10)
  (howafter)[409+⍳45]←(,⎕UCS 10),'   This is typically used to select those fu'
  (howafter)[454+⍳40]←'nctions that were ''changed'' after',(,⎕UCS 10),'   a c'
  (howafter)[494+⍳40]←'ertain date.',(,⎕UCS 10 10),'   The significance of the'
  (howafter)[534+⍳50]←' ''.t'' timestamp depends on the convention used to',(,⎕UCS 10)
  (howafter)[584+⍳53]←'   create it.  In the toolkit workspace the ''.t'' time'
  (howafter)[637+⍳42]←'stamp was changed no',(,⎕UCS 10),'   matter how small t'
  (howafter)[679+⍳48]←'he change to the function (including changes to',(,⎕UCS 10)
  (howafter)[727+⍳53]←'   comments).  (However, the ''.v'' version number and '
  (howafter)[780+⍳40]←'date only changed with',(,⎕UCS 10),'   ''significant'' '
  (howafter)[820+⍳55]←'changes, e.g.  changes to codes, arguments, algorithms,'
  (howafter)[875+⍳27]←' and',(,⎕UCS 10),'   so on).',(,⎕UCS 10 10),'Arguments:'
  (howafter)[902+⍳32]←(,⎕UCS 10),'---------',(,⎕UCS 10),'<funs>   Character ve'
  (howafter)[934+⍳42]←'ctor or matrix',(,⎕UCS 10),'   Namelist of functions.  '
  (howafter)[976+⍳35]←'If <Funs> is empty, ',(,⎕UCS 9109),'nl 3 is used.',(,⎕UCS 10)
  (howafter)[1011+⍳41]←(,⎕UCS 10),'<ts>   Numeric vector (1 to 6 elements)',(,⎕UCS 10)
  (howafter)[1052+⍳54]←'   The time against which the timestamps will be compa'
  (howafter)[1106+⍳41]←'red.  <ts> is assumed',(,⎕UCS 10),'   to have the orde'
  (howafter)[1147+⍳53]←'r (yyyy mm dd hh mm ss), but a shorter vector can be',(,⎕UCS 10)
  (howafter)[1200+⍳53]←'   used, with the remaining elements defaulting to 0.'
  (howafter)[1253+⍳18]←(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howafter)[1271+⍳41]←'y>   Character matrix',(,⎕UCS 10),'   Matrix of names '
  (howafter)[1312+⍳46]←'of functions meeting the timestamp criterion.',(,⎕UCS 10)
  (howafter)[1358+⍳21]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'.'
  (howafter)[1379+⍳54]←'..Select all functions in workspace changed after Jan '
  (howafter)[1433+⍳33]←'1, 1992.',(,⎕UCS 10),'      '''' after 1992 1 1',(,⎕UCS 10)
  (howafter)[1466+⍳23]←'   (results not shown)',(,⎕UCS 10)

howamortize←2010⍴0 ⍝ prolog ≡1
  (howamortize)[⍳56]←'--------------------------------------------------------'
  (howamortize)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'amortize'
  (howamortize)[89+⍳40]←' w',(,⎕UCS 10),'amortization schedule based on <w> = '
  (howamortize)[129+⍳39]←'debt, rate, months',(,⎕UCS 10),'--------------------'
  (howamortize)[168+⍳52]←'----------------------------------------------------'
  (howamortize)[220+⍳24]←'------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'--'
  (howamortize)[244+⍳39]←'----------',(,⎕UCS 10),'   This function computes an'
  (howamortize)[283+⍳42]←' amortization schedule.  The amortization',(,⎕UCS 10)
  (howamortize)[325+⍳52]←'   algorithm is very simple (based on equal payments'
  (howamortize)[377+⍳39]←').  Use this function',(,⎕UCS 10),'   only for plann'
  (howamortize)[416+⍳51]←'ing purposes, as the schedule used by the financial'
  (howamortize)[467+⍳42]←(,⎕UCS 10),'   institution supplying the loan may dif'
  (howamortize)[509+⍳24]←'fer.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-------'
  (howamortize)[533+⍳34]←'--',(,⎕UCS 10),'<w>   3 element numeric vector',(,⎕UCS 10)
  (howamortize)[567+⍳46]←'   w[1] debt -- in total units (e.g. dollars)',(,⎕UCS 10)
  (howamortize)[613+⍳52]←'   w[2] rate -- the yearly interest rate expressed a'
  (howamortize)[665+⍳39]←'s a fraction',(,⎕UCS 10),'                e.g. 10.5 '
  (howamortize)[704+⍳39]←'per cent is expressed as .15',(,⎕UCS 10),'   w[3] ti'
  (howamortize)[743+⍳52]←'me period -- number of months over which loan will b'
  (howamortize)[795+⍳24]←'e repaid',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howamortize)[819+⍳29]←(,⎕UCS 10),'<y>   5 column matrix',(,⎕UCS 10),'   y[;'
  (howamortize)[848+⍳39]←'1] period',(,⎕UCS 10),'   y[;2] current debt outstan'
  (howamortize)[887+⍳39]←'ding',(,⎕UCS 10),'   y[;3] monthly payment (same pay'
  (howamortize)[926+⍳39]←'ment each month)',(,⎕UCS 10),'   y[;4] amortized amo'
  (howamortize)[965+⍳46]←'unt (portion of payment applied to principal)',(,⎕UCS 10)
  (howamortize)[1011+⍳51]←'   y[;5] interest (portion of payment counting as i'
  (howamortize)[1062+⍳23]←'nterest)',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'-----'
  (howamortize)[1085+⍳38]←'-',(,⎕UCS 10),'   Adapted from - The APL Handbook o'
  (howamortize)[1123+⍳41]←'f Techniques, IBM Corporation, Edited by',(,⎕UCS 10)
  (howamortize)[1164+⍳33]←'   Dave Macklin, 1977',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howamortize)[1197+⍳38]←'--------',(,⎕UCS 10),'..... borrow 50,000 dollars a'
  (howamortize)[1235+⍳38]←'t 10.5 per cent yearly interest',(,⎕UCS 10),'..... '
  (howamortize)[1273+⍳46]←'repay over 25 years with monthly payments (12',(,⎕UCS 215)
  (howamortize)[1319+⍳23]←'25 months)',(,⎕UCS 10),'      y',(,⎕UCS 8592),'amor'
  (howamortize)[1342+⍳29]←'tize 50000 .15, 12',(,⎕UCS 215 50 53 10 10),'..... '
  (howamortize)[1371+⍳51]←'display the payment schedule for the first 12 payme'
  (howamortize)[1422+⍳22]←'nts',(,⎕UCS 10),'      (2 0,8',(,⎕UCS 9076),'8 2) '
  (howamortize)[1444+⍳17]←(,⎕UCS 9045 121 91 9075),'12;]',(,⎕UCS 10),' 150000.'
  (howamortize)[1461+⍳38]←'00  640.42   15.42  625.00',(,⎕UCS 10),' 249984.58 '
  (howamortize)[1499+⍳38]←' 640.42   15.61  624.81',(,⎕UCS 10),' 349968.98  64'
  (howamortize)[1537+⍳38]←'0.42   15.80  624.61',(,⎕UCS 10),' 449953.17  640.4'
  (howamortize)[1575+⍳38]←'2   16.00  624.41',(,⎕UCS 10),' 549937.17  640.42  '
  (howamortize)[1613+⍳38]←' 16.20  624.21',(,⎕UCS 10),' 649920.97  640.42   16'
  (howamortize)[1651+⍳38]←'.40  624.01',(,⎕UCS 10),' 749904.57  640.42   16.61'
  (howamortize)[1689+⍳38]←'  623.81',(,⎕UCS 10),' 849887.96  640.42   16.82  6'
  (howamortize)[1727+⍳38]←'23.60',(,⎕UCS 10),' 949871.15  640.42   17.03  623.'
  (howamortize)[1765+⍳37]←'39',(,⎕UCS 10),'1049854.12  640.42   17.24  623.18'
  (howamortize)[1802+⍳36]←(,⎕UCS 10),'1149836.88  640.42   17.45  622.96',(,⎕UCS 10)
  (howamortize)[1838+⍳37]←'1249819.43  640.42   17.67  622.74',(,⎕UCS 10 10),'.'
  (howamortize)[1875+⍳51]←'.... compute and display total amount, principal, a'
  (howamortize)[1926+⍳38]←'nd interest paid',(,⎕UCS 10),'      12 2 12 2 12 2 '
  (howamortize)[1964+⍳13]←(,⎕UCS 9045 43 9023),'0 2',(,⎕UCS 8595 121 10),'   1'
  (howamortize)[1977+⍳33]←'92124.59    50000.00   142124.59',(,⎕UCS 10)

howarabic←1298⍴0 ⍝ prolog ≡1
  (howarabic)[⍳58]←'----------------------------------------------------------'
  (howarabic)[58+⍳32]←'--------------------',(,⎕UCS 10 121 8592),'arabic x',(,⎕UCS 10)
  (howarabic)[90+⍳55]←'returns arabic (base 10) equivalent for character roman'
  (howarabic)[145+⍳41]←' numeral <x>',(,⎕UCS 10),'----------------------------'
  (howarabic)[186+⍳51]←'--------------------------------------------------',(,⎕UCS 10)
  (howarabic)[237+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howarabic)[265+⍳54]←'   <arabic> returns the equivalent Arabic (i.e.  base '
  (howarabic)[319+⍳41]←'10 notation) form of a',(,⎕UCS 10),'   number given in'
  (howarabic)[360+⍳52]←' ''Roman numeral'' notation.  The result is returned a'
  (howarabic)[412+⍳27]←'s a',(,⎕UCS 10),'   numeric quantity.',(,⎕UCS 10 10),'A'
  (howarabic)[439+⍳28]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<x>   Ch'
  (howarabic)[467+⍳41]←'aracter scalar or vector',(,⎕UCS 10),'   <x> is expect'
  (howarabic)[508+⍳52]←'ed in valid ''Roman numeral'' notation.  <x> is checke'
  (howarabic)[560+⍳37]←'d for',(,⎕UCS 10),'   valid Roman letters ''x'', ''i'''
  (howarabic)[597+⍳44]←', ''v'', etc., and an error message issued if',(,⎕UCS 10)
  (howarabic)[641+⍳54]←'   invalid letters are found.  However, correct syntax'
  (howarabic)[695+⍳39]←' is not validated.',(,⎕UCS 10 10),'   Valid roman nume'
  (howarabic)[734+⍳54]←'rals are translated correctly.  Incorrectly written ro'
  (howarabic)[788+⍳41]←'man',(,⎕UCS 10),'   numerals are translated with no wa'
  (howarabic)[829+⍳41]←'rning message, but the result has no',(,⎕UCS 10),'   m'
  (howarabic)[870+⍳24]←'eaning.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howarabic)[894+⍳41]←'<y>   numeric scalar',(,⎕UCS 10),'   The Arabic number'
  (howarabic)[935+⍳42]←' corresponding to the Roman numeral <x>.',(,⎕UCS 10 10)
  (howarabic)[977+⍳28]←'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ara'
  (howarabic)[1005+⍳30]←'bic ''iv''',(,⎕UCS 10 52 10),'      arabic ''xiv''',(,⎕UCS 10)
  (howarabic)[1035+⍳33]←(,⎕UCS 49 52 10),'      arabic ''mdcccclxxxviii''',(,⎕UCS 10)
  (howarabic)[1068+⍳32]←'1988',(,⎕UCS 10),'      arabic ''mcmlxxxviii''',(,⎕UCS 10)
  (howarabic)[1100+⍳38]←'1988',(,⎕UCS 10 10),',,, Incorrect roman numerals are'
  (howarabic)[1138+⍳48]←' translated but the result has no significance.',(,⎕UCS 10)
  (howarabic)[1186+⍳28]←'      arabic ''mmvvicd''',(,⎕UCS 10),'2409',(,⎕UCS 10)
  (howarabic)[1214+⍳39]←(,⎕UCS 10),'... <roman> and <arabic> are inverses',(,⎕UCS 10)
  (howarabic)[1253+⍳38]←'      roman arabic ''mcmlxxxviii''',(,⎕UCS 10),'mcmlx'
  (howarabic)[1291+⍳7]←'xxviii',(,⎕UCS 10)

howarray←1299⍴0 ⍝ prolog ≡1
  (howarray)[⍳59]←'-----------------------------------------------------------'
  (howarray)[59+⍳35]←'-------------------',(,⎕UCS 10 114 8592),'del array str'
  (howarray)[94+⍳46]←(,⎕UCS 10),'general vector reshape. reshape vector <str> '
  (howarray)[140+⍳42]←'using delimiters <del>',(,⎕UCS 10),'-------------------'
  (howarray)[182+⍳55]←'-------------------------------------------------------'
  (howarray)[237+⍳27]←'----',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-------'
  (howarray)[264+⍳42]←'-----',(,⎕UCS 10),'   This function reshapes a vector i'
  (howarray)[306+⍳42]←'nto an array according to the field',(,⎕UCS 10),'   del'
  (howarray)[348+⍳55]←'imiters in <del>.  <array> is a generalization to n dim'
  (howarray)[403+⍳30]←'ensions of the',(,⎕UCS 10),'   function <',(,⎕UCS 8710),'b'
  (howarray)[433+⍳43]←'ox>, which reshapes a vector to a matrix.',(,⎕UCS 10 10)
  (howarray)[476+⍳29]←'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<del>   '
  (howarray)[505+⍳42]←'Vector',(,⎕UCS 10),'   A vector of n delimiters where t'
  (howarray)[547+⍳42]←'he first delimiter specifies the first',(,⎕UCS 10),'   '
  (howarray)[589+⍳55]←'dimension, the second delimiter specifies the second di'
  (howarray)[644+⍳36]←'mension, and so on.',(,⎕UCS 10 10),'<str>   Vector',(,⎕UCS 10)
  (howarray)[680+⍳50]←'   A vector of data to be reshaped into an array.',(,⎕UCS 10)
  (howarray)[730+⍳19]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>'
  (howarray)[749+⍳42]←'   Array',(,⎕UCS 10),'   The result is an array with ra'
  (howarray)[791+⍳20]←'nk 1+',(,⎕UCS 9076),'del.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howarray)[811+⍳42]←'------',(,⎕UCS 10),'   Andreas Werder (I.P.Sharp, Zuric'
  (howarray)[853+⍳44]←'h), taken from: APL, A Design Handbook for',(,⎕UCS 10),' '
  (howarray)[897+⍳41]←'  Commercial Systems, by Adrian Smith.',(,⎕UCS 10 10),'E'
  (howarray)[938+⍳29]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...Reshape '
  (howarray)[967+⍳55]←'vector to rank-3 array.  </> separates planes, <,> sepa'
  (howarray)[1022+⍳22]←'rates rows.',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592),'ma'
  (howarray)[1044+⍳36]←'t',(,⎕UCS 8592),'''/,'' array ''apple,betty,cat/one,tw'
  (howarray)[1080+⍳21]←'o,three''',(,⎕UCS 10),'apple',(,⎕UCS 10),'betty',(,⎕UCS 10)
  (howarray)[1101+⍳14]←'cat',(,⎕UCS 10 10),'one',(,⎕UCS 10),'two',(,⎕UCS 10),'t'
  (howarray)[1115+⍳16]←'hree',(,⎕UCS 10),'      ',(,⎕UCS 9076),'mat',(,⎕UCS 10)
  (howarray)[1131+⍳39]←'2 3 5',(,⎕UCS 10 10),'...Special case -- Reshape vecto'
  (howarray)[1170+⍳38]←'r to matrix.',(,⎕UCS 10),'      '' '' array ''apple be'
  (howarray)[1208+⍳21]←'tty cat''',(,⎕UCS 10),'apple',(,⎕UCS 10),'betty',(,⎕UCS 10)
  (howarray)[1229+⍳22]←'cat',(,⎕UCS 10),'...Same as <',(,⎕UCS 8710),'box>',(,⎕UCS 10)
  (howarray)[1251+⍳32]←'      '''' ',(,⎕UCS 8710),'box ''apple betty cat''',(,⎕UCS 10)
  (howarray)[1283+⍳16]←'apple',(,⎕UCS 10),'betty',(,⎕UCS 10),'cat',(,⎕UCS 10)

howbal←1511⍴0 ⍝ prolog ≡1
  (howbal)[⍳61]←'-------------------------------------------------------------'
  (howbal)[61+⍳29]←'-----------------',(,⎕UCS 10 90 8592),'J bal N',(,⎕UCS 10),'d'
  (howbal)[90+⍳58]←'isplay balance (nesting levels) in lines <J> of function <'
  (howbal)[148+⍳44]←'N>',(,⎕UCS 10),'-----------------------------------------'
  (howbal)[192+⍳42]←'-------------------------------------',(,⎕UCS 10 10),'Int'
  (howbal)[234+⍳31]←'roduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <bal'
  (howbal)[265+⍳57]←'> is a very useful tool to analyze complex statement line'
  (howbal)[322+⍳42]←'s of a',(,⎕UCS 10),'   function.  It uses the ''exploded'
  (howbal)[364+⍳43]←''' display produced by <balance>.  (See',(,⎕UCS 10),'   e'
  (howbal)[407+⍳42]←'xamples below and for <balance>.)',(,⎕UCS 10 10),'   The '
  (howbal)[449+⍳55]←'<bal> function is a ''driver'' for <balance>.  It checks '
  (howbal)[504+⍳44]←'the arguments',(,⎕UCS 10),'   and applies <balance> to ea'
  (howbal)[548+⍳40]←'ch specified function line.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howbal)[588+⍳32]←'---------',(,⎕UCS 10),'<j>   Numeric vector',(,⎕UCS 10),' '
  (howbal)[620+⍳57]←'  A vector of line numbers within the function <name>.  L'
  (howbal)[677+⍳41]←'ine 0 is considered',(,⎕UCS 10),'   to be the header.',(,⎕UCS 10)
  (howbal)[718+⍳37]←(,⎕UCS 10),'<name>   Character vector or scalar',(,⎕UCS 10)
  (howbal)[755+⍳45]←'   The name of the function to be analyzed.',(,⎕UCS 10 10)
  (howbal)[800+⍳31]←'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Character '
  (howbal)[831+⍳44]←'matrix',(,⎕UCS 10),'   The formatted display showing line'
  (howbal)[875+⍳40]←' numbers and exploded display.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howbal)[915+⍳42]←'------',(,⎕UCS 10),'   Adapted from the xref workspace',(,⎕UCS 10)
  (howbal)[957+⍳21]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),' '
  (howbal)[978+⍳37]←'     18 19 bal ''balance''',(,⎕UCS 10),'balance[18]',(,⎕UCS 10)
  (howbal)[1015+⍳19]←(,⎕UCS 107 109 8592 8968),'/mb',(,⎕UCS 10 10),'balance[19'
  (howbal)[1034+⍳21]←']',(,⎕UCS 10 110 8592),'(...)',(,⎕UCS 8854),'n,[.](.....'
  (howbal)[1055+⍳23]←')',(,⎕UCS 9076),'''.''',(,⎕UCS 10),'   -mb     0  km,'
  (howbal)[1078+⍳28]←(,⎕UCS 9076),'n   .',(,⎕UCS 10 10),'      10 bal ''subtot'
  (howbal)[1106+⍳22]←'al''',(,⎕UCS 10),'subtotal[10]',(,⎕UCS 10 114 8592),'(..'
  (howbal)[1128+⍳56]←'.......................................)[...............'
  (howbal)[1184+⍳43]←']',(,⎕UCS 10),'   m,[.]-/[.](.............)[............'
  (howbal)[1227+⍳28]←'..]  ',(,⎕UCS 9035),'(.....),p[..];',(,⎕UCS 10),'      1'
  (howbal)[1255+⍳30]←'    2  +\[.] 0,[.] m  ',(,⎕UCS 9021),'p+(..)',(,⎕UCS 9076)
  (howbal)[1285+⍳23]←' 0 1 ;     ',(,⎕UCS 9075 49 8593 9076),'m    ;2',(,⎕UCS 10)
  (howbal)[1308+⍳37]←'                 1     1         ',(,⎕UCS 9076 112 10 10)
  (howbal)[1345+⍳33]←'      26 bal ''gettag''',(,⎕UCS 10),'gettag[26]',(,⎕UCS 10)
  (howbal)[1378+⍳34]←(,⎕UCS 73 8592),'(.............................)',(,⎕UCS 9075)
  (howbal)[1412+⍳21]←(,⎕UCS 49 10),'   ',(,⎕UCS 9021 60 92 9021),'(...........'
  (howbal)[1433+⍳28]←'......)',(,⎕UCS 8743),'.=Tag',(,⎕UCS 10),'        (.....'
  (howbal)[1461+⍳30]←'.......)',(,⎕UCS 8593 67 114 10),'         (.....),',(,⎕UCS 9076)
  (howbal)[1491+⍳20]←'Tag',(,⎕UCS 10),'          1',(,⎕UCS 8593 9076 67 114 10)

howbalance←1928⍴0 ⍝ prolog ≡1
  (howbalance)[⍳57]←'---------------------------------------------------------'
  (howbalance)[57+⍳33]←'---------------------',(,⎕UCS 10 121 8592),'balance n'
  (howbalance)[90+⍳44]←(,⎕UCS 10),'display balance (nesting levels) in text ve'
  (howbalance)[134+⍳40]←'ctor <n>',(,⎕UCS 10),'-------------------------------'
  (howbalance)[174+⍳48]←'-----------------------------------------------',(,⎕UCS 10)
  (howbalance)[222+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howbalance)[250+⍳53]←'   For a given text <n> containing pairs of balanced '
  (howbalance)[303+⍳40]←'delimiters, this',(,⎕UCS 10),'   function produces a '
  (howbalance)[343+⍳51]←'clearly formatted ''exploded'' display of the text.  '
  (howbalance)[394+⍳40]←'It',(,⎕UCS 10),'   is very useful for analyzing APL s'
  (howbalance)[434+⍳40]←'tatements containing many quotes,',(,⎕UCS 10),'   par'
  (howbalance)[474+⍳44]←'entheses, or index brackets.  See examples.',(,⎕UCS 10)
  (howbalance)[518+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howbalance)[540+⍳40]←'<n>   character vector',(,⎕UCS 10),'   Text to be ana'
  (howbalance)[580+⍳22]←'lyzed',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howbalance)[602+⍳39]←'<y>   character matrix',(,⎕UCS 10),'   The ''exploded'
  (howbalance)[641+⍳27]←''' display of <n>',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'-'
  (howbalance)[668+⍳37]←'-----',(,⎕UCS 10),'   Adapted from xref workspace',(,⎕UCS 10)
  (howbalance)[705+⍳20]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howbalance)[725+⍳53]←'...Below are three APL statements adapted from variou'
  (howbalance)[778+⍳20]←'s sources',(,⎕UCS 10 10),'      ',(,⎕UCS 9109 8592),'l'
  (howbalance)[798+⍳14]←'ine',(,⎕UCS 8592 39 105 8592),'((((1',(,⎕UCS 8593 9076)
  (howbalance)[812+⍳14]←'cr),',(,⎕UCS 9076),'tag)',(,⎕UCS 8593),'cr)',(,⎕UCS 8743)
  (howbalance)[826+⍳18]←'.=tag)',(,⎕UCS 9075 49 39 10 105 8592),'((((1',(,⎕UCS 8593)
  (howbalance)[844+⍳12]←(,⎕UCS 9076),'cr),',(,⎕UCS 9076),'tag)',(,⎕UCS 8593),'c'
  (howbalance)[856+⍳19]←'r)',(,⎕UCS 8743),'.=tag)',(,⎕UCS 9075 49 10),'      b'
  (howbalance)[875+⍳33]←'alance line',(,⎕UCS 10 105 8592),'(..................'
  (howbalance)[908+⍳33]←'.......)',(,⎕UCS 9075 49 10),'   (.................)'
  (howbalance)[941+⍳25]←(,⎕UCS 8743),'.=tag',(,⎕UCS 10),'    (............)'
  (howbalance)[966+⍳19]←(,⎕UCS 8593 99 114 10),'     (.....),',(,⎕UCS 9076),'t'
  (howbalance)[985+⍳16]←'ag',(,⎕UCS 10),'      1',(,⎕UCS 8593 9076 99 114 10 10)
  (howbalance)[1001+⍳15]←'      ',(,⎕UCS 9109 8592),'line',(,⎕UCS 8592 39 9109)
  (howbalance)[1016+⍳34]←(,⎕UCS 8592),'''''... name = script'''',N,''''.  Size'
  (howbalance)[1050+⍳23]←' = '''',(',(,⎕UCS 9045 9076 9038),'''''script'''',N)'
  (howbalance)[1073+⍳27]←'''',(,⎕UCS 10 9109 8592),'''... name = script'',N,'''
  (howbalance)[1100+⍳26]←'.  Size = '',(',(,⎕UCS 9045 9076 9038),'''script'',N'
  (howbalance)[1126+⍳22]←')',(,⎕UCS 10),'      balance line',(,⎕UCS 10 9109)
  (howbalance)[1148+⍳36]←(,⎕UCS 8592),'''.................'',N,''..........'','
  (howbalance)[1184+⍳39]←'(.............)',(,⎕UCS 10),'   ... name = script   '
  (howbalance)[1223+⍳27]←'  .  Size =    ',(,⎕UCS 9045 9076 9038),'''......'','
  (howbalance)[1250+⍳39]←'N',(,⎕UCS 10),'                                     '
  (howbalance)[1289+⍳21]←'     script',(,⎕UCS 10 10),'      ',(,⎕UCS 9109 8592)
  (howbalance)[1310+⍳28]←'line',(,⎕UCS 8592 39 114 8592),'(m,[1]-/[2](+\[1] 0,'
  (howbalance)[1338+⍳16]←'[1] m)[',(,⎕UCS 9021),'p+(',(,⎕UCS 9076 112 41 9076),' '
  (howbalance)[1354+⍳21]←'0 1 ;])[',(,⎕UCS 9035 40 9075 49 8593 9076),'m),p[;2'
  (howbalance)[1375+⍳31]←'];]''',(,⎕UCS 10 114 8592),'(m,[1]-/[2](+\[1] 0,[1] '
  (howbalance)[1406+⍳13]←'m)[',(,⎕UCS 9021),'p+(',(,⎕UCS 9076 112 41 9076),' 0'
  (howbalance)[1419+⍳21]←' 1 ;])[',(,⎕UCS 9035 40 9075 49 8593 9076),'m),p[;2]'
  (howbalance)[1440+⍳23]←';]',(,⎕UCS 10),'      balance line',(,⎕UCS 10 114)
  (howbalance)[1463+⍳40]←(,⎕UCS 8592),'(......................................'
  (howbalance)[1503+⍳39]←'...)[...............]',(,⎕UCS 10),'   m,[.]-/[.](...'
  (howbalance)[1542+⍳37]←'..........)[..............]  ',(,⎕UCS 9035),'(.....)'
  (howbalance)[1579+⍳37]←',p[..];',(,⎕UCS 10),'      1    2  +\[.] 0,[.] m  '
  (howbalance)[1616+⍳20]←(,⎕UCS 9021),'p+(..)',(,⎕UCS 9076),' 0 1 ;     ',(,⎕UCS 9075)
  (howbalance)[1636+⍳21]←(,⎕UCS 49 8593 9076),'m    ;2',(,⎕UCS 10),'          '
  (howbalance)[1657+⍳32]←'       1     1         ',(,⎕UCS 9076 112 10),'...For'
  (howbalance)[1689+⍳52]←' the last statement the first line of the display re'
  (howbalance)[1741+⍳36]←'adily shows the',(,⎕UCS 10),'...basic structure:',(,⎕UCS 10)
  (howbalance)[1777+⍳32]←'...          r',(,⎕UCS 8592),'(matrix)[index;]',(,⎕UCS 10)
  (howbalance)[1809+⍳52]←'...Now look at the second line of the display for mo'
  (howbalance)[1861+⍳39]←'re detail on (matrix):',(,⎕UCS 10),'...          (m,'
  (howbalance)[1900+⍳28]←'[1]-/[2] (matrix2)[index;])',(,⎕UCS 10)

howbase←1411⍴0 ⍝ prolog ≡1
  (howbase)[⍳60]←'------------------------------------------------------------'
  (howbase)[60+⍳34]←'------------------',(,⎕UCS 10 114 8592),'cs base text',(,⎕UCS 10)
  (howbase)[94+⍳57]←'encodes <text> to an integer using collating sequence <cs'
  (howbase)[151+⍳43]←'>',(,⎕UCS 10),'-----------------------------------------'
  (howbase)[194+⍳41]←'-------------------------------------',(,⎕UCS 10 10),'In'
  (howbase)[235+⍳30]←'troduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <b'
  (howbase)[265+⍳56]←'ase> encodes a text argument to a base n+1 integer using'
  (howbase)[321+⍳43]←' a specified',(,⎕UCS 10),'   sequence n letters long.  T'
  (howbase)[364+⍳47]←'his result has many applications, for example,',(,⎕UCS 10)
  (howbase)[411+⍳56]←'   for sorting text, encoding names to a numeric field, '
  (howbase)[467+⍳33]←'secret writing, etc.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howbase)[500+⍳34]←'---------',(,⎕UCS 10),'<cs>   Character vector',(,⎕UCS 10)
  (howbase)[534+⍳56]←'   <cs> is the collating sequence.  Each element in <cs>'
  (howbase)[590+⍳41]←' in effect represents',(,⎕UCS 10),'   a ''digit'' in the'
  (howbase)[631+⍳52]←' number system to which the argument <text> will be',(,⎕UCS 10)
  (howbase)[683+⍳41]←'   encoded.',(,⎕UCS 10 10),'<text>   Character vector or'
  (howbase)[724+⍳43]←' matrix',(,⎕UCS 10),'   Each row of <text> represents a '
  (howbase)[767+⍳43]←'text vector that will be encoded into one',(,⎕UCS 10),' '
  (howbase)[810+⍳50]←'  number.  A vector is treated as a 1-row matrix.',(,⎕UCS 10)
  (howbase)[860+⍳20]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r> '
  (howbase)[880+⍳43]←'  Numeric vector',(,⎕UCS 10),'   Vector of encoded numbe'
  (howbase)[923+⍳41]←'rs.  The numbers will be in base (1+',(,⎕UCS 9076),'cs) '
  (howbase)[964+⍳43]←'in order',(,⎕UCS 10),'   to take account of unknown char'
  (howbase)[1007+⍳44]←'acters, that is, characters not present in',(,⎕UCS 10),' '
  (howbase)[1051+⍳27]←'  <cs>.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------'
  (howbase)[1078+⍳23]←(,⎕UCS 10),'      cs',(,⎕UCS 8592),'''0123456789''',(,⎕UCS 10)
  (howbase)[1101+⍳35]←'      cs base ''0''',(,⎕UCS 10 48 10),'      cs base '''
  (howbase)[1136+⍳24]←'1''',(,⎕UCS 10 49 10),'      cs base 2 1',(,⎕UCS 9076),''''
  (howbase)[1160+⍳26]←'01''',(,⎕UCS 10),'0 1',(,⎕UCS 10),'      cs base ''10'''
  (howbase)[1186+⍳28]←(,⎕UCS 10 49 49 10),'... decode the integer',(,⎕UCS 10),' '
  (howbase)[1214+⍳26]←'     cs[1+11 11 11',(,⎕UCS 8868),'11]',(,⎕UCS 10),'010'
  (howbase)[1240+⍳27]←(,⎕UCS 10 10),'      cs',(,⎕UCS 8592),'''abcdefghijklmno'
  (howbase)[1267+⍳22]←'pqrstuvwxyz''',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 110)
  (howbase)[1289+⍳24]←(,⎕UCS 8592),'cs base ''apple''',(,⎕UCS 10),'306481',(,⎕UCS 10)
  (howbase)[1313+⍳55]←'... Remember that the result <n> is a one-element vecto'
  (howbase)[1368+⍳29]←'r.',(,⎕UCS 10),'      cs[1+27 27 27 27 27',(,⎕UCS 8868)
  (howbase)[1397+⍳14]←(,⎕UCS 40 9075 48 41 9076 110 93 10),'apple',(,⎕UCS 10)

howbeside←1422⍴0 ⍝ prolog ≡1
  (howbeside)[⍳58]←'----------------------------------------------------------'
  (howbeside)[58+⍳34]←'--------------------',(,⎕UCS 10 121 8592),'a beside b',(,⎕UCS 10)
  (howbeside)[92+⍳55]←'catenate array <a> to array <b> (maximum rank 2) on las'
  (howbeside)[147+⍳41]←'t coordinate',(,⎕UCS 10),'----------------------------'
  (howbeside)[188+⍳51]←'--------------------------------------------------',(,⎕UCS 10)
  (howbeside)[239+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howbeside)[267+⍳54]←'   Often one wants to catenate vectors and matrices wh'
  (howbeside)[321+⍳41]←'ose lengths are not',(,⎕UCS 10),'   conformable.  This'
  (howbeside)[362+⍳53]←' function pads the arguments and catenates them along'
  (howbeside)[415+⍳44]←(,⎕UCS 10),'   the second coordinate (columns).  This f'
  (howbeside)[459+⍳41]←'unction is associated with the',(,⎕UCS 10),'   functio'
  (howbeside)[500+⍳54]←'n <on> which catenates along rows.  Both functions are'
  (howbeside)[554+⍳41]←' restricted',(,⎕UCS 10),'   to arrays of rank 2 or les'
  (howbeside)[595+⍳25]←'s.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howbeside)[620+⍳39]←'<a>   Array (rank',(,⎕UCS 8804),'2), numeric or charac'
  (howbeside)[659+⍳25]←'ter',(,⎕UCS 10 10),'<b>   Same as <a>',(,⎕UCS 10 10),'R'
  (howbeside)[684+⍳27]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Matrix',(,⎕UCS 10)
  (howbeside)[711+⍳54]←'   The result consists of <a> catenated to <b> along t'
  (howbeside)[765+⍳41]←'he last coordinate.  If',(,⎕UCS 10),'   an argument is'
  (howbeside)[806+⍳54]←' a scalar or vector, it is first reshaped to a one-col'
  (howbeside)[860+⍳41]←'umn',(,⎕UCS 10),'   matrix.  The number of columns in '
  (howbeside)[901+⍳41]←'<y> is the sum of the number of columns',(,⎕UCS 10),' '
  (howbeside)[942+⍳48]←'  in each argument, after reshaping, that is, (',(,⎕UCS 175)
  (howbeside)[990+⍳14]←(,⎕UCS 49 8593 9076),'y) = (',(,⎕UCS 175 49 8593 9076),'a'
  (howbeside)[1004+⍳20]←')+(',(,⎕UCS 175 49 8593 9076 98 41 10 10),'Examples:'
  (howbeside)[1024+⍳18]←(,⎕UCS 10),'--------',(,⎕UCS 10),'      v',(,⎕UCS 8592)
  (howbeside)[1042+⍳19]←'''aaaa''',(,⎕UCS 10),'      m',(,⎕UCS 8592),'2 2',(,⎕UCS 9076)
  (howbeside)[1061+⍳24]←'''b''',(,⎕UCS 10),'      v beside m',(,⎕UCS 10),'abb'
  (howbeside)[1085+⍳22]←(,⎕UCS 10),'abb',(,⎕UCS 10 97 10 97 10),'      m besid'
  (howbeside)[1107+⍳25]←'e v beside m',(,⎕UCS 10),'bbabb',(,⎕UCS 10),'bbabb',(,⎕UCS 10)
  (howbeside)[1132+⍳19]←'  a',(,⎕UCS 10),'  a',(,⎕UCS 10),'      (3 3',(,⎕UCS 9076)
  (howbeside)[1151+⍳28]←(,⎕UCS 39 8902),''') beside '' '', m beside v',(,⎕UCS 10)
  (howbeside)[1179+⍳11]←(,⎕UCS 8902 8902 8902),' bba',(,⎕UCS 10 8902 8902 8902)
  (howbeside)[1190+⍳15]←' bba',(,⎕UCS 10 8902 8902 8902),'   a',(,⎕UCS 10),'  '
  (howbeside)[1205+⍳35]←'    a',(,⎕UCS 10 10),'      10 20 30 40 beside 3 3'
  (howbeside)[1240+⍳24]←(,⎕UCS 9076 53 10),'10  5  5  5',(,⎕UCS 10),'20  5  5 '
  (howbeside)[1264+⍳26]←' 5',(,⎕UCS 10),'30  5  5  5',(,⎕UCS 10),'40  0  0  0'
  (howbeside)[1290+⍳41]←(,⎕UCS 10 10),'..... Note a difference between <beside'
  (howbeside)[1331+⍳39]←'> and the APL catenate function',(,⎕UCS 10),'      '''
  (howbeside)[1370+⍳21]←'a'' beside 2 2',(,⎕UCS 9076 39 8902 39 10 97 8902 8902)
  (howbeside)[1391+⍳19]←(,⎕UCS 10 32 8902 8902 10),'      ''a'',2 2',(,⎕UCS 9076)
  (howbeside)[1410+⍳12]←(,⎕UCS 39 8902 39 10 97 8902 8902 10 97 8902 8902 10)

howboxf←1122⍴0 ⍝ prolog ≡1
  (howboxf)[⍳60]←'------------------------------------------------------------'
  (howboxf)[60+⍳30]←'------------------',(,⎕UCS 10 121 8592),'w boxf v',(,⎕UCS 10)
  (howboxf)[90+⍳57]←'box fields. <y[i;]> is a field of vector <v> specifed by '
  (howboxf)[147+⍳43]←'width <w[i]>',(,⎕UCS 10),'------------------------------'
  (howboxf)[190+⍳49]←'------------------------------------------------',(,⎕UCS 10)
  (howboxf)[239+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howboxf)[267+⍳56]←'   <boxf> reshapes a vector into a matrix, given a set o'
  (howboxf)[323+⍳41]←'f ''field'' widths.',(,⎕UCS 10),'   This function is mor'
  (howboxf)[364+⍳41]←'e direct than <',(,⎕UCS 8710),'box> when the field width'
  (howboxf)[405+⍳28]←'s are',(,⎕UCS 10),'   already known.',(,⎕UCS 10 10),'Arg'
  (howboxf)[433+⍳30]←'uments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<w>   Numeri'
  (howboxf)[463+⍳43]←'c vector',(,⎕UCS 10),'   The field widths of vector <v>.'
  (howboxf)[506+⍳36]←(,⎕UCS 10 10),'<v>   Character or numeric vector',(,⎕UCS 10)
  (howboxf)[542+⍳42]←'   The data to be reshaped to a matrix.',(,⎕UCS 10 10),'R'
  (howboxf)[584+⍳27]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Matrix',(,⎕UCS 10)
  (howboxf)[611+⍳56]←'   A matrix representation of vector <v>.  <y[i;]> is a '
  (howboxf)[667+⍳43]←'field of vector <v>',(,⎕UCS 10),'   specifed by width <w'
  (howboxf)[710+⍳49]←'[i]>.  The fill character is blank for character',(,⎕UCS 10)
  (howboxf)[759+⍳41]←'   matrices, 0 for numeric matrices.',(,⎕UCS 10 10),'Sou'
  (howboxf)[800+⍳30]←'rce:',(,⎕UCS 10),'------',(,⎕UCS 10),'   Adapted from Th'
  (howboxf)[830+⍳42]←'e APL Programming Guide (IBM), page 26.',(,⎕UCS 10 10),'E'
  (howboxf)[872+⍳30]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      record'
  (howboxf)[902+⍳40]←(,⎕UCS 8592),'''John Doe65 Any StreetToronto Ontario''',(,⎕UCS 10)
  (howboxf)[942+⍳28]←'      widths',(,⎕UCS 8592),'8 13 15',(,⎕UCS 10),'      w'
  (howboxf)[970+⍳30]←'idths boxf record',(,⎕UCS 10),'John Doe',(,⎕UCS 10),'65 '
  (howboxf)[1000+⍳29]←'Any Street',(,⎕UCS 10),'Toronto Ontario',(,⎕UCS 10 10),' '
  (howboxf)[1029+⍳45]←'     2 3 4 boxf 8 8 98 98 98 100 100 100 200',(,⎕UCS 10)
  (howboxf)[1074+⍳32]←'  8   8   0   0',(,⎕UCS 10),' 98  98  98   0',(,⎕UCS 10)
  (howboxf)[1106+⍳16]←'100 100 100 200',(,⎕UCS 10)

howbp←1107⍴0 ⍝ prolog ≡1
  (howbp)[⍳62]←'--------------------------------------------------------------'
  (howbp)[62+⍳26]←'----------------',(,⎕UCS 10 121 8592),'bp x',(,⎕UCS 10),'se'
  (howbp)[88+⍳57]←'arch for ''break points'' based on beginning of identical s'
  (howbp)[145+⍳45]←'equences in <x>',(,⎕UCS 10),'-----------------------------'
  (howbp)[190+⍳50]←'-------------------------------------------------',(,⎕UCS 10)
  (howbp)[240+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howbp)[268+⍳56]←'   <bp> computes the ''break points'' in a vector or matri'
  (howbp)[324+⍳43]←'x.  A ''break point''',(,⎕UCS 10),'   is defined as the be'
  (howbp)[367+⍳50]←'ginning of a sequence of identical elements (in a',(,⎕UCS 10)
  (howbp)[417+⍳58]←'   vector) or identical rows (in a matrix).  (A sequence o'
  (howbp)[475+⍳45]←'f identical',(,⎕UCS 10),'   elements or rows is also calle'
  (howbp)[520+⍳28]←'d a ''run''.)',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'----'
  (howbp)[548+⍳32]←'-----',(,⎕UCS 10),'<x>   Vector or matrix',(,⎕UCS 10),'   '
  (howbp)[580+⍳45]←'A scalar is treated as a 1-element vector.',(,⎕UCS 10 10),'R'
  (howbp)[625+⍳32]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Boolean vect'
  (howbp)[657+⍳45]←'or',(,⎕UCS 10),'   y[i]=1 if x[i] (or x[i;] in a matrix) i'
  (howbp)[702+⍳38]←'s the beginning of a ''run''',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howbp)[740+⍳28]←'--------',(,⎕UCS 10),'      v',(,⎕UCS 8592),'''aabbbcdddd'
  (howbp)[768+⍳31]←'''',(,⎕UCS 10),'      bp v',(,⎕UCS 10),'1 0 1 0 0 1 1 0 0 '
  (howbp)[799+⍳43]←'0',(,⎕UCS 10 10),'Note that the result of <bp> can be used'
  (howbp)[842+⍳45]←' in many ways.  Here are two.',(,⎕UCS 10),'   (1) Compute '
  (howbp)[887+⍳34]←'the number of runs.',(,⎕UCS 10),'      +/bp v',(,⎕UCS 10 52)
  (howbp)[921+⍳46]←(,⎕UCS 10 10),'   (2) Insert a blank space (or line) before'
  (howbp)[967+⍳35]←' each run.',(,⎕UCS 10),'      (expandbe bp v)\v',(,⎕UCS 10)
  (howbp)[1002+⍳37]←' aa bbb c dddd',(,⎕UCS 10),'      (expandbe bp m)',(,⎕UCS 9024)
  (howbp)[1039+⍳24]←(,⎕UCS 109 8592),'''/'' ',(,⎕UCS 8710),'box ''apple/apple/'
  (howbp)[1063+⍳27]←'betty/cat/cat''',(,⎕UCS 10 10),'apple',(,⎕UCS 10),'apple'
  (howbp)[1090+⍳16]←(,⎕UCS 10 10),'betty',(,⎕UCS 10 10),'cat',(,⎕UCS 10),'cat'
  (howbp)[1106+⍳1]←(,⎕UCS 10)

howbrowse←2541⍴0 ⍝ prolog ≡1
  (howbrowse)[⍳58]←'----------------------------------------------------------'
  (howbrowse)[58+⍳34]←'--------------------',(,⎕UCS 10 121 8592),'s browse x',(,⎕UCS 10)
  (howbrowse)[92+⍳55]←'list occurrences of string <s> (name or any string) in '
  (howbrowse)[147+⍳41]←'functions <x>',(,⎕UCS 10),'---------------------------'
  (howbrowse)[188+⍳52]←'---------------------------------------------------',(,⎕UCS 10)
  (howbrowse)[240+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howbrowse)[268+⍳54]←'   <browse> lists occurrences of a specified substring'
  (howbrowse)[322+⍳41]←' <s> in one or more',(,⎕UCS 10),'   functions.  <s> ca'
  (howbrowse)[363+⍳48]←'n be any sequence, or restricted to names only.',(,⎕UCS 10)
  (howbrowse)[411+⍳44]←(,⎕UCS 10),'   The arguments and result of <browse> are'
  (howbrowse)[455+⍳41]←' consistent with the toolkit',(,⎕UCS 10),'   function '
  (howbrowse)[496+⍳54]←'<change>, and the two functions are intended to be use'
  (howbrowse)[550+⍳26]←'d together.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'--'
  (howbrowse)[576+⍳40]←'-------',(,⎕UCS 10),'<s>   character scalar or vector'
  (howbrowse)[616+⍳44]←(,⎕UCS 10),'   The search specification.  <s> has three'
  (howbrowse)[660+⍳41]←' permitted formats: s=string,',(,⎕UCS 10),'   n=string'
  (howbrowse)[701+⍳49]←', string.  ''s='' specifies ''string search'' and ''n='
  (howbrowse)[750+⍳38]←''' specifies',(,⎕UCS 10),'   ''name search''.  The def'
  (howbrowse)[788+⍳37]←'ault is ''s=''.',(,⎕UCS 10 10),'   String search (s=):'
  (howbrowse)[825+⍳52]←' ''string'' is any sequence of APL characters, and all'
  (howbrowse)[877+⍳44]←(,⎕UCS 10),'   occurrences are reported.  Leading, trai'
  (howbrowse)[921+⍳41]←'ling, and embedded blanks are',(,⎕UCS 10),'   permitte'
  (howbrowse)[962+⍳52]←'d.  If ''string'' has trailing blanks, note that <brow'
  (howbrowse)[1014+⍳40]←'se> searches',(,⎕UCS 10),'   the canonical matrix, so'
  (howbrowse)[1054+⍳46]←' trailing blanks in each line are considered.',(,⎕UCS 10)
  (howbrowse)[1100+⍳41]←(,⎕UCS 10),'   Name search (n=): ''string'' is restric'
  (howbrowse)[1141+⍳40]←'ted to characters allowed in a name,',(,⎕UCS 10),'   '
  (howbrowse)[1181+⍳52]←'and the search returns only those lines containing '''
  (howbrowse)[1233+⍳39]←'string'' as a complete',(,⎕UCS 10),'   sequence (incl'
  (howbrowse)[1272+⍳53]←'uding in comments or within quotes), surrounded optio'
  (howbrowse)[1325+⍳40]←'nally',(,⎕UCS 10),'   by blanks or any other characte'
  (howbrowse)[1365+⍳40]←'r not allowed in a name.  For a name',(,⎕UCS 10),'   '
  (howbrowse)[1405+⍳45]←'search blanks are not permitted in ''string''.',(,⎕UCS 10)
  (howbrowse)[1450+⍳34]←(,⎕UCS 10),'<x>   Character vector or matrix',(,⎕UCS 10)
  (howbrowse)[1484+⍳45]←'   The namelist of functions to be searched.',(,⎕UCS 10)
  (howbrowse)[1529+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howbrowse)[1546+⍳40]←'y>   Character matrix',(,⎕UCS 10),'   The report.  Th'
  (howbrowse)[1586+⍳53]←'e first line notes the full left argument.  (This hel'
  (howbrowse)[1639+⍳40]←'ps to',(,⎕UCS 10),'   notice a mis-specified search s'
  (howbrowse)[1679+⍳41]←'pecification.) If ''string'' is present in',(,⎕UCS 10)
  (howbrowse)[1720+⍳53]←'   the function as interpreted by the type of search,'
  (howbrowse)[1773+⍳40]←' the report shows the',(,⎕UCS 10),'   function name, '
  (howbrowse)[1813+⍳51]←'search type, ''string'', and function lines containin'
  (howbrowse)[1864+⍳38]←'g',(,⎕UCS 10),'   ''string''.  If a function is not l'
  (howbrowse)[1902+⍳38]←'isted, it means that ''string'' is not',(,⎕UCS 10),' '
  (howbrowse)[1940+⍳52]←'  present in the function.  Other results, such as '''
  (howbrowse)[1992+⍳39]←'function not found'',',(,⎕UCS 10),'   are also report'
  (howbrowse)[2031+⍳24]←'ed.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howbrowse)[2055+⍳38]←'... String search.',(,⎕UCS 10),'      ''move'' browse'
  (howbrowse)[2093+⍳37]←' ''browse''',(,⎕UCS 10),'... browsing with (s=move)',(,⎕UCS 10)
  (howbrowse)[2130+⍳26]←(,⎕UCS 10),'... browse  (s=move)',(,⎕UCS 10),'16 ',(,⎕UCS 9053)
  (howbrowse)[2156+⍳44]←'remove browse type specification if present',(,⎕UCS 10)
  (howbrowse)[2200+⍳33]←'36 ',(,⎕UCS 9053),'remove duplicate row numbers',(,⎕UCS 10)
  (howbrowse)[2233+⍳38]←'45 ',(,⎕UCS 9053),'remove trailing blank lines after '
  (howbrowse)[2271+⍳38]←'last text, and trailing blanks',(,⎕UCS 10 10),'... Na'
  (howbrowse)[2309+⍳37]←'me search.',(,⎕UCS 10),'      ''n=ss'' browse ''brows'
  (howbrowse)[2346+⍳28]←'e''',(,⎕UCS 10),'... browsing with (n=ss)',(,⎕UCS 10)
  (howbrowse)[2374+⍳29]←(,⎕UCS 10),'... browse  (n=ss)',(,⎕UCS 10),'10 ''brows'
  (howbrowse)[2403+⍳35]←'e'' checksubroutine ''on ss ssn ',(,⎕UCS 8710),'dtb'''
  (howbrowse)[2438+⍳28]←(,⎕UCS 10),'25 ',(,⎕UCS 9053),'<ssn> and <ss> take vec'
  (howbrowse)[2466+⍳38]←'tor args. delimiter ',(,⎕UCS 9109),'av[1] avoids line'
  (howbrowse)[2504+⍳24]←' run-on.',(,⎕UCS 10),'29 Ls:i',(,⎕UCS 8592),'(,text,'
  (howbrowse)[2528+⍳13]←(,⎕UCS 9109),'av[1]) ss s',(,⎕UCS 10)

howcatoffun←344⍴0 ⍝ prolog ≡1
  (howcatoffun)[⍳56]←'--------------------------------------------------------'
  (howcatoffun)[56+⍳34]←'----------------------',(,⎕UCS 10 89 8592),'catoffun '
  (howcatoffun)[90+⍳40]←'X',(,⎕UCS 10),'return categories represented by funct'
  (howcatoffun)[130+⍳39]←'ions <X>',(,⎕UCS 10),'------------------------------'
  (howcatoffun)[169+⍳49]←'------------------------------------------------',(,⎕UCS 10)
  (howcatoffun)[218+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howcatoffun)[246+⍳52]←'   For an explanation of the function <catoffun>, pl'
  (howcatoffun)[298+⍳39]←'ease refer to the',(,⎕UCS 10),'   document on <funsi'
  (howcatoffun)[337+⍳7]←'ncat>.',(,⎕UCS 10)

howcdays←1470⍴0 ⍝ prolog ≡1
  (howcdays)[⍳59]←'-----------------------------------------------------------'
  (howcdays)[59+⍳30]←'-------------------',(,⎕UCS 10 121 8592),'cdays n',(,⎕UCS 10)
  (howcdays)[89+⍳56]←'convert Gregorian day counts <n> to date format (mm dd y'
  (howcdays)[145+⍳42]←'yyy)',(,⎕UCS 10),'-------------------------------------'
  (howcdays)[187+⍳43]←'-----------------------------------------',(,⎕UCS 10 10)
  (howcdays)[230+⍳29]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'  '
  (howcdays)[259+⍳55]←' <cdays> is the inverse of <days>.  It converts a Grego'
  (howcdays)[314+⍳42]←'rian day count to',(,⎕UCS 10),'   the corresponding cal'
  (howcdays)[356+⍳52]←'endar date in the numeric format (mm dd yyyy), that',(,⎕UCS 10)
  (howcdays)[408+⍳55]←'   is, month day year.  <n> can be a scalar or vector o'
  (howcdays)[463+⍳40]←'f day counts.',(,⎕UCS 10 10),'   For a definition of Gr'
  (howcdays)[503+⍳49]←'egorian day counts and the assumptions used with',(,⎕UCS 10)
  (howcdays)[552+⍳55]←'   these two functions, refer to the documentation on <'
  (howcdays)[607+⍳27]←'days>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'--------'
  (howcdays)[634+⍳33]←'-',(,⎕UCS 10),'<n>   Numeric scalar or vector',(,⎕UCS 10)
  (howcdays)[667+⍳44]←'   <n> is set of the Gregorian day counts.',(,⎕UCS 10 10)
  (howcdays)[711+⍳29]←'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Numeric '
  (howcdays)[740+⍳42]←'matrix',(,⎕UCS 10),'   The Gregorian calendar dates cor'
  (howcdays)[782+⍳36]←'responding to <n>.',(,⎕UCS 10),'   y[;1] = month',(,⎕UCS 10)
  (howcdays)[818+⍳31]←'   y[;2] = day',(,⎕UCS 10),'   y[;3] = year',(,⎕UCS 10)
  (howcdays)[849+⍳19]←(,⎕UCS 10),'Source:',(,⎕UCS 10),'------',(,⎕UCS 10),'   '
  (howcdays)[868+⍳55]←'Adapted from the APL Handbook of Techniques, IBM, 1978.'
  (howcdays)[923+⍳27]←'  (Refer to',(,⎕UCS 10),'   <dates>).',(,⎕UCS 10 10),'E'
  (howcdays)[950+⍳25]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howcdays)[975+⍳21]←(,⎕UCS 8592 109 8592),'3 3',(,⎕UCS 9076),'12 8 1984 6 20'
  (howcdays)[996+⍳32]←' 1947 1 23 1950',(,⎕UCS 10),'  12    8 1984',(,⎕UCS 10),' '
  (howcdays)[1028+⍳30]←'  6   20 1947',(,⎕UCS 10),'   1   23 1950',(,⎕UCS 10 10)
  (howcdays)[1058+⍳53]←'...Compute the Gregorian day counts of the dates <m>.'
  (howcdays)[1111+⍳31]←(,⎕UCS 10),'      days m',(,⎕UCS 10),'724618 710932 711'
  (howcdays)[1142+⍳36]←'880',(,⎕UCS 10),'...Convert back to date format.',(,⎕UCS 10)
  (howcdays)[1178+⍳34]←'      cdays days m',(,⎕UCS 10),'  12    8 1984',(,⎕UCS 10)
  (howcdays)[1212+⍳30]←'   6   20 1947',(,⎕UCS 10),'   1   23 1950',(,⎕UCS 10)
  (howcdays)[1242+⍳44]←(,⎕UCS 10),'...What is the date 100 days from September'
  (howcdays)[1286+⍳40]←' 9, 1992?',(,⎕UCS 10),'      cdays 100+days 9 9 1992',(,⎕UCS 10)
  (howcdays)[1326+⍳41]←'  12   18 1992',(,⎕UCS 10),'...Using (mm dd yyyy) as d'
  (howcdays)[1367+⍳45]←'ate interchange format allows useful syntax.',(,⎕UCS 10)
  (howcdays)[1412+⍳41]←'      ''e'' fdate cdays 100+days 9 9 1992',(,⎕UCS 10),'d'
  (howcdays)[1453+⍳17]←'ecember 18, 1992',(,⎕UCS 10)

howchange←2934⍴0 ⍝ prolog ≡1
  (howchange)[⍳58]←'----------------------------------------------------------'
  (howchange)[58+⍳34]←'--------------------',(,⎕UCS 10 121 8592),'s change x',(,⎕UCS 10)
  (howchange)[92+⍳55]←'change occurrences of text (name or any string) in func'
  (howchange)[147+⍳41]←'tions <x>',(,⎕UCS 10),'-------------------------------'
  (howchange)[188+⍳48]←'-----------------------------------------------',(,⎕UCS 10)
  (howchange)[236+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howchange)[264+⍳52]←'   <change> replaces a specified substring (''old'') w'
  (howchange)[316+⍳39]←'ith another substring',(,⎕UCS 10),'   (''new'') in one'
  (howchange)[355+⍳52]←' or more functions.  ''old'' can be any sequence of AP'
  (howchange)[407+⍳41]←'L',(,⎕UCS 10),'   characters, or restricted only to oc'
  (howchange)[448+⍳39]←'currences as a valid APL name.',(,⎕UCS 10 10),'   <cha'
  (howchange)[487+⍳54]←'nge> is consistent with <browse>, and the two function'
  (howchange)[541+⍳41]←'s are intended',(,⎕UCS 10),'   to be used together.  B'
  (howchange)[582+⍳51]←'efore making large-scale changes to the workspace,',(,⎕UCS 10)
  (howchange)[633+⍳54]←'   it is advisable to browse the functions carefully, '
  (howchange)[687+⍳31]←'and save a backup.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howchange)[718+⍳41]←'---------',(,⎕UCS 10),'<s>   character scalar or vecto'
  (howchange)[759+⍳41]←'r',(,⎕UCS 10),'   <s> specifies the type of replace op'
  (howchange)[800+⍳37]←'eration and the ''old'' and ''new''',(,⎕UCS 10),'   su'
  (howchange)[837+⍳54]←'bstrings.  <s> has three permitted formats: n=/old/new'
  (howchange)[891+⍳39]←', s=/old/new,',(,⎕UCS 10),'   /old/new.  ''s='' specif'
  (howchange)[930+⍳46]←'ies ''string replace'' and ''n='' specifies ''name',(,⎕UCS 10)
  (howchange)[976+⍳49]←'   replace''.  The default is ''s=''.  ''/'' represent'
  (howchange)[1025+⍳40]←'s an arbitrarily chosen',(,⎕UCS 10),'   delimiter not'
  (howchange)[1065+⍳34]←' used in either ''old'' or ''new''.',(,⎕UCS 10 10),' '
  (howchange)[1099+⍳51]←'  String replace (s=): ''old'' is a sequence of any A'
  (howchange)[1150+⍳40]←'PL characters, and all',(,⎕UCS 10),'   occurrences of'
  (howchange)[1190+⍳49]←' the sequence ''old'' are replaced by ''new''.  Leadi'
  (howchange)[1239+⍳40]←'ng,',(,⎕UCS 10),'   trailing, and embedded blanks are'
  (howchange)[1279+⍳39]←' permitted in both strings.  If ''old''',(,⎕UCS 10),' '
  (howchange)[1318+⍳53]←'  has trailing blanks, note that since <change> searc'
  (howchange)[1371+⍳40]←'hes the canonical',(,⎕UCS 10),'   matrix, some traili'
  (howchange)[1411+⍳39]←'ng blanks in a line may be replaced.',(,⎕UCS 10 10),' '
  (howchange)[1450+⍳51]←'  Name replace (n=): ''old'' is restricted to charact'
  (howchange)[1501+⍳40]←'ers allowed in a name,',(,⎕UCS 10),'   and <change> r'
  (howchange)[1541+⍳51]←'eplaces only those occurrences of ''old'' used as a n'
  (howchange)[1592+⍳38]←'ame,',(,⎕UCS 10),'   that is, a sequence or ''word'' '
  (howchange)[1630+⍳40]←'surrounded optionally by blanks or any',(,⎕UCS 10),' '
  (howchange)[1670+⍳53]←'  other character not allowed in a name.  For a name '
  (howchange)[1723+⍳39]←'replace blanks are not',(,⎕UCS 10),'   permitted in '
  (howchange)[1762+⍳37]←'''old'' (but ''new'' is unrestricted).',(,⎕UCS 10 10),'<'
  (howchange)[1799+⍳40]←'x>   Character vector or matrix',(,⎕UCS 10),'   The n'
  (howchange)[1839+⍳38]←'amelist of functions to be changed.',(,⎕UCS 10 10),'R'
  (howchange)[1877+⍳27]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'Global result'
  (howchange)[1904+⍳43]←(,⎕UCS 10),'   All specified functions are searched an'
  (howchange)[1947+⍳40]←'d re-fixed.  A function is changed',(,⎕UCS 10),'   if'
  (howchange)[1987+⍳51]←' the search string (''old'') was present in the funct'
  (howchange)[2038+⍳40]←'ion (even in comment',(,⎕UCS 10),'   lines and within'
  (howchange)[2078+⍳53]←' quotes).  A function is renamed if the replace opera'
  (howchange)[2131+⍳40]←'tion',(,⎕UCS 10),'   changed the name of the function'
  (howchange)[2171+⍳42]←' in the header.  If ''old'' is not present,',(,⎕UCS 10)
  (howchange)[2213+⍳38]←'   the function remains changed.',(,⎕UCS 10 10),'   <'
  (howchange)[2251+⍳40]←'y> Character matrix',(,⎕UCS 10),'   The report.  The '
  (howchange)[2291+⍳52]←'first line notes the full left argument specifying '''
  (howchange)[2343+⍳37]←'s=''',(,⎕UCS 10),'   or ''n='' (that is, string or na'
  (howchange)[2380+⍳43]←'me replace), and the old and new strings.',(,⎕UCS 10),' '
  (howchange)[2423+⍳53]←'  (This helps to notice a mis-specified change specif'
  (howchange)[2476+⍳40]←'ication).  For each',(,⎕UCS 10),'   function specifie'
  (howchange)[2516+⍳38]←'d, the function name and result of ',(,⎕UCS 9109),'fx'
  (howchange)[2554+⍳40]←' is reported.',(,⎕UCS 10),'   Other results, such as '
  (howchange)[2594+⍳41]←'''function not found'', are also reported.',(,⎕UCS 10)
  (howchange)[2635+⍳53]←'   However, which functions were actually changed is '
  (howchange)[2688+⍳26]←'not reported.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-'
  (howchange)[2714+⍳28]←'-------',(,⎕UCS 10),'...String replace.',(,⎕UCS 10),'.'
  (howchange)[2742+⍳49]←'..Change all occurrences of ''x'' to ''y'' in the fun'
  (howchange)[2791+⍳36]←'ction ''testit''.',(,⎕UCS 10),'      ''/x/y'' change '
  (howchange)[2827+⍳27]←'''testit''',(,⎕UCS 10 10),'...Name replace.',(,⎕UCS 10)
  (howchange)[2854+⍳49]←'...Only change occurrences of the name ''x'' to y.',(,⎕UCS 10)
  (howchange)[2903+⍳31]←'      ''n=/x/y'' change ''testit''',(,⎕UCS 10)

howchecksize←2411⍴0 ⍝ prolog ≡1
  (howchecksize)[⍳55]←'-------------------------------------------------------'
  (howchecksize)[55+⍳33]←'-----------------------',(,⎕UCS 10 89 8592),'checksi'
  (howchecksize)[88+⍳39]←'ze List',(,⎕UCS 10),'return report showing sizes of '
  (howchecksize)[127+⍳38]←'objects in <List>, sorted by size',(,⎕UCS 10),'----'
  (howchecksize)[165+⍳51]←'---------------------------------------------------'
  (howchecksize)[216+⍳36]←'-----------------------',(,⎕UCS 10 10),'Introductio'
  (howchecksize)[252+⍳25]←'n:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   For a '
  (howchecksize)[277+⍳51]←'specified list of object names, <checksize> compute'
  (howchecksize)[328+⍳38]←'s their sizes and',(,⎕UCS 10),'   returns the list '
  (howchecksize)[366+⍳51]←'sorted by size, with a summary total.  Sorting by s'
  (howchecksize)[417+⍳38]←'ize',(,⎕UCS 10),'   highlights the objects taking t'
  (howchecksize)[455+⍳36]←'he most space.',(,⎕UCS 10 10),'   This report is ve'
  (howchecksize)[491+⍳51]←'ry useful in many situations, for example, when rev'
  (howchecksize)[542+⍳37]←'iewing',(,⎕UCS 10),'   a workspace, assessing a ''w'
  (howchecksize)[579+⍳47]←'s full'' situation, or performing a ''clean up''.',(,⎕UCS 10)
  (howchecksize)[626+⍳41]←(,⎕UCS 10),'   Note: <checksize> is system-dependent'
  (howchecksize)[667+⍳36]←'.  See section on Notes.',(,⎕UCS 10 10),'Arguments:'
  (howchecksize)[703+⍳28]←(,⎕UCS 10),'---------',(,⎕UCS 10),'<list>   Characte'
  (howchecksize)[731+⍳38]←'r vector or array',(,⎕UCS 10),'   Namelist of objec'
  (howchecksize)[769+⍳28]←'ts to be reported.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howchecksize)[797+⍳30]←'------',(,⎕UCS 10),'<y>   Character matrix',(,⎕UCS 10)
  (howchecksize)[827+⍳51]←'   <y> is the report.  The first line is the total '
  (howchecksize)[878+⍳38]←'line.  The remaining lines',(,⎕UCS 10),'   list the'
  (howchecksize)[916+⍳51]←' object names and their sizes in decreasing order. '
  (howchecksize)[967+⍳38]←' (For a',(,⎕UCS 10),'   definition of size, see Not'
  (howchecksize)[1005+⍳19]←'es.)',(,⎕UCS 10 10),'Notes:',(,⎕UCS 10),'-----',(,⎕UCS 10)
  (howchecksize)[1024+⍳50]←'   <checksize> uses the system-dependent function '
  (howchecksize)[1074+⍳35]←'<vtype> to determine the',(,⎕UCS 10),'   ''type'' '
  (howchecksize)[1109+⍳50]←'(boolean, integer, real, or character) of each var'
  (howchecksize)[1159+⍳37]←'iable.',(,⎕UCS 10),'   <checksize> then computes t'
  (howchecksize)[1196+⍳43]←'he size of each variable using this table:',(,⎕UCS 10)
  (howchecksize)[1239+⍳40]←(,⎕UCS 10),'          Boolean    1 byte  = 8 elemen'
  (howchecksize)[1279+⍳37]←'ts of the object',(,⎕UCS 10),'          Character '
  (howchecksize)[1316+⍳47]←' 1 byte  = 1 element (character) of the object',(,⎕UCS 10)
  (howchecksize)[1363+⍳50]←'          Integer    4 bytes = 1 element (number) '
  (howchecksize)[1413+⍳37]←'of the object',(,⎕UCS 10),'          Real       8 '
  (howchecksize)[1450+⍳41]←'bytes = 1 element (number) of the object',(,⎕UCS 10)
  (howchecksize)[1491+⍳40]←(,⎕UCS 10),'   The size of a function is taken to b'
  (howchecksize)[1531+⍳38]←'e the number of non-blank characters',(,⎕UCS 10),' '
  (howchecksize)[1569+⍳50]←'  in its canonical representation (1 byte per char'
  (howchecksize)[1619+⍳35]←'acter).',(,⎕UCS 10 10),'   These computations are '
  (howchecksize)[1654+⍳47]←'approximate and system-dependent, but are good',(,⎕UCS 10)
  (howchecksize)[1701+⍳50]←'   enough for practical purposes.  However, <vtype'
  (howchecksize)[1751+⍳37]←'> and <checksize> may',(,⎕UCS 10),'   easily be mo'
  (howchecksize)[1788+⍳50]←'dified to use particular system features and sizin'
  (howchecksize)[1838+⍳22]←'g',(,⎕UCS 10),'   algorithms.',(,⎕UCS 10 10),'Exam'
  (howchecksize)[1860+⍳24]←'ples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...Comput'
  (howchecksize)[1884+⍳50]←'e the size of all variables in workspace:  checksi'
  (howchecksize)[1934+⍳22]←'ze ',(,⎕UCS 9109),'nl 2',(,⎕UCS 10),'...Compute th'
  (howchecksize)[1956+⍳49]←'e size of all variables and functions: checksize '
  (howchecksize)[2005+⍳25]←(,⎕UCS 9109),'nl 2 3',(,⎕UCS 10),'...Using the tool'
  (howchecksize)[2030+⍳50]←'kit function <nl>, compute the size of all variabl'
  (howchecksize)[2080+⍳31]←'es',(,⎕UCS 10),'...starting with ''how'': ''how'
  (howchecksize)[2111+⍳22]←(,⎕UCS 8902),''' nl 2',(,⎕UCS 10 10),'...An example'
  (howchecksize)[2133+⍳43]←' report using some sample defined objects.',(,⎕UCS 10)
  (howchecksize)[2176+⍳50]←'...(Note:  This report may differ on various APL s'
  (howchecksize)[2226+⍳22]←'ystems.)',(,⎕UCS 10),'      a',(,⎕UCS 8592),'1 1 1'
  (howchecksize)[2248+⍳22]←' 0 1 1 1 0',(,⎕UCS 10),'      b',(,⎕UCS 8592),'23 '
  (howchecksize)[2270+⍳21]←'45 667',(,⎕UCS 10),'      c',(,⎕UCS 8592),'''This '
  (howchecksize)[2291+⍳36]←'is a character vector.''',(,⎕UCS 10),'      checks'
  (howchecksize)[2327+⍳35]←'ize ''a b c checksize vtype''',(,⎕UCS 10),'915 ---'
  (howchecksize)[2362+⍳24]←'------',(,⎕UCS 10),'614 checksize',(,⎕UCS 10),'261'
  (howchecksize)[2386+⍳19]←' vtype',(,⎕UCS 10),' 27 c',(,⎕UCS 10),' 12 b',(,⎕UCS 10)
  (howchecksize)[2405+⍳6]←'  1 a',(,⎕UCS 10)

howchecksubroutine←1437⍴0 ⍝ prolog ≡1
  (howchecksubroutine)[⍳49]←'-------------------------------------------------'
  (howchecksubroutine)[49+⍳33]←'-----------------------------',(,⎕UCS 10),'N c'
  (howchecksubroutine)[82+⍳33]←'hecksubroutine L',(,⎕UCS 10),'check workspace '
  (howchecksubroutine)[115+⍳41]←'for subroutines <L> used by function <N>',(,⎕UCS 10)
  (howchecksubroutine)[156+⍳45]←'---------------------------------------------'
  (howchecksubroutine)[201+⍳34]←'---------------------------------',(,⎕UCS 10)
  (howchecksubroutine)[235+⍳22]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'-------'
  (howchecksubroutine)[257+⍳32]←'-----',(,⎕UCS 10),'   <checksubroutine> check'
  (howchecksubroutine)[289+⍳45]←'s for the presence of specified functions in '
  (howchecksubroutine)[334+⍳32]←'the',(,⎕UCS 10),'   workspace and gives a war'
  (howchecksubroutine)[366+⍳45]←'ning message if the functions are not present'
  (howchecksubroutine)[411+⍳30]←'.',(,⎕UCS 10),'   It is a ''core'' function f'
  (howchecksubroutine)[441+⍳43]←'or the tookit workspace, since many of the',(,⎕UCS 10)
  (howchecksubroutine)[484+⍳45]←'   toolkit functions use other toolkit functi'
  (howchecksubroutine)[529+⍳32]←'ons.  It is used in every',(,⎕UCS 10),'   too'
  (howchecksubroutine)[561+⍳45]←'lkit function that uses other toolkit functio'
  (howchecksubroutine)[606+⍳17]←'ns.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howchecksubroutine)[623+⍳31]←'--------',(,⎕UCS 10),'<n>   Character vector'
  (howchecksubroutine)[654+⍳24]←(,⎕UCS 10),'   Name of a function',(,⎕UCS 10 10)
  (howchecksubroutine)[678+⍳34]←'<l>   Character vector or matrix',(,⎕UCS 10),' '
  (howchecksubroutine)[712+⍳30]←'  Namelist of functions',(,⎕UCS 10 10),'Resul'
  (howchecksubroutine)[742+⍳19]←'t:',(,⎕UCS 10),'------',(,⎕UCS 10),'   <check'
  (howchecksubroutine)[761+⍳45]←'subroutine> checks for the presence of functi'
  (howchecksubroutine)[806+⍳32]←'ons <l> in the',(,⎕UCS 10),'   workspace.  If'
  (howchecksubroutine)[838+⍳45]←' any are not present, a warning message is gi'
  (howchecksubroutine)[883+⍳32]←'ven.  The',(,⎕UCS 10),'   function name <n> i'
  (howchecksubroutine)[915+⍳45]←'s noted in the message, and is used for infor'
  (howchecksubroutine)[960+⍳27]←'mational',(,⎕UCS 10),'   purposes only.',(,⎕UCS 10)
  (howchecksubroutine)[987+⍳14]←(,⎕UCS 10),'Notes:',(,⎕UCS 10),'-----',(,⎕UCS 10)
  (howchecksubroutine)[1001+⍳44]←'   Only a warning message is given, and then'
  (howchecksubroutine)[1045+⍳33]←' execution continues.  However,',(,⎕UCS 10),' '
  (howchecksubroutine)[1078+⍳44]←'  the programmer can change the function to '
  (howchecksubroutine)[1122+⍳31]←'suspend if functions are not',(,⎕UCS 10),'  '
  (howchecksubroutine)[1153+⍳44]←' present, or to autocopy the functions into '
  (howchecksubroutine)[1197+⍳31]←'the workspace, if the APL',(,⎕UCS 10),'   im'
  (howchecksubroutine)[1228+⍳29]←'plementation allows that.',(,⎕UCS 10 10),'Ex'
  (howchecksubroutine)[1257+⍳18]←'amples:',(,⎕UCS 10),'--------',(,⎕UCS 10),' '
  (howchecksubroutine)[1275+⍳41]←'     ''foo'' checksubroutine ''funca funcb f'
  (howchecksubroutine)[1316+⍳30]←'uncc''',(,⎕UCS 10),'...If any of <funca>, <f'
  (howchecksubroutine)[1346+⍳44]←'uncb>, or <funcc> are missing, a warning mes'
  (howchecksubroutine)[1390+⍳31]←'sage',(,⎕UCS 10),'...is displayed, and execu'
  (howchecksubroutine)[1421+⍳16]←'tion continues.',(,⎕UCS 10)

howcjulian←1564⍴0 ⍝ prolog ≡1
  (howcjulian)[⍳57]←'---------------------------------------------------------'
  (howcjulian)[57+⍳34]←'---------------------',(,⎕UCS 10 122 8592),'cjulian js'
  (howcjulian)[91+⍳44]←(,⎕UCS 10),'convert Julian day numbers <js> to (mm dd y'
  (howcjulian)[135+⍳40]←'yyy style)',(,⎕UCS 10),'-----------------------------'
  (howcjulian)[175+⍳50]←'-------------------------------------------------',(,⎕UCS 10)
  (howcjulian)[225+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howcjulian)[253+⍳51]←'   <cjulian> converts a ''Julian day number'' to its '
  (howcjulian)[304+⍳40]←'corresponding calenar',(,⎕UCS 10),'   date, in the nu'
  (howcjulian)[344+⍳53]←'meric format (mm dd yyyy).  The calendar style is als'
  (howcjulian)[397+⍳25]←'o',(,⎕UCS 10),'   indicated.',(,⎕UCS 10 10),'   <cjul'
  (howcjulian)[422+⍳53]←'ian> is the inverse function to <julian>.  For the de'
  (howcjulian)[475+⍳39]←'finition of the',(,⎕UCS 10),'   terms ''Julian day nu'
  (howcjulian)[514+⍳48]←'mber'', ''calendar style'', and other notes on the',(,⎕UCS 10)
  (howcjulian)[562+⍳53]←'   Julian calendar, refer to the documentation on <ju'
  (howcjulian)[615+⍳25]←'lian>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'------'
  (howcjulian)[640+⍳40]←'---',(,⎕UCS 10),'<js>   Numeric scalar or vector, or '
  (howcjulian)[680+⍳26]←'n',(,⎕UCS 215),'2 matrix',(,⎕UCS 10),'   If scalar or'
  (howcjulian)[706+⍳42]←' vector, <js> represents Julian numbers.',(,⎕UCS 10),' '
  (howcjulian)[748+⍳53]←'  If a matrix, the columns of <js> are interpreted as'
  (howcjulian)[801+⍳40]←' follows:',(,⎕UCS 10),'   js[;1] = Julian day numbers'
  (howcjulian)[841+⍳43]←(,⎕UCS 10),'   js[;2] = style of calendar to be used i'
  (howcjulian)[884+⍳37]←'n converting the day number',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howcjulian)[921+⍳31]←'------',(,⎕UCS 10),'<z>   Numeric matrix, n',(,⎕UCS 215)
  (howcjulian)[952+⍳28]←(,⎕UCS 52 10),'   z[;1] = month',(,⎕UCS 10),'   z[;2] '
  (howcjulian)[980+⍳27]←'= day',(,⎕UCS 10),'   z[;3] = year',(,⎕UCS 10),'   z['
  (howcjulian)[1007+⍳24]←';4] = style',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'---'
  (howcjulian)[1031+⍳39]←'---',(,⎕UCS 10),'   Adapted from The APL Handbook of'
  (howcjulian)[1070+⍳40]←' Techniques, IBM, 1978.  (Refer to the',(,⎕UCS 10),' '
  (howcjulian)[1110+⍳31]←'  <date> function.)',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howcjulian)[1141+⍳18]←'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 122)
  (howcjulian)[1159+⍳25]←(,⎕UCS 8592),'julian 2 3',(,⎕UCS 9076),'5 12 1988 5 1'
  (howcjulian)[1184+⍳26]←'7 1977',(,⎕UCS 10),'2447294 2443281',(,⎕UCS 10),'   '
  (howcjulian)[1210+⍳33]←'   cjulian z',(,⎕UCS 10),'   5   12 1988    1',(,⎕UCS 10)
  (howcjulian)[1243+⍳37]←'   5   17 1977    1',(,⎕UCS 10 10),'...One must be c'
  (howcjulian)[1280+⍳51]←'areful to specify the appropriate style calendar as'
  (howcjulian)[1331+⍳42]←(,⎕UCS 10),'...necessary.  In North America January 1'
  (howcjulian)[1373+⍳39]←', 1800 has the following Julian day',(,⎕UCS 10),'...'
  (howcjulian)[1412+⍳17]←'number:',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 122)
  (howcjulian)[1429+⍳25]←(,⎕UCS 8592),'julian 1 1 1800',(,⎕UCS 10),'2378497',(,⎕UCS 10)
  (howcjulian)[1454+⍳42]←(,⎕UCS 10),'...But in Russia this number stands for a'
  (howcjulian)[1496+⍳39]←' different calendar date:',(,⎕UCS 10),'      cjulian'
  (howcjulian)[1535+⍳24]←' 1 2',(,⎕UCS 9076),'z,0',(,⎕UCS 10),'  12   21 1799 '
  (howcjulian)[1559+⍳5]←'   0',(,⎕UCS 10)

howcomments←1423⍴0 ⍝ prolog ≡1
  (howcomments)[⍳56]←'--------------------------------------------------------'
  (howcomments)[56+⍳34]←'----------------------',(,⎕UCS 10 89 8592),'comments '
  (howcomments)[90+⍳40]←'X',(,⎕UCS 10),'return header and header comments (i.e'
  (howcomments)[130+⍳39]←'. initial comments) in function <X>',(,⎕UCS 10),'---'
  (howcomments)[169+⍳52]←'----------------------------------------------------'
  (howcomments)[221+⍳37]←'-----------------------',(,⎕UCS 10 10),'Introduction'
  (howcomments)[258+⍳26]←':',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <comment'
  (howcomments)[284+⍳52]←'s> returns the header line and all the initial comme'
  (howcomments)[336+⍳39]←'nts in the',(,⎕UCS 10),'   function with name <X>.  '
  (howcomments)[375+⍳45]←'This is often a quick and useful document to',(,⎕UCS 10)
  (howcomments)[420+⍳52]←'   remind or inform how the function <X> works, espe'
  (howcomments)[472+⍳39]←'cially if the function',(,⎕UCS 10),'   is well-comme'
  (howcomments)[511+⍳24]←'nted.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'------'
  (howcomments)[535+⍳28]←'---',(,⎕UCS 10),'<X>   Character vector',(,⎕UCS 10),' '
  (howcomments)[563+⍳31]←'  Name of a function.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howcomments)[594+⍳30]←'------',(,⎕UCS 10),'<Y>   Character matrix',(,⎕UCS 10)
  (howcomments)[624+⍳38]←'   The matrix of comment statements',(,⎕UCS 10 10),'E'
  (howcomments)[662+⍳26]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      co'
  (howcomments)[688+⍳17]←'mments ''',(,⎕UCS 8710),'box''',(,⎕UCS 10 121 8592),'c'
  (howcomments)[705+⍳18]←'hars ',(,⎕UCS 8710),'box x',(,⎕UCS 10 9053),'''box'''
  (howcomments)[723+⍳52]←' vector <x> using separator and fill character <char'
  (howcomments)[775+⍳19]←'s>',(,⎕UCS 10 9053),'.e (3 5',(,⎕UCS 9076),'''appleb'
  (howcomments)[794+⍳33]←'ettycat  '') = ''/'' ',(,⎕UCS 8710),'box ''apple/bet'
  (howcomments)[827+⍳21]←'ty/cat''',(,⎕UCS 10 9053),'.k reshape',(,⎕UCS 10 9053)
  (howcomments)[848+⍳35]←'.t 1988.4.28.1.20.21',(,⎕UCS 10 9053),'.v 2.0 / 8jul'
  (howcomments)[883+⍳35]←'83',(,⎕UCS 10 9053),'chars[1]=separator; chars[2]=fi'
  (howcomments)[918+⍳35]←'ll; defaults are blank/zero',(,⎕UCS 10 9053),'<y>  m'
  (howcomments)[953+⍳52]←'atrix corresponding to a vector delimited into logic'
  (howcomments)[1005+⍳31]←'al fields',(,⎕UCS 10 10),'      comments ''nl''',(,⎕UCS 10)
  (howcomments)[1036+⍳19]←'Nly',(,⎕UCS 8592),'Nls nl Nlc',(,⎕UCS 10 9053),'nam'
  (howcomments)[1055+⍳51]←'elist of functions or variables <Nlc> within specif'
  (howcomments)[1106+⍳24]←'ication <Nls>',(,⎕UCS 10 9053),'.e ''nl'' ',(,⎕UCS 8710)
  (howcomments)[1130+⍳32]←'rowmem ''a-z'' nl 3',(,⎕UCS 10 9053),'.k programmin'
  (howcomments)[1162+⍳29]←'g-tools',(,⎕UCS 10 9053),'.t 1992.3.8.11.18.0',(,⎕UCS 10)
  (howcomments)[1191+⍳22]←(,⎕UCS 9053),'.v 1.0 / 27jul89',(,⎕UCS 10 9053),'.v '
  (howcomments)[1213+⍳36]←'1.1 / 02mar92 / localized ',(,⎕UCS 9109),'io, defin'
  (howcomments)[1249+⍳34]←'ition of right arg changed',(,⎕UCS 10 9053),'.v 1.2'
  (howcomments)[1283+⍳51]←' / 06mar92 / replace matdown with matacross for for'
  (howcomments)[1334+⍳34]←'matting output',(,⎕UCS 10 9053),'.v 1.3 / 08mar92 /'
  (howcomments)[1368+⍳51]←' specify gradeup collating sequence to put blank fi'
  (howcomments)[1419+⍳4]←'rst',(,⎕UCS 10)

howcondense←1753⍴0 ⍝ prolog ≡1
  (howcondense)[⍳56]←'--------------------------------------------------------'
  (howcondense)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'d conden'
  (howcondense)[89+⍳40]←'se v',(,⎕UCS 10),'remove redundant blanks and blanks '
  (howcondense)[129+⍳39]←'around characters specified in <d>',(,⎕UCS 10),'----'
  (howcondense)[168+⍳52]←'----------------------------------------------------'
  (howcondense)[220+⍳37]←'----------------------',(,⎕UCS 10 10),'Introduction:'
  (howcondense)[257+⍳29]←(,⎕UCS 10),'------------',(,⎕UCS 10),'   This functio'
  (howcondense)[286+⍳52]←'n useful for analyzing certain types of character ve'
  (howcondense)[338+⍳38]←'ctors, for',(,⎕UCS 10),'   example ''command-paramet'
  (howcondense)[376+⍳47]←'er'' input.  The definition of this function is',(,⎕UCS 10)
  (howcondense)[423+⍳28]←'   taken from <y',(,⎕UCS 8592 100 32 9109),'drb v> ('
  (howcondense)[451+⍳50]←'delete redundant blanks), a system function in an',(,⎕UCS 10)
  (howcondense)[501+⍳52]←'   implementation of APL called APL.68000.  It remov'
  (howcondense)[553+⍳38]←'es redundant blanks',(,⎕UCS 10),'   (which is what '
  (howcondense)[591+⍳40]←(,⎕UCS 8710),'db does), and it also deletes blanks su'
  (howcondense)[631+⍳39]←'rrounding a given',(,⎕UCS 10),'   set of characters.'
  (howcondense)[670+⍳50]←'  After using <condense> the ''fields'' delimited by'
  (howcondense)[720+⍳37]←' the',(,⎕UCS 10),'   ''delimiters'' <d> can be remov'
  (howcondense)[757+⍳43]←'ed from <y> without further need to remove',(,⎕UCS 10)
  (howcondense)[800+⍳33]←'   blank characters.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howcondense)[833+⍳33]←'---------',(,⎕UCS 10),'<d>   character vector',(,⎕UCS 10)
  (howcondense)[866+⍳52]←'   This is a character vector specifying characters '
  (howcondense)[918+⍳39]←'within <v> that usually',(,⎕UCS 10),'   represent lo'
  (howcondense)[957+⍳37]←'gical field delimiters.',(,⎕UCS 10 10),'<v>   charac'
  (howcondense)[994+⍳39]←'ter vector',(,⎕UCS 10),'   This is the character vec'
  (howcondense)[1033+⍳32]←'tor to be ''condensed''.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howcondense)[1065+⍳29]←'------',(,⎕UCS 10),'<y>  character vector',(,⎕UCS 10)
  (howcondense)[1094+⍳51]←'   All leading, trailing, and multiple internal bla'
  (howcondense)[1145+⍳38]←'nks are removed.',(,⎕UCS 10),'   Also, all blanks a'
  (howcondense)[1183+⍳45]←'round any of the characters contained in <d>',(,⎕UCS 10)
  (howcondense)[1228+⍳27]←'   are removed.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howcondense)[1255+⍳24]←'--------',(,⎕UCS 10),'      frame v',(,⎕UCS 8592),''''
  (howcondense)[1279+⍳40]←'    apple , betty   ,  cat   ,, dog   ''',(,⎕UCS 10)
  (howcondense)[1319+⍳41]←'(    apple , betty   ,  cat   ,, dog   )',(,⎕UCS 10)
  (howcondense)[1360+⍳41]←(,⎕UCS 10),'...Note that blanks around delimiter <,>'
  (howcondense)[1401+⍳38]←' are removed as well as leading,',(,⎕UCS 10),'...tr'
  (howcondense)[1439+⍳38]←'ailing, and redundant blanks.',(,⎕UCS 10),'      fr'
  (howcondense)[1477+⍳36]←'ame '','' condense v',(,⎕UCS 10),'(apple,betty,cat,'
  (howcondense)[1513+⍳36]←',dog)',(,⎕UCS 10 10),'...Now two delimiters are use'
  (howcondense)[1549+⍳33]←'d.  Compare the results.',(,⎕UCS 10),'      v',(,⎕UCS 8592)
  (howcondense)[1582+⍳50]←'''print  ,  filename  , summary  ;  read,filename  '
  (howcondense)[1632+⍳24]←'''',(,⎕UCS 10),'      '','' condense v',(,⎕UCS 10),'p'
  (howcondense)[1656+⍳39]←'rint,filename,summary ; read,filename',(,⎕UCS 10),' '
  (howcondense)[1695+⍳36]←'     '',;'' condense v',(,⎕UCS 10),'print,filename,'
  (howcondense)[1731+⍳22]←'summary;read,filename',(,⎕UCS 10)

howcondense1←1456⍴0 ⍝ prolog ≡1
  (howcondense1)[⍳55]←'-------------------------------------------------------'
  (howcondense1)[55+⍳32]←'-----------------------',(,⎕UCS 10 121 8592),'d cond'
  (howcondense1)[87+⍳39]←'ense1 x',(,⎕UCS 10),'remove redundant blanks and bla'
  (howcondense1)[126+⍳40]←'nks around characters specified in <d>',(,⎕UCS 10),'-'
  (howcondense1)[166+⍳51]←'---------------------------------------------------'
  (howcondense1)[217+⍳36]←'--------------------------',(,⎕UCS 10 10),'Introduc'
  (howcondense1)[253+⍳25]←'tion:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   Thi'
  (howcondense1)[278+⍳51]←'s function is similar to <condense> except that bla'
  (howcondense1)[329+⍳38]←'nks are not removed',(,⎕UCS 10),'   from within quo'
  (howcondense1)[367+⍳23]←'tes.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'------'
  (howcondense1)[390+⍳28]←'---',(,⎕UCS 10),'<d>   character vector',(,⎕UCS 10),' '
  (howcondense1)[418+⍳51]←'  This is a character vector specifying characters '
  (howcondense1)[469+⍳38]←'within <v> that usually',(,⎕UCS 10),'   represent l'
  (howcondense1)[507+⍳36]←'ogical field delimiters.',(,⎕UCS 10 10),'<v>   char'
  (howcondense1)[543+⍳38]←'acter vector',(,⎕UCS 10),'   This is the character '
  (howcondense1)[581+⍳34]←'vector to be ''condensed''.',(,⎕UCS 10 10),'Result:'
  (howcondense1)[615+⍳28]←(,⎕UCS 10),'------',(,⎕UCS 10),'<y>  character vecto'
  (howcondense1)[643+⍳38]←'r',(,⎕UCS 10),'   All leading, trailing, and multip'
  (howcondense1)[681+⍳38]←'le internal blanks are removed.',(,⎕UCS 10),'   Als'
  (howcondense1)[719+⍳51]←'o, all blanks around any of the characters containe'
  (howcondense1)[770+⍳38]←'d in <d>',(,⎕UCS 10),'   are removed.  However, any'
  (howcondense1)[808+⍳40]←' blanks within quotes are not removed.',(,⎕UCS 10 10)
  (howcondense1)[848+⍳25]←'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      '
  (howcondense1)[873+⍳33]←'frame v',(,⎕UCS 8592),'''    apple , ''''betty   , '
  (howcondense1)[906+⍳34]←' cat  '''',, dog   ''',(,⎕UCS 10),'(    apple , ''b'
  (howcondense1)[940+⍳35]←'etty   ,  cat  '',, dog   )',(,⎕UCS 10 10),'...Blan'
  (howcondense1)[975+⍳51]←'ks around delimiter <,> are removed, except those w'
  (howcondense1)[1026+⍳35]←'ithin quotes.',(,⎕UCS 10),'      '','' condense1 v'
  (howcondense1)[1061+⍳31]←(,⎕UCS 10),'apple,''betty   ,  cat  '',,dog',(,⎕UCS 10)
  (howcondense1)[1092+⍳35]←'      frame '','' condense1 v',(,⎕UCS 10),'(apple,'
  (howcondense1)[1127+⍳33]←'''betty   ,  cat  '',,dog)',(,⎕UCS 10 10),'...Now '
  (howcondense1)[1160+⍳47]←'two delimiters are used.  Compare the results.',(,⎕UCS 10)
  (howcondense1)[1207+⍳32]←'      v',(,⎕UCS 8592),'''print  ''''text within qu'
  (howcondense1)[1239+⍳39]←'otes;   more text''''; read, filename  ''',(,⎕UCS 10)
  (howcondense1)[1278+⍳34]←'      '',;'' condense1 v',(,⎕UCS 10),'print ''text'
  (howcondense1)[1312+⍳43]←' within quotes;   more text'';read,filename',(,⎕UCS 10)
  (howcondense1)[1355+⍳29]←(,⎕UCS 10),'...Compare with <condense>',(,⎕UCS 10),' '
  (howcondense1)[1384+⍳34]←'     '',;'' condense v',(,⎕UCS 10),'print ''text w'
  (howcondense1)[1418+⍳38]←'ithin quotes;more text'';read,filename',(,⎕UCS 10)

howcontents←2443⍴0 ⍝ prolog ≡1
  (howcontents)[⍳56]←'--------------------------------------------------------'
  (howcontents)[56+⍳34]←'----------------------',(,⎕UCS 10 89 8592),'contents '
  (howcontents)[90+⍳40]←'X',(,⎕UCS 10),'formatted report of functions <X> by c'
  (howcontents)[130+⍳39]←'ategory (with line 1 and header)',(,⎕UCS 10),'------'
  (howcontents)[169+⍳52]←'----------------------------------------------------'
  (howcontents)[221+⍳36]←'--------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howcontents)[257+⍳39]←'------------',(,⎕UCS 10),'   <contents> returns a fo'
  (howcontents)[296+⍳51]←'rmatted and sorted summary report for the specified'
  (howcontents)[347+⍳42]←(,⎕UCS 10),'   functions <X>.  (It can be used in the'
  (howcontents)[389+⍳39]←' toolkit workspace or any other',(,⎕UCS 10),'   work'
  (howcontents)[428+⍳37]←'space.)',(,⎕UCS 10 10),'   The report groups the fun'
  (howcontents)[465+⍳50]←'ctions by category (from the category information',(,⎕UCS 10)
  (howcontents)[515+⍳50]←'   in the ''k'' tag line) and sorts by function name'
  (howcontents)[565+⍳39]←'.  There is one line for',(,⎕UCS 10),'   each functi'
  (howcontents)[604+⍳52]←'on, containing the name, syntax (from the header), a'
  (howcontents)[656+⍳39]←'nd brief',(,⎕UCS 10),'   description (from the comme'
  (howcontents)[695+⍳46]←'nt on the first line).  A star appears beside',(,⎕UCS 10)
  (howcontents)[741+⍳50]←'   the name of any function whose ''how'' document i'
  (howcontents)[791+⍳37]←'s present in the workspace.',(,⎕UCS 10 10),'   <cont'
  (howcontents)[828+⍳52]←'ents> is very useful for reviewing the functions in '
  (howcontents)[880+⍳39]←'a new workspace,',(,⎕UCS 10),'   during the program '
  (howcontents)[919+⍳52]←'development process, and for workspace documentation'
  (howcontents)[971+⍳23]←'.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------'
  (howcontents)[994+⍳34]←(,⎕UCS 10),'<X>   Character vector or matrix',(,⎕UCS 10)
  (howcontents)[1028+⍳51]←'   Namelist of functions to be listed in the report'
  (howcontents)[1079+⍳18]←'.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howcontents)[1097+⍳38]←'<Y>   Character matrix',(,⎕UCS 10),'   The report s'
  (howcontents)[1135+⍳51]←'ummarizing the functions and sorted within categori'
  (howcontents)[1186+⍳38]←'es.',(,⎕UCS 10),'   Categories are determined by th'
  (howcontents)[1224+⍳38]←'e ''k'' tag line in each function.  If',(,⎕UCS 10),' '
  (howcontents)[1262+⍳49]←'  there is no category information (i.e.  no ''k'' '
  (howcontents)[1311+⍳38]←'tag line), the function is',(,⎕UCS 10),'   placed i'
  (howcontents)[1349+⍳49]←'n the ''empty'' (i.e.  blank) category.  The one-li'
  (howcontents)[1398+⍳38]←'ne function',(,⎕UCS 10),'   description is the comm'
  (howcontents)[1436+⍳50]←'ent line expected on the first line.  However, the'
  (howcontents)[1486+⍳41]←(,⎕UCS 10),'   first line is included no matter what'
  (howcontents)[1527+⍳23]←' it is.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'----'
  (howcontents)[1550+⍳38]←'----',(,⎕UCS 10),'...To compute the report for all '
  (howcontents)[1588+⍳36]←'functions in the workspace, use ',(,⎕UCS 9109),'nl '
  (howcontents)[1624+⍳22]←'3',(,⎕UCS 10),'      contents ',(,⎕UCS 9109),'nl 3'
  (howcontents)[1646+⍳26]←(,⎕UCS 10),'      ',(,⎕UCS 9053),' (results not show'
  (howcontents)[1672+⍳36]←'n)',(,⎕UCS 10 10),'...To compute the report for all'
  (howcontents)[1708+⍳36]←' functions in category ''date''',(,⎕UCS 10),'      '
  (howcontents)[1744+⍳33]←'contents (',(,⎕UCS 9109),'nl 3) funsincat ''date'''
  (howcontents)[1777+⍳26]←(,⎕UCS 10),'      ',(,⎕UCS 9053),' (results not show'
  (howcontents)[1803+⍳36]←'n)',(,⎕UCS 10 10),'...Compute report for selected f'
  (howcontents)[1839+⍳43]←'unctions and display the first 78 columns.',(,⎕UCS 10)
  (howcontents)[1882+⍳35]←'      x',(,⎕UCS 8592),'contents ''boxf jr array nof'
  (howcontents)[1917+⍳18]←'unc''',(,⎕UCS 10),'      ((1',(,⎕UCS 8593 9076),'x)'
  (howcontents)[1935+⍳29]←',78)',(,⎕UCS 8593 120 10 10),'---------------------'
  (howcontents)[1964+⍳51]←'---------------------------------------------------'
  (howcontents)[2015+⍳25]←'------',(,⎕UCS 10),'    nofunc    .',(,⎕UCS 10 10 10)
  (howcontents)[2040+⍳38]←'formatting',(,⎕UCS 10),'---------------------------'
  (howcontents)[2078+⍳51]←'---------------------------------------------------'
  (howcontents)[2129+⍳18]←(,⎕UCS 10 32 32 8902),' jr        r',(,⎕UCS 8592),'j'
  (howcontents)[2147+⍳49]←'r x.  justify right: justify character array <x>',(,⎕UCS 10)
  (howcontents)[2196+⍳26]←(,⎕UCS 10 10),'reshape',(,⎕UCS 10),'----------------'
  (howcontents)[2222+⍳51]←'---------------------------------------------------'
  (howcontents)[2273+⍳27]←'-----------',(,⎕UCS 10 32 32 8902),' array     r'
  (howcontents)[2300+⍳39]←(,⎕UCS 8592),'del array str.  general vector reshape'
  (howcontents)[2339+⍳30]←'. reshape vector <str> u',(,⎕UCS 10 32 32 8902),' b'
  (howcontents)[2369+⍳36]←'oxf      y',(,⎕UCS 8592),'w boxf v.  box fields. <y'
  (howcontents)[2405+⍳38]←'[i;]> is a field of vector <v> specif',(,⎕UCS 10)

howcontents1←1867⍴0 ⍝ prolog ≡1
  (howcontents1)[⍳55]←'-------------------------------------------------------'
  (howcontents1)[55+⍳33]←'-----------------------',(,⎕UCS 13 89 8592),'content'
  (howcontents1)[88+⍳39]←'s1 X',(,⎕UCS 13),'quick condensed report of function'
  (howcontents1)[127+⍳38]←'s <X> by category (with line 1)',(,⎕UCS 13),'------'
  (howcontents1)[165+⍳51]←'---------------------------------------------------'
  (howcontents1)[216+⍳36]←'---------------------',(,⎕UCS 13 13),'Introduction:'
  (howcontents1)[252+⍳28]←(,⎕UCS 13),'------------',(,⎕UCS 13),'   <contents1>'
  (howcontents1)[280+⍳51]←' returns a quick condensed sorted summary report fo'
  (howcontents1)[331+⍳38]←'r the',(,⎕UCS 13),'   specified functions <X>.  (It'
  (howcontents1)[369+⍳45]←' can be used in the toolkit workspace or any',(,⎕UCS 13)
  (howcontents1)[414+⍳36]←'   other workspace.)',(,⎕UCS 13 13),'   <contents1>'
  (howcontents1)[450+⍳51]←' provides a condensed and faster report than <conte'
  (howcontents1)[501+⍳38]←'nts> with',(,⎕UCS 13),'   somewhat less information'
  (howcontents1)[539+⍳44]←'.  Please refer to the intoroduction of the',(,⎕UCS 13)
  (howcontents1)[583+⍳51]←'   documentation on <contents> for an explanation o'
  (howcontents1)[634+⍳34]←'f usage and concepts.',(,⎕UCS 13 13),'Arguments:',(,⎕UCS 13)
  (howcontents1)[668+⍳38]←'---------',(,⎕UCS 13),'<X>   Character vector or ma'
  (howcontents1)[706+⍳38]←'trix',(,⎕UCS 13),'   Namelist of functions to be li'
  (howcontents1)[744+⍳29]←'sted in the report.',(,⎕UCS 13 13),'Result:',(,⎕UCS 13)
  (howcontents1)[773+⍳30]←'------',(,⎕UCS 13),'<Y>   Character matrix',(,⎕UCS 13)
  (howcontents1)[803+⍳51]←'   The report summarizing the functions and sorted '
  (howcontents1)[854+⍳38]←'within categories.',(,⎕UCS 13),'   Categories are d'
  (howcontents1)[892+⍳49]←'etermined by the ''k'' tag line in each function.  '
  (howcontents1)[941+⍳38]←'If',(,⎕UCS 13),'   there is no category information'
  (howcontents1)[979+⍳42]←' (i.e.  no ''k'' tag line), the function is',(,⎕UCS 13)
  (howcontents1)[1021+⍳48]←'   placed in the ''empty'' (i.e.  blank) category.'
  (howcontents1)[1069+⍳37]←'  The one-line function',(,⎕UCS 13),'   descriptio'
  (howcontents1)[1106+⍳50]←'n is the comment line expected on the first line. '
  (howcontents1)[1156+⍳37]←' However, the',(,⎕UCS 13),'   first line is includ'
  (howcontents1)[1193+⍳35]←'ed no matter what it is.',(,⎕UCS 13 13),'Examples:'
  (howcontents1)[1228+⍳27]←(,⎕UCS 13),'--------',(,⎕UCS 13),'...To compute the'
  (howcontents1)[1255+⍳48]←' report for all functions in the workspace, use '
  (howcontents1)[1303+⍳22]←(,⎕UCS 9109),'nl 3',(,⎕UCS 13),'      contents1 '
  (howcontents1)[1325+⍳13]←(,⎕UCS 9109),'nl 3',(,⎕UCS 13),'      ',(,⎕UCS 9053)
  (howcontents1)[1338+⍳35]←' (results not shown)',(,⎕UCS 13 13),'...To compute'
  (howcontents1)[1373+⍳48]←' the report for all functions in category ''date'''
  (howcontents1)[1421+⍳25]←(,⎕UCS 13),'      contents1 (',(,⎕UCS 9109),'nl 3) '
  (howcontents1)[1446+⍳24]←'funsincat ''date''',(,⎕UCS 13),'      ',(,⎕UCS 9053)
  (howcontents1)[1470+⍳35]←' (results not shown)',(,⎕UCS 13 13),'...Compute re'
  (howcontents1)[1505+⍳50]←'port for selected functions and display the first '
  (howcontents1)[1555+⍳22]←'78 columns.',(,⎕UCS 13),'      x',(,⎕UCS 8592),'co'
  (howcontents1)[1577+⍳35]←'ntents1 ''boxf jr array nofunc''',(,⎕UCS 13),'    '
  (howcontents1)[1612+⍳15]←'  ((1',(,⎕UCS 8593 9076),'x),78)',(,⎕UCS 8593 120)
  (howcontents1)[1627+⍳25]←(,⎕UCS 13),'formatting',(,⎕UCS 8902),'jr     justif'
  (howcontents1)[1652+⍳38]←'y right: justify character array <x>',(,⎕UCS 13 13)
  (howcontents1)[1690+⍳35]←'reshape   ',(,⎕UCS 8902),'array  general vector re'
  (howcontents1)[1725+⍳44]←'shape. reshape vector <str> using delimiter',(,⎕UCS 13)
  (howcontents1)[1769+⍳35]←'          ',(,⎕UCS 8902),'boxf   box fields. <y[i;'
  (howcontents1)[1804+⍳44]←']> is a field of vector <v> specifed by wid',(,⎕UCS 13)
  (howcontents1)[1848+⍳19]←(,⎕UCS 13),'           nofunc',(,⎕UCS 13)

howcpucon←2246⍴0 ⍝ prolog ≡1
  (howcpucon)[⍳58]←'----------------------------------------------------------'
  (howcpucon)[58+⍳30]←'--------------------',(,⎕UCS 10 122 8592),'cpucon',(,⎕UCS 10)
  (howcpucon)[88+⍳55]←'returns elapsed cpu and connect time since function las'
  (howcpucon)[143+⍳41]←'t executed',(,⎕UCS 10),'------------------------------'
  (howcpucon)[184+⍳49]←'------------------------------------------------',(,⎕UCS 10)
  (howcpucon)[233+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howcpucon)[261+⍳54]←'   <cpucon> returns the elapsed time since the functio'
  (howcpucon)[315+⍳41]←'n was last executed.',(,⎕UCS 10),'   It is used to mea'
  (howcpucon)[356+⍳49]←'sure the time to execute a particular set of APL',(,⎕UCS 10)
  (howcpucon)[405+⍳54]←'   statements.  This may be used, for example, in an a'
  (howcpucon)[459+⍳41]←'pplication program',(,⎕UCS 10),'   where one wants to '
  (howcpucon)[500+⍳39]←'give the user feedback.',(,⎕UCS 10 10),'   The result '
  (howcpucon)[539+⍳39]←'is computed from the information in ',(,⎕UCS 9109),'ai'
  (howcpucon)[578+⍳41]←', and is clearly',(,⎕UCS 10),'   dependent on the accu'
  (howcpucon)[619+⍳39]←'racy of ',(,⎕UCS 9109),'ai in the APL implementation b'
  (howcpucon)[658+⍳41]←'eing used.',(,⎕UCS 10),'   (The standard records that '
  (howcpucon)[699+⍳41]←(,⎕UCS 9109),'ai[2 3] returns the accumulated cpu and',(,⎕UCS 10)
  (howcpucon)[740+⍳54]←'   connect time, respectively, in milliseconds, for th'
  (howcpucon)[794+⍳32]←'e entire workspace',(,⎕UCS 10),'   session.)',(,⎕UCS 10)
  (howcpucon)[826+⍳44]←(,⎕UCS 10),'   A substitution for <cpucon> may be requi'
  (howcpucon)[870+⍳34]←'red in case ',(,⎕UCS 9109),'ai is not functional',(,⎕UCS 10)
  (howcpucon)[904+⍳54]←'   on the APL implementation being used, or other more'
  (howcpucon)[958+⍳41]←' accurate timing',(,⎕UCS 10),'   features are availabl'
  (howcpucon)[999+⍳19]←'e.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howcpucon)[1018+⍳40]←'<z>   2-element numeric vector',(,⎕UCS 10),'   This i'
  (howcpucon)[1058+⍳45]←'s elapsed cpu and connect time (in units of ',(,⎕UCS 9109)
  (howcpucon)[1103+⍳40]←'ai) since the function',(,⎕UCS 10),'   was last execu'
  (howcpucon)[1143+⍳40]←'ted.',(,⎕UCS 10),'   z[1] -- elapsed cpu time (millis'
  (howcpucon)[1183+⍳32]←'econds).  Computed from ',(,⎕UCS 9109),'ai[2].',(,⎕UCS 10)
  (howcpucon)[1215+⍳53]←'   z[2] -- elapsed connect time (milliseconds).  Comp'
  (howcpucon)[1268+⍳23]←'uted from ',(,⎕UCS 9109),'ai[3].',(,⎕UCS 10 10),'Note'
  (howcpucon)[1291+⍳27]←'s:',(,⎕UCS 10),'-----',(,⎕UCS 10),'   A global variab'
  (howcpucon)[1318+⍳52]←'le is used to keep track of the cpu and connect time'
  (howcpucon)[1370+⍳43]←(,⎕UCS 10),'   setting between invocations of the func'
  (howcpucon)[1413+⍳40]←'tion.  If the global variable is',(,⎕UCS 10),'   not '
  (howcpucon)[1453+⍳53]←'present in the workspace, it is created.  <cpucon> sh'
  (howcpucon)[1506+⍳40]←'ould be executed',(,⎕UCS 10),'   once before one begi'
  (howcpucon)[1546+⍳50]←'ns to do the timing, in order to ''initialize'' the',(,⎕UCS 10)
  (howcpucon)[1596+⍳31]←'   global variable.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howcpucon)[1627+⍳40]←'--------',(,⎕UCS 10),'... Suppose you wish to time th'
  (howcpucon)[1667+⍳40]←'e following statement in a function.',(,⎕UCS 10),'...'
  (howcpucon)[1707+⍳53]←' Execute the function (and ignore result) once before'
  (howcpucon)[1760+⍳40]←' beginning to time.',(,⎕UCS 10),'... Then execute the'
  (howcpucon)[1800+⍳40]←' statement(s) to be timed.',(,⎕UCS 10),'... Then exec'
  (howcpucon)[1840+⍳29]←'ute cpucon again.',(,⎕UCS 10),'      sink',(,⎕UCS 8592)
  (howcpucon)[1869+⍳21]←'cpucon',(,⎕UCS 10),'      a',(,⎕UCS 8592),'+/((?',(,⎕UCS 9075)
  (howcpucon)[1890+⍳14]←'200)',(,⎕UCS 9075 63 9075),'200)',(,⎕UCS 8712 40 63)
  (howcpucon)[1904+⍳12]←(,⎕UCS 9075),'200)',(,⎕UCS 9075 63 9075),'200',(,⎕UCS 10)
  (howcpucon)[1916+⍳18]←'      ',(,⎕UCS 9109 8592 116 116 8592),'cpucon',(,⎕UCS 10)
  (howcpucon)[1934+⍳38]←'13 41',(,⎕UCS 10 10),'... The result can be formatted'
  (howcpucon)[1972+⍳35]←' using <fcpucon>.',(,⎕UCS 10),'      fcpucon tt',(,⎕UCS 10)
  (howcpucon)[2007+⍳48]←'cpu= 0 m   0.013 s       connect= 0 m   0.041 s',(,⎕UCS 10)
  (howcpucon)[2055+⍳43]←(,⎕UCS 10),'... For ease of use you can use the toolki'
  (howcpucon)[2098+⍳37]←'t cover function <timing>.',(,⎕UCS 10),'      sink'
  (howcpucon)[2135+⍳16]←(,⎕UCS 8592),'timing',(,⎕UCS 10),'      a',(,⎕UCS 8592)
  (howcpucon)[2151+⍳17]←'+/((?',(,⎕UCS 9075),'200)',(,⎕UCS 9075 63 9075),'200)'
  (howcpucon)[2168+⍳12]←(,⎕UCS 8712 40 63 9075),'200)',(,⎕UCS 9075 63 9075),'2'
  (howcpucon)[2180+⍳18]←'00',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592),'timing',(,⎕UCS 10)
  (howcpucon)[2198+⍳48]←'cpu= 0 m   0.013 s       connect= 0 m   0.041 s',(,⎕UCS 10)

howdate←1118⍴0 ⍝ prolog ≡1
  (howdate)[⍳60]←'------------------------------------------------------------'
  (howdate)[60+⍳27]←'------------------',(,⎕UCS 10 121 8592),'date',(,⎕UCS 10),'r'
  (howdate)[87+⍳50]←'eturn today''s date in format (monthname dd, yyyy)',(,⎕UCS 10)
  (howdate)[137+⍳56]←'--------------------------------------------------------'
  (howdate)[193+⍳38]←'----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howdate)[231+⍳43]←'------------',(,⎕UCS 10),'   <date> is used for reports.'
  (howdate)[274+⍳43]←'  Although it simply calls <fdate> (see',(,⎕UCS 10),'   '
  (howdate)[317+⍳56]←'programming notes below), it is provided in the toolkit '
  (howdate)[373+⍳43]←'workspace because',(,⎕UCS 10),'   it is seems to be used'
  (howdate)[416+⍳28]←' everywhere!',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---'
  (howdate)[444+⍳29]←'------',(,⎕UCS 10 9109),'ts   Global argument',(,⎕UCS 10)
  (howdate)[473+⍳41]←'   ',(,⎕UCS 9109),'ts is used to provide the current day'
  (howdate)[514+⍳18]←'.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howdate)[532+⍳42]←'<y>   Character vector',(,⎕UCS 10),'   Today''s date in '
  (howdate)[574+⍳43]←'English in (monthname day, year) format.',(,⎕UCS 10 10),'E'
  (howdate)[617+⍳29]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      date',(,⎕UCS 10)
  (howdate)[646+⍳41]←'april 14, 1992',(,⎕UCS 10 10),'...The length of the resu'
  (howdate)[687+⍳41]←'lt depends on the particular date.',(,⎕UCS 10),'      '
  (howdate)[728+⍳16]←(,⎕UCS 9076),'date',(,⎕UCS 10),'1 14',(,⎕UCS 10 10),'Prog'
  (howdate)[744+⍳33]←'ramming Notes:',(,⎕UCS 10),'-----------------',(,⎕UCS 10)
  (howdate)[777+⍳56]←'   It is often a convenience to have functions returning'
  (howdate)[833+⍳43]←' the current date in',(,⎕UCS 10),'   a specific format, '
  (howdate)[876+⍳54]←'for example, when writing many reports.  Simply write',(,⎕UCS 10)
  (howdate)[930+⍳54]←'   a ''cover'' function in the same way that <date> cove'
  (howdate)[984+⍳26]←'rs ''e'' fdate ',(,⎕UCS 9109),'ts[2 3',(,⎕UCS 10),'   1]'
  (howdate)[1010+⍳55]←'.  This can be done, for example, for the functions <fd'
  (howdate)[1065+⍳42]←'my> and',(,⎕UCS 10),'   <fisodate> for the correspondin'
  (howdate)[1107+⍳11]←'g formats.',(,⎕UCS 10)

howdates←794⍴0 ⍝ prolog ≡1
  (howdates)[⍳59]←'-----------------------------------------------------------'
  (howdates)[59+⍳30]←'-------------------',(,⎕UCS 10 121 8592),'dates n',(,⎕UCS 10)
  (howdates)[89+⍳56]←'return month,day,year date equivalents of gregorian day '
  (howdates)[145+⍳42]←'count <n>',(,⎕UCS 10),'--------------------------------'
  (howdates)[187+⍳47]←'----------------------------------------------',(,⎕UCS 10)
  (howdates)[234+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howdates)[262+⍳55]←'   <dates> is the inverse of <days>.  It converts Grego'
  (howdates)[317+⍳42]←'rian day counts into',(,⎕UCS 10),'   numeric calendar d'
  (howdates)[359+⍳40]←'ates of the form: month, day, year',(,⎕UCS 10 10),'Argu'
  (howdates)[399+⍳29]←'ments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<n>   numeri'
  (howdates)[428+⍳42]←'c vector',(,⎕UCS 10),'   <n> is a vector of Gregorian d'
  (howdates)[470+⍳26]←'ay counts.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howdates)[496+⍳26]←(,⎕UCS 10),'<y>   n',(,⎕UCS 215),'3 numeric matrix',(,⎕UCS 10)
  (howdates)[522+⍳32]←'   y[;1] = month',(,⎕UCS 10),'   y[;2] = day',(,⎕UCS 10)
  (howdates)[554+⍳27]←'   y[;3] = year',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'--'
  (howdates)[581+⍳42]←'----',(,⎕UCS 10),'   The APL Handbook of Techniques, 19'
  (howdates)[623+⍳27]←'77, (IBM).',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-----'
  (howdates)[650+⍳16]←'---',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 109 8592),'2 '
  (howdates)[666+⍳27]←'3',(,⎕UCS 9076),'5 17 1977 5 12 1988',(,⎕UCS 10),'   5 '
  (howdates)[693+⍳29]←'  17 1977',(,⎕UCS 10),'   5   12 1988',(,⎕UCS 10),'    '
  (howdates)[722+⍳29]←'  days m',(,⎕UCS 10),'721856 725869',(,⎕UCS 10),'      '
  (howdates)[751+⍳29]←'dates days m',(,⎕UCS 10),'   5   17 1977',(,⎕UCS 10),' '
  (howdates)[780+⍳14]←'  5   12 1988',(,⎕UCS 10)

howdays←1862⍴0 ⍝ prolog ≡1
  (howdays)[⍳60]←'------------------------------------------------------------'
  (howdays)[60+⍳28]←'------------------',(,⎕UCS 10 121 8592),'days d',(,⎕UCS 10)
  (howdays)[88+⍳56]←'compute Gregorian day count for dates <d> = (mm dd yyyy)'
  (howdays)[144+⍳46]←(,⎕UCS 10),'---------------------------------------------'
  (howdays)[190+⍳41]←'---------------------------------',(,⎕UCS 10 10),'Introd'
  (howdays)[231+⍳30]←'uction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <days>'
  (howdays)[261+⍳56]←' computes the Gregorian day count for the calendar date '
  (howdays)[317+⍳43]←'<d>.  The',(,⎕UCS 10),'   Gregorian day count is the num'
  (howdays)[360+⍳43]←'ber of days since 1/1/1, inclusive, as if',(,⎕UCS 10),' '
  (howdays)[403+⍳56]←'  the Gregorian calendar had been in continual use since'
  (howdays)[459+⍳41]←' that date.',(,⎕UCS 10 10),'   It can be used to compute'
  (howdays)[500+⍳49]←' with dates for the Gregorian calendar, which is',(,⎕UCS 10)
  (howdays)[549+⍳56]←'   fine for most recent events! The inverse of <days> is'
  (howdays)[605+⍳28]←' <cdays>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'------'
  (howdays)[633+⍳40]←'---',(,⎕UCS 10),'<d>   3-element numeric vector or n',(,⎕UCS 215)
  (howdays)[673+⍳39]←'3 matrix',(,⎕UCS 10),'   A vector is treated as a 1',(,⎕UCS 215)
  (howdays)[712+⍳30]←'3 matrix.',(,⎕UCS 10),'   d[;1] = month',(,⎕UCS 10),'   '
  (howdays)[742+⍳30]←'d[;2] = day',(,⎕UCS 10),'   d[;3] = year',(,⎕UCS 10 10),'R'
  (howdays)[772+⍳30]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Numeric ve'
  (howdays)[802+⍳43]←'ctor',(,⎕UCS 10),'   y[i] is the Gregorian day count for'
  (howdays)[845+⍳41]←' d[i;].',(,⎕UCS 10 10),'   7|y gives the day of the week'
  (howdays)[886+⍳44]←' for each Gregorian day count, as follows:',(,⎕UCS 10),' '
  (howdays)[930+⍳56]←'  Sunday=0, Monday=1, Tuesday=2, Wednesday=3, Thursday=4'
  (howdays)[986+⍳29]←', Friday=5,',(,⎕UCS 10),'   Saturday=6.',(,⎕UCS 10 10),'S'
  (howdays)[1015+⍳29]←'ource:',(,⎕UCS 10),'------',(,⎕UCS 10),'   Adapted from'
  (howdays)[1044+⍳44]←' The APL Handbook of Techniques, IBM, 1978.',(,⎕UCS 10)
  (howdays)[1088+⍳21]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),' '
  (howdays)[1109+⍳14]←'     ',(,⎕UCS 9109 8592 109 8592),'2 3',(,⎕UCS 9076),'5'
  (howdays)[1123+⍳34]←' 17 1977 5 12 1988',(,⎕UCS 10),'   5   17 1977',(,⎕UCS 10)
  (howdays)[1157+⍳29]←'   5   12 1988',(,⎕UCS 10),'      days m',(,⎕UCS 10),'7'
  (howdays)[1186+⍳40]←'21856 725869',(,⎕UCS 10 10),'...1900 was not a leap yea'
  (howdays)[1226+⍳52]←'r, but 2000 will be so.  Compute the number of days',(,⎕UCS 10)
  (howdays)[1278+⍳55]←'...between February 28, 1900 and March 1, 1900.  Also c'
  (howdays)[1333+⍳42]←'ompute the days',(,⎕UCS 10),'...between February 28, 20'
  (howdays)[1375+⍳31]←'00 and March 1, 2000.',(,⎕UCS 10 10),'      m',(,⎕UCS 8592)
  (howdays)[1406+⍳40]←'4 3',(,⎕UCS 9076),'2 28 1900 3 1 1900 2 28 2000 3 1 200'
  (howdays)[1446+⍳16]←'0',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 122 8592),'days'
  (howdays)[1462+⍳32]←' m',(,⎕UCS 10),'693654 693655 730178 730180',(,⎕UCS 10),' '
  (howdays)[1494+⍳32]←'     (-/z[2 1]), (-/z[4 3])',(,⎕UCS 10),'1 2',(,⎕UCS 10)
  (howdays)[1526+⍳55]←'...There is 1 day between the first pair, and 2 days be'
  (howdays)[1581+⍳42]←'tween the second pair.',(,⎕UCS 10),'...(i.e.  February '
  (howdays)[1623+⍳40]←'29 will occur in the year 2000.)',(,⎕UCS 10 10),'...Wha'
  (howdays)[1663+⍳42]←'t day of the week was December 8, 1984?',(,⎕UCS 10),'  '
  (howdays)[1705+⍳38]←'    7|days 12 8 1984',(,⎕UCS 10 54 10),'...It was Satur'
  (howdays)[1743+⍳40]←'day (day 6).',(,⎕UCS 10 10),'...The inverse of <days> i'
  (howdays)[1783+⍳50]←'s <cdays>.  (Convert a day count back to a date.)',(,⎕UCS 10)
  (howdays)[1833+⍳29]←'      cdays 693654',(,⎕UCS 10),'2 28 1900',(,⎕UCS 10)

howddup←1426⍴0 ⍝ prolog ≡1
  (howddup)[⍳60]←'------------------------------------------------------------'
  (howddup)[60+⍳28]←'------------------',(,⎕UCS 10 121 8592),'ddup x',(,⎕UCS 10)
  (howddup)[88+⍳52]←'delete duplicate elements from vector or matrix <x>',(,⎕UCS 10)
  (howddup)[140+⍳56]←'--------------------------------------------------------'
  (howddup)[196+⍳38]←'----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howddup)[234+⍳43]←'------------',(,⎕UCS 10),'   <ddup> deletes duplicate el'
  (howddup)[277+⍳47]←'ements from a vector or matrix.  An element is',(,⎕UCS 10)
  (howddup)[324+⍳56]←'   taken to mean <x[i]> for vector <x>, and <x[i;]> for '
  (howddup)[380+⍳43]←'matrix <x>.  The',(,⎕UCS 10),'   function returns the un'
  (howddup)[423+⍳41]←'ique elements of the array.',(,⎕UCS 10 10),'   Although '
  (howddup)[464+⍳56]←'<ddup> is merely an application of compression and the <'
  (howddup)[520+⍳43]←'first>',(,⎕UCS 10),'   function, it provides a very usef'
  (howddup)[563+⍳43]←'ul syntax for deleting duplicate',(,⎕UCS 10),'   element'
  (howddup)[606+⍳32]←'s.  (See examples.)',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howddup)[638+⍳43]←'---------',(,⎕UCS 10),'<x>   vector or matrix, character'
  (howddup)[681+⍳27]←' or numeric',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howddup)[708+⍳33]←(,⎕UCS 10),'<y>   vector or matrix',(,⎕UCS 10),'   The re'
  (howddup)[741+⍳56]←'sult consists of the unique elements of the argument <x>'
  (howddup)[797+⍳43]←', that is,',(,⎕UCS 10),'   <x> with all duplicate elemen'
  (howddup)[840+⍳28]←'ts removed.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-----'
  (howddup)[868+⍳30]←'---',(,⎕UCS 10),'...The case of matrices',(,⎕UCS 10),'  '
  (howddup)[898+⍳23]←'    ddup m',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''ca'
  (howddup)[921+⍳45]←'t/apple/betty/apple/betty/cat/dog/cat/betty''',(,⎕UCS 10)
  (howddup)[966+⍳17]←'cat',(,⎕UCS 10),'apple',(,⎕UCS 10),'betty',(,⎕UCS 10),'d'
  (howddup)[983+⍳16]←'og',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 110 8592),'6 2'
  (howddup)[999+⍳13]←(,⎕UCS 9076 9075 52 10),'1 2',(,⎕UCS 10),'3 4',(,⎕UCS 10),'1'
  (howddup)[1012+⍳15]←' 2',(,⎕UCS 10),'3 4',(,⎕UCS 10),'1 2',(,⎕UCS 10),'3 4',(,⎕UCS 10)
  (howddup)[1027+⍳21]←'      ddup n',(,⎕UCS 10),'1 2',(,⎕UCS 10),'3 4',(,⎕UCS 10)
  (howddup)[1048+⍳32]←(,⎕UCS 10),'...The case of vectors',(,⎕UCS 10),'      dd'
  (howddup)[1080+⍳40]←'up ''abcdcdeablclabkciefghigjkkzzyz''',(,⎕UCS 10),'abcd'
  (howddup)[1120+⍳42]←'elkifghjzy',(,⎕UCS 10),'      ddup 1 2 3 10 20 3 2 1 20'
  (howddup)[1162+⍳30]←(,⎕UCS 10),'1 2 3 10 20',(,⎕UCS 10 10),'...how <ddup> is'
  (howddup)[1192+⍳27]←' computed',(,⎕UCS 10),'      (first m)',(,⎕UCS 9023 109)
  (howddup)[1219+⍳17]←(,⎕UCS 10),'cat',(,⎕UCS 10),'apple',(,⎕UCS 10),'betty',(,⎕UCS 10)
  (howddup)[1236+⍳42]←'dog',(,⎕UCS 10),'...Another way of computing <ddup> is '
  (howddup)[1278+⍳42]←'to sort the matrix (to bring together',(,⎕UCS 10),'...a'
  (howddup)[1320+⍳55]←'ll duplicate rows), then compute break points, and comp'
  (howddup)[1375+⍳22]←'ress.',(,⎕UCS 10),'      (bp a)',(,⎕UCS 9023 97 8592),''''
  (howddup)[1397+⍳21]←''' sort m',(,⎕UCS 10),'apple',(,⎕UCS 10),'betty',(,⎕UCS 10)
  (howddup)[1418+⍳8]←'cat',(,⎕UCS 10),'dog',(,⎕UCS 10)

howdeltag←872⍴0 ⍝ prolog ≡1
  (howdeltag)[⍳58]←'----------------------------------------------------------'
  (howdeltag)[58+⍳36]←'--------------------',(,⎕UCS 10 89 8592),'Code deltag F'
  (howdeltag)[94+⍳42]←'ns',(,⎕UCS 10),'delete tag line labelled with <Code> fr'
  (howdeltag)[136+⍳41]←'om functions <Fns>',(,⎕UCS 10),'----------------------'
  (howdeltag)[177+⍳54]←'------------------------------------------------------'
  (howdeltag)[231+⍳26]←'--',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'--------'
  (howdeltag)[257+⍳41]←'----',(,⎕UCS 10),'   <deltag> is the library utility t'
  (howdeltag)[298+⍳43]←'o delete the specified tag-lines from the',(,⎕UCS 10),' '
  (howdeltag)[341+⍳43]←'  functions specified in the namelist <M>.',(,⎕UCS 10)
  (howdeltag)[384+⍳44]←(,⎕UCS 10),'   This function is useful for quickly remo'
  (howdeltag)[428+⍳41]←'ving obsolete or erroneous tag',(,⎕UCS 10),'   lines. '
  (howdeltag)[469+⍳52]←' For more information about ''tag-lines'', consult the'
  (howdeltag)[521+⍳31]←' documentation',(,⎕UCS 10),'   on <gettag>.',(,⎕UCS 10)
  (howdeltag)[552+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howdeltag)[574+⍳54]←'<Code>   Character or numeric scalar or 1-element vect'
  (howdeltag)[628+⍳40]←'or',(,⎕UCS 10),'   The code identifying the comment '''
  (howdeltag)[668+⍳38]←'tag-line'' belng selected.',(,⎕UCS 10 10),'<Fns>   Cha'
  (howdeltag)[706+⍳41]←'racter vector or matrix',(,⎕UCS 10),'   Namelist of fu'
  (howdeltag)[747+⍳25]←'nctions.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howdeltag)[772+⍳41]←'<Y>   Numeric vector',(,⎕UCS 10),'   Binary vector ind'
  (howdeltag)[813+⍳54]←'icating success or failure of fixing the changed funct'
  (howdeltag)[867+⍳5]←'ion.',(,⎕UCS 10)

howdescribe1←1449⍴0 ⍝ prolog ≡1
  (howdescribe1)[⍳55]←'-------------------------------------------------------'
  (howdescribe1)[55+⍳39]←'-----------------------',(,⎕UCS 10),'Notices and Dis'
  (howdescribe1)[94+⍳39]←'tribution Policy',(,⎕UCS 10),'----------------------'
  (howdescribe1)[133+⍳51]←'---------------------------------------------------'
  (howdescribe1)[184+⍳36]←'-----',(,⎕UCS 10 10),'Copyright Notice and Distribu'
  (howdescribe1)[220+⍳38]←'tion Policy:',(,⎕UCS 10),'-------------------------'
  (howdescribe1)[258+⍳38]←'---------------',(,⎕UCS 10),'   The Toronto APL Spe'
  (howdescribe1)[296+⍳51]←'cial Interest Group is making this workspace availa'
  (howdescribe1)[347+⍳38]←'ble',(,⎕UCS 10),'   with the understanding that any'
  (howdescribe1)[385+⍳39]←' or all of the contents may be freely',(,⎕UCS 10),' '
  (howdescribe1)[424+⍳51]←'  reproduced and/or used.  No charge should be made'
  (howdescribe1)[475+⍳38]←' except to cover the',(,⎕UCS 10),'   cost, if any, '
  (howdescribe1)[513+⍳36]←'of reproduction and distribution.',(,⎕UCS 10 10),' '
  (howdescribe1)[549+⍳51]←'  Furthermore, it is the best understanding of the '
  (howdescribe1)[600+⍳38]←'Group that no copyright',(,⎕UCS 10),'   and/or prop'
  (howdescribe1)[638+⍳51]←'rietary rights pertaining to the contributed functi'
  (howdescribe1)[689+⍳38]←'ons will be',(,⎕UCS 10),'   infringed in so doing. '
  (howdescribe1)[727+⍳46]←' If this is not so, please inform the Toolkit',(,⎕UCS 10)
  (howdescribe1)[773+⍳42]←'   editor at the address noted elsewhere.',(,⎕UCS 10)
  (howdescribe1)[815+⍳17]←(,⎕UCS 10),'Credit:',(,⎕UCS 10),'------',(,⎕UCS 10),' '
  (howdescribe1)[832+⍳51]←'  Credit should be given the Toronto APL Special In'
  (howdescribe1)[883+⍳38]←'terest Group when',(,⎕UCS 10),'   distributing this'
  (howdescribe1)[921+⍳51]←' workspace.  The source note (.n tagline), where pr'
  (howdescribe1)[972+⍳38]←'esent',(,⎕UCS 10),'   in a function, should be pres'
  (howdescribe1)[1010+⍳37]←'erved when separately publishing or',(,⎕UCS 10),' '
  (howdescribe1)[1047+⍳50]←'  distributing any toolkit function without change'
  (howdescribe1)[1097+⍳22]←'.',(,⎕UCS 10 10),'Disclaimer:',(,⎕UCS 10),'-------'
  (howdescribe1)[1119+⍳37]←'---',(,⎕UCS 10),'   No warranty or liability on th'
  (howdescribe1)[1156+⍳39]←'e part of the Toronto APL SIG for the',(,⎕UCS 10),' '
  (howdescribe1)[1195+⍳50]←'  Toolkit workspace, either for the original distr'
  (howdescribe1)[1245+⍳37]←'ibution, or any',(,⎕UCS 10),'   subsequent distrib'
  (howdescribe1)[1282+⍳50]←'ution by individuals or organizations distributing'
  (howdescribe1)[1332+⍳37]←' or',(,⎕UCS 10),'   using the Toolkit, is expresse'
  (howdescribe1)[1369+⍳43]←'d or implied by any statement appearing in',(,⎕UCS 10)
  (howdescribe1)[1412+⍳37]←'   the workspace or version thereof.',(,⎕UCS 10)

howdescribe2←806⍴0 ⍝ prolog ≡1
  (howdescribe2)[⍳55]←'-------------------------------------------------------'
  (howdescribe2)[55+⍳37]←'-----------------------',(,⎕UCS 10),'Introduction',(,⎕UCS 10)
  (howdescribe2)[92+⍳52]←'----------------------------------------------------'
  (howdescribe2)[144+⍳36]←'--------------------------',(,⎕UCS 10 10),'   The T'
  (howdescribe2)[180+⍳51]←'oronto APL Special Interest Group is a group of peo'
  (howdescribe2)[231+⍳38]←'ple interested in',(,⎕UCS 10),'   APL, and based in'
  (howdescribe2)[269+⍳51]←' Toronto, Canada.  The Toronto Toolkit is a collect'
  (howdescribe2)[320+⍳38]←'ion',(,⎕UCS 10),'   of APL functions sponsored by t'
  (howdescribe2)[358+⍳43]←'he Group for the benefit of the entire APL',(,⎕UCS 10)
  (howdescribe2)[401+⍳36]←'   community.',(,⎕UCS 10 10),'   All the functions '
  (howdescribe2)[437+⍳51]←'conform completely to the ISO (International Standa'
  (howdescribe2)[488+⍳38]←'rds',(,⎕UCS 10),'   Organization) APL standard.  Th'
  (howdescribe2)[526+⍳43]←'e functions cover a wide variety of common',(,⎕UCS 10)
  (howdescribe2)[569+⍳34]←'   ''utility'' applications.',(,⎕UCS 10 10),'   The'
  (howdescribe2)[603+⍳51]←' project was begun in 1983 and has progressed throu'
  (howdescribe2)[654+⍳38]←'gh two versions (a',(,⎕UCS 10),'   manual in 1985 a'
  (howdescribe2)[692+⍳51]←'nd 1988) and has now progressed to version 2.1, the'
  (howdescribe2)[743+⍳38]←' most',(,⎕UCS 10),'   complete version so far, in c'
  (howdescribe2)[781+⍳25]←'omputer-readable format.',(,⎕UCS 10)

howdescribe3←2080⍴0 ⍝ prolog ≡1
  (howdescribe3)[⍳55]←'-------------------------------------------------------'
  (howdescribe3)[55+⍳39]←'-----------------------',(,⎕UCS 10),'Coding Conventi'
  (howdescribe3)[94+⍳39]←'ons',(,⎕UCS 10),'-----------------------------------'
  (howdescribe3)[133+⍳44]←'-------------------------------------------',(,⎕UCS 10)
  (howdescribe3)[177+⍳28]←(,⎕UCS 10),'Global Variables:',(,⎕UCS 10),'---------'
  (howdescribe3)[205+⍳38]←'-------',(,⎕UCS 10),'   The only global variable th'
  (howdescribe3)[243+⍳36]←'at needs to be pre-defined is g',(,⎕UCS 8710),'cr, '
  (howdescribe3)[279+⍳37]←'which holds',(,⎕UCS 10),'   the return character.',(,⎕UCS 10)
  (howdescribe3)[316+⍳30]←(,⎕UCS 10),'Checking for Sub-functions:',(,⎕UCS 10),'-'
  (howdescribe3)[346+⍳38]←'-------------------------',(,⎕UCS 10),'   The follo'
  (howdescribe3)[384+⍳50]←'wing four functions have been treated as ''primitiv'
  (howdescribe3)[434+⍳37]←'e'' functions',(,⎕UCS 10),'   and are assumed to be'
  (howdescribe3)[471+⍳48]←' present when any toolkit function is executed.',(,⎕UCS 10)
  (howdescribe3)[519+⍳21]←'   They are: ',(,⎕UCS 8710),'box, ',(,⎕UCS 8710),'d'
  (howdescribe3)[540+⍳47]←'b, checksubroutine, signalerror.  If any other',(,⎕UCS 10)
  (howdescribe3)[587+⍳51]←'   function is needed by a toolkit function, <check'
  (howdescribe3)[638+⍳38]←'subroutine> is used to',(,⎕UCS 10),'   test for its'
  (howdescribe3)[676+⍳51]←' presence in the workspace, and if not present a su'
  (howdescribe3)[727+⍳38]←'itable',(,⎕UCS 10),'   reminder message is issued t'
  (howdescribe3)[765+⍳39]←'hat helps to copy missing functions.',(,⎕UCS 10 10),'O'
  (howdescribe3)[804+⍳38]←'rigin-Independence:',(,⎕UCS 10),'------------------'
  (howdescribe3)[842+⍳38]←'-',(,⎕UCS 10),'   The functions are origin-independ'
  (howdescribe3)[880+⍳40]←'ent.  Origin-independence is typically',(,⎕UCS 10),' '
  (howdescribe3)[920+⍳36]←'  ensured by localizing ',(,⎕UCS 9109),'io, but in '
  (howdescribe3)[956+⍳40]←'some cases the algorithm is written in',(,⎕UCS 10),' '
  (howdescribe3)[996+⍳51]←'  an origin-independent manner.  Some of the functi'
  (howdescribe3)[1047+⍳37]←'ons in the',(,⎕UCS 10),'   library-utility categor'
  (howdescribe3)[1084+⍳35]←'y may require origin-1 however.',(,⎕UCS 10 10),'Av'
  (howdescribe3)[1119+⍳37]←'oiding Name Conflicts:',(,⎕UCS 10),'--------------'
  (howdescribe3)[1156+⍳25]←'---------',(,⎕UCS 10),'   When using ',(,⎕UCS 9109)
  (howdescribe3)[1181+⍳15]←'cr, ',(,⎕UCS 9109),'fx, ',(,⎕UCS 9109),'nc, ',(,⎕UCS 9109)
  (howdescribe3)[1196+⍳48]←'nl and the execute function, name-shadowing may',(,⎕UCS 10)
  (howdescribe3)[1244+⍳48]←'   be an issue.  ''Shadowing'' is the conflict bet'
  (howdescribe3)[1292+⍳37]←'ween names used locally in a',(,⎕UCS 10),'   funct'
  (howdescribe3)[1329+⍳50]←'ion, and the same names used globally in the works'
  (howdescribe3)[1379+⍳37]←'pace.  This is',(,⎕UCS 10),'   avoided in the tool'
  (howdescribe3)[1416+⍳50]←'kit by following the convention that the local nam'
  (howdescribe3)[1466+⍳37]←'es',(,⎕UCS 10),'   begin with an underscored (or u'
  (howdescribe3)[1503+⍳40]←'pper-case) letter.  It is expected that',(,⎕UCS 10)
  (howdescribe3)[1543+⍳50]←'   the programmer avoid using this convention for '
  (howdescribe3)[1593+⍳37]←'their own function names',(,⎕UCS 10),'   or global'
  (howdescribe3)[1630+⍳25]←' variables.',(,⎕UCS 10 10),'Tag-lines:',(,⎕UCS 10),'-'
  (howdescribe3)[1655+⍳37]←'--------',(,⎕UCS 10),'   After the first documenta'
  (howdescribe3)[1692+⍳49]←'tion line of each function, there are one or more'
  (howdescribe3)[1741+⍳38]←(,⎕UCS 10),'   comment lines ''tagged'' by a period'
  (howdescribe3)[1779+⍳39]←' followed by a letter.  These comment',(,⎕UCS 10),' '
  (howdescribe3)[1818+⍳42]←'  lines are used in the following manner:',(,⎕UCS 10)
  (howdescribe3)[1860+⍳49]←'   .e  --  an executable example of the function',(,⎕UCS 10)
  (howdescribe3)[1909+⍳50]←'   .k  --  key word specifying the category of the'
  (howdescribe3)[1959+⍳37]←' function',(,⎕UCS 10),'   .n  --  name of the sour'
  (howdescribe3)[1996+⍳37]←'ce',(,⎕UCS 10),'   .t  --  time-stamp (programmer-'
  (howdescribe3)[2033+⍳37]←'defined)',(,⎕UCS 10),'   .v  --  version number an'
  (howdescribe3)[2070+⍳10]←'d comment',(,⎕UCS 10)

howdescribe4←323⍴0 ⍝ prolog ≡1
  (howdescribe4)[⍳55]←'-------------------------------------------------------'
  (howdescribe4)[55+⍳32]←'-----------------------',(,⎕UCS 10),'Sources',(,⎕UCS 10)
  (howdescribe4)[87+⍳52]←'----------------------------------------------------'
  (howdescribe4)[139+⍳36]←'--------------------------',(,⎕UCS 10 10),'   The s'
  (howdescribe4)[175+⍳51]←'ource of each contributed function is indicated in '
  (howdescribe4)[226+⍳38]←'the .n comment',(,⎕UCS 10),'   line within the func'
  (howdescribe4)[264+⍳46]←'tion, or in the supplied documentation of the',(,⎕UCS 10)
  (howdescribe4)[310+⍳13]←'   function.',(,⎕UCS 10)

howdescribe5←812⍴0 ⍝ prolog ≡1
  (howdescribe5)[⍳55]←'-------------------------------------------------------'
  (howdescribe5)[55+⍳39]←'-----------------------',(,⎕UCS 10),'Organization of'
  (howdescribe5)[94+⍳39]←' the Toolkit Workspace',(,⎕UCS 10),'----------------'
  (howdescribe5)[133+⍳51]←'---------------------------------------------------'
  (howdescribe5)[184+⍳36]←'-----------',(,⎕UCS 10 10),'   The workspace may be'
  (howdescribe5)[220+⍳51]←' viewed as a collection of individual functions, so'
  (howdescribe5)[271+⍳38]←'me',(,⎕UCS 10),'   of which call other functions.  '
  (howdescribe5)[309+⍳40]←'If any function calls other functions,',(,⎕UCS 10),' '
  (howdescribe5)[349+⍳51]←'  <checksubroutine> is used to test for the presenc'
  (howdescribe5)[400+⍳38]←'e of these functions',(,⎕UCS 10),'   (and all funct'
  (howdescribe5)[438+⍳51]←'ions called by them) at the beginning.  The only re'
  (howdescribe5)[489+⍳38]←'quired',(,⎕UCS 10),'   global variable that needs t'
  (howdescribe5)[527+⍳36]←'o be pre-defined is g',(,⎕UCS 8710),'cr which holds'
  (howdescribe5)[563+⍳27]←' the',(,⎕UCS 10),'   return character.',(,⎕UCS 10 10)
  (howdescribe5)[590+⍳51]←'   There is no group structure.  However, the funct'
  (howdescribe5)[641+⍳38]←'ions have been placed into',(,⎕UCS 10),'   categori'
  (howdescribe5)[679+⍳51]←'es for explanatory purposes and to aid in finding s'
  (howdescribe5)[730+⍳38]←'uitable',(,⎕UCS 10),'   functions for an applicatio'
  (howdescribe5)[768+⍳44]←'n.  This is done using the .k comment line.',(,⎕UCS 10)

howdescribe6←803⍴0 ⍝ prolog ≡1
  (howdescribe6)[⍳55]←'-------------------------------------------------------'
  (howdescribe6)[55+⍳39]←'-----------------------',(,⎕UCS 10),'How to Use the '
  (howdescribe6)[94+⍳39]←'Toolkit',(,⎕UCS 10),'-------------------------------'
  (howdescribe6)[133+⍳48]←'-----------------------------------------------',(,⎕UCS 10)
  (howdescribe6)[181+⍳41]←(,⎕UCS 10),'To use a toolkit function, follow these '
  (howdescribe6)[222+⍳36]←'steps:',(,⎕UCS 10 10),'(1) Copy the basic functions'
  (howdescribe6)[258+⍳43]←' and global variables into your workspace.',(,⎕UCS 10)
  (howdescribe6)[301+⍳24]←'     )copy toolkit ',(,⎕UCS 8710),'db ',(,⎕UCS 8710)
  (howdescribe6)[325+⍳35]←'box checksubroutine signalerror g',(,⎕UCS 8710 99)
  (howdescribe6)[360+⍳36]←(,⎕UCS 114 10 10),'(2) Copy the desired function (ca'
  (howdescribe6)[396+⍳38]←'ll it <foo>) into your workspace.',(,⎕UCS 10),'    '
  (howdescribe6)[434+⍳36]←' )copy toolkit foo',(,⎕UCS 10 10),'(3) Execute foo '
  (howdescribe6)[470+⍳42]←'(with any required arguments, of course).',(,⎕UCS 10)
  (howdescribe6)[512+⍳36]←'     foo',(,⎕UCS 10 10),'(4) If foo requires any ot'
  (howdescribe6)[548+⍳51]←'her toolkit functions not present in your workspace'
  (howdescribe6)[599+⍳38]←',',(,⎕UCS 10),'    a warning message will appear ad'
  (howdescribe6)[637+⍳38]←'vising which functions to copy from',(,⎕UCS 10),'  '
  (howdescribe6)[675+⍳36]←'  the toolkit.',(,⎕UCS 10 10),'   Note that if you '
  (howdescribe6)[711+⍳51]←'have followed step (1), above, for a previous toolk'
  (howdescribe6)[762+⍳38]←'it',(,⎕UCS 10),'   function, it need not be repeate'
  (howdescribe6)[800+⍳3]←'d.',(,⎕UCS 10)

howdescribe7←1287⍴0 ⍝ prolog ≡1
  (howdescribe7)[⍳55]←'-------------------------------------------------------'
  (howdescribe7)[55+⍳38]←'-----------------------',(,⎕UCS 10),'Documentation',(,⎕UCS 10)
  (howdescribe7)[93+⍳52]←'----------------------------------------------------'
  (howdescribe7)[145+⍳36]←'--------------------------',(,⎕UCS 10 10),'   The T'
  (howdescribe7)[181+⍳51]←'oolkit is extensively documented.  The following pr'
  (howdescribe7)[232+⍳38]←'ovides a summary',(,⎕UCS 10),'   of the functions p'
  (howdescribe7)[270+⍳49]←'rovided for documentation purposes.  Consult the',(,⎕UCS 10)
  (howdescribe7)[319+⍳51]←'   document for each function (using <explain>) for'
  (howdescribe7)[370+⍳36]←' further details.',(,⎕UCS 10 10),'   It is expected'
  (howdescribe7)[406+⍳51]←' that these functions be executed within the toolki'
  (howdescribe7)[457+⍳25]←'t',(,⎕UCS 10),'   workspace itself.',(,⎕UCS 10 10),' '
  (howdescribe7)[482+⍳51]←'  Depending on your computer, some of these functio'
  (howdescribe7)[533+⍳38]←'ns may take several',(,⎕UCS 10),'   minutes to comp'
  (howdescribe7)[571+⍳51]←'lete execution if the entire list of toolkit functi'
  (howdescribe7)[622+⍳38]←'ons is',(,⎕UCS 10),'   used for the argument.  To t'
  (howdescribe7)[660+⍳44]←'est response time, try the functions on one',(,⎕UCS 10)
  (howdescribe7)[704+⍳36]←'   or two functions first.',(,⎕UCS 10 10),'   conte'
  (howdescribe7)[740+⍳51]←'nts -- summary report of one-line description of ea'
  (howdescribe7)[791+⍳36]←'ch function',(,⎕UCS 10 10),'   contents1 -- another'
  (howdescribe7)[827+⍳42]←' summary report (quicker than <contents>)',(,⎕UCS 10)
  (howdescribe7)[869+⍳41]←(,⎕UCS 10),'   explain -- return one-page document e'
  (howdescribe7)[910+⍳38]←'xplaining purpose, arguments, notes,',(,⎕UCS 10),' '
  (howdescribe7)[948+⍳36]←'  examples, etc.',(,⎕UCS 10 10),'   comments -- ret'
  (howdescribe7)[984+⍳51]←'urn the initial explanatory comments within each fu'
  (howdescribe7)[1035+⍳35]←'nction',(,⎕UCS 10 10),'   example -- display and e'
  (howdescribe7)[1070+⍳39]←'xecute an example use of the function',(,⎕UCS 10 10)
  (howdescribe7)[1109+⍳50]←'   funsincat -- returns list of all functions in a'
  (howdescribe7)[1159+⍳35]←' category',(,⎕UCS 10 10),'   catoffun -- return ca'
  (howdescribe7)[1194+⍳35]←'tegory of specified function',(,⎕UCS 10 10),'   fn'
  (howdescribe7)[1229+⍳50]←'list -- return function listing of one or more fun'
  (howdescribe7)[1279+⍳8]←'ctions',(,⎕UCS 10 10)

howdescribe8←994⍴0 ⍝ prolog ≡1
  (howdescribe8)[⍳55]←'-------------------------------------------------------'
  (howdescribe8)[55+⍳39]←'-----------------------',(,⎕UCS 10),'Differences bet'
  (howdescribe8)[94+⍳39]←'ween Version 2.0 and Version 2.1',(,⎕UCS 10),'------'
  (howdescribe8)[133+⍳51]←'---------------------------------------------------'
  (howdescribe8)[184+⍳36]←'---------------------',(,⎕UCS 10 10),'   Version 2.'
  (howdescribe8)[220+⍳51]←'0 was published as a manual in 1988.  Version 2.1 w'
  (howdescribe8)[271+⍳38]←'as published',(,⎕UCS 10),'   in diskette form in 19'
  (howdescribe8)[309+⍳36]←'92.',(,⎕UCS 10 10),'   The main differences between'
  (howdescribe8)[345+⍳38]←' the two versions is the following:',(,⎕UCS 10 10),' '
  (howdescribe8)[383+⍳49]←'  (1) Enhancements to the functions in the ''date'''
  (howdescribe8)[432+⍳36]←' category.',(,⎕UCS 10 10),'   (2) Enhancements and '
  (howdescribe8)[468+⍳50]←'additions to the functions in the ''programming too'
  (howdescribe8)[518+⍳37]←'ls''',(,⎕UCS 10),'   category, including <fagl>, <b'
  (howdescribe8)[555+⍳36]←'rowse>, and <change>.',(,⎕UCS 10 10),'   (3) Use of'
  (howdescribe8)[591+⍳51]←' <signalerror> for argument checking throughout the'
  (howdescribe8)[642+⍳36]←' workspace.',(,⎕UCS 10 10),'   (4) Increased number'
  (howdescribe8)[678+⍳51]←' of function documents from 100 to 140.  All docume'
  (howdescribe8)[729+⍳34]←'nts',(,⎕UCS 10),'   were edited and clarified.',(,⎕UCS 10)
  (howdescribe8)[763+⍳41]←(,⎕UCS 10),'   (5) Improved comments and performance'
  (howdescribe8)[804+⍳36]←', corrected minor errors.',(,⎕UCS 10 10),'   (6) In'
  (howdescribe8)[840+⍳51]←' some functions the order of the arguments was chan'
  (howdescribe8)[891+⍳38]←'ged.  (See',(,⎕UCS 10),'   version comment line for'
  (howdescribe8)[929+⍳36]←' details).',(,⎕UCS 10 10),'   (7) Major enhancement'
  (howdescribe8)[965+⍳29]←'s to <example> and <script>.',(,⎕UCS 10)

howdescribe9←811⍴0 ⍝ prolog ≡1
  (howdescribe9)[⍳55]←'-------------------------------------------------------'
  (howdescribe9)[55+⍳39]←'-----------------------',(,⎕UCS 10),'For Further Inf'
  (howdescribe9)[94+⍳39]←'ormation ...',(,⎕UCS 10),'--------------------------'
  (howdescribe9)[133+⍳51]←'---------------------------------------------------'
  (howdescribe9)[184+⍳36]←'-',(,⎕UCS 10 10),'   For further information about '
  (howdescribe9)[220+⍳44]←'the Toolkit, including comments, questions,',(,⎕UCS 10)
  (howdescribe9)[264+⍳51]←'   additions, and corrections, feel free to contact'
  (howdescribe9)[315+⍳38]←' the Toolkit editor',(,⎕UCS 10),'   at the address '
  (howdescribe9)[353+⍳36]←'below.',(,⎕UCS 10 10),'   For further information a'
  (howdescribe9)[389+⍳38]←'bout the Toronto Chapter of the ACM',(,⎕UCS 10),'  '
  (howdescribe9)[427+⍳51]←' APL SIG, and for information about joining SIGAPL '
  (howdescribe9)[478+⍳36]←'or ACM, write to:',(,⎕UCS 10 10),'    Toronto APL S'
  (howdescribe9)[514+⍳38]←'pecial Interest Group,',(,⎕UCS 10),'    P.O. Box 38'
  (howdescribe9)[552+⍳38]←'4, Adelaide Street Station,',(,⎕UCS 10),'    Toront'
  (howdescribe9)[590+⍳32]←'o, Ontario, Canada.',(,⎕UCS 10),'    M5C 2J5',(,⎕UCS 10)
  (howdescribe9)[622+⍳41]←(,⎕UCS 10),'   For current phone numbers for the Too'
  (howdescribe9)[663+⍳38]←'lkit editor or any other member of',(,⎕UCS 10),'   '
  (howdescribe9)[701+⍳51]←'the executive, refer to a current issue of the SIG '
  (howdescribe9)[752+⍳38]←'newsletter, or write',(,⎕UCS 10),'   to the Group a'
  (howdescribe9)[790+⍳21]←'t the above address.',(,⎕UCS 10)

howdescribeindex←533⍴0 ⍝ prolog ≡1
  (howdescribeindex)[⍳51]←'---------------------------------------------------'
  (howdescribeindex)[51+⍳34]←'---------------------------',(,⎕UCS 10),'Index',(,⎕UCS 10)
  (howdescribeindex)[85+⍳35]←'Toronto Toolkit Version 2.1',(,⎕UCS 10),'-------'
  (howdescribeindex)[120+⍳47]←'-----------------------------------------------'
  (howdescribeindex)[167+⍳32]←'------------------------',(,⎕UCS 10 10),'Please'
  (howdescribeindex)[199+⍳46]←' choose by number one of the following topics:'
  (howdescribeindex)[245+⍳35]←(,⎕UCS 10 10),'   1 - Notices and Distribution P'
  (howdescribeindex)[280+⍳26]←'olicy',(,⎕UCS 10),'   2 - Introduction',(,⎕UCS 10)
  (howdescribeindex)[306+⍳34]←'   3 - Coding Conventions',(,⎕UCS 10),'   4 - S'
  (howdescribeindex)[340+⍳34]←'ources',(,⎕UCS 10),'   5 - Organization of Tool'
  (howdescribeindex)[374+⍳34]←'kit Workspace',(,⎕UCS 10),'   6 - How to use th'
  (howdescribeindex)[408+⍳31]←'e Toolkit',(,⎕UCS 10),'   7 - Documentation',(,⎕UCS 10)
  (howdescribeindex)[439+⍳46]←'   8 - Differences between Version 2.0 and 2.1'
  (howdescribeindex)[485+⍳36]←(,⎕UCS 10),'   9 - For further information ...',(,⎕UCS 10)
  (howdescribeindex)[521+⍳12]←(,⎕UCS 10),'   0 - end',(,⎕UCS 10)

howdfh←959⍴0 ⍝ prolog ≡1
  (howdfh)[⍳61]←'-------------------------------------------------------------'
  (howdfh)[61+⍳27]←'-----------------',(,⎕UCS 10 121 8592),'dfh x',(,⎕UCS 10),'r'
  (howdfh)[88+⍳45]←'eturn decimal values of hex numbers <x>',(,⎕UCS 10),'-----'
  (howdfh)[133+⍳57]←'---------------------------------------------------------'
  (howdfh)[190+⍳32]←'----------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howdfh)[222+⍳43]←'------------',(,⎕UCS 10),'   <dfh> stands for ''decimal f'
  (howdfh)[265+⍳46]←'rom hex''.  The function returns the ''decimal''',(,⎕UCS 10)
  (howdfh)[311+⍳57]←'   (i.e.  base-10) numbers corresponding to the numbers <'
  (howdfh)[368+⍳37]←'x> given in',(,⎕UCS 10),'   hexadecimal notation.',(,⎕UCS 10)
  (howdfh)[405+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howdfh)[428+⍳44]←'x>   Character matrix',(,⎕UCS 10),'   Each row of <x> is '
  (howdfh)[472+⍳54]←'treated as a hex number.  Numbers must be zero-padded',(,⎕UCS 10)
  (howdfh)[526+⍳57]←'   as necessary, since blanks are considered unknown char'
  (howdfh)[583+⍳44]←'acters.  A scalar',(,⎕UCS 10),'   or vector is treated a '
  (howdfh)[627+⍳29]←'1-row matrix.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howdfh)[656+⍳34]←(,⎕UCS 10),'<y>   Numeric vector',(,⎕UCS 10),'   The vecto'
  (howdfh)[690+⍳56]←'r of decimal (base 10) equivalents.  y[i] is the base-10'
  (howdfh)[746+⍳32]←(,⎕UCS 10),'   equivalent of x[i;].',(,⎕UCS 10 10),'Exampl'
  (howdfh)[778+⍳20]←'es:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howdfh)[798+⍳22]←(,⎕UCS 8592 109 8592),'6 3',(,⎕UCS 9076),'''0000010101000a'
  (howdfh)[820+⍳17]←'b35a''',(,⎕UCS 10),'000',(,⎕UCS 10),'001',(,⎕UCS 10),'010'
  (howdfh)[837+⍳13]←(,⎕UCS 10),'100',(,⎕UCS 10),'0ab',(,⎕UCS 10),'35a',(,⎕UCS 10)
  (howdfh)[850+⍳32]←'      dfh m',(,⎕UCS 10),'0 1 16 256 171 858',(,⎕UCS 10),'.'
  (howdfh)[882+⍳44]←'.. <hfd> is the inverse for <dfh>.',(,⎕UCS 10),'      3 h'
  (howdfh)[926+⍳18]←'fd dfh m',(,⎕UCS 10),'000',(,⎕UCS 10),'001',(,⎕UCS 10),'0'
  (howdfh)[944+⍳15]←'10',(,⎕UCS 10),'100',(,⎕UCS 10),'0ab',(,⎕UCS 10),'35a',(,⎕UCS 10)

howdimension←545⍴0 ⍝ prolog ≡1
  (howdimension)[⍳55]←'-------------------------------------------------------'
  (howdimension)[55+⍳32]←'-----------------------',(,⎕UCS 10 114 8592),'rcm di'
  (howdimension)[87+⍳39]←'mension m',(,⎕UCS 10),'compute (n-1) dimension array'
  (howdimension)[126+⍳38]←' from coordinate/data matrix <m>',(,⎕UCS 10),'-----'
  (howdimension)[164+⍳51]←'---------------------------------------------------'
  (howdimension)[215+⍳32]←'----------------------',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howdimension)[247+⍳38]←'------',(,⎕UCS 10),'   Dan King, Toronto, Canada.  '
  (howdimension)[285+⍳35]←'(telephone 416-595-1782)',(,⎕UCS 10 10),'Examples:'
  (howdimension)[320+⍳17]←(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howdimension)[337+⍳11]←(,⎕UCS 8592),'data',(,⎕UCS 8592),'5 4',(,⎕UCS 9076),'1'
  (howdimension)[348+⍳40]←' 3 2 1 1 1 3 2 3 2 2 3 1 1 2 4 4 1 2 5',(,⎕UCS 10),'1'
  (howdimension)[388+⍳23]←' 3 2 1',(,⎕UCS 10),'1 1 3 2',(,⎕UCS 10),'3 2 2 3',(,⎕UCS 10)
  (howdimension)[411+⍳22]←'1 1 2 4',(,⎕UCS 10),'4 1 2 5',(,⎕UCS 10),'      '
  (howdimension)[433+⍳10]←(,⎕UCS 9109 8592),'rcm',(,⎕UCS 8592),'3 3',(,⎕UCS 9076)
  (howdimension)[443+⍳15]←(,⎕UCS 9075 51 10),'1 2 3',(,⎕UCS 10),'1 2 3',(,⎕UCS 10)
  (howdimension)[458+⍳31]←'1 2 3',(,⎕UCS 10),'      rcm dimension data',(,⎕UCS 10)
  (howdimension)[489+⍳18]←'0 4 2',(,⎕UCS 10),'0 0 0',(,⎕UCS 10),'0 1 0',(,⎕UCS 10)
  (howdimension)[507+⍳15]←(,⎕UCS 10),'0 0 0',(,⎕UCS 10),'0 0 0',(,⎕UCS 10),'0 '
  (howdimension)[522+⍳17]←'0 0',(,⎕UCS 10 10),'0 0 0',(,⎕UCS 10),'0 3 0',(,⎕UCS 10)
  (howdimension)[539+⍳6]←'0 0 0',(,⎕UCS 10)

howdisplayfunction←2334⍴0 ⍝ prolog ≡1
  (howdisplayfunction)[⍳49]←'-------------------------------------------------'
  (howdisplayfunction)[49+⍳31]←'-----------------------------',(,⎕UCS 10 121)
  (howdisplayfunction)[80+⍳22]←(,⎕UCS 8592),'e displayfunction a',(,⎕UCS 10),'d'
  (howdisplayfunction)[102+⍳45]←'isplay of canonical matrix <a> using exdents '
  (howdisplayfunction)[147+⍳32]←'<e>',(,⎕UCS 10),'----------------------------'
  (howdisplayfunction)[179+⍳45]←'---------------------------------------------'
  (howdisplayfunction)[224+⍳21]←'-----',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howdisplayfunction)[245+⍳32]←'------------',(,⎕UCS 10),'   <displayfunction'
  (howdisplayfunction)[277+⍳45]←'> computes the usual formatted display of a f'
  (howdisplayfunction)[322+⍳32]←'unction,',(,⎕UCS 10),'   including line numbe'
  (howdisplayfunction)[354+⍳28]←'rs and ''',(,⎕UCS 8711),''' at the top and bo'
  (howdisplayfunction)[382+⍳30]←'ttom.  (See examples.)',(,⎕UCS 10 10),'   The'
  (howdisplayfunction)[412+⍳45]←' function optionally allows different values '
  (howdisplayfunction)[457+⍳32]←'to exdent comment, branch,',(,⎕UCS 10),'   an'
  (howdisplayfunction)[489+⍳30]←'d label statements.',(,⎕UCS 10 10),'   A defi'
  (howdisplayfunction)[519+⍳45]←'ned function is the only method in ISO-standa'
  (howdisplayfunction)[564+⍳32]←'rd APL to produce a',(,⎕UCS 10),'   formatted'
  (howdisplayfunction)[596+⍳45]←' function display as a computable result.  Th'
  (howdisplayfunction)[641+⍳32]←'e canonical matrix',(,⎕UCS 10),'   (result of'
  (howdisplayfunction)[673+⍳29]←' ',(,⎕UCS 9109),'cr) is the usual argument.',(,⎕UCS 10)
  (howdisplayfunction)[702+⍳21]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------'
  (howdisplayfunction)[723+⍳23]←(,⎕UCS 10),'<e>   Numeric vector',(,⎕UCS 10),' '
  (howdisplayfunction)[746+⍳45]←'  e[1] -- spaces to exdent comment statements'
  (howdisplayfunction)[791+⍳32]←' (default=1)',(,⎕UCS 10),'   e[2] -- spaces t'
  (howdisplayfunction)[823+⍳39]←'o exdent branch statements (default=0)',(,⎕UCS 10)
  (howdisplayfunction)[862+⍳45]←'   e[3] -- spaces to exdent label statements '
  (howdisplayfunction)[907+⍳32]←'(default=value for e[1])',(,⎕UCS 10),'   Note'
  (howdisplayfunction)[939+⍳45]←': e[3] defaults to e[1] because comments and '
  (howdisplayfunction)[984+⍳32]←'labels are often exdented',(,⎕UCS 10),'   the'
  (howdisplayfunction)[1016+⍳29]←' same amount.',(,⎕UCS 10 10),'<a>   Characte'
  (howdisplayfunction)[1045+⍳31]←'r matrix',(,⎕UCS 10),'   This is usually the'
  (howdisplayfunction)[1076+⍳29]←' result of ',(,⎕UCS 9109),'cr, or in the sam'
  (howdisplayfunction)[1105+⍳31]←'e format, although the',(,⎕UCS 10),'   funct'
  (howdisplayfunction)[1136+⍳42]←'ion does not ''care'' (i.e.  check the argum'
  (howdisplayfunction)[1178+⍳16]←'ent).',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howdisplayfunction)[1194+⍳29]←'-----',(,⎕UCS 10),'<z>   Character matrix',(,⎕UCS 10)
  (howdisplayfunction)[1223+⍳44]←'   A display form of the matrix <a>.  Commen'
  (howdisplayfunction)[1267+⍳31]←'ts, branch statements, and',(,⎕UCS 10),'   l'
  (howdisplayfunction)[1298+⍳44]←'abelled lines will be exdented according to '
  (howdisplayfunction)[1342+⍳28]←'the argument <e>.',(,⎕UCS 10 10),'Examples:'
  (howdisplayfunction)[1370+⍳21]←(,⎕UCS 10),'--------',(,⎕UCS 10),'...Display '
  (howdisplayfunction)[1391+⍳44]←'example function <foo> using specified exden'
  (howdisplayfunction)[1435+⍳31]←'t values.',(,⎕UCS 10),'...Note: 4 2 and 4 2 '
  (howdisplayfunction)[1466+⍳34]←'4 would produce the same result.',(,⎕UCS 10),' '
  (howdisplayfunction)[1500+⍳29]←'     4 2 4 displayfunction ',(,⎕UCS 9109),'c'
  (howdisplayfunction)[1529+⍳14]←'r ''foo''',(,⎕UCS 10),'    ',(,⎕UCS 8711),' '
  (howdisplayfunction)[1543+⍳16]←'   y',(,⎕UCS 8592),'foo x;z',(,⎕UCS 10),'[1]'
  (howdisplayfunction)[1559+⍳29]←'  ',(,⎕UCS 9053),'nonsense example for displ'
  (howdisplayfunction)[1588+⍳22]←'ayfunction',(,⎕UCS 10),'[2]      z',(,⎕UCS 8592)
  (howdisplayfunction)[1610+⍳17]←(,⎕UCS 57 10),'[3]    ',(,⎕UCS 8594),'(x=0)/L'
  (howdisplayfunction)[1627+⍳16]←'10',(,⎕UCS 10),'[4]      y',(,⎕UCS 8592),'z+'
  (howdisplayfunction)[1643+⍳13]←'x',(,⎕UCS 10),'[5]    ',(,⎕UCS 8594 48 10),'['
  (howdisplayfunction)[1656+⍳20]←'6]  L10:',(,⎕UCS 10),'[7]      y',(,⎕UCS 8592)
  (howdisplayfunction)[1676+⍳13]←(,⎕UCS 52 10),'    ',(,⎕UCS 8711 10 10),'Note'
  (howdisplayfunction)[1689+⍳18]←'s:',(,⎕UCS 10),'-----',(,⎕UCS 10),'   This f'
  (howdisplayfunction)[1707+⍳44]←'unction provides flexibility in setting the '
  (howdisplayfunction)[1751+⍳31]←'line exdents to serve',(,⎕UCS 10),'   differ'
  (howdisplayfunction)[1782+⍳44]←'ent purposes.  (The standard settings used i'
  (howdisplayfunction)[1826+⍳31]←'n the function editor',(,⎕UCS 10),'   are as'
  (howdisplayfunction)[1857+⍳44]←' defined for the defaults for <e>).  The sta'
  (howdisplayfunction)[1901+⍳31]←'ndard settings exdent',(,⎕UCS 10),'   only c'
  (howdisplayfunction)[1932+⍳44]←'omments and labelled lines.  Another opinion'
  (howdisplayfunction)[1976+⍳31]←' is to exdent branch',(,⎕UCS 10),'   stateme'
  (howdisplayfunction)[2007+⍳44]←'nts to clarify the branching structure, if a'
  (howdisplayfunction)[2051+⍳31]←'ny.  Further, the',(,⎕UCS 10),'   standard u'
  (howdisplayfunction)[2082+⍳44]←'ses exdent values of 1 0 1 for comments, bra'
  (howdisplayfunction)[2126+⍳31]←'nch, and labels,',(,⎕UCS 10),'   respectivel'
  (howdisplayfunction)[2157+⍳44]←'y.  Another opinion is that larger values pr'
  (howdisplayfunction)[2201+⍳31]←'oduce a more',(,⎕UCS 10),'   readable displa'
  (howdisplayfunction)[2232+⍳44]←'y for programme development and publication.'
  (howdisplayfunction)[2276+⍳31]←'  Try 4 2 4.',(,⎕UCS 10),'   (Thanks to Adri'
  (howdisplayfunction)[2307+⍳27]←'an Smith for these ideas.)',(,⎕UCS 10)

howdround←1961⍴0 ⍝ prolog ≡1
  (howdround)[⍳58]←'----------------------------------------------------------'
  (howdround)[58+⍳34]←'--------------------',(,⎕UCS 10 114 8592),'u dround v',(,⎕UCS 10)
  (howdround)[92+⍳55]←'distributive rounding of a vector <v> to arbitrary scal'
  (howdround)[147+⍳41]←'ar unit <u>',(,⎕UCS 10),'-----------------------------'
  (howdround)[188+⍳50]←'-------------------------------------------------',(,⎕UCS 10)
  (howdround)[238+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howdround)[266+⍳54]←'   Rounding a set of numbers before summation may caus'
  (howdround)[320+⍳41]←'e an error in the sum,',(,⎕UCS 10),'   as round-off er'
  (howdround)[361+⍳54]←'rors may interfere.  It would be good practice to carr'
  (howdround)[415+⍳41]←'y',(,⎕UCS 10),'   maximum precision until the final su'
  (howdround)[456+⍳41]←'mmation and then round the sum.',(,⎕UCS 10),'   Howeve'
  (howdround)[497+⍳54]←'r, when this is not possible, we may still want to ens'
  (howdround)[551+⍳41]←'ure that the',(,⎕UCS 10),'   rounded sum is the same a'
  (howdround)[592+⍳39]←'s the sum of the rounded numbers.',(,⎕UCS 10 10),'Argu'
  (howdround)[631+⍳28]←'ments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<v>   numer'
  (howdround)[659+⍳39]←'ic vector',(,⎕UCS 10),'   the numbers to be rounded',(,⎕UCS 10)
  (howdround)[698+⍳31]←(,⎕UCS 10),'<u>   numeric scalar',(,⎕UCS 10),'   arbitr'
  (howdround)[729+⍳51]←'ary scalar unit controlling rounding decimal place',(,⎕UCS 10)
  (howdround)[780+⍳18]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y'
  (howdround)[798+⍳41]←'>   numeric vector',(,⎕UCS 10),'   The result is a vec'
  (howdround)[839+⍳54]←'tor of rounded <x> with the roundoff errors distribute'
  (howdround)[893+⍳26]←'d',(,⎕UCS 10),'   among the numbers.',(,⎕UCS 10 10),'S'
  (howdround)[919+⍳28]←'ource:',(,⎕UCS 10),'------',(,⎕UCS 10),'   The APL Han'
  (howdround)[947+⍳39]←'dbook of Techniques, 1977 (IBM)',(,⎕UCS 10 10),'Exampl'
  (howdround)[986+⍳28]←'es:',(,⎕UCS 10),'--------',(,⎕UCS 10),'..... Suppose v'
  (howdround)[1014+⍳53]←' is a vector of dollar amounts (after currency adjust'
  (howdround)[1067+⍳25]←'ment)',(,⎕UCS 10),'      v',(,⎕UCS 8592),'167.0811 42'
  (howdround)[1092+⍳53]←'4.7704 519.4701 77.0022 163.6762 31.3536 559.1038 170'
  (howdround)[1145+⍳25]←'55.742',(,⎕UCS 10),'      v',(,⎕UCS 8592),'v,125.3108'
  (howdround)[1170+⍳53]←' 247.7827 1168.8078 256.674 130.941 877.8996 127.7951'
  (howdround)[1223+⍳31]←(,⎕UCS 10),'..... sum of rounded numbers',(,⎕UCS 10),' '
  (howdround)[1254+⍳30]←'     +/.01 dround v',(,⎕UCS 10),'21933.41',(,⎕UCS 10),'.'
  (howdround)[1284+⍳40]←'.... rounded sum of numbers',(,⎕UCS 10),'      2 rnd '
  (howdround)[1324+⍳27]←'+/v',(,⎕UCS 10),'21933.41',(,⎕UCS 10),'..... This sum'
  (howdround)[1351+⍳53]←' is not the same as the sum of rounded numbers using '
  (howdround)[1404+⍳40]←'<rnd>',(,⎕UCS 10),'..... which is the usual function '
  (howdround)[1444+⍳35]←'used for rounding.',(,⎕UCS 10),'      +/2 rnd v',(,⎕UCS 10)
  (howdround)[1479+⍳34]←'21933.4',(,⎕UCS 10),'..... differs by a penny!',(,⎕UCS 10)
  (howdround)[1513+⍳43]←(,⎕UCS 10),'..... Compute and display how the results '
  (howdround)[1556+⍳37]←'of <rnd> and <dround> differ.',(,⎕UCS 10),'      m'
  (howdround)[1593+⍳31]←(,⎕UCS 8592),'(.01 dround v),[1.5] 2 rnd v',(,⎕UCS 10),' '
  (howdround)[1624+⍳27]←'     (',(,⎕UCS 9045),'m),'' '' beside (''/'' ',(,⎕UCS 8710)
  (howdround)[1651+⍳32]←'box '' /<-- different'')[,1+',(,⎕UCS 8800),'/m;]',(,⎕UCS 10)
  (howdround)[1683+⍳36]←'  167.08   167.08',(,⎕UCS 10),'  424.77   424.77',(,⎕UCS 10)
  (howdround)[1719+⍳33]←'  519.47   519.47',(,⎕UCS 10),'   77       77',(,⎕UCS 10)
  (howdround)[1752+⍳36]←'  163.68   163.68',(,⎕UCS 10),'   31.35    31.35',(,⎕UCS 10)
  (howdround)[1788+⍳35]←'  559.1    559.1',(,⎕UCS 10),'17055.74 17055.74',(,⎕UCS 10)
  (howdround)[1823+⍳36]←'  125.31   125.31',(,⎕UCS 10),'  247.78   247.78',(,⎕UCS 10)
  (howdround)[1859+⍳40]←' 1168.81  1168.81',(,⎕UCS 10),'  256.68   256.67 <-- '
  (howdround)[1899+⍳29]←'different',(,⎕UCS 10),'  130.94   130.94',(,⎕UCS 10),' '
  (howdround)[1928+⍳33]←' 877.9    877.9',(,⎕UCS 10),'  127.8    127.8',(,⎕UCS 10)

howds←378⍴0 ⍝ prolog ≡1
  (howds)[⍳62]←'--------------------------------------------------------------'
  (howds)[62+⍳26]←'----------------',(,⎕UCS 10 122 8592),'ds x',(,⎕UCS 10),'se'
  (howds)[88+⍳46]←'t of descriptive statistics for data <x>',(,⎕UCS 10),'-----'
  (howds)[134+⍳58]←'----------------------------------------------------------'
  (howds)[192+⍳32]←'---------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-'
  (howds)[224+⍳45]←'-----------',(,⎕UCS 10),'   For a details on how the stati'
  (howds)[269+⍳45]←'stics are computed, refer to the function',(,⎕UCS 10),'   '
  (howds)[314+⍳58]←'itself, the function <dstat>, and the documentation on <ds'
  (howds)[372+⍳6]←'tat>.',(,⎕UCS 10)

howdstat←1430⍴0 ⍝ prolog ≡1
  (howdstat)[⍳59]←'-----------------------------------------------------------'
  (howdstat)[59+⍳30]←'-------------------',(,⎕UCS 10),'dstat x',(,⎕UCS 10),'la'
  (howdstat)[89+⍳50]←'belled set of descriptive statistics for data <x>',(,⎕UCS 10)
  (howdstat)[139+⍳55]←'-------------------------------------------------------'
  (howdstat)[194+⍳39]←'-----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howdstat)[233+⍳42]←'------------',(,⎕UCS 10),'   <dstat> formats the statis'
  (howdstat)[275+⍳49]←'tics computed by <ds>.  If a different format is',(,⎕UCS 10)
  (howdstat)[324+⍳55]←'   required, <dstat> can be changed without affecting <'
  (howdstat)[379+⍳42]←'ds>.  Several common',(,⎕UCS 10),'   statistics, includ'
  (howdstat)[421+⍳54]←'ing mean, range, and standard deviation, are included',(,⎕UCS 10)
  (howdstat)[475+⍳30]←'   in the report.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howdstat)[505+⍳31]←'---------',(,⎕UCS 10),'<x>   numeric vector',(,⎕UCS 10)
  (howdstat)[536+⍳19]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'   '
  (howdstat)[555+⍳55]←'A labelled set of statistics is displayed on the termin'
  (howdstat)[610+⍳42]←'al using',(,⎕UCS 10),'   quad-output.  For details on h'
  (howdstat)[652+⍳42]←'ow the statistics are computed, refer to',(,⎕UCS 10),' '
  (howdstat)[694+⍳30]←'  the function <ds>.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howdstat)[724+⍳42]←'------',(,⎕UCS 10),'   Statpack2, K.  W.  Smillie (Publ'
  (howdstat)[766+⍳42]←'ication No.  17, University of Alberta,',(,⎕UCS 10),'  '
  (howdstat)[808+⍳28]←' February 1969)',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-'
  (howdstat)[836+⍳27]←'-------',(,⎕UCS 10),'      data',(,⎕UCS 8592),'67.5 68 '
  (howdstat)[863+⍳35]←'151 154 69 43 54',(,⎕UCS 10 10),'      dstat data',(,⎕UCS 10)
  (howdstat)[898+⍳42]←'sample size.......... 7',(,⎕UCS 10),'mean..............'
  (howdstat)[940+⍳42]←'... 86.64285714',(,⎕UCS 10),'variance............. 2112'
  (howdstat)[982+⍳41]←'.392857',(,⎕UCS 10),'standard deviation... 45.9607752',(,⎕UCS 10)
  (howdstat)[1023+⍳41]←'standard error....... 17.37154018',(,⎕UCS 10),'mean de'
  (howdstat)[1064+⍳41]←'viation....... 37.63265306',(,⎕UCS 10),'median........'
  (howdstat)[1105+⍳37]←'....... 68',(,⎕UCS 10),'maximum.............. 154',(,⎕UCS 10)
  (howdstat)[1142+⍳41]←'minimum.............. 43',(,⎕UCS 10),'range...........'
  (howdstat)[1183+⍳20]←'..... 111',(,⎕UCS 10 10),'      ',(,⎕UCS 9109 8592 122)
  (howdstat)[1203+⍳29]←(,⎕UCS 8592),'ds data',(,⎕UCS 10),'7 86.64285714 2112.3'
  (howdstat)[1232+⍳54]←'92857 45.9607752 17.37154018 37.63265306 68 154 43 111'
  (howdstat)[1286+⍳16]←(,⎕UCS 10),'      ',(,⎕UCS 8710),'db 8 2 ',(,⎕UCS 9045)
  (howdstat)[1302+⍳39]←(,⎕UCS 32 122 10),'7.00 86.64 2112.39 45.96 17.37 37.63'
  (howdstat)[1341+⍳34]←' 68.00 154.00 43.00 111.00',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howdstat)[1375+⍳26]←(,⎕UCS 8592),'''mean of data = '',,8 2 ',(,⎕UCS 9045),' '
  (howdstat)[1401+⍳29]←'z[2]',(,⎕UCS 10),'mean of data =    86.64',(,⎕UCS 10)

howduparray←1269⍴0 ⍝ prolog ≡1
  (howduparray)[⍳56]←'--------------------------------------------------------'
  (howduparray)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'a duparr'
  (howduparray)[89+⍳40]←'ay m',(,⎕UCS 10),'duplicate array <m>.  duplicate <a['
  (howduparray)[129+⍳39]←'1]> times along coordinate <a[2]>',(,⎕UCS 10),'-----'
  (howduparray)[168+⍳52]←'----------------------------------------------------'
  (howduparray)[220+⍳36]←'---------------------',(,⎕UCS 10 10),'Introduction:'
  (howduparray)[256+⍳28]←(,⎕UCS 10),'------------',(,⎕UCS 10),'   <duparray> '
  (howduparray)[284+⍳48]←'''duplicates'' (that is, ''copies'') the entire arra'
  (howduparray)[332+⍳39]←'y <m> and',(,⎕UCS 10),'   catenates the <a[1]> array'
  (howduparray)[371+⍳44]←'s along the coordinate specified by <a[2]>.',(,⎕UCS 10)
  (howduparray)[415+⍳52]←'   For example, if <m> is a matrix and <a> is 5 1, t'
  (howduparray)[467+⍳39]←'he result will be 5',(,⎕UCS 10),'   copies of <m> ca'
  (howduparray)[506+⍳43]←'tenated along the first coordinate (rows).',(,⎕UCS 10)
  (howduparray)[549+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howduparray)[571+⍳39]←'<a>   Numeric vector',(,⎕UCS 10),'   a[1] -- Number '
  (howduparray)[610+⍳42]←'of copies of the array <m> in the result.',(,⎕UCS 10)
  (howduparray)[652+⍳52]←'   a[2] -- Coordinate along which catenation takes p'
  (howduparray)[704+⍳39]←'lace.',(,⎕UCS 10),'           a[2] must be in the ra'
  (howduparray)[743+⍳33]←'nge (1,',(,⎕UCS 9076 9076),'m), that is, less than o'
  (howduparray)[776+⍳39]←'r equal to',(,⎕UCS 10),'           the rank of <m>. '
  (howduparray)[815+⍳49]←' a[2]=1 means the first coordinate, a[2]=2 means',(,⎕UCS 10)
  (howduparray)[864+⍳52]←'           the second coordinate, and so on.  If a[2'
  (howduparray)[916+⍳39]←'] is left out, it',(,⎕UCS 10),'           defaults t'
  (howduparray)[955+⍳37]←'o the last coordinate.',(,⎕UCS 10 10),'<m>   Numeric'
  (howduparray)[992+⍳39]←' or character array',(,⎕UCS 10),'   Array to be dupl'
  (howduparray)[1031+⍳23]←'icated.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howduparray)[1054+⍳28]←(,⎕UCS 10),'<y>   Array',(,⎕UCS 10),'   <y> consists'
  (howduparray)[1082+⍳32]←' of <a[1]> copies of <m>.  (',(,⎕UCS 9076 9076),'y)'
  (howduparray)[1114+⍳17]←' = (',(,⎕UCS 9076 9076),'m).',(,⎕UCS 10 10),'Exampl'
  (howduparray)[1131+⍳20]←'es:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howduparray)[1151+⍳14]←(,⎕UCS 8592 109 8592),'3 3',(,⎕UCS 9076),'''abc123'
  (howduparray)[1165+⍳12]←(,⎕UCS 8902),'-+''',(,⎕UCS 10),'abc',(,⎕UCS 10),'123'
  (howduparray)[1177+⍳26]←(,⎕UCS 10 8902 45 43 10),'      2 1 duparray m',(,⎕UCS 10)
  (howduparray)[1203+⍳15]←'abc',(,⎕UCS 10),'123',(,⎕UCS 10 8902 45 43 10),'abc'
  (howduparray)[1218+⍳18]←(,⎕UCS 10),'123',(,⎕UCS 10 8902 45 43 10),'      2 2'
  (howduparray)[1236+⍳25]←' duparray m',(,⎕UCS 10),'abcabc',(,⎕UCS 10),'123123'
  (howduparray)[1261+⍳8]←(,⎕UCS 10 8902 45 43 8902 45 43 10)

howeaster←1753⍴0 ⍝ prolog ≡1
  (howeaster)[⍳58]←'----------------------------------------------------------'
  (howeaster)[58+⍳33]←'--------------------',(,⎕UCS 10 122 8592),'easter ys',(,⎕UCS 10)
  (howeaster)[91+⍳55]←'compute date of Easter (mm dd yyyy) for years <ys> = (y'
  (howeaster)[146+⍳41]←'yyy style)',(,⎕UCS 10),'------------------------------'
  (howeaster)[187+⍳49]←'------------------------------------------------',(,⎕UCS 10)
  (howeaster)[236+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howeaster)[264+⍳54]←'   Given a vector of years, <easter> computes the cale'
  (howeaster)[318+⍳41]←'ndar date of Easter',(,⎕UCS 10),'   Sunday in the cale'
  (howeaster)[359+⍳53]←'ndar date format (mm dd yyyy) for each of the years.',(,⎕UCS 10)
  (howeaster)[412+⍳54]←'   The style of calendar to be used in each case can b'
  (howeaster)[466+⍳29]←'e optionally',(,⎕UCS 10),'   specified.',(,⎕UCS 10 10),'A'
  (howeaster)[495+⍳28]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<ys>   N'
  (howeaster)[523+⍳37]←'umeric scalar or vector, or n',(,⎕UCS 215),'1 or n',(,⎕UCS 215)
  (howeaster)[560+⍳41]←'2 matrix',(,⎕UCS 10),'   <ys> specifies the years and '
  (howeaster)[601+⍳43]←'optionally the calendar style to be used.',(,⎕UCS 10),' '
  (howeaster)[644+⍳40]←'  For an n',(,⎕UCS 215),'2 matrix, the columns are int'
  (howeaster)[684+⍳41]←'erpreted as follows:',(,⎕UCS 10),'   ys[;1] = year (e.'
  (howeaster)[725+⍳41]←'g. 1992)',(,⎕UCS 10),'   ys[;2] = calendar style (0 or'
  (howeaster)[766+⍳39]←' 1)',(,⎕UCS 10 10),'   A scalar or vector is treated a'
  (howeaster)[805+⍳34]←'s a matrix with (',(,⎕UCS 215 47 9076),'ys) rows and 1'
  (howeaster)[839+⍳41]←' column,',(,⎕UCS 10),'   with the year in the first co'
  (howeaster)[880+⍳44]←'lumn and the style defaulting to the value',(,⎕UCS 10),' '
  (howeaster)[924+⍳49]←'  as described for <julian>.  Similarly for an n',(,⎕UCS 215)
  (howeaster)[973+⍳25]←'1 matrix.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howeaster)[998+⍳31]←(,⎕UCS 10),'<z>   Numeric matrix',(,⎕UCS 10),'   A matr'
  (howeaster)[1029+⍳53]←'ix of dates, each row in the calendar date format (mm'
  (howeaster)[1082+⍳38]←' dd yyyy).',(,⎕UCS 10),'   z[;1] = month (1 to 12)',(,⎕UCS 10)
  (howeaster)[1120+⍳40]←'   z[;2] = day (1 to 31)',(,⎕UCS 10),'   z[;3] = year'
  (howeaster)[1160+⍳18]←(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'------',(,⎕UCS 10),' '
  (howeaster)[1178+⍳53]←'  The APL Handbook of Techniques, IBM, 1978.  The alg'
  (howeaster)[1231+⍳40]←'orithm was adapted',(,⎕UCS 10),'   from Knuth, Volume'
  (howeaster)[1271+⍳24]←' II.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------'
  (howeaster)[1295+⍳30]←(,⎕UCS 10),'      easter 1992',(,⎕UCS 10),'   4   19 1'
  (howeaster)[1325+⍳39]←'992',(,⎕UCS 10),'...Formatted as an English phrase:',(,⎕UCS 10)
  (howeaster)[1364+⍳38]←'      ''e'' fdate easter 1992',(,⎕UCS 10),'april 19, '
  (howeaster)[1402+⍳38]←'1992',(,⎕UCS 10 10),'...When is Easter Sunday for 198'
  (howeaster)[1440+⍳38]←'7 and the next 9 years?',(,⎕UCS 10),'      ''e'' fdat'
  (howeaster)[1478+⍳32]←'e easter 1986+',(,⎕UCS 9075 49 48 10),'april 19, 1987'
  (howeaster)[1510+⍳29]←(,⎕UCS 10),'april 3, 1988',(,⎕UCS 10),'march 26, 1989'
  (howeaster)[1539+⍳30]←(,⎕UCS 10),'april 15, 1990',(,⎕UCS 10),'april 31, 1991'
  (howeaster)[1569+⍳30]←(,⎕UCS 10),'april 19, 1992',(,⎕UCS 10),'april 11, 1993'
  (howeaster)[1599+⍳29]←(,⎕UCS 10),'april 3, 1994',(,⎕UCS 10),'april 16, 1995'
  (howeaster)[1628+⍳28]←(,⎕UCS 10),'april 7, 1996',(,⎕UCS 10 10),'...Date of E'
  (howeaster)[1656+⍳53]←'aster in the old style calendar (e.g. in Russia in 18'
  (howeaster)[1709+⍳25]←'85):',(,⎕UCS 10),'      easter 1 2',(,⎕UCS 9076),'188'
  (howeaster)[1734+⍳19]←'5 0',(,⎕UCS 10),'   4   31 1885',(,⎕UCS 10)

howexample←2189⍴0 ⍝ prolog ≡1
  (howexample)[⍳57]←'---------------------------------------------------------'
  (howexample)[57+⍳35]←'---------------------',(,⎕UCS 10 89 8592),'X example N'
  (howexample)[92+⍳44]←(,⎕UCS 10),'display and execute an example for function'
  (howexample)[136+⍳40]←'s <N>. <X> specifies options.',(,⎕UCS 10),'----------'
  (howexample)[176+⍳53]←'-----------------------------------------------------'
  (howexample)[229+⍳31]←'---------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howexample)[260+⍳40]←'------------',(,⎕UCS 10),'   <example> displays and e'
  (howexample)[300+⍳49]←'xecutes an example APL statement for each of the',(,⎕UCS 10)
  (howexample)[349+⍳38]←'   functions specified in <N>.',(,⎕UCS 10 10),'   The'
  (howexample)[387+⍳53]←' functions in the toolkit workspace contain a comment'
  (howexample)[440+⍳40]←' statement with an',(,⎕UCS 10),'   executable example'
  (howexample)[480+⍳51]←', identified by the characters ''.e '' at the beginni'
  (howexample)[531+⍳40]←'ng',(,⎕UCS 10),'   of the comment.  <example> selects'
  (howexample)[571+⍳40]←' the example in this comment and',(,⎕UCS 10),'   exec'
  (howexample)[611+⍳38]←'utes it.',(,⎕UCS 10 10),'   <X> specifies options for'
  (howexample)[649+⍳49]←' displaying trace messages during execution, and',(,⎕UCS 10)
  (howexample)[698+⍳50]←'   for returning a summary report of the results.',(,⎕UCS 10)
  (howexample)[748+⍳43]←(,⎕UCS 10),'   <example> can be used as a simple (thou'
  (howexample)[791+⍳40]←'gh not complete) test that the',(,⎕UCS 10),'   toolki'
  (howexample)[831+⍳38]←'t functions are working correctly.',(,⎕UCS 10 10),'Ar'
  (howexample)[869+⍳27]←'guments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<X>   1-'
  (howexample)[896+⍳40]←'element numeric scalar or vector',(,⎕UCS 10),'   <X> '
  (howexample)[936+⍳52]←'specifies options for trace messages and the result.'
  (howexample)[988+⍳43]←(,⎕UCS 10),'   X=1 -- display trace messages before an'
  (howexample)[1031+⍳39]←'d after executing each example.',(,⎕UCS 10),'   X=2 '
  (howexample)[1070+⍳52]←'-- return summary report <Y> showing the examples an'
  (howexample)[1122+⍳34]←'d result codes.',(,⎕UCS 10),'   X=3 -- do both',(,⎕UCS 10)
  (howexample)[1156+⍳52]←'   X=0 -- do neither.  no trace messages, and <Y> is'
  (howexample)[1208+⍳36]←' empty.',(,⎕UCS 10),'   Empty <X> defaults to 1.',(,⎕UCS 10)
  (howexample)[1244+⍳36]←(,⎕UCS 10),'<N>   Character array, rank 0 to 2',(,⎕UCS 10)
  (howexample)[1280+⍳39]←'   <N> is the namelist of functions.',(,⎕UCS 10 10),'R'
  (howexample)[1319+⍳26]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<Y>   Charac'
  (howexample)[1345+⍳39]←'ter matrix',(,⎕UCS 10),'   <Y> is the optional summa'
  (howexample)[1384+⍳46]←'ry report of the results, as specified in the',(,⎕UCS 10)
  (howexample)[1430+⍳46]←'   argument.  (See examples for description.)',(,⎕UCS 10)
  (howexample)[1476+⍳42]←(,⎕UCS 10),'   If the example statement does not exec'
  (howexample)[1518+⍳39]←'ute properly (i.e.  gives the wrong',(,⎕UCS 10),'   '
  (howexample)[1557+⍳52]←'results or <example> suspends), consult the notes wi'
  (howexample)[1609+⍳27]←'thin <example>.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howexample)[1636+⍳39]←'--------',(,⎕UCS 10),'...Execute an example with tra'
  (howexample)[1675+⍳32]←'ce messages.',(,⎕UCS 10),'      '''' example ''',(,⎕UCS 8710)
  (howexample)[1707+⍳20]←'box''',(,⎕UCS 10 8710),'box',(,⎕UCS 10),'      (3 5'
  (howexample)[1727+⍳27]←(,⎕UCS 9076),'''applebettycat  '') = ''/'' ',(,⎕UCS 8710)
  (howexample)[1754+⍳35]←'box ''apple/betty/cat''',(,⎕UCS 10),'      ... ok',(,⎕UCS 10)
  (howexample)[1789+⍳42]←(,⎕UCS 10),'...Execute examples for every function in'
  (howexample)[1831+⍳34]←' the workspace.',(,⎕UCS 10),'      '''' example ',(,⎕UCS 9109)
  (howexample)[1865+⍳24]←'nl 3',(,⎕UCS 10),'      ',(,⎕UCS 9053),'results not '
  (howexample)[1889+⍳37]←'shown',(,⎕UCS 10 10),'...Execute examples and return'
  (howexample)[1926+⍳39]←' report of examples and results.',(,⎕UCS 10),'      '
  (howexample)[1965+⍳21]←'2 example ''',(,⎕UCS 8710),'box ',(,⎕UCS 8710),'db f'
  (howexample)[1986+⍳29]←'oo mungo badexample''',(,⎕UCS 10),'1: (3 5',(,⎕UCS 9076)
  (howexample)[2015+⍳32]←'''applebettycat  '') = ''/'' ',(,⎕UCS 8710),'box ''a'
  (howexample)[2047+⍳36]←'pple/betty/cat''',(,⎕UCS 10),'1: ''apple betty cat'''
  (howexample)[2083+⍳31]←' = ',(,⎕UCS 8710),'db ''  apple  betty  cat  ''',(,⎕UCS 10)
  (howexample)[2114+⍳39]←'9: function foo        not found.',(,⎕UCS 10),'8: no'
  (howexample)[2153+⍳36]←' .e example found in mungo',(,⎕UCS 10),'0: 3=2+2',(,⎕UCS 10)

howexpandaf←2024⍴0 ⍝ prolog ≡1
  (howexpandaf)[⍳56]←'--------------------------------------------------------'
  (howexpandaf)[56+⍳33]←'----------------------',(,⎕UCS 10 114 8592),'expandaf'
  (howexpandaf)[89+⍳40]←' w',(,⎕UCS 10),'<r> is expansion vector to insert <w['
  (howexpandaf)[129+⍳30]←'i]',(,⎕UCS 9076),'0> after the i-th position',(,⎕UCS 10)
  (howexpandaf)[159+⍳52]←'----------------------------------------------------'
  (howexpandaf)[211+⍳37]←'--------------------------',(,⎕UCS 10 10),'Introduct'
  (howexpandaf)[248+⍳26]←'ion:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   This '
  (howexpandaf)[274+⍳52]←'function returns an expansion vector to insert <w[i]'
  (howexpandaf)[326+⍳39]←'> zeros after the',(,⎕UCS 10),'   i-th position of a'
  (howexpandaf)[365+⍳50]←'n array along some coordinate.  It is a companion',(,⎕UCS 10)
  (howexpandaf)[415+⍳52]←'   function to <expandbe> (expand a vector before sp'
  (howexpandaf)[467+⍳32]←'ecified positions).',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howexpandaf)[499+⍳26]←'---------',(,⎕UCS 10),'<w>   vector',(,⎕UCS 10),'   '
  (howexpandaf)[525+⍳37]←'w[i]>0  indicates to insert w',(,⎕UCS 9076),'0 after'
  (howexpandaf)[562+⍳39]←' position i',(,⎕UCS 10),'   w[i]=0  indicates not to'
  (howexpandaf)[601+⍳27]←' insert anything',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howexpandaf)[628+⍳26]←'-----',(,⎕UCS 10),'<r>   vector',(,⎕UCS 10),'   The '
  (howexpandaf)[654+⍳36]←'required expansion vector',(,⎕UCS 10 10),'Examples:'
  (howexpandaf)[690+⍳29]←(,⎕UCS 10),'--------',(,⎕UCS 10),'...Produce an expan'
  (howexpandaf)[719+⍳37]←'sion vector to insert 2',(,⎕UCS 9076),'0 after eleme'
  (howexpandaf)[756+⍳30]←'nts in even positions',(,⎕UCS 10),'      v',(,⎕UCS 8592)
  (howexpandaf)[786+⍳31]←'1 2 3 4 5 6 7',(,⎕UCS 10),'      expandaf (',(,⎕UCS 9076)
  (howexpandaf)[817+⍳22]←(,⎕UCS 118 41 9076),' 0 2',(,⎕UCS 10),'1 1 0 0 1 1 0 '
  (howexpandaf)[839+⍳39]←'0 1 1 0 0 1',(,⎕UCS 10),'...Now use this expansion v'
  (howexpandaf)[878+⍳39]←'ector to expand the vector',(,⎕UCS 10),'      (expan'
  (howexpandaf)[917+⍳18]←'daf (',(,⎕UCS 9076 118 41 9076),' 0 2)\v',(,⎕UCS 10),'1'
  (howexpandaf)[935+⍳37]←' 2 0 0 3 4 0 0 5 6 0 0 7',(,⎕UCS 10 10),'...Insert 1'
  (howexpandaf)[972+⍳27]←(,⎕UCS 9076),'0 after first element, 2',(,⎕UCS 9076),'0'
  (howexpandaf)[999+⍳39]←' after second element, etc.',(,⎕UCS 10),'      (expa'
  (howexpandaf)[1038+⍳19]←'ndaf ',(,⎕UCS 9075 9076),'v)\v',(,⎕UCS 10),'1 0 2 0'
  (howexpandaf)[1057+⍳51]←' 0 3 0 0 0 4 0 0 0 0 5 0 0 0 0 0 6 0 0 0 0 0 0 7 0 '
  (howexpandaf)[1108+⍳36]←'0 0 0 0 0 0',(,⎕UCS 10 10),'...Insert 0 after the s'
  (howexpandaf)[1144+⍳33]←'econd element',(,⎕UCS 10),'      (expandaf 2=',(,⎕UCS 9075)
  (howexpandaf)[1177+⍳22]←(,⎕UCS 9076),'v)\v',(,⎕UCS 10),'1 2 0 3 4 5 6 7',(,⎕UCS 10)
  (howexpandaf)[1199+⍳51]←'...This is simpler than the following solution with'
  (howexpandaf)[1250+⍳30]←'out <expandaf>',(,⎕UCS 10),'      (1 1 0,(',(,⎕UCS 175)
  (howexpandaf)[1280+⍳13]←(,⎕UCS 50 43 9076 118 41 9076),'1)\v',(,⎕UCS 10),'1 '
  (howexpandaf)[1293+⍳36]←'2 0 3 4 5 6 7',(,⎕UCS 10 10),'...Insert zero after '
  (howexpandaf)[1329+⍳38]←'every negative number in a vector',(,⎕UCS 10),'    '
  (howexpandaf)[1367+⍳20]←'  v',(,⎕UCS 8592),'10 20 ',(,⎕UCS 175),'3 30 40 ',(,⎕UCS 175)
  (howexpandaf)[1387+⍳24]←'101 50 ',(,⎕UCS 175),'3.3',(,⎕UCS 10),'      (expan'
  (howexpandaf)[1411+⍳17]←'daf ',(,⎕UCS 175 49 61 215),'v)\v',(,⎕UCS 10),'10 2'
  (howexpandaf)[1428+⍳23]←'0 ',(,⎕UCS 175),'3 0 30 40 ',(,⎕UCS 175),'101 0 50 '
  (howexpandaf)[1451+⍳25]←(,⎕UCS 175),'3.3 0',(,⎕UCS 10 10),'...Insert 2 blank'
  (howexpandaf)[1476+⍳41]←' columns after every column of a matrix',(,⎕UCS 10),' '
  (howexpandaf)[1517+⍳18]←'     m',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''a'
  (howexpandaf)[1535+⍳34]←'pple/betty/cat''',(,⎕UCS 10),'      (expandaf (',(,⎕UCS 175)
  (howexpandaf)[1569+⍳12]←(,⎕UCS 49 8593 9076 109 41 9076),'2)\m',(,⎕UCS 10),'a'
  (howexpandaf)[1581+⍳28]←'  p  p  l  e',(,⎕UCS 10),'b  e  t  t  y',(,⎕UCS 10),'c'
  (howexpandaf)[1609+⍳27]←'  a  t',(,⎕UCS 10 10),'Programming Notes:',(,⎕UCS 10)
  (howexpandaf)[1636+⍳38]←'-----------------',(,⎕UCS 10),'   <expandaf> is rel'
  (howexpandaf)[1674+⍳51]←'ated to its companion function <expandbe> is a simp'
  (howexpandaf)[1725+⍳38]←'le',(,⎕UCS 10),'   way.  Suppose <w> defines a set '
  (howexpandaf)[1763+⍳42]←'of positions to expand an array after the',(,⎕UCS 10)
  (howexpandaf)[1805+⍳51]←'   specified positions.  Then the required expansio'
  (howexpandaf)[1856+⍳38]←'n vector computed by',(,⎕UCS 10),'   <expandaf w> i'
  (howexpandaf)[1894+⍳31]←'s also given by <',(,⎕UCS 175 49 8595),'expandbe 0,'
  (howexpandaf)[1925+⍳30]←'w>.  For example, ...',(,⎕UCS 10),'      w',(,⎕UCS 8592)
  (howexpandaf)[1955+⍳18]←'3 0 0',(,⎕UCS 10),'      ',(,⎕UCS 175 49 8595),'exp'
  (howexpandaf)[1973+⍳25]←'andbe w,0',(,⎕UCS 10),'0 0 0 1 1 1',(,⎕UCS 10),'   '
  (howexpandaf)[1998+⍳26]←'   expandaf w',(,⎕UCS 10),'1 0 0 0 1 1',(,⎕UCS 10)

howexpandbe←1728⍴0 ⍝ prolog ≡1
  (howexpandbe)[⍳56]←'--------------------------------------------------------'
  (howexpandbe)[56+⍳33]←'----------------------',(,⎕UCS 10 114 8592),'expandbe'
  (howexpandbe)[89+⍳40]←' w',(,⎕UCS 10),'<r> is expansion vector to insert <w['
  (howexpandbe)[129+⍳31]←'i]',(,⎕UCS 9076),'0> before the i-th position',(,⎕UCS 10)
  (howexpandbe)[160+⍳52]←'----------------------------------------------------'
  (howexpandbe)[212+⍳37]←'--------------------------',(,⎕UCS 10 10),'Introduct'
  (howexpandbe)[249+⍳26]←'ion:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   This '
  (howexpandbe)[275+⍳52]←'function returns an expansion vector to insert <w[i]'
  (howexpandbe)[327+⍳39]←'> zeros before',(,⎕UCS 10),'   the i-th position of '
  (howexpandbe)[366+⍳45]←'an array along some coordinate.  This result',(,⎕UCS 10)
  (howexpandbe)[411+⍳52]←'   provides a simple and elegant solution to a surpr'
  (howexpandbe)[463+⍳39]←'ising number of problems.',(,⎕UCS 10),'   (See examp'
  (howexpandbe)[502+⍳37]←'les.)',(,⎕UCS 10 10),'   <expandbe> is a companion f'
  (howexpandbe)[539+⍳45]←'unction to <expandaf> (expand a vector after',(,⎕UCS 10)
  (howexpandbe)[584+⍳36]←'   specified positions).',(,⎕UCS 10 10),'Arguments:'
  (howexpandbe)[620+⍳24]←(,⎕UCS 10),'---------',(,⎕UCS 10),'<w>   vector',(,⎕UCS 10)
  (howexpandbe)[644+⍳37]←'   w[i]>0  indicates to insert w',(,⎕UCS 9076),'0 be'
  (howexpandbe)[681+⍳39]←'fore position i',(,⎕UCS 10),'   w[i]=0  indicates no'
  (howexpandbe)[720+⍳30]←'t to insert anything',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howexpandbe)[750+⍳26]←'------',(,⎕UCS 10),'<r>   vector',(,⎕UCS 10),'   The'
  (howexpandbe)[776+⍳37]←' required expansion vector',(,⎕UCS 10 10),'Examples:'
  (howexpandbe)[813+⍳29]←(,⎕UCS 10),'--------',(,⎕UCS 10),'...Produce an expan'
  (howexpandbe)[842+⍳37]←'sion vector to insert 2',(,⎕UCS 9076),'0 before elem'
  (howexpandbe)[879+⍳31]←'ents in even positions',(,⎕UCS 10),'      v',(,⎕UCS 8592)
  (howexpandbe)[910+⍳31]←'1 2 3 4 5 6 7',(,⎕UCS 10),'      expandbe (',(,⎕UCS 9076)
  (howexpandbe)[941+⍳22]←(,⎕UCS 118 41 9076),' 0 2',(,⎕UCS 10),'1 0 0 1 1 0 0 '
  (howexpandbe)[963+⍳39]←'1 1 0 0 1 1',(,⎕UCS 10),'...Now use this expansion v'
  (howexpandbe)[1002+⍳38]←'ector to expand the vector',(,⎕UCS 10),'      (expa'
  (howexpandbe)[1040+⍳18]←'ndbe (',(,⎕UCS 9076 118 41 9076),' 0 2)\v',(,⎕UCS 10)
  (howexpandbe)[1058+⍳36]←'1 0 0 2 3 0 0 4 5 0 0 6 7',(,⎕UCS 10 10),'...Insert'
  (howexpandbe)[1094+⍳29]←' 1',(,⎕UCS 9076),'0 before first element, 2',(,⎕UCS 9076)
  (howexpandbe)[1123+⍳38]←'0 before second element, etc.',(,⎕UCS 10),'      (e'
  (howexpandbe)[1161+⍳19]←'xpandbe ',(,⎕UCS 9075 9076),'v)\v',(,⎕UCS 10),'0 1 '
  (howexpandbe)[1180+⍳51]←'0 0 2 0 0 0 3 0 0 0 0 4 0 0 0 0 0 5 0 0 0 0 0 0 6 0'
  (howexpandbe)[1231+⍳36]←' 0 0 0 0 0 0 7',(,⎕UCS 10 10),'...Insert 0 before t'
  (howexpandbe)[1267+⍳36]←'he second element',(,⎕UCS 10),'      (expandbe 2='
  (howexpandbe)[1303+⍳22]←(,⎕UCS 9075 9076),'v)\v',(,⎕UCS 10),'1 0 2 3 4 5 6 7'
  (howexpandbe)[1325+⍳41]←(,⎕UCS 10),'...This is simpler than the following so'
  (howexpandbe)[1366+⍳38]←'lution without <expandbe>',(,⎕UCS 10),'      (1 0,('
  (howexpandbe)[1404+⍳13]←(,⎕UCS 175 49 43 9076 118 41 9076),'1)\v',(,⎕UCS 10),'1'
  (howexpandbe)[1417+⍳36]←' 0 2 3 4 5 6 7',(,⎕UCS 10 10),'...Insert zero befor'
  (howexpandbe)[1453+⍳38]←'e every negative number in a vector',(,⎕UCS 10),'  '
  (howexpandbe)[1491+⍳21]←'    v',(,⎕UCS 8592),'10 20 ',(,⎕UCS 175),'3 30 40 '
  (howexpandbe)[1512+⍳14]←(,⎕UCS 175),'101 50 ',(,⎕UCS 175),'3.3',(,⎕UCS 10),' '
  (howexpandbe)[1526+⍳24]←'     (expandbe ',(,⎕UCS 175 49 61 215),'v)\v',(,⎕UCS 10)
  (howexpandbe)[1550+⍳23]←'10 20 0 ',(,⎕UCS 175),'3 30 40 0 ',(,⎕UCS 175),'101'
  (howexpandbe)[1573+⍳22]←' 50 0 ',(,⎕UCS 175),'3.3',(,⎕UCS 10 10),'...Insert '
  (howexpandbe)[1595+⍳49]←'1 blank row before each ''breakpoint'' in a sorted '
  (howexpandbe)[1644+⍳19]←'matrix',(,⎕UCS 10),'      m',(,⎕UCS 8592),'''/'' '
  (howexpandbe)[1663+⍳24]←(,⎕UCS 8710),'box ''cat/cat/dog/dog''',(,⎕UCS 10),' '
  (howexpandbe)[1687+⍳28]←'     (expandbe bp m)',(,⎕UCS 9024 109 10 10),'cat',(,⎕UCS 10)
  (howexpandbe)[1715+⍳13]←'cat',(,⎕UCS 10 10),'dog',(,⎕UCS 10),'dog',(,⎕UCS 10)

howexplain←1717⍴0 ⍝ prolog ≡1
  (howexplain)[⍳57]←'---------------------------------------------------------'
  (howexplain)[57+⍳34]←'---------------------',(,⎕UCS 10 89 8592),'explain X',(,⎕UCS 10)
  (howexplain)[91+⍳54]←'explain functions <x>. return how documents for specif'
  (howexplain)[145+⍳40]←'ied functions',(,⎕UCS 10),'--------------------------'
  (howexplain)[185+⍳52]←'----------------------------------------------------'
  (howexplain)[237+⍳28]←(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'------------'
  (howexplain)[265+⍳43]←(,⎕UCS 10),'   <explain> returns the how document for '
  (howexplain)[308+⍳40]←'each of the specified functions in',(,⎕UCS 10),'   th'
  (howexplain)[348+⍳38]←'e namelist <X>.',(,⎕UCS 10 10),'   For most of the fu'
  (howexplain)[386+⍳53]←'nctions in the toolkit workspace, there is an associa'
  (howexplain)[439+⍳40]←'ted',(,⎕UCS 10),'   document (a character vector deli'
  (howexplain)[479+⍳41]←'mited by ''return'' characters) whose name',(,⎕UCS 10)
  (howexplain)[520+⍳51]←'   is the name of the function prefaced by ''how''.  '
  (howexplain)[571+⍳38]←'This ''how'' document',(,⎕UCS 10),'   describes the a'
  (howexplain)[609+⍳53]←'rguments, results, usage notes, examples, etc.  <expl'
  (howexplain)[662+⍳40]←'ain>',(,⎕UCS 10),'   provides a useful method for acc'
  (howexplain)[702+⍳40]←'essing these documents.  Unrecognized',(,⎕UCS 10),'  '
  (howexplain)[742+⍳51]←' functions and functions with no ''how'' document are'
  (howexplain)[793+⍳31]←' suitably handled.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howexplain)[824+⍳40]←'---------',(,⎕UCS 10),'<X>   Character vector or matr'
  (howexplain)[864+⍳29]←'ix',(,⎕UCS 10),'   Namelist of functions.',(,⎕UCS 10)
  (howexplain)[893+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howexplain)[910+⍳40]←'Y>   Character vector',(,⎕UCS 10),'   <Y> is the cate'
  (howexplain)[950+⍳51]←'nated result of all the specified ''how'' documents, '
  (howexplain)[1001+⍳39]←'each',(,⎕UCS 10),'   document separated by some blan'
  (howexplain)[1040+⍳23]←'k lines.',(,⎕UCS 10 10),'Notes:',(,⎕UCS 10),'-----',(,⎕UCS 10)
  (howexplain)[1063+⍳52]←'   It is often very convenient to put the result of '
  (howexplain)[1115+⍳39]←'<explain> on the',(,⎕UCS 10),'   implementation full'
  (howexplain)[1154+⍳48]←'-screen editor, if that is avaialble, using the',(,⎕UCS 10)
  (howexplain)[1202+⍳52]←'   appropriate utility function for that implementat'
  (howexplain)[1254+⍳24]←'ion.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------'
  (howexplain)[1278+⍳28]←(,⎕UCS 10),'...Explain the function <',(,⎕UCS 8710),'b'
  (howexplain)[1306+⍳23]←'ox>.',(,⎕UCS 10),'      explain ''',(,⎕UCS 8710),'bo'
  (howexplain)[1329+⍳23]←'x''',(,⎕UCS 10),'      ',(,⎕UCS 9053),'results not s'
  (howexplain)[1352+⍳33]←'hown',(,⎕UCS 10 10),'...Explain two functions <',(,⎕UCS 8710)
  (howexplain)[1385+⍳33]←'box> and <box1>.',(,⎕UCS 10),'      explain ''',(,⎕UCS 8710)
  (howexplain)[1418+⍳36]←'box box1''',(,⎕UCS 10 10),'...Explain all the functi'
  (howexplain)[1454+⍳37]←'ons in the category ''reshape''',(,⎕UCS 10),'      e'
  (howexplain)[1491+⍳35]←'xplain '''' funsincat ''reshape''',(,⎕UCS 10),'     '
  (howexplain)[1526+⍳24]←' ',(,⎕UCS 9053),'results not shown',(,⎕UCS 10),'...N'
  (howexplain)[1550+⍳52]←'ote: The result of <explain> can be very large if th'
  (howexplain)[1602+⍳39]←'e function namelist',(,⎕UCS 10),'...is large.  It ma'
  (howexplain)[1641+⍳52]←'y be preferable to return one variable at a time, in'
  (howexplain)[1693+⍳24]←' a',(,⎕UCS 10),'...looping function.',(,⎕UCS 10)

howfagl←1375⍴0 ⍝ prolog ≡1
  (howfagl)[⍳60]←'------------------------------------------------------------'
  (howfagl)[60+⍳29]←'------------------',(,⎕UCS 10),'Buffer',(,⎕UCS 8592),'fag'
  (howfagl)[89+⍳44]←'l X',(,⎕UCS 10),'find all global referents in function <X'
  (howfagl)[133+⍳43]←'> or functions called by <X>',(,⎕UCS 10),'--------------'
  (howfagl)[176+⍳56]←'--------------------------------------------------------'
  (howfagl)[232+⍳28]←'--------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'----'
  (howfagl)[260+⍳43]←'--------',(,⎕UCS 10),'   <fagl> finds all global referen'
  (howfagl)[303+⍳43]←'ts.  It finds all the global referents of',(,⎕UCS 10),' '
  (howfagl)[346+⍳52]←'  the function <x> and the functions called by <x>.',(,⎕UCS 10)
  (howfagl)[398+⍳44]←(,⎕UCS 10),'   For an explanation of ''global referents'''
  (howfagl)[442+⍳43]←' consult the documentation on',(,⎕UCS 10),'   <fgl> whic'
  (howfagl)[485+⍳46]←'h finds the global referents of one function.',(,⎕UCS 10)
  (howfagl)[531+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howfagl)[554+⍳43]←'x>   Character vector or scalar',(,⎕UCS 10),'   The name'
  (howfagl)[597+⍳41]←' of the function to be analyzed.',(,⎕UCS 10 10),'Result:'
  (howfagl)[638+⍳31]←(,⎕UCS 10),'------',(,⎕UCS 10),'<z>   Character matrix',(,⎕UCS 10)
  (howfagl)[669+⍳56]←'   <z> is a matrix containing in alphabetical order the '
  (howfagl)[725+⍳43]←'global referents of',(,⎕UCS 10),'   the function specifi'
  (howfagl)[768+⍳52]←'ed in <x> and all the functions called by <x>.  The',(,⎕UCS 10)
  (howfagl)[820+⍳54]←'   list includes ''semi-global'' names; that is, names t'
  (howfagl)[874+⍳43]←'hat are global to one',(,⎕UCS 10),'   of the functions b'
  (howfagl)[917+⍳45]←'ut local to one of the functions calling it.',(,⎕UCS 10)
  (howfagl)[962+⍳20]←(,⎕UCS 10),'Notes:',(,⎕UCS 10),'-----',(,⎕UCS 10),'   <fa'
  (howfagl)[982+⍳44]←'gl> calls <fgl> as many times as required.',(,⎕UCS 10 10)
  (howfagl)[1026+⍳27]←'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      '''''
  (howfagl)[1053+⍳34]←' matacross fagl ''fagl''',(,⎕UCS 10 32 9109),'av       '
  (howfagl)[1087+⍳28]←'        ',(,⎕UCS 9109),'cr               ',(,⎕UCS 9109),'e'
  (howfagl)[1115+⍳26]←'x               ',(,⎕UCS 9109 105 111 10 32 9109),'lc  '
  (howfagl)[1141+⍳40]←'             ',(,⎕UCS 9109),'nc               checksubr'
  (howfagl)[1181+⍳42]←'outine   fglr',(,⎕UCS 10),' fgl               global   '
  (howfagl)[1223+⍳42]←'         gradeup           on',(,⎕UCS 10),' signalerror'
  (howfagl)[1265+⍳27]←'       s',(,⎕UCS 8710),'checksubroutine ',(,⎕UCS 8710),'b'
  (howfagl)[1292+⍳27]←'ox              ',(,⎕UCS 8710 100 98 10 32 8710),'rowme'
  (howfagl)[1319+⍳40]←'m           Buffer',(,⎕UCS 10 10),'...See also the exam'
  (howfagl)[1359+⍳16]←'ples for <fgl>.',(,⎕UCS 10)

howfcpucon←1518⍴0 ⍝ prolog ≡1
  (howfcpucon)[⍳57]←'---------------------------------------------------------'
  (howfcpucon)[57+⍳33]←'---------------------',(,⎕UCS 10 122 8592),'fcpucon x'
  (howfcpucon)[90+⍳42]←(,⎕UCS 10),'format cpu and connect time integers <x>',(,⎕UCS 10)
  (howfcpucon)[132+⍳53]←'-----------------------------------------------------'
  (howfcpucon)[185+⍳38]←'-------------------------',(,⎕UCS 10 10),'Introductio'
  (howfcpucon)[223+⍳27]←'n:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <fcpucon'
  (howfcpucon)[250+⍳53]←'> formats cpu and connect time numbers, given the two'
  (howfcpucon)[303+⍳29]←' numbers as',(,⎕UCS 10),'   the argument.',(,⎕UCS 10)
  (howfcpucon)[332+⍳43]←(,⎕UCS 10),'   <fcpucon> is usually used to format the'
  (howfcpucon)[375+⍳40]←' result of the toolkit function',(,⎕UCS 10),'   <cpuc'
  (howfcpucon)[415+⍳53]←'on>, but may be used for the result of any function r'
  (howfcpucon)[468+⍳40]←'eturning these',(,⎕UCS 10),'   two numbers.  This is '
  (howfcpucon)[508+⍳52]←'typically useful when other timing algorithms using',(,⎕UCS 10)
  (howfcpucon)[560+⍳53]←'   non-standard APL implementation features are used.'
  (howfcpucon)[613+⍳23]←(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howfcpucon)[636+⍳40]←'<x>   2-element numeric vector',(,⎕UCS 10),'   This i'
  (howfcpucon)[676+⍳53]←'s the elapsed cpu and connect time computed in whatev'
  (howfcpucon)[729+⍳40]←'er way required.',(,⎕UCS 10),'   x[1] -- cpu time (mi'
  (howfcpucon)[769+⍳40]←'lliseconds)',(,⎕UCS 10),'   x[2] -- connect time (mil'
  (howfcpucon)[809+⍳25]←'liseconds)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-----'
  (howfcpucon)[834+⍳27]←'-',(,⎕UCS 10),'<z>   Character vector',(,⎕UCS 10),'  '
  (howfcpucon)[861+⍳44]←' The formatted version of the argument <x>.',(,⎕UCS 10)
  (howfcpucon)[905+⍳20]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howfcpucon)[925+⍳53]←'... Suppose you wish to time the following statement '
  (howfcpucon)[978+⍳40]←'in a function.',(,⎕UCS 10),'... Execute the function '
  (howfcpucon)[1018+⍳51]←'(and ignore result) once before beginning to time.',(,⎕UCS 10)
  (howfcpucon)[1069+⍳47]←'... Then execute the statement(s) to be timed.',(,⎕UCS 10)
  (howfcpucon)[1116+⍳39]←'... Then execute cpucon again.',(,⎕UCS 10),'     sin'
  (howfcpucon)[1155+⍳16]←'k',(,⎕UCS 8592),'cpucon',(,⎕UCS 10),'     a',(,⎕UCS 8592)
  (howfcpucon)[1171+⍳16]←'+/((?',(,⎕UCS 9075),'200)',(,⎕UCS 9075 63 9075),'200'
  (howfcpucon)[1187+⍳12]←')',(,⎕UCS 8712 40 63 9075),'200)',(,⎕UCS 9075 63 9075)
  (howfcpucon)[1199+⍳20]←'200',(,⎕UCS 10),'     ',(,⎕UCS 9109 8592),'fcpucon c'
  (howfcpucon)[1219+⍳39]←'pucon',(,⎕UCS 10),'cpu= 0 m   0.013 s       connect='
  (howfcpucon)[1258+⍳37]←' 0 m   0.041 s',(,⎕UCS 10 10),'... For ease of use y'
  (howfcpucon)[1295+⍳48]←'ou can use the toolkit cover function <timing>.',(,⎕UCS 10)
  (howfcpucon)[1343+⍳42]←'... This function is simply defined as: y',(,⎕UCS 8592)
  (howfcpucon)[1385+⍳26]←'fcpucon cpucon',(,⎕UCS 10),'     sink',(,⎕UCS 8592),'t'
  (howfcpucon)[1411+⍳19]←'iming',(,⎕UCS 10),'     a',(,⎕UCS 8592),'+/((?',(,⎕UCS 9075)
  (howfcpucon)[1430+⍳14]←'200)',(,⎕UCS 9075 63 9075),'200)',(,⎕UCS 8712 40 63)
  (howfcpucon)[1444+⍳12]←(,⎕UCS 9075),'200)',(,⎕UCS 9075 63 9075),'200',(,⎕UCS 10)
  (howfcpucon)[1456+⍳20]←'     ',(,⎕UCS 9109 8592),'timing',(,⎕UCS 10),'cpu= 0'
  (howfcpucon)[1476+⍳42]←' m   0.013 s       connect= 0 m   0.041 s',(,⎕UCS 10)

howfdate←1806⍴0 ⍝ prolog ≡1
  (howfdate)[⍳59]←'-----------------------------------------------------------'
  (howfdate)[59+⍳33]←'-------------------',(,⎕UCS 10 121 8592),'lc fdate t',(,⎕UCS 10)
  (howfdate)[92+⍳56]←'format dates <t> = (mm dd yyyy) as <y> = (monthname dd, '
  (howfdate)[148+⍳42]←'yyyy)',(,⎕UCS 10),'------------------------------------'
  (howfdate)[190+⍳44]←'------------------------------------------',(,⎕UCS 10 10)
  (howfdate)[234+⍳29]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'  '
  (howfdate)[263+⍳55]←' <fdate> formats dates.  Given a numeric argument of da'
  (howfdate)[318+⍳42]←'tes <t> in the form',(,⎕UCS 10),'   (mm dd yyyy), i.e. '
  (howfdate)[360+⍳53]←' month day year, <fdate> returns a character matrix,',(,⎕UCS 10)
  (howfdate)[413+⍳55]←'   each row in format (monthname dd, yyyy).  The langua'
  (howfdate)[468+⍳37]←'ge of the month can',(,⎕UCS 10),'   be specified.',(,⎕UCS 10)
  (howfdate)[505+⍳44]←(,⎕UCS 10),'   Note that (mm dd yyyy) is the general ''i'
  (howfdate)[549+⍳41]←'nterchange'' format used throughout',(,⎕UCS 10),'   for'
  (howfdate)[590+⍳33]←' the date functions.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howfdate)[623+⍳42]←'---------',(,⎕UCS 10),'<lc>  Character scalar or 1-elem'
  (howfdate)[665+⍳42]←'ent vector',(,⎕UCS 10),'   The language code specifying'
  (howfdate)[707+⍳42]←' the language of the month name.',(,⎕UCS 10),'      lc='
  (howfdate)[749+⍳37]←'''e'' -- English',(,⎕UCS 10),'      lc=''f'' -- French'
  (howfdate)[786+⍳33]←(,⎕UCS 10 10),'<t>   Numeric vector or matrix',(,⎕UCS 10)
  (howfdate)[819+⍳55]←'   <t> specifies dates as a 3-column matrix, one row pe'
  (howfdate)[874+⍳42]←'r date.  If <t> is a',(,⎕UCS 10),'   3-element vector, '
  (howfdate)[916+⍳43]←'it is treated as a 1-row 3-column matrix.',(,⎕UCS 10),' '
  (howfdate)[959+⍳42]←'     t[;1] -- month (1 to 12)',(,⎕UCS 10),'      t[;2] '
  (howfdate)[1001+⍳41]←'-- day (1 to 31)',(,⎕UCS 10),'      t[;3] -- year (int'
  (howfdate)[1042+⍳22]←'eger)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howfdate)[1064+⍳41]←'<y>   Character matrix',(,⎕UCS 10),'   The matrix <y> '
  (howfdate)[1105+⍳54]←'is a left-justified matrix of dates.  y[i;] is the i-t'
  (howfdate)[1159+⍳41]←'h row',(,⎕UCS 10),'   of <t> formatted as (monthname d'
  (howfdate)[1200+⍳34]←'ay, year).  The length of <y> (',(,⎕UCS 175 49 8593)
  (howfdate)[1234+⍳35]←(,⎕UCS 9076 121 41 10),'   depends on the value of the '
  (howfdate)[1269+⍳42]←'dates being formatted.  (See examples).',(,⎕UCS 10 10),'E'
  (howfdate)[1311+⍳28]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'..... <fda'
  (howfdate)[1339+⍳54]←'te> formats a date given in numeric (month day year) f'
  (howfdate)[1393+⍳25]←'ormat.',(,⎕UCS 10),'      ''e'' fdate ',(,⎕UCS 9109),'t'
  (howfdate)[1418+⍳28]←'s[2 3 1]',(,⎕UCS 10),'april 14, 1992',(,⎕UCS 10),'    '
  (howfdate)[1446+⍳24]←'  ''f'' fdate ',(,⎕UCS 9109),'ts[2 3 1]',(,⎕UCS 10),'a'
  (howfdate)[1470+⍳25]←'vril 14, 1992',(,⎕UCS 10 10),'      dd',(,⎕UCS 8592),'4'
  (howfdate)[1495+⍳39]←' 3',(,⎕UCS 9076),'5 13 1988 12 8 1984 1 1 1991 7 5 154'
  (howfdate)[1534+⍳17]←'3',(,⎕UCS 10),'      (',(,⎕UCS 9045),'dd),((',(,⎕UCS 9076)
  (howfdate)[1551+⍳27]←'dd)',(,⎕UCS 9076),'''-''),(''e'' fdate dd),((',(,⎕UCS 9076)
  (howfdate)[1578+⍳23]←'dd)',(,⎕UCS 9076),'''-''),''f'' fdate dd',(,⎕UCS 10),' '
  (howfdate)[1601+⍳48]←'  5   13 1988---may 13, 1988    ---mai 13, 1988',(,⎕UCS 10)
  (howfdate)[1649+⍳53]←'  12    8 1984---december 8, 1984---decembre 8, 1984',(,⎕UCS 10)
  (howfdate)[1702+⍳52]←'   1    1 1991---january 1, 1991 ---janvier 1, 1991',(,⎕UCS 10)
  (howfdate)[1754+⍳52]←'   7    5 1543---july 5, 1543    ---juillet 5, 1543',(,⎕UCS 10)

howfdmy←1286⍴0 ⍝ prolog ≡1
  (howfdmy)[⍳60]←'------------------------------------------------------------'
  (howfdmy)[60+⍳28]←'------------------',(,⎕UCS 10 121 8592),'fdmy t',(,⎕UCS 10)
  (howfdmy)[88+⍳53]←'format dates <t> = (mm dd yyyy) as <y> = (dd mon yy)',(,⎕UCS 10)
  (howfdmy)[141+⍳56]←'--------------------------------------------------------'
  (howfdmy)[197+⍳38]←'----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howfdmy)[235+⍳43]←'------------',(,⎕UCS 10),'   <fdmy> formats dates.  Give'
  (howfdmy)[278+⍳46]←'n the numeric argument <t> in the form (mm dd',(,⎕UCS 10)
  (howfdmy)[324+⍳56]←'   yyyy), i.e.  month day year, <fdmy> returns the date '
  (howfdmy)[380+⍳43]←'formatted as the',(,⎕UCS 10),'   character vector (dd mo'
  (howfdmy)[423+⍳43]←'n yyyy) where ''mon'' represents a 3-letter',(,⎕UCS 10),' '
  (howfdmy)[466+⍳56]←'  abbreviation for the month.  <t> can also be a matrix '
  (howfdmy)[522+⍳28]←'of dates.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'------'
  (howfdmy)[550+⍳35]←'---',(,⎕UCS 10),'<t>   Numeric vector or matrix',(,⎕UCS 10)
  (howfdmy)[585+⍳56]←'   <t> specifies the date as a 3-column matrix.  If <t> '
  (howfdmy)[641+⍳43]←'is a vector, it is',(,⎕UCS 10),'   treated as a 1-row ma'
  (howfdmy)[684+⍳37]←'trix.',(,⎕UCS 10),'      t[;1] -- month (1 to 12)',(,⎕UCS 10)
  (howfdmy)[721+⍳43]←'      t[;2] -- day (1 to 31)',(,⎕UCS 10),'      t[;3] --'
  (howfdmy)[764+⍳28]←' year (integer)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'---'
  (howfdmy)[792+⍳30]←'---',(,⎕UCS 10),'<y>   Character matrix',(,⎕UCS 10),'   '
  (howfdmy)[822+⍳56]←'The matrix <y> is a matrix of dates.  y[i;] is the i-th '
  (howfdmy)[878+⍳43]←'row of <t>',(,⎕UCS 10),'   formatted as (dd mon yy).  Th'
  (howfdmy)[921+⍳32]←'e length of <y> (',(,⎕UCS 175 49 8593 9076),'y) is 9=2+1'
  (howfdmy)[953+⍳29]←'+3+1+2.',(,⎕UCS 10),'   (See examples).',(,⎕UCS 10 10),'E'
  (howfdmy)[982+⍳30]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'..... <fdmy>'
  (howfdmy)[1012+⍳55]←' formats a date given in numeric month day year format.'
  (howfdmy)[1067+⍳23]←(,⎕UCS 10),'      fdmy ',(,⎕UCS 9109),'ts[2 3 1]',(,⎕UCS 10)
  (howfdmy)[1090+⍳20]←'14 apr 92',(,⎕UCS 10 10),'      ',(,⎕UCS 9109 8592 100)
  (howfdmy)[1110+⍳25]←(,⎕UCS 100 8592),'4 3',(,⎕UCS 9076),'5 13 1988 12 8 1984'
  (howfdmy)[1135+⍳35]←' 1 1 1991 12 5 1543',(,⎕UCS 10),'   5   13 1988',(,⎕UCS 10)
  (howfdmy)[1170+⍳31]←'  12    8 1984',(,⎕UCS 10),'   1    1 1991',(,⎕UCS 10),' '
  (howfdmy)[1201+⍳23]←' 12    5 1543',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 120)
  (howfdmy)[1224+⍳20]←(,⎕UCS 8592),'fdmy dd',(,⎕UCS 10),'13 may 88',(,⎕UCS 10),' '
  (howfdmy)[1244+⍳28]←'8 dec 84',(,⎕UCS 10),' 1 jan 91',(,⎕UCS 10),' 5 dec 43'
  (howfdmy)[1272+⍳14]←(,⎕UCS 10),'      ',(,⎕UCS 9076 120 10),'4 9',(,⎕UCS 10)

howfgl←2035⍴0 ⍝ prolog ≡1
  (howfgl)[⍳61]←'-------------------------------------------------------------'
  (howfgl)[61+⍳27]←'-----------------',(,⎕UCS 10 90 8592),'fgl X',(,⎕UCS 10),'f'
  (howfgl)[88+⍳45]←'ind global referents of function <X>',(,⎕UCS 10),'--------'
  (howfgl)[133+⍳57]←'---------------------------------------------------------'
  (howfgl)[190+⍳30]←'-------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-'
  (howfgl)[220+⍳44]←'-----------',(,⎕UCS 10),'   <fgl> is used by the programm'
  (howfgl)[264+⍳44]←'er to find the global referents of a',(,⎕UCS 10),'   spec'
  (howfgl)[308+⍳42]←'ified function <x>.',(,⎕UCS 10 10),'   A referent of a fu'
  (howfgl)[350+⍳56]←'nction is an identifier used in the text of a function,',(,⎕UCS 10)
  (howfgl)[406+⍳57]←'   but not in a comment or character constant.  A referen'
  (howfgl)[463+⍳44]←'t is global if it',(,⎕UCS 10),'   is not localized in the'
  (howfgl)[507+⍳47]←' header or a line label.  Global referents are',(,⎕UCS 10)
  (howfgl)[554+⍳57]←'   frequently a source of problems in debugging or in und'
  (howfgl)[611+⍳44]←'erstanding',(,⎕UCS 10),'   unfamiliar functions.  (Sugges'
  (howfgl)[655+⍳44]←'tion: Since a global referent could be',(,⎕UCS 10),'   ca'
  (howfgl)[699+⍳57]←'used by a mispelled variable, use <fgl> to quickly identi'
  (howfgl)[756+⍳29]←'fy',(,⎕UCS 10),'   mispellings.)',(,⎕UCS 10 10),'Argument'
  (howfgl)[785+⍳31]←'s:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<x>   Character ve'
  (howfgl)[816+⍳44]←'ctor or scalar',(,⎕UCS 10),'   The name of the function t'
  (howfgl)[860+⍳29]←'o be analyzed.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-----'
  (howfgl)[889+⍳31]←'-',(,⎕UCS 10),'<z>   Character matrix',(,⎕UCS 10),'   <z>'
  (howfgl)[920+⍳57]←' is a matrix whose rows contain in alphabetical order the'
  (howfgl)[977+⍳44]←' global',(,⎕UCS 10),'   referents of the function specifi'
  (howfgl)[1021+⍳43]←'ed in <x>.  The list will include the',(,⎕UCS 10),'   na'
  (howfgl)[1064+⍳56]←'mes of any system functions and variables (i.e.  those n'
  (howfgl)[1120+⍳26]←'ames starting',(,⎕UCS 10),'   with ''',(,⎕UCS 9109),''')'
  (howfgl)[1146+⍳49]←' unless these have been localized in the header.',(,⎕UCS 10)
  (howfgl)[1195+⍳20]←(,⎕UCS 10),'Notes:',(,⎕UCS 10),'-----',(,⎕UCS 10),'   <fg'
  (howfgl)[1215+⍳54]←'l> is the ''driver'' function for the function <global>.'
  (howfgl)[1269+⍳43]←'  It checks the',(,⎕UCS 10),'   argument(s), and applies'
  (howfgl)[1312+⍳49]←' the <global> to the canonical representation of',(,⎕UCS 10)
  (howfgl)[1361+⍳56]←'   the specified function.  <fgl> has underscored variab'
  (howfgl)[1417+⍳41]←'le names to avoid',(,⎕UCS 10),'   ''shadowing'' function'
  (howfgl)[1458+⍳48]←' names within the workspace.  Since <global> is',(,⎕UCS 10)
  (howfgl)[1506+⍳56]←'   passed the required text as a canonical representatio'
  (howfgl)[1562+⍳43]←'n, it does not have',(,⎕UCS 10),'   to be written to dea'
  (howfgl)[1605+⍳39]←'l with the ''shadowing'' situation.',(,⎕UCS 10 10),'   S'
  (howfgl)[1644+⍳41]←'ee also the description of <global>.',(,⎕UCS 10 10),'Exa'
  (howfgl)[1685+⍳29]←'mples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      fgl ''fg'
  (howfgl)[1714+⍳20]←'l''',(,⎕UCS 10 9109 99 114 10 9109 110 99 10),'checksubr'
  (howfgl)[1734+⍳26]←'outine',(,⎕UCS 10),'global',(,⎕UCS 10),'signalerror',(,⎕UCS 10)
  (howfgl)[1760+⍳46]←(,⎕UCS 10),'...The global referents of the toolkit functi'
  (howfgl)[1806+⍳42]←'on <contents> displayed in a',(,⎕UCS 10),'...''compresse'
  (howfgl)[1848+⍳39]←'d'' format.',(,⎕UCS 10),'      '''' matacross fgl ''cont'
  (howfgl)[1887+⍳24]←'ents''',(,⎕UCS 10 32 9109),'av             ',(,⎕UCS 9109)
  (howfgl)[1911+⍳54]←'nc             bp              checksubroutine gettag',(,⎕UCS 10)
  (howfgl)[1965+⍳41]←' gradeup         on              ',(,⎕UCS 8710),'box    '
  (howfgl)[2006+⍳26]←'        ',(,⎕UCS 8710),'db             ',(,⎕UCS 8710),'d'
  (howfgl)[2032+⍳3]←'tb',(,⎕UCS 10)

howfi←1640⍴0 ⍝ prolog ≡1
  (howfi)[⍳62]←'--------------------------------------------------------------'
  (howfi)[62+⍳26]←'----------------',(,⎕UCS 10 114 8592),'fi a',(,⎕UCS 10),'fi'
  (howfi)[88+⍳48]←'x (translate) text input <a> to numeric vector',(,⎕UCS 10),'-'
  (howfi)[136+⍳58]←'----------------------------------------------------------'
  (howfi)[194+⍳35]←'-------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howfi)[229+⍳45]←'------------',(,⎕UCS 10),'   <fi> converts a character vec'
  (howfi)[274+⍳45]←'tor representing a set of numbers into the',(,⎕UCS 10),'  '
  (howfi)[319+⍳56]←' corresponding numeric vector.  This is known as ''fixing'
  (howfi)[375+⍳42]←''' input, similar',(,⎕UCS 10),'   to ''fixing'' a function'
  (howfi)[417+⍳43]←' with ',(,⎕UCS 9109),'fx.  (Note that <fi> is found in som'
  (howfi)[460+⍳45]←'e APL',(,⎕UCS 10),'   implementations as the useful but no'
  (howfi)[505+⍳33]←'n-standard system function ',(,⎕UCS 9109),'fi.)',(,⎕UCS 10)
  (howfi)[538+⍳48]←(,⎕UCS 10),'   Refer also to the complementary toolkit func'
  (howfi)[586+⍳45]←'tion <vi> to validate numeric',(,⎕UCS 10),'   input before'
  (howfi)[631+⍳30]←' converting.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-----'
  (howfi)[661+⍳32]←'----',(,⎕UCS 10),'<a>   Character vector',(,⎕UCS 10),'   <'
  (howfi)[693+⍳58]←'a> represents one or more numeric constants in standard AP'
  (howfi)[751+⍳45]←'L syntax,',(,⎕UCS 10),'   including numbers in exponential'
  (howfi)[796+⍳45]←' notation.  Leading, trailing, and',(,⎕UCS 10),'   multipl'
  (howfi)[841+⍳42]←'e intervening blanks are allowed.',(,⎕UCS 10 10),'Result:'
  (howfi)[883+⍳29]←(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   Numeric vector',(,⎕UCS 10)
  (howfi)[912+⍳58]←'   r[i] = number if the i-th non-blank field represents a '
  (howfi)[970+⍳45]←'valid number.',(,⎕UCS 10),'   r[i] = 0      if the i-th no'
  (howfi)[1015+⍳42]←'n-blank field is an invalid number.',(,⎕UCS 10 10),'   <r'
  (howfi)[1057+⍳42]←'> is empty if <a> is empty or blank.',(,⎕UCS 10 10),'Sour'
  (howfi)[1099+⍳31]←'ce:',(,⎕UCS 10),'------',(,⎕UCS 10),'   Correction to Alg'
  (howfi)[1130+⍳55]←'orithm 146 -- Conversion of Numeric Output, by Jeffrey',(,⎕UCS 10)
  (howfi)[1185+⍳57]←'   Multach.  (APL Quote Quad, Volume 11, No.  2, December'
  (howfi)[1242+⍳28]←' 1980).',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howfi)[1270+⍳42]←'      fi ''1.10  10009  .45  5.6e',(,⎕UCS 175),'5  5.6e7 '
  (howfi)[1312+⍳37]←' ',(,⎕UCS 175 55 39 10),'1.1 10009 0.45 0.000056 56000000'
  (howfi)[1349+⍳21]←' ',(,⎕UCS 175 55 10 10),'      x',(,⎕UCS 8592),'''1 2 a.3'
  (howfi)[1370+⍳31]←'  0  4.6.6  14  0''',(,⎕UCS 10),'      fi x',(,⎕UCS 10),'1'
  (howfi)[1401+⍳44]←' 2 0 0 0 14 0',(,⎕UCS 10),'... <vi> distinguishes between'
  (howfi)[1445+⍳43]←' a real 0 and an invalid number.',(,⎕UCS 10),'      vi x'
  (howfi)[1488+⍳32]←(,⎕UCS 10),'1 1 0 1 0 1 1',(,⎕UCS 10 10),'... The argument'
  (howfi)[1520+⍳44]←' consists of numeric constants only.',(,⎕UCS 10),'      f'
  (howfi)[1564+⍳25]←'i ''',(,⎕UCS 175),'7 -7  5  2+3''',(,⎕UCS 10 175),'7 0 5 '
  (howfi)[1589+⍳25]←'0',(,⎕UCS 10 10),'      3',(,⎕UCS 215),'fi''10 20 4.3 ',(,⎕UCS 175)
  (howfi)[1614+⍳26]←'45 a.3''',(,⎕UCS 10),'30 60 12.9 ',(,⎕UCS 175),'135 0',(,⎕UCS 10)

howfibspiral←1156⍴0 ⍝ prolog ≡1
  (howfibspiral)[⍳55]←'-------------------------------------------------------'
  (howfibspiral)[55+⍳32]←'-----------------------',(,⎕UCS 10 109 8592),'a fibs'
  (howfibspiral)[87+⍳39]←'piral b',(,⎕UCS 10),'fibonacci spiral. choose neighb'
  (howfibspiral)[126+⍳43]←'ouring pairs <a>,<b> from fibonacci series',(,⎕UCS 10)
  (howfibspiral)[169+⍳51]←'---------------------------------------------------'
  (howfibspiral)[220+⍳36]←'---------------------------',(,⎕UCS 10 10),'Introdu'
  (howfibspiral)[256+⍳25]←'ction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   Th'
  (howfibspiral)[281+⍳51]←'is is an interesting recursive function that comput'
  (howfibspiral)[332+⍳38]←'es a spiral graphic.',(,⎕UCS 10),'   The function u'
  (howfibspiral)[370+⍳50]←'ses neighbouring pairs of the Fibonacci series, an'
  (howfibspiral)[420+⍳41]←(,⎕UCS 10),'   infinite series whose first few eleme'
  (howfibspiral)[461+⍳38]←'nts are: 1 1 2 3 5 8 13 21 34 55 89',(,⎕UCS 10),'  '
  (howfibspiral)[499+⍳23]←' 144 ...',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'--'
  (howfibspiral)[522+⍳29]←'-------',(,⎕UCS 10),'<a>   Numeric scalar',(,⎕UCS 10)
  (howfibspiral)[551+⍳39]←'   A member of the Fibonacci series.',(,⎕UCS 10 10),'<'
  (howfibspiral)[590+⍳38]←'b>   Numeric scalar',(,⎕UCS 10),'   The number imme'
  (howfibspiral)[628+⍳47]←'diately following <a> in the Fibonacci series.',(,⎕UCS 10)
  (howfibspiral)[675+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howfibspiral)[692+⍳38]←'m>   Character matrix',(,⎕UCS 10),'   The matrix wh'
  (howfibspiral)[730+⍳51]←'en printed or displayed is the representation of a '
  (howfibspiral)[781+⍳38]←'spiral and',(,⎕UCS 10),'   the lengths of the arms '
  (howfibspiral)[819+⍳40]←'are based on the Fibonacci sequence.  (',(,⎕UCS 9076)
  (howfibspiral)[859+⍳23]←'m) = (a,b)',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-'
  (howfibspiral)[882+⍳28]←'-------',(,⎕UCS 10),'      3 fibspiral 5',(,⎕UCS 10)
  (howfibspiral)[910+⍳11]←(,⎕UCS 32 9675 9675 10 9675 32 32 9675 10 9675 9675)
  (howfibspiral)[921+⍳27]←(,⎕UCS 32 32 9675 10 10),'      13 fibspiral 21',(,⎕UCS 10)
  (howfibspiral)[948+⍳17]←'       ',(,⎕UCS 9675 9675 10),'      ',(,⎕UCS 9675)
  (howfibspiral)[965+⍳15]←(,⎕UCS 32 32 9675 10),'     ',(,⎕UCS 9675),'    ',(,⎕UCS 9675)
  (howfibspiral)[980+⍳13]←(,⎕UCS 10),'    ',(,⎕UCS 9675),'      ',(,⎕UCS 9675)
  (howfibspiral)[993+⍳14]←(,⎕UCS 10),'   ',(,⎕UCS 9675),'        ',(,⎕UCS 9675)
  (howfibspiral)[1007+⍳17]←(,⎕UCS 10 32 32 9675),'          ',(,⎕UCS 9675 10 32)
  (howfibspiral)[1024+⍳17]←(,⎕UCS 9675),'            ',(,⎕UCS 9675 10 9675),' '
  (howfibspiral)[1041+⍳21]←'             ',(,⎕UCS 9675 10 9675),'    ',(,⎕UCS 9675)
  (howfibspiral)[1062+⍳15]←(,⎕UCS 9675),'         ',(,⎕UCS 9675 10 32 9675),' '
  (howfibspiral)[1077+⍳16]←'  ',(,⎕UCS 9675 32 9675),'         ',(,⎕UCS 9675 10)
  (howfibspiral)[1093+⍳18]←(,⎕UCS 32 32 9675),'    ',(,⎕UCS 9675),'          '
  (howfibspiral)[1111+⍳13]←(,⎕UCS 9675 10),'   ',(,⎕UCS 9675 32 32 9675),'    '
  (howfibspiral)[1124+⍳17]←'        ',(,⎕UCS 9675 10),'    ',(,⎕UCS 9675 9675),' '
  (howfibspiral)[1141+⍳15]←'             ',(,⎕UCS 9675 10)

howfindcoords←1138⍴0 ⍝ prolog ≡1
  (howfindcoords)[⍳54]←'------------------------------------------------------'
  (howfindcoords)[54+⍳31]←'------------------------',(,⎕UCS 10 122 8592),'m fi'
  (howfindcoords)[85+⍳38]←'ndcoords s',(,⎕UCS 10),'find coordinates of sequenc'
  (howfindcoords)[123+⍳37]←'e <s> in matrix <m>',(,⎕UCS 10),'-----------------'
  (howfindcoords)[160+⍳50]←'--------------------------------------------------'
  (howfindcoords)[210+⍳27]←'-----------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howfindcoords)[237+⍳37]←'------------',(,⎕UCS 10),'   <findcoords> finds th'
  (howfindcoords)[274+⍳49]←'e coordinates of a sequence within the rows of a',(,⎕UCS 10)
  (howfindcoords)[323+⍳24]←'   matrix.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howfindcoords)[347+⍳37]←'--------',(,⎕UCS 10),'<m>   Character or numeric m'
  (howfindcoords)[384+⍳35]←'atrix',(,⎕UCS 10),'   The array to be searched.',(,⎕UCS 10)
  (howfindcoords)[419+⍳40]←(,⎕UCS 10),'<s>   Character or numeric vector or sc'
  (howfindcoords)[459+⍳37]←'alar',(,⎕UCS 10),'   The sequence to be searched f'
  (howfindcoords)[496+⍳35]←'or.',(,⎕UCS 10 10),'<m> and <s> must be both chara'
  (howfindcoords)[531+⍳26]←'cter or numeric.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howfindcoords)[557+⍳31]←'------',(,⎕UCS 10),'<z>   Numeric matrix (n',(,⎕UCS 215)
  (howfindcoords)[588+⍳36]←(,⎕UCS 50 41 10),'   Each row represents the coordi'
  (howfindcoords)[624+⍳44]←'nates of the beginning of one occurrence of',(,⎕UCS 10)
  (howfindcoords)[668+⍳50]←'   <s> in <m>.  Overlapping occurrences are counte'
  (howfindcoords)[718+⍳19]←'d.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howfindcoords)[737+⍳33]←'   Examples workspace',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howfindcoords)[770+⍳18]←'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 109)
  (howfindcoords)[788+⍳20]←(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''apple/bet'
  (howfindcoords)[808+⍳32]←'ty/type/apple/betty/type''',(,⎕UCS 10),'apple',(,⎕UCS 10)
  (howfindcoords)[840+⍳17]←'betty',(,⎕UCS 10),'type',(,⎕UCS 10),'apple',(,⎕UCS 10)
  (howfindcoords)[857+⍳24]←'betty',(,⎕UCS 10),'type',(,⎕UCS 10),'      m findc'
  (howfindcoords)[881+⍳18]←'oords ''p''',(,⎕UCS 10),'1 2',(,⎕UCS 10),'1 3',(,⎕UCS 10)
  (howfindcoords)[899+⍳13]←'3 3',(,⎕UCS 10),'4 2',(,⎕UCS 10),'4 3',(,⎕UCS 10),'6'
  (howfindcoords)[912+⍳27]←' 3',(,⎕UCS 10),'      m findcoords ''ty''',(,⎕UCS 10)
  (howfindcoords)[939+⍳13]←'2 4',(,⎕UCS 10),'3 1',(,⎕UCS 10),'5 4',(,⎕UCS 10),'6'
  (howfindcoords)[952+⍳14]←' 1',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 109 8592),'9'
  (howfindcoords)[966+⍳35]←'9 ',(,⎕UCS 8710),'box 1 1 2 3 99 4 1 1 1 99 1 1 2 '
  (howfindcoords)[1001+⍳18]←'3',(,⎕UCS 10),'1 1 2 3',(,⎕UCS 10),'4 1 1 1',(,⎕UCS 10)
  (howfindcoords)[1019+⍳36]←'1 1 2 3',(,⎕UCS 10),'... Note that overlapping oc'
  (howfindcoords)[1055+⍳44]←'currences of 1 1 are counted.  (See row 2).',(,⎕UCS 10)
  (howfindcoords)[1099+⍳27]←'      m findcoords 1 1',(,⎕UCS 10),'1 1',(,⎕UCS 10)
  (howfindcoords)[1126+⍳12]←'2 2',(,⎕UCS 10),'2 3',(,⎕UCS 10),'3 1',(,⎕UCS 10)

howfindut←1713⍴0 ⍝ prolog ≡1
  (howfindut)[⍳58]←'----------------------------------------------------------'
  (howfindut)[58+⍳34]←'--------------------',(,⎕UCS 10 121 8592),'a findut b',(,⎕UCS 10)
  (howfindut)[92+⍳53]←'find position of unique truncation <b> in vector <a>',(,⎕UCS 10)
  (howfindut)[145+⍳54]←'------------------------------------------------------'
  (howfindut)[199+⍳39]←'------------------------',(,⎕UCS 10 10),'Introduction:'
  (howfindut)[238+⍳31]←(,⎕UCS 10),'------------',(,⎕UCS 10),'   Given a list <'
  (howfindut)[269+⍳54]←'a> of words and a unique truncation <b>, <findut> comp'
  (howfindut)[323+⍳41]←'utes',(,⎕UCS 10),'   the ordinal position of the word '
  (howfindut)[364+⍳38]←'determined by <b>.',(,⎕UCS 10 10),'   A ''unique trunc'
  (howfindut)[402+⍳51]←'ation'' is a truncated (''shortened'') version of any '
  (howfindut)[453+⍳41]←'word',(,⎕UCS 10),'   that uniquely distinguishes it fr'
  (howfindut)[494+⍳41]←'om the other members of a list.  For',(,⎕UCS 10),'   e'
  (howfindut)[535+⍳54]←'xample, in the list (add append clear change delete en'
  (howfindut)[589+⍳39]←'d enter insert),',(,⎕UCS 10),'   the truncation ''a'' '
  (howfindut)[628+⍳52]←'is not unique because it cannot distinguish between',(,⎕UCS 10)
  (howfindut)[680+⍳48]←'   ''add'' and ''append''.  However, ''ap'' uniquely d'
  (howfindut)[728+⍳35]←'istinguishes ''append''.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howfindut)[763+⍳33]←'---------',(,⎕UCS 10),'<a>   Character vector',(,⎕UCS 10)
  (howfindut)[796+⍳54]←'   This is the list of words to be searched.  All word'
  (howfindut)[850+⍳41]←'s must be preceeded by',(,⎕UCS 10),'   one blank, incl'
  (howfindut)[891+⍳52]←'uding the first word.  Thus, =/'' ''=a gives the numbe'
  (howfindut)[943+⍳29]←'r of',(,⎕UCS 10),'   words in the list.',(,⎕UCS 10 10),'<'
  (howfindut)[972+⍳41]←'b>  Character vector or scalar',(,⎕UCS 10),'   This is'
  (howfindut)[1013+⍳45]←' the truncation and must not contain blanks.',(,⎕UCS 10)
  (howfindut)[1058+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howfindut)[1075+⍳27]←'y>   Numeric scalar',(,⎕UCS 10),'   y=',(,⎕UCS 175),'1'
  (howfindut)[1102+⍳48]←'   <b> is found but is not a unique truncation.',(,⎕UCS 10)
  (howfindut)[1150+⍳53]←'   y =0   <b> is not found. (In particular, if b is e'
  (howfindut)[1203+⍳40]←'mpty, y is 0.)',(,⎕UCS 10),'   y >0   <y> is the inde'
  (howfindut)[1243+⍳27]←'x of <b> in <a>.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'-'
  (howfindut)[1270+⍳40]←'-----',(,⎕UCS 10),'   APL Quote Quad (about 1974), by'
  (howfindut)[1310+⍳26]←' J. P. Benyi.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-'
  (howfindut)[1336+⍳24]←'-------',(,⎕UCS 10),'      words',(,⎕UCS 8592),''' ad'
  (howfindut)[1360+⍳47]←'d append clear change delete end enter insert''',(,⎕UCS 10)
  (howfindut)[1407+⍳32]←'      +/words='' ''',(,⎕UCS 10 56 10 10),'... result '
  (howfindut)[1439+⍳26]←'is ',(,⎕UCS 175),'1 (not unique)',(,⎕UCS 10),'      w'
  (howfindut)[1465+⍳29]←'ords findut ''a''',(,⎕UCS 10 175 49 10 10),'... resul'
  (howfindut)[1494+⍳39]←'t is 0 (not found)',(,⎕UCS 10),'      words findut '''
  (howfindut)[1533+⍳33]←'g''',(,⎕UCS 10 48 10 10),'...result > 0 (index of wor'
  (howfindut)[1566+⍳40]←'d determined by argument)',(,⎕UCS 10),'      words fi'
  (howfindut)[1606+⍳33]←'ndut ''ap''',(,⎕UCS 10 50 10),'      words findut ''c'
  (howfindut)[1639+⍳31]←'le''',(,⎕UCS 10 51 10),'      words findut ''ent''',(,⎕UCS 10)
  (howfindut)[1670+⍳26]←(,⎕UCS 55 10 10),'...empty vector',(,⎕UCS 10),'      w'
  (howfindut)[1696+⍳17]←'ords findut ''''',(,⎕UCS 10 48 10)

howfirst←1542⍴0 ⍝ prolog ≡1
  (howfirst)[⍳59]←'-----------------------------------------------------------'
  (howfirst)[59+⍳30]←'-------------------',(,⎕UCS 10 121 8592),'first x',(,⎕UCS 10)
  (howfirst)[89+⍳56]←'first occurrence of elements in scalar, vector or matrix'
  (howfirst)[145+⍳42]←' <x>',(,⎕UCS 10),'-------------------------------------'
  (howfirst)[187+⍳43]←'-----------------------------------------',(,⎕UCS 10 10)
  (howfirst)[230+⍳29]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'  '
  (howfirst)[259+⍳55]←' <first> returns the boolean vector <y> that selects th'
  (howfirst)[314+⍳42]←'e first occurrence',(,⎕UCS 10),'   of each element in a'
  (howfirst)[356+⍳53]←' vector or matrix.  (An element refers to x[i] for a',(,⎕UCS 10)
  (howfirst)[409+⍳55]←'   vector, and x[i;] for a matrix.) This result has man'
  (howfirst)[464+⍳29]←'y applications, such',(,⎕UCS 10),'   as:',(,⎕UCS 10),' '
  (howfirst)[493+⍳40]←'        ',(,⎕UCS 8902),'  The unique elements of a vect'
  (howfirst)[533+⍳27]←'or or matrix',(,⎕UCS 10),'         ',(,⎕UCS 8902),'  Th'
  (howfirst)[560+⍳42]←'e first or only appearance of a row',(,⎕UCS 10),'      '
  (howfirst)[602+⍳40]←'   ',(,⎕UCS 8902),'  The index numbers of these or corr'
  (howfirst)[642+⍳27]←'esponding rows',(,⎕UCS 10),'         ',(,⎕UCS 8902),'  '
  (howfirst)[669+⍳44]←'The corresponding rows of an inverted file',(,⎕UCS 10 10)
  (howfirst)[713+⍳29]←'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<x>   Ch'
  (howfirst)[742+⍳45]←'aracter or numeric scalar, vector or matrix',(,⎕UCS 10),' '
  (howfirst)[787+⍳47]←'  A scalar is treated as a one-element vector.',(,⎕UCS 10)
  (howfirst)[834+⍳19]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>'
  (howfirst)[853+⍳42]←'   Numeric vector',(,⎕UCS 10),'   y[i]=1 -- x[i] (or x['
  (howfirst)[895+⍳50]←'i;] for a matrix) is the first occurrence of that',(,⎕UCS 10)
  (howfirst)[945+⍳42]←'             element in the array.',(,⎕UCS 10),'   y[i]'
  (howfirst)[987+⍳45]←'=0 -- Element i is not the first occurrence.',(,⎕UCS 10)
  (howfirst)[1032+⍳18]←(,⎕UCS 10),'Source:',(,⎕UCS 10),'------',(,⎕UCS 10),'  '
  (howfirst)[1050+⍳54]←' Adapted from The APL Handbook of Techniques, IBM, 197'
  (howfirst)[1104+⍳23]←'7.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howfirst)[1127+⍳38]←'... Scalar and Vector',(,⎕UCS 10),'      first ''b''',(,⎕UCS 10)
  (howfirst)[1165+⍳41]←(,⎕UCS 49 10),'      first ''abcdcdeablclabciefghijklnm'
  (howfirst)[1206+⍳40]←'mnopq''',(,⎕UCS 10),'1 1 1 1 0 0 1 0 0 1 0 0 0 0 0 1 0'
  (howfirst)[1246+⍳39]←' 1 1 1 0 1 1 0 1 1 0 0 1 1 1',(,⎕UCS 10 10),'... Matri'
  (howfirst)[1285+⍳14]←'x',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 109 8592),'''/'
  (howfirst)[1299+⍳37]←''' ',(,⎕UCS 8710),'box ''apple/betty/apple/dog/cat/cat'
  (howfirst)[1336+⍳20]←'/betty''',(,⎕UCS 10),'apple',(,⎕UCS 10),'betty',(,⎕UCS 10)
  (howfirst)[1356+⍳15]←'apple',(,⎕UCS 10),'dog',(,⎕UCS 10),'cat',(,⎕UCS 10),'c'
  (howfirst)[1371+⍳23]←'at',(,⎕UCS 10),'betty',(,⎕UCS 10),'      first m',(,⎕UCS 10)
  (howfirst)[1394+⍳30]←'1 1 0 1 1 0 0',(,⎕UCS 10),'      (first m)',(,⎕UCS 9023)
  (howfirst)[1424+⍳15]←(,⎕UCS 109 10),'apple',(,⎕UCS 10),'betty',(,⎕UCS 10),'d'
  (howfirst)[1439+⍳28]←'og',(,⎕UCS 10),'cat',(,⎕UCS 10),'... Number of unique '
  (howfirst)[1467+⍳24]←'rows',(,⎕UCS 10),'      +/first m',(,⎕UCS 10 52 10),'.'
  (howfirst)[1491+⍳36]←'.. Numeric argument',(,⎕UCS 10),'      first 6 2',(,⎕UCS 9076)
  (howfirst)[1527+⍳15]←(,⎕UCS 9075 52 10),'1 1 0 0 0 0',(,⎕UCS 10)

howfisodate←1389⍴0 ⍝ prolog ≡1
  (howfisodate)[⍳56]←'--------------------------------------------------------'
  (howfisodate)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'fisodate'
  (howfisodate)[89+⍳40]←' t',(,⎕UCS 10),'format dates <t> = (mm dd yyyy) as <y'
  (howfisodate)[129+⍳39]←'> = (yyyy-mm-dd)',(,⎕UCS 10),'----------------------'
  (howfisodate)[168+⍳52]←'----------------------------------------------------'
  (howfisodate)[220+⍳24]←'----',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'----'
  (howfisodate)[244+⍳39]←'--------',(,⎕UCS 10),'   <fisodate> formats dates.  '
  (howfisodate)[283+⍳47]←'Given the numeric argument <t> in the form (mm',(,⎕UCS 10)
  (howfisodate)[330+⍳52]←'   dd yyyy), i.e.  month day year, <fisodate> return'
  (howfisodate)[382+⍳39]←'s the date formatted as',(,⎕UCS 10),'   the characte'
  (howfisodate)[421+⍳52]←'r vector (yyyy-mm-dd).  <t> can also be a matrix of '
  (howfisodate)[473+⍳24]←'dates.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-----'
  (howfisodate)[497+⍳36]←'----',(,⎕UCS 10),'<t>   Numeric vector or matrix',(,⎕UCS 10)
  (howfisodate)[533+⍳52]←'   <t> specifies the date as a 3-column matrix.  If '
  (howfisodate)[585+⍳39]←'<t> is a vector, it is',(,⎕UCS 10),'   treated as a '
  (howfisodate)[624+⍳39]←'1-row matrix.',(,⎕UCS 10),'      t[;1] -- month (1 t'
  (howfisodate)[663+⍳35]←'o 12)',(,⎕UCS 10),'      t[;2] -- day (1 to 31)',(,⎕UCS 10)
  (howfisodate)[698+⍳37]←'      t[;3] -- year (integer)',(,⎕UCS 10 10),'Result'
  (howfisodate)[735+⍳26]←':',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Character m'
  (howfisodate)[761+⍳39]←'atrix',(,⎕UCS 10),'   The matrix <y> is a matrix of '
  (howfisodate)[800+⍳39]←'dates.  y[i;] is the i-th row of <t>',(,⎕UCS 10),'  '
  (howfisodate)[839+⍳52]←' formatted in the iso format (yyyy-mm-dd).  The leng'
  (howfisodate)[891+⍳21]←'th of <y> (',(,⎕UCS 175 49 8593 9076),'y) is',(,⎕UCS 10)
  (howfisodate)[912+⍳52]←'   10=4+1+2+1+2.  Leading zeros are used if necessar'
  (howfisodate)[964+⍳39]←'y to pad the numbers.',(,⎕UCS 10),'   (See examples)'
  (howfisodate)[1003+⍳22]←'.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howfisodate)[1025+⍳51]←'..... <fisodate> formats a date given in numeric (m'
  (howfisodate)[1076+⍳38]←'onth day year) format.',(,⎕UCS 10),'      fisodate '
  (howfisodate)[1114+⍳22]←(,⎕UCS 9109),'ts[2 3 1]',(,⎕UCS 10),'1992-04-14',(,⎕UCS 10)
  (howfisodate)[1136+⍳41]←(,⎕UCS 10),'...The last date is before the year 1000'
  (howfisodate)[1177+⍳13]←'.',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 100 100 8592)
  (howfisodate)[1190+⍳36]←'5 3',(,⎕UCS 9076),'5 13 1988 12 8 1984 1 1 1991 12 '
  (howfisodate)[1226+⍳30]←'5 1543 4 4 472',(,⎕UCS 10),'   5   13 1988',(,⎕UCS 10)
  (howfisodate)[1256+⍳30]←'  12    8 1984',(,⎕UCS 10),'   1    1 1991',(,⎕UCS 10)
  (howfisodate)[1286+⍳30]←'  12    5 1543',(,⎕UCS 10),'   4    4  472',(,⎕UCS 10)
  (howfisodate)[1316+⍳29]←'      fisodate dd',(,⎕UCS 10),'1988-05-13',(,⎕UCS 10)
  (howfisodate)[1345+⍳25]←'1984-12-08',(,⎕UCS 10),'1991-01-01',(,⎕UCS 10),'154'
  (howfisodate)[1370+⍳19]←'3-12-05',(,⎕UCS 10),'0472-04-04',(,⎕UCS 10)

howfixuparray←1010⍴0 ⍝ prolog ≡1
  (howfixuparray)[⍳54]←'------------------------------------------------------'
  (howfixuparray)[54+⍳31]←'------------------------',(,⎕UCS 10 121 8592),'fixu'
  (howfixuparray)[85+⍳38]←'parray data',(,⎕UCS 10),'return character matrix re'
  (howfixuparray)[123+⍳37]←'presentation of array <data>',(,⎕UCS 10),'--------'
  (howfixuparray)[160+⍳50]←'--------------------------------------------------'
  (howfixuparray)[210+⍳35]←'--------------------',(,⎕UCS 10 10),'Introduction:'
  (howfixuparray)[245+⍳27]←(,⎕UCS 10),'------------',(,⎕UCS 10),'   <fixuparra'
  (howfixuparray)[272+⍳50]←'y> is useful for formatting arrays for presentatio'
  (howfixuparray)[322+⍳37]←'n, for',(,⎕UCS 10),'   instance, when incorporatin'
  (howfixuparray)[359+⍳42]←'g the text of arrays into documents.  The',(,⎕UCS 10)
  (howfixuparray)[401+⍳50]←'   function prepares a character matrix representa'
  (howfixuparray)[451+⍳37]←'tion of the argument',(,⎕UCS 10),'   <data>, which'
  (howfixuparray)[488+⍳49]←' can be a numeric or character array of any rank.'
  (howfixuparray)[537+⍳23]←(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howfixuparray)[560+⍳47]←'<data>   numeric or character array (any rank)',(,⎕UCS 10)
  (howfixuparray)[607+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howfixuparray)[624+⍳37]←'y>   character matrix',(,⎕UCS 10),'   A character '
  (howfixuparray)[661+⍳50]←'representation of <data>.  Note that a multi-dimen'
  (howfixuparray)[711+⍳37]←'sional array',(,⎕UCS 10),'   (greater than rank 2)'
  (howfixuparray)[748+⍳50]←' is typically displayed with one blank row between'
  (howfixuparray)[798+⍳25]←(,⎕UCS 10),'   each plane.',(,⎕UCS 10 10),'Examples'
  (howfixuparray)[823+⍳18]←':',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howfixuparray)[841+⍳18]←(,⎕UCS 8592 109 8592),'fixuparray 2',(,⎕UCS 10 50 10)
  (howfixuparray)[859+⍳15]←'      ',(,⎕UCS 9076 109 10),'1 1',(,⎕UCS 10 10),' '
  (howfixuparray)[874+⍳23]←'     ',(,⎕UCS 9109 8592 109 8592),'fixuparray 2 2'
  (howfixuparray)[897+⍳12]←(,⎕UCS 9076 9075 52 10),'1 2',(,⎕UCS 10),'3 4',(,⎕UCS 10)
  (howfixuparray)[909+⍳15]←'      ',(,⎕UCS 9076 109 10),'2 3',(,⎕UCS 10 10),' '
  (howfixuparray)[924+⍳24]←'     ',(,⎕UCS 9109 8592 109 8592),'fixuparray 2 2 '
  (howfixuparray)[948+⍳17]←'2 3',(,⎕UCS 9076),'''abcdef''',(,⎕UCS 10),'abc',(,⎕UCS 10)
  (howfixuparray)[965+⍳13]←'def',(,⎕UCS 10 10),'abc',(,⎕UCS 10),'def',(,⎕UCS 10)
  (howfixuparray)[978+⍳12]←(,⎕UCS 10),'abc',(,⎕UCS 10),'def',(,⎕UCS 10 10),'ab'
  (howfixuparray)[990+⍳13]←'c',(,⎕UCS 10),'def',(,⎕UCS 10),'      ',(,⎕UCS 9076)
  (howfixuparray)[1003+⍳7]←(,⎕UCS 109 10),'11 3',(,⎕UCS 10)

howfnlist←2308⍴0 ⍝ prolog ≡1
  (howfnlist)[⍳58]←'----------------------------------------------------------'
  (howfnlist)[58+⍳34]←'--------------------',(,⎕UCS 10 89 8592),'E fnlist T',(,⎕UCS 10)
  (howfnlist)[92+⍳55]←'function lister. display functions in list <T> using sp'
  (howfnlist)[147+⍳41]←'acing parameters <E>',(,⎕UCS 10),'--------------------'
  (howfnlist)[188+⍳54]←'------------------------------------------------------'
  (howfnlist)[242+⍳26]←'----',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'------'
  (howfnlist)[268+⍳41]←'------',(,⎕UCS 10),'   <fnlist> produces a listing for'
  (howfnlist)[309+⍳44]←' several functions or the entire workspace.',(,⎕UCS 10)
  (howfnlist)[353+⍳54]←'   It is especially useful when no other workspace lis'
  (howfnlist)[407+⍳27]←'ter is handy.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howfnlist)[434+⍳31]←'--------',(,⎕UCS 10),'<E>   Numeric vector',(,⎕UCS 10),' '
  (howfnlist)[465+⍳54]←'  This vector controls the following aspects of the li'
  (howfnlist)[519+⍳41]←'sting.',(,⎕UCS 10),'   E[1] -- number of blank lines b'
  (howfnlist)[560+⍳38]←'etween each function (default=1)',(,⎕UCS 10),'   1',(,⎕UCS 8595)
  (howfnlist)[598+⍳54]←'E  -- all remaining parameters (if any) are passed to '
  (howfnlist)[652+⍳39]←'<displayfunction>',(,⎕UCS 10 10),'<T>   Character scal'
  (howfnlist)[691+⍳41]←'ar, vector, or matrix',(,⎕UCS 10),'   The namelist of '
  (howfnlist)[732+⍳53]←'functions to be displayed.  If <T> is not empty, each'
  (howfnlist)[785+⍳44]←(,⎕UCS 10),'   function specified in <T> is displayed. '
  (howfnlist)[829+⍳37]←' If <T> is empty, the default is',(,⎕UCS 10),'   ',(,⎕UCS 9109)
  (howfnlist)[866+⍳54]←'nl 3 with <fnlist> and all its subroutines removed fro'
  (howfnlist)[920+⍳26]←'m the list.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-----'
  (howfnlist)[946+⍳28]←'-',(,⎕UCS 10),'<Y>   Character matrix',(,⎕UCS 10),'   '
  (howfnlist)[974+⍳54]←'<Y> is a sorted listing of the functions formatted by '
  (howfnlist)[1028+⍳40]←'<displayfunction>',(,⎕UCS 10),'   according to the ar'
  (howfnlist)[1068+⍳25]←'gument <E>.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--'
  (howfnlist)[1093+⍳40]←'------',(,⎕UCS 10),'...Display all the functions in t'
  (howfnlist)[1133+⍳40]←'he workspace using default parameters',(,⎕UCS 10),'  '
  (howfnlist)[1173+⍳34]←'    '''' fnlist ''''',(,⎕UCS 10 10),'...It is conveni'
  (howfnlist)[1207+⍳52]←'ent to use the toolkit function <nl> with <fnlist>.',(,⎕UCS 10)
  (howfnlist)[1259+⍳47]←'...List all the functions starting with ''edi''.',(,⎕UCS 10)
  (howfnlist)[1306+⍳28]←'      '''' fnlist ''edi',(,⎕UCS 8902),''' nl 3',(,⎕UCS 10)
  (howfnlist)[1334+⍳28]←(,⎕UCS 10),'...Display <fnlist>',(,⎕UCS 10),'      '''
  (howfnlist)[1362+⍳35]←''' fnlist ''fnlist''',(,⎕UCS 10 10),'...Display speci'
  (howfnlist)[1397+⍳50]←'fied functions using specified spacing parameters',(,⎕UCS 10)
  (howfnlist)[1447+⍳34]←'      1 4 2 4 fnlist ''jr jl''',(,⎕UCS 10),'    ',(,⎕UCS 8711)
  (howfnlist)[1481+⍳17]←'    r',(,⎕UCS 8592),'jl x',(,⎕UCS 10),'[1]  ',(,⎕UCS 9053)
  (howfnlist)[1498+⍳43]←'justify left: justify character array <x>',(,⎕UCS 10),'['
  (howfnlist)[1541+⍳22]←'2]  ',(,⎕UCS 9053),'.e (2 6',(,⎕UCS 9076),'''ab    cd'
  (howfnlist)[1563+⍳31]←'    '') = jl 2 6',(,⎕UCS 9076),'''ab    cd    ''',(,⎕UCS 10)
  (howfnlist)[1594+⍳25]←'[3]  ',(,⎕UCS 9053),'.k formatting',(,⎕UCS 10),'[4]  '
  (howfnlist)[1619+⍳18]←'    r',(,⎕UCS 8592),'(+/',(,⎕UCS 8743),'\'' ''=x)',(,⎕UCS 9021)
  (howfnlist)[1637+⍳14]←(,⎕UCS 120 10),'    ',(,⎕UCS 8711 10 10),'    ',(,⎕UCS 8711)
  (howfnlist)[1651+⍳17]←'    r',(,⎕UCS 8592),'jr x',(,⎕UCS 10),'[1]  ',(,⎕UCS 9053)
  (howfnlist)[1668+⍳43]←'justify right: justify character array <x>',(,⎕UCS 10)
  (howfnlist)[1711+⍳22]←'[2]  ',(,⎕UCS 9053),'.e (2 6',(,⎕UCS 9076),'''    ab '
  (howfnlist)[1733+⍳32]←'   cd'') = jr 2 6',(,⎕UCS 9076),'''ab    cd    ''',(,⎕UCS 10)
  (howfnlist)[1765+⍳25]←'[3]  ',(,⎕UCS 9053),'.k formatting',(,⎕UCS 10),'[4]  '
  (howfnlist)[1790+⍳15]←'    r',(,⎕UCS 8592),'(-+/',(,⎕UCS 8743 92 9021),''' '
  (howfnlist)[1805+⍳15]←'''=x)',(,⎕UCS 9021 120 10),'    ',(,⎕UCS 8711 10 10),'P'
  (howfnlist)[1820+⍳36]←'rogramming Notes:',(,⎕UCS 10),'-----------------',(,⎕UCS 10)
  (howfnlist)[1856+⍳53]←'   The explicit result of <fnlist> can be passed to i'
  (howfnlist)[1909+⍳40]←'mplementation-dependent',(,⎕UCS 10),'   functions for'
  (howfnlist)[1949+⍳53]←' full-screen display and printing.  Since the listing'
  (howfnlist)[2002+⍳38]←' may',(,⎕UCS 10),'   easily be large, a ''wsfull'' co'
  (howfnlist)[2040+⍳40]←'ndition may arise when listing large',(,⎕UCS 10),'   '
  (howfnlist)[2080+⍳53]←'workspaces.  In this situation list the workspace a p'
  (howfnlist)[2133+⍳40]←'ortion at a time.',(,⎕UCS 10),'   Also, <fnlist> may '
  (howfnlist)[2173+⍳47]←'be modified using implementation functions for',(,⎕UCS 10)
  (howfnlist)[2220+⍳53]←'   sorting, formatting a function, and printing the l'
  (howfnlist)[2273+⍳35]←'isting as it is being',(,⎕UCS 10),'   computed.',(,⎕UCS 10)

howftime←877⍴0 ⍝ prolog ≡1
  (howftime)[⍳59]←'-----------------------------------------------------------'
  (howftime)[59+⍳31]←'-------------------',(,⎕UCS 10 116 8592),'ftime ts',(,⎕UCS 10)
  (howftime)[90+⍳41]←'return time of day <ts> (',(,⎕UCS 9109),'ts format) in f'
  (howftime)[131+⍳42]←'ormat hh:mm:ss (am/pm)',(,⎕UCS 10),'-------------------'
  (howftime)[173+⍳55]←'-------------------------------------------------------'
  (howftime)[228+⍳27]←'----',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-------'
  (howftime)[255+⍳42]←'-----',(,⎕UCS 10),'   <ftime> returns the time of day a'
  (howftime)[297+⍳42]←'s a formatted character vector, given an',(,⎕UCS 10),' '
  (howftime)[339+⍳53]←'  arbitrary 3-number argument representing the time.',(,⎕UCS 10)
  (howftime)[392+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howftime)[414+⍳42]←'<ts>   3-element numeric vector',(,⎕UCS 10),'   The ele'
  (howftime)[456+⍳53]←'ments in <ts> must be equivalent to that returned by '
  (howftime)[509+⍳30]←(,⎕UCS 9109),'ts[4 5 6]',(,⎕UCS 10),'   ts[1] -- hours o'
  (howftime)[539+⍳36]←'f day (0 to 23)',(,⎕UCS 10),'   ts[2] -- minutes',(,⎕UCS 10)
  (howftime)[575+⍳30]←'   ts[3] -- seconds',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howftime)[605+⍳30]←'-----',(,⎕UCS 10),'<y>   Character vector',(,⎕UCS 10),' '
  (howftime)[635+⍳55]←'  <y> is the time represented by <ts> in the format hh:'
  (howftime)[690+⍳27]←'mm:ss (am/pm)',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--'
  (howftime)[717+⍳23]←'------',(,⎕UCS 10),'      ftime 3',(,⎕UCS 8593 51 8595)
  (howftime)[740+⍳22]←(,⎕UCS 9109 116 115 10),'01:07:27 pm',(,⎕UCS 10),'      '
  (howftime)[762+⍳29]←'ftime 11 11 11',(,⎕UCS 10),'11:11:11 am',(,⎕UCS 10),'  '
  (howftime)[791+⍳24]←'    ',(,⎕UCS 9076),'ftime 11 11 11',(,⎕UCS 10 49 49 10),' '
  (howftime)[815+⍳32]←'     ftime 23 35 14',(,⎕UCS 10),'11:35:14 pm',(,⎕UCS 10)
  (howftime)[847+⍳30]←'      ftime 0 1 1',(,⎕UCS 10),'12:01:01 am',(,⎕UCS 10)

howfunsincat←1897⍴0 ⍝ prolog ≡1
  (howfunsincat)[⍳55]←'-------------------------------------------------------'
  (howfunsincat)[55+⍳33]←'-----------------------',(,⎕UCS 10 89 8592),'N funsi'
  (howfunsincat)[88+⍳39]←'ncat X',(,⎕UCS 10),'list of functions in <n> belongi'
  (howfunsincat)[127+⍳38]←'ng to categorys specified in <x>',(,⎕UCS 10),'-----'
  (howfunsincat)[165+⍳51]←'---------------------------------------------------'
  (howfunsincat)[216+⍳36]←'----------------------',(,⎕UCS 10 10),'Introduction'
  (howfunsincat)[252+⍳25]←':',(,⎕UCS 10),'------------',(,⎕UCS 10),'   Functio'
  (howfunsincat)[277+⍳51]←'ns in the toolkit workspace contain a category tag-'
  (howfunsincat)[328+⍳38]←'line.  This is a',(,⎕UCS 10),'   comment statement '
  (howfunsincat)[366+⍳30]←'of the form: ',(,⎕UCS 9053),'.k categoryname',(,⎕UCS 10)
  (howfunsincat)[396+⍳41]←(,⎕UCS 10),'   This information can be used to group'
  (howfunsincat)[437+⍳38]←' functions for documentation or',(,⎕UCS 10),'   dev'
  (howfunsincat)[475+⍳51]←'elopment purposes.  The toolkit contains several fu'
  (howfunsincat)[526+⍳38]←'nctions that use',(,⎕UCS 10),'   the category tag-l'
  (howfunsincat)[564+⍳51]←'ine.  <funsincat> selects all the functions belongi'
  (howfunsincat)[615+⍳38]←'ng',(,⎕UCS 10),'   to specified categories.  The co'
  (howfunsincat)[653+⍳41]←'mpanion function <catoffun> returns the',(,⎕UCS 10),' '
  (howfunsincat)[694+⍳51]←'  category of a given function.  (Note also the fun'
  (howfunsincat)[745+⍳38]←'ctions <contents> and',(,⎕UCS 10),'   <contents1> t'
  (howfunsincat)[783+⍳51]←'hat compute a report of functions sorted within cat'
  (howfunsincat)[834+⍳23]←'egory.)',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---'
  (howfunsincat)[857+⍳38]←'------',(,⎕UCS 10),'<n>   Character vector or matri'
  (howfunsincat)[895+⍳38]←'x',(,⎕UCS 10),'   Namelist of functions.  If <n> is'
  (howfunsincat)[933+⍳30]←' empty, it defaults to ',(,⎕UCS 9109),'nl 3.',(,⎕UCS 10)
  (howfunsincat)[963+⍳40]←(,⎕UCS 10),'<x>   Character vector or 1-row matrix',(,⎕UCS 10)
  (howfunsincat)[1003+⍳49]←'   One wildcard name specification, e.g.  ''delete'
  (howfunsincat)[1052+⍳28]←'-elements'' or ''delete',(,⎕UCS 8902),''' for',(,⎕UCS 10)
  (howfunsincat)[1080+⍳49]←'   all categories beginning with the word ''delete'
  (howfunsincat)[1129+⍳19]←'''.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howfunsincat)[1148+⍳37]←'<y>   Character matrix',(,⎕UCS 10),'   A sorted li'
  (howfunsincat)[1185+⍳50]←'st of the functions in <n> that belong to the cate'
  (howfunsincat)[1235+⍳28]←'gories',(,⎕UCS 10),'   specified in <x>.',(,⎕UCS 10)
  (howfunsincat)[1263+⍳20]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howfunsincat)[1283+⍳49]←'...Find the functions in the workspace in the ''su'
  (howfunsincat)[1332+⍳36]←'bstitution'' category.',(,⎕UCS 10),'...Search the '
  (howfunsincat)[1368+⍳50]←'entire workspace.  Note: Processing time can be re'
  (howfunsincat)[1418+⍳37]←'latively',(,⎕UCS 10),'...long when searching the e'
  (howfunsincat)[1455+⍳35]←'ntire workspace.',(,⎕UCS 10),'      '''' funsincat'
  (howfunsincat)[1490+⍳23]←' ''substitution''',(,⎕UCS 10 115 114 10),'srn',(,⎕UCS 10)
  (howfunsincat)[1513+⍳35]←'vrepl',(,⎕UCS 10 10),'...Find the catagory of func'
  (howfunsincat)[1548+⍳22]←'tion <',(,⎕UCS 8710),'box>.',(,⎕UCS 10),'      cat'
  (howfunsincat)[1570+⍳20]←'offun ''',(,⎕UCS 8710),'box''',(,⎕UCS 10),'reshape'
  (howfunsincat)[1590+⍳40]←(,⎕UCS 10),'...Find all functions in categories who'
  (howfunsincat)[1630+⍳36]←'se names starts with the word',(,⎕UCS 10),'...''de'
  (howfunsincat)[1666+⍳49]←'lete''.  Ignore functions in the workspace startin'
  (howfunsincat)[1715+⍳33]←'g with ''edi'' or ''fs''.',(,⎕UCS 10),'      78 ma'
  (howfunsincat)[1748+⍳17]←'tacross (''',(,⎕UCS 8764),'edi',(,⎕UCS 8902 32 8764)
  (howfunsincat)[1765+⍳28]←(,⎕UCS 102 115 8902),''' nl 3) funsincat ''delete'
  (howfunsincat)[1793+⍳34]←(,⎕UCS 8902 39 10),' condense  condense1 ddup      '
  (howfunsincat)[1827+⍳31]←'ddup1     suppress  ',(,⎕UCS 8710),'db       ',(,⎕UCS 8710)
  (howfunsincat)[1858+⍳16]←(,⎕UCS 100 99 10 32 8710),'dlb      ',(,⎕UCS 8710),'d'
  (howfunsincat)[1874+⍳20]←'lc      ',(,⎕UCS 8710),'dtb      ',(,⎕UCS 8710),'d'
  (howfunsincat)[1894+⍳3]←'tc',(,⎕UCS 10)

howgettag←2186⍴0 ⍝ prolog ≡1
  (howgettag)[⍳58]←'----------------------------------------------------------'
  (howgettag)[58+⍳34]←'--------------------',(,⎕UCS 10 89 8592),'X gettag M',(,⎕UCS 10)
  (howgettag)[92+⍳55]←'get line containing tag X (or line X if numeric) for fu'
  (howgettag)[147+⍳41]←'nctions in M',(,⎕UCS 10),'----------------------------'
  (howgettag)[188+⍳51]←'--------------------------------------------------',(,⎕UCS 10)
  (howgettag)[239+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howgettag)[267+⍳54]←'   <gettag> is the library utility to return the speci'
  (howgettag)[321+⍳41]←'fied tag-lines in the',(,⎕UCS 10),'   functions specif'
  (howgettag)[362+⍳51]←'ied in the namelist <M>.  A ''tag-line'' is a comment'
  (howgettag)[413+⍳44]←(,⎕UCS 10),'   identified at the beginning by the chara'
  (howgettag)[457+⍳37]←'cters ''.x '', where ''x'' stands for',(,⎕UCS 10),'   '
  (howgettag)[494+⍳54]←'an arbitrary code.  <gettag> can also select line 0 (h'
  (howgettag)[548+⍳41]←'eader) and line 1',(,⎕UCS 10),'   (first line - usuall'
  (howgettag)[589+⍳53]←'y a comment describing the purpose of the function).',(,⎕UCS 10)
  (howgettag)[642+⍳44]←(,⎕UCS 10),'   The companion functions are <puttag> and'
  (howgettag)[686+⍳41]←' <deltag>, for inserting and',(,⎕UCS 10),'   deleting '
  (howgettag)[727+⍳54]←'a tag-line, respectively.  (Refer to those functions f'
  (howgettag)[781+⍳41]←'or more',(,⎕UCS 10),'   details).  These three functio'
  (howgettag)[822+⍳42]←'ns can be used to set, maintain, and use',(,⎕UCS 10),' '
  (howgettag)[864+⍳43]←'  the ''tag-line'' concept in any workspace.',(,⎕UCS 10)
  (howgettag)[907+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howgettag)[929+⍳53]←'<X>   Character or numeric scalar or 1-element vector'
  (howgettag)[982+⍳43]←(,⎕UCS 10),'   The code identifying the comment ''tag-l'
  (howgettag)[1025+⍳37]←'ine'' belng selected.',(,⎕UCS 10 10),'<M>   Character'
  (howgettag)[1062+⍳40]←' vector or matrix',(,⎕UCS 10),'   Namelist of functio'
  (howgettag)[1102+⍳20]←'ns.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howgettag)[1122+⍳40]←'<Y>   Character matrix',(,⎕UCS 10),'   A matrix of ta'
  (howgettag)[1162+⍳53]←'g-lines.  The rows correspond to the order of functio'
  (howgettag)[1215+⍳40]←'ns in',(,⎕UCS 10),'   <M>.  If a tag-line is not pres'
  (howgettag)[1255+⍳42]←'ent, a blank line is returned.  If there',(,⎕UCS 10),' '
  (howgettag)[1297+⍳53]←'  are several tag-lines with the same identifier, the'
  (howgettag)[1350+⍳34]←' last one is returned.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howgettag)[1384+⍳20]←'--------',(,⎕UCS 10),'      m',(,⎕UCS 8592),''''' '
  (howgettag)[1404+⍳29]←(,⎕UCS 8710),'box ''array nofunc dfh srn''',(,⎕UCS 10),'.'
  (howgettag)[1433+⍳41]←'..Select the catagory name (if present)',(,⎕UCS 10),' '
  (howgettag)[1474+⍳27]←'     ''k'' gettag m',(,⎕UCS 10),'reshape',(,⎕UCS 10 10)
  (howgettag)[1501+⍳27]←'translation',(,⎕UCS 10),'substitution',(,⎕UCS 10 10),'.'
  (howgettag)[1528+⍳53]←'..Select the most recent version number (assuming ord'
  (howgettag)[1581+⍳38]←'er least to most recent)',(,⎕UCS 10),'      ''v'' get'
  (howgettag)[1619+⍳25]←'tag m',(,⎕UCS 10),'1.0 / 15dec79',(,⎕UCS 10 10),'1.2 '
  (howgettag)[1644+⍳40]←'/ 16apr92 / signalerror used',(,⎕UCS 10),'1.3 / 03apr'
  (howgettag)[1684+⍳45]←'92 / arg checking enhanced, signalerror used',(,⎕UCS 10)
  (howgettag)[1729+⍳43]←(,⎕UCS 10),'...Select the headers (line 0) and remove '
  (howgettag)[1772+⍳29]←'local variable list.',(,⎕UCS 10),'      r',(,⎕UCS 8592)
  (howgettag)[1801+⍳21]←'0 gettag m',(,⎕UCS 10),'      (',(,⎕UCS 9076 114 41)
  (howgettag)[1822+⍳18]←(,⎕UCS 9076 40 8744),'\r='';'')',(,⎕UCS 9021),'[1]r,[.'
  (howgettag)[1840+⍳22]←'5]'' ''',(,⎕UCS 10 114 8592),'del array str',(,⎕UCS 10)
  (howgettag)[1862+⍳16]←(,⎕UCS 10 121 8592),'dfh x',(,⎕UCS 10 108 8592),'text '
  (howgettag)[1878+⍳38]←'srn s',(,⎕UCS 10 10),'...Catenate function names and '
  (howgettag)[1916+⍳41]←'function description (typically line 1)',(,⎕UCS 10),' '
  (howgettag)[1957+⍳30]←'     m,'' '',1 gettag m',(,⎕UCS 10),'array  ',(,⎕UCS 9053)
  (howgettag)[1987+⍳53]←'general vector reshape. reshape vector <str> using de'
  (howgettag)[2040+⍳27]←'limiters <del>',(,⎕UCS 10),'nofunc',(,⎕UCS 10),'dfh  '
  (howgettag)[2067+⍳38]←'  ',(,⎕UCS 9053),'return decimal values of hex number'
  (howgettag)[2105+⍳25]←'s <x>',(,⎕UCS 10),'srn    ',(,⎕UCS 9053),'search and '
  (howgettag)[2130+⍳51]←'replace name by ''new'' sequence in <text>. <s>=/name'
  (howgettag)[2181+⍳5]←'/new',(,⎕UCS 10)

howglobal←1481⍴0 ⍝ prolog ≡1
  (howglobal)[⍳58]←'----------------------------------------------------------'
  (howglobal)[58+⍳34]←'--------------------',(,⎕UCS 10 103 8592),'f global m',(,⎕UCS 10)
  (howglobal)[92+⍳54]←'global referents in canonical form <m> of function <f>'
  (howglobal)[146+⍳44]←(,⎕UCS 10),'-------------------------------------------'
  (howglobal)[190+⍳39]←'-----------------------------------',(,⎕UCS 10 10),'In'
  (howglobal)[229+⍳28]←'troduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   '
  (howglobal)[257+⍳54]←'<global> analyzes the canonical form <m> of the functi'
  (howglobal)[311+⍳41]←'on <f> for the',(,⎕UCS 10),'   presence of global refe'
  (howglobal)[352+⍳39]←'rents.',(,⎕UCS 10 10),'   Note: The programmer typical'
  (howglobal)[391+⍳47]←'ly uses <fgl> (find global referents) which is',(,⎕UCS 10)
  (howglobal)[438+⍳52]←'   the ''driver'' function for <global>.  For informat'
  (howglobal)[490+⍳41]←'ion on <fgl> and the',(,⎕UCS 10),'   definition of glo'
  (howglobal)[531+⍳43]←'bal referents, see the document on <fgl>.',(,⎕UCS 10 10)
  (howglobal)[574+⍳28]←'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<f>   C'
  (howglobal)[602+⍳41]←'haracter vector',(,⎕UCS 10),'   The name of an unlocke'
  (howglobal)[643+⍳36]←'d function.',(,⎕UCS 10 10),'<m>   Character matrix',(,⎕UCS 10)
  (howglobal)[679+⍳42]←'   The canonical matrix of function <f>.',(,⎕UCS 10 10)
  (howglobal)[721+⍳28]←'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<g>   Charact'
  (howglobal)[749+⍳41]←'er matrix',(,⎕UCS 10),'   <g> is a matrix whose rows c'
  (howglobal)[790+⍳41]←'ontain in alphabetical order the global',(,⎕UCS 10),' '
  (howglobal)[831+⍳39]←'  referents of the function <f>.',(,⎕UCS 10 10),'Notes'
  (howglobal)[870+⍳13]←':',(,⎕UCS 10),'-----',(,⎕UCS 10),'   ',(,⎕UCS 9109),'-'
  (howglobal)[883+⍳54]←'names can easily be deleted from the result.  However,'
  (howglobal)[937+⍳41]←' since membership',(,⎕UCS 10),'   in the set of valid '
  (howglobal)[978+⍳42]←(,⎕UCS 9109),'-names (system variables and functions) i'
  (howglobal)[1020+⍳40]←'s',(,⎕UCS 10),'   system-dependent, <global> does not'
  (howglobal)[1060+⍳25]←' delete them.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'--'
  (howglobal)[1085+⍳40]←'----',(,⎕UCS 10),'   Adapted from Algorithm 142 -- Gl'
  (howglobal)[1125+⍳41]←'obal Referents of a Function (APL Quote',(,⎕UCS 10),' '
  (howglobal)[1166+⍳42]←'  Quad, 10, 4, June 1980), by Roger Hui.',(,⎕UCS 10 10)
  (howglobal)[1208+⍳26]←'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      '''
  (howglobal)[1234+⍳22]←'fgl'' global ',(,⎕UCS 9109),'cr ''fgl''',(,⎕UCS 10)
  (howglobal)[1256+⍳23]←(,⎕UCS 9109 99 114 10 9109 110 99 10),'checksubroutine'
  (howglobal)[1279+⍳26]←(,⎕UCS 10),'global',(,⎕UCS 10 10),'      ''''matacross'
  (howglobal)[1305+⍳33]←' ''contents'' global ',(,⎕UCS 9109),'cr ''contents'''
  (howglobal)[1338+⍳22]←(,⎕UCS 10 32 9109),'av             ',(,⎕UCS 9109),'nc '
  (howglobal)[1360+⍳51]←'            bp              checksubroutine gettag',(,⎕UCS 10)
  (howglobal)[1411+⍳38]←' gradeup         on              ',(,⎕UCS 8710),'box '
  (howglobal)[1449+⍳28]←'           ',(,⎕UCS 8710),'db             ',(,⎕UCS 8710)
  (howglobal)[1477+⍳4]←'dtb',(,⎕UCS 10)

howgradeup←2174⍴0 ⍝ prolog ≡1
  (howgradeup)[⍳57]←'---------------------------------------------------------'
  (howgradeup)[57+⍳34]←'---------------------',(,⎕UCS 10 121 8592),'cs gradeup'
  (howgradeup)[91+⍳41]←' m',(,⎕UCS 10),'gradeup vector for character <m> based'
  (howgradeup)[132+⍳40]←' on collating sequence <cs>',(,⎕UCS 10),'------------'
  (howgradeup)[172+⍳53]←'-----------------------------------------------------'
  (howgradeup)[225+⍳29]←'-------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howgradeup)[254+⍳39]←'------------',(,⎕UCS 10),'   <gradeup> computes the '
  (howgradeup)[293+⍳48]←'''gradeup'' or ''sort'' vector for sorting character'
  (howgradeup)[341+⍳43]←(,⎕UCS 10),'   arguments using the collating sequence '
  (howgradeup)[384+⍳40]←'<cs>.  If the collating sequence',(,⎕UCS 10),'   <cs>'
  (howgradeup)[424+⍳51]←' is reversed, <gradeup> returns the ''gradedown'' vec'
  (howgradeup)[475+⍳40]←'tor.  <gradeup>',(,⎕UCS 10),'   sets no restriction o'
  (howgradeup)[515+⍳46]←'n the number of columns in a matrix argument.',(,⎕UCS 10)
  (howgradeup)[561+⍳41]←(,⎕UCS 10),'   ''Standard'' APL does not allow charact'
  (howgradeup)[602+⍳40]←'er arguments for the gradeup and',(,⎕UCS 10),'   grad'
  (howgradeup)[642+⍳24]←'edown functions ',(,⎕UCS 9035),' and ',(,⎕UCS 9042),'.'
  (howgradeup)[666+⍳43]←'  However, <gradeup> applies the algorithm',(,⎕UCS 10)
  (howgradeup)[709+⍳29]←'   v[',(,⎕UCS 9035 99 115 9075),'v] to sort a vector,'
  (howgradeup)[738+⍳38]←' or sort a matrix column by column.',(,⎕UCS 10 10),'A'
  (howgradeup)[776+⍳27]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<cs>   '
  (howgradeup)[803+⍳40]←'Character vector',(,⎕UCS 10),'   <cs> is the collatin'
  (howgradeup)[843+⍳47]←'g sequence to be applied to <m>.  The order of',(,⎕UCS 10)
  (howgradeup)[890+⍳53]←'   characters in <cs> is the sort order that will be '
  (howgradeup)[943+⍳34]←'used.  Empty <cs>',(,⎕UCS 10),'   defaults to ',(,⎕UCS 9109)
  (howgradeup)[977+⍳53]←'av, that is, the order in the atomic vector.  However'
  (howgradeup)[1030+⍳24]←', note',(,⎕UCS 10),'   that ',(,⎕UCS 9109),'av order'
  (howgradeup)[1054+⍳52]←' is not defined in the APL standard.  For example, t'
  (howgradeup)[1106+⍳39]←'he',(,⎕UCS 10),'   blank may come before or after th'
  (howgradeup)[1145+⍳41]←'e letters, depending on the system, and',(,⎕UCS 10),' '
  (howgradeup)[1186+⍳37]←'  this affects word sorting.',(,⎕UCS 10 10),'<m>   C'
  (howgradeup)[1223+⍳35]←'haracter vector or matrix',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howgradeup)[1258+⍳29]←'------',(,⎕UCS 10),'<y>   Numeric vector',(,⎕UCS 10),' '
  (howgradeup)[1287+⍳52]←'  <y> is the vector that will sort the argument <m>.'
  (howgradeup)[1339+⍳39]←'  If <m> is a vector,',(,⎕UCS 10),'   then m[y] will'
  (howgradeup)[1378+⍳52]←' be sorted.  If <m> is a matrix, then m[y;] will be '
  (howgradeup)[1430+⍳24]←'sorted.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-----'
  (howgradeup)[1454+⍳17]←'---',(,⎕UCS 10),'      m',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710)
  (howgradeup)[1471+⍳25]←'box v',(,⎕UCS 8592),'''zoo/dog/dogs/cat''',(,⎕UCS 10)
  (howgradeup)[1496+⍳52]←'... Sort in alphabetical order ensuring blank is fir'
  (howgradeup)[1548+⍳38]←'st.',(,⎕UCS 10),'      m['' abcdefghijklmnopqrstuvwx'
  (howgradeup)[1586+⍳24]←'yz'' gradeup m;]',(,⎕UCS 10),'cat',(,⎕UCS 10),'dog',(,⎕UCS 10)
  (howgradeup)[1610+⍳26]←'dogs',(,⎕UCS 10),'zoo',(,⎕UCS 10),'... Sort in desce'
  (howgradeup)[1636+⍳45]←'nding order by reversing collating sequence.',(,⎕UCS 10)
  (howgradeup)[1681+⍳36]←'      m[(',(,⎕UCS 9021),''' abcdefghijklmnopqrstuvwx'
  (howgradeup)[1717+⍳25]←'yz'') gradeup m;]',(,⎕UCS 10),'zoo',(,⎕UCS 10),'dogs'
  (howgradeup)[1742+⍳16]←(,⎕UCS 10),'dog',(,⎕UCS 10),'cat',(,⎕UCS 10),'... Sor'
  (howgradeup)[1758+⍳20]←'t using ',(,⎕UCS 9109),'av. ('' '',',(,⎕UCS 9109),'a'
  (howgradeup)[1778+⍳37]←'v ensures blank sorts first.)',(,⎕UCS 10),'      m'
  (howgradeup)[1815+⍳22]←(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''mountbatten'
  (howgradeup)[1837+⍳46]←'/mountains/mountain/mounting/mount of olives''',(,⎕UCS 10)
  (howgradeup)[1883+⍳30]←'      m[('' '',',(,⎕UCS 9109),'av) gradeup m;]',(,⎕UCS 10)
  (howgradeup)[1913+⍳26]←'mount of olives',(,⎕UCS 10),'mountain',(,⎕UCS 10),'m'
  (howgradeup)[1939+⍳26]←'ountains',(,⎕UCS 10),'mountbatten',(,⎕UCS 10),'mount'
  (howgradeup)[1965+⍳38]←'ing',(,⎕UCS 10),'... If letters came before blank, '
  (howgradeup)[2003+⍳42]←'''mountains'' would come before ''mountain''.',(,⎕UCS 10)
  (howgradeup)[2045+⍳41]←'...Note: '''' gradeup m defaults to using ',(,⎕UCS 9109)
  (howgradeup)[2086+⍳37]←'av as the collating sequence.',(,⎕UCS 10 10),'... so'
  (howgradeup)[2123+⍳34]←'rt a vector',(,⎕UCS 10),'      v['''' gradeup v]',(,⎕UCS 10)
  (howgradeup)[2157+⍳17]←'///acddggoooostz',(,⎕UCS 10)

howgradeup1←751⍴0 ⍝ prolog ≡1
  (howgradeup1)[⍳56]←'--------------------------------------------------------'
  (howgradeup1)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'cs grade'
  (howgradeup1)[89+⍳40]←'up1 m',(,⎕UCS 10),'gradeup vector for character <m> b'
  (howgradeup1)[129+⍳39]←'ased on collating sequence <cs>',(,⎕UCS 10),'-------'
  (howgradeup1)[168+⍳52]←'----------------------------------------------------'
  (howgradeup1)[220+⍳35]←'-------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howgradeup1)[255+⍳39]←'------------',(,⎕UCS 10),'   This function has the s'
  (howgradeup1)[294+⍳46]←'ame arguments and result as <gradeup>.  For a',(,⎕UCS 10)
  (howgradeup1)[340+⍳51]←'   description, refer to the document on <gradeup>.'
  (howgradeup1)[391+⍳40]←(,⎕UCS 10 10),'   The difference bewteen <gradeup> an'
  (howgradeup1)[431+⍳39]←'d <gradeup1> is that the latter',(,⎕UCS 10),'   func'
  (howgradeup1)[470+⍳52]←'tion uses an algorithm based on encoding each row as'
  (howgradeup1)[522+⍳39]←' an integer, and',(,⎕UCS 10),'   then sorting the in'
  (howgradeup1)[561+⍳48]←'tegers.  As a consequence, <gradeup1> imposes a',(,⎕UCS 10)
  (howgradeup1)[609+⍳52]←'   restriction on the number of columns in a matrix '
  (howgradeup1)[661+⍳39]←'argument, for accurate',(,⎕UCS 10),'   sorting.  For'
  (howgradeup1)[700+⍳51]←' details, refer to the comments within <gradeup1>.',(,⎕UCS 10)

howgrafd←2234⍴0 ⍝ prolog ≡1
  (howgrafd)[⍳59]←'-----------------------------------------------------------'
  (howgrafd)[59+⍳33]←'-------------------',(,⎕UCS 10 103 102 8592),'codes graf'
  (howgrafd)[92+⍳43]←'d x',(,⎕UCS 10),'histogram of data <x> specified by <cod'
  (howgrafd)[135+⍳42]←'es>',(,⎕UCS 10),'--------------------------------------'
  (howgrafd)[177+⍳43]←'----------------------------------------',(,⎕UCS 10 10),'I'
  (howgrafd)[220+⍳29]←'ntroduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   '
  (howgrafd)[249+⍳55]←'<grafd> is a scaled, labelled and formatted histogram t'
  (howgrafd)[304+⍳42]←'hat is handy when',(,⎕UCS 10),'   you really need a his'
  (howgrafd)[346+⍳29]←'togram quickly!',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howgrafd)[375+⍳42]←'--------',(,⎕UCS 10),'<codes>   2-element numeric vecto'
  (howgrafd)[417+⍳42]←'r',(,⎕UCS 10),'   codes[1] = Number of increments (cell'
  (howgrafd)[459+⍳42]←'s) to be used along the y-axis',(,⎕UCS 10),'           '
  (howgrafd)[501+⍳55]←'   This number is in effect the scaling factor.  The y '
  (howgrafd)[556+⍳42]←'increments',(,⎕UCS 10),'              are computed so t'
  (howgrafd)[598+⍳42]←'hat all data, from the minimum to the',(,⎕UCS 10),'    '
  (howgrafd)[640+⍳55]←'          maximum, can be plotted within codes[1] incre'
  (howgrafd)[695+⍳42]←'ments.',(,⎕UCS 10),'   codes[2] = Periods per cycle in '
  (howgrafd)[737+⍳41]←'the data.',(,⎕UCS 10),'              This sets the ''ti'
  (howgrafd)[778+⍳43]←'ck-marks'' along the x-axis.  For example,',(,⎕UCS 10),' '
  (howgrafd)[821+⍳55]←'             codes[2]=6 specifies a tick-mark every 6 d'
  (howgrafd)[876+⍳34]←'ata points.',(,⎕UCS 10 10),'<x>   Numeric vector',(,⎕UCS 10)
  (howgrafd)[910+⍳40]←'   The vector of data to be plotted.',(,⎕UCS 10 10),'Re'
  (howgrafd)[950+⍳29]←'sult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<gf>   Character'
  (howgrafd)[979+⍳42]←' matrix',(,⎕UCS 10),'   The representation of the graph'
  (howgrafd)[1021+⍳22]←'.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howgrafd)[1043+⍳53]←'...Specify 12 increments along the y-axis and ''tick-m'
  (howgrafd)[1096+⍳40]←'arks'' every 4 columns.',(,⎕UCS 10),'      12 4 grafd '
  (howgrafd)[1136+⍳37]←'20 22 24 19 15 16 14 30 15 19 26 24',(,⎕UCS 10 8728)
  (howgrafd)[1173+⍳12]←(,⎕UCS 8728 8728 8728 8728),' ---',(,⎕UCS 9675),'---'
  (howgrafd)[1185+⍳10]←(,⎕UCS 9675),'---',(,⎕UCS 9675 32 8728 8728 8728 8728)
  (howgrafd)[1195+⍳28]←(,⎕UCS 8728 10),'38.00              38.00',(,⎕UCS 10),'3'
  (howgrafd)[1223+⍳41]←'6.00              36.00',(,⎕UCS 10),'34.00            '
  (howgrafd)[1264+⍳33]←'  34.00',(,⎕UCS 10),'32.00              32.00',(,⎕UCS 10)
  (howgrafd)[1297+⍳26]←'30.00        ',(,⎕UCS 9109),'     30.00',(,⎕UCS 10),'2'
  (howgrafd)[1323+⍳26]←'8.00        ',(,⎕UCS 9109),'     28.00',(,⎕UCS 10),'26'
  (howgrafd)[1349+⍳23]←'.00        ',(,⎕UCS 9109 32 32 9109),'  26.00',(,⎕UCS 10)
  (howgrafd)[1372+⍳17]←'24.00   ',(,⎕UCS 9109),'    ',(,⎕UCS 9109 32 32 9109)
  (howgrafd)[1389+⍳16]←(,⎕UCS 9109),' 24.00',(,⎕UCS 10),'22.00  ',(,⎕UCS 9109)
  (howgrafd)[1405+⍳15]←(,⎕UCS 9109),'    ',(,⎕UCS 9109 32 32 9109 9109),' 22.0'
  (howgrafd)[1420+⍳15]←'0',(,⎕UCS 10),'20.00 ',(,⎕UCS 9109 9109 9109),'    '
  (howgrafd)[1435+⍳17]←(,⎕UCS 9109 32 32 9109 9109),' 20.00',(,⎕UCS 10),'18.00'
  (howgrafd)[1452+⍳10]←' ',(,⎕UCS 9109 9109 9109 9109),'   ',(,⎕UCS 9109 32)
  (howgrafd)[1462+⍳17]←(,⎕UCS 9109 9109 9109),' 18.00',(,⎕UCS 10),'16.00 ',(,⎕UCS 9109)
  (howgrafd)[1479+⍳11]←(,⎕UCS 9109 9109 9109 32 9109 32 9109 32 9109 9109 9109)
  (howgrafd)[1490+⍳17]←' 16.00',(,⎕UCS 10),'14.00 ',(,⎕UCS 9109 9109 9109 9109)
  (howgrafd)[1507+⍳14]←(,⎕UCS 9109 9109 9109 9109 9109 9109 9109 9109),' 14.00'
  (howgrafd)[1521+⍳12]←(,⎕UCS 10 8728 8728 8728 8728 8728),' ---',(,⎕UCS 9675),'-'
  (howgrafd)[1533+⍳11]←'--',(,⎕UCS 9675),'---',(,⎕UCS 9675 32 8728 8728 8728)
  (howgrafd)[1544+⍳34]←(,⎕UCS 8728 8728 10 10),'...In order to set reasonable '
  (howgrafd)[1578+⍳46]←'increments, ''dummy'' data may need to be used.',(,⎕UCS 10)
  (howgrafd)[1624+⍳54]←'...Compare the increments in the following two graphs '
  (howgrafd)[1678+⍳41]←'placed side by side.',(,⎕UCS 10),'      (10 2 grafd .1'
  (howgrafd)[1719+⍳47]←' 5 7 9),'' '','' '','' '',(10 2 grafd 0 .1 5 7 9 10)',(,⎕UCS 10)
  (howgrafd)[1766+⍳11]←(,⎕UCS 8728 8728 8728 8728 32 45 9675 45 9675 32 8728)
  (howgrafd)[1777+⍳10]←(,⎕UCS 8728 8728 8728),'   ',(,⎕UCS 8728 8728 8728 8728)
  (howgrafd)[1787+⍳12]←(,⎕UCS 8728 32 45 9675 45 9675 45 9675 32 8728 8728 8728)
  (howgrafd)[1799+⍳32]←(,⎕UCS 8728 8728 10),'9.10      9.10   10.00      ',(,⎕UCS 9109)
  (howgrafd)[1831+⍳26]←' 10.00',(,⎕UCS 10),'8.20    ',(,⎕UCS 9109),' 8.20    9'
  (howgrafd)[1857+⍳22]←'.00     ',(,⎕UCS 9109 9109),'  9.00',(,⎕UCS 10),'7.30 '
  (howgrafd)[1879+⍳24]←'   ',(,⎕UCS 9109),' 7.30    8.00     ',(,⎕UCS 9109 9109)
  (howgrafd)[1903+⍳22]←'  8.00',(,⎕UCS 10),'6.40   ',(,⎕UCS 9109 9109),' 6.40 '
  (howgrafd)[1925+⍳21]←'   7.00    ',(,⎕UCS 9109 9109 9109),'  7.00',(,⎕UCS 10)
  (howgrafd)[1946+⍳27]←'5.50   ',(,⎕UCS 9109 9109),' 5.50    6.00    ',(,⎕UCS 9109)
  (howgrafd)[1973+⍳16]←(,⎕UCS 9109 9109),'  6.00',(,⎕UCS 10),'4.60  ',(,⎕UCS 9109)
  (howgrafd)[1989+⍳20]←(,⎕UCS 9109 9109),' 4.60    5.00   ',(,⎕UCS 9109 9109)
  (howgrafd)[2009+⍳16]←(,⎕UCS 9109 9109),'  5.00',(,⎕UCS 10),'3.70  ',(,⎕UCS 9109)
  (howgrafd)[2025+⍳20]←(,⎕UCS 9109 9109),' 3.70    4.00   ',(,⎕UCS 9109 9109)
  (howgrafd)[2045+⍳16]←(,⎕UCS 9109 9109),'  4.00',(,⎕UCS 10),'2.80  ',(,⎕UCS 9109)
  (howgrafd)[2061+⍳20]←(,⎕UCS 9109 9109),' 2.80    3.00   ',(,⎕UCS 9109 9109)
  (howgrafd)[2081+⍳16]←(,⎕UCS 9109 9109),'  3.00',(,⎕UCS 10),'1.90  ',(,⎕UCS 9109)
  (howgrafd)[2097+⍳20]←(,⎕UCS 9109 9109),' 1.90    2.00   ',(,⎕UCS 9109 9109)
  (howgrafd)[2117+⍳16]←(,⎕UCS 9109 9109),'  2.00',(,⎕UCS 10),'1.00  ',(,⎕UCS 9109)
  (howgrafd)[2133+⍳20]←(,⎕UCS 9109 9109),' 1.00    1.00   ',(,⎕UCS 9109 9109)
  (howgrafd)[2153+⍳15]←(,⎕UCS 9109 9109),'  1.00',(,⎕UCS 10),'0.10 ',(,⎕UCS 9109)
  (howgrafd)[2168+⍳19]←(,⎕UCS 9109 9109 9109),' 0.10    0.00 ',(,⎕UCS 9109 9109)
  (howgrafd)[2187+⍳13]←(,⎕UCS 9109 9109 9109 9109),'  0.00',(,⎕UCS 10 8728 8728)
  (howgrafd)[2200+⍳11]←(,⎕UCS 8728 8728 32 45 9675 45 9675 32 8728 8728 8728)
  (howgrafd)[2211+⍳11]←(,⎕UCS 8728),'   ',(,⎕UCS 8728 8728 8728 8728 8728 32 45)
  (howgrafd)[2222+⍳11]←(,⎕UCS 9675 45 9675 45 9675 32 8728 8728 8728 8728 8728)
  (howgrafd)[2233+⍳1]←(,⎕UCS 10)

howhfd←1159⍴0 ⍝ prolog ≡1
  (howhfd)[⍳61]←'-------------------------------------------------------------'
  (howhfd)[61+⍳28]←'-----------------',(,⎕UCS 10 121 8592),'n hfd d',(,⎕UCS 10)
  (howhfd)[89+⍳58]←'return hex equivalent of integers <d> to <n> hex positions'
  (howhfd)[147+⍳47]←(,⎕UCS 10),'----------------------------------------------'
  (howhfd)[194+⍳42]←'--------------------------------',(,⎕UCS 10 10),'Introduc'
  (howhfd)[236+⍳31]←'tion:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <dfh> sta'
  (howhfd)[267+⍳54]←'nds for ''hex from decimal''.  The function returns the '
  (howhfd)[321+⍳42]←'''hex'' (i.e.',(,⎕UCS 10),'   base-16) numbers correspond'
  (howhfd)[363+⍳36]←'ing to the numbers <x>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howhfd)[399+⍳32]←'---------',(,⎕UCS 10),'<n>   Numeric scalar',(,⎕UCS 10),' '
  (howhfd)[431+⍳57]←'  <n> determines the number of positions in the hex numbe'
  (howhfd)[488+⍳44]←'rs.  <n> must be',(,⎕UCS 10),'   large enough to accommod'
  (howhfd)[532+⍳47]←'ate the size of the numbers in <d>.  If <n> is',(,⎕UCS 10)
  (howhfd)[579+⍳48]←'   too small, the result <y> will be truncated.',(,⎕UCS 10)
  (howhfd)[627+⍳34]←(,⎕UCS 10),'<d>   Numeric vector',(,⎕UCS 10),'   The vecto'
  (howhfd)[661+⍳41]←'r of decimal (base 10) numbers.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howhfd)[702+⍳31]←'------',(,⎕UCS 10),'<y>   Character matrix',(,⎕UCS 10),' '
  (howhfd)[733+⍳57]←'  Each row of <y> is a hex number.  Numbers will be zero-'
  (howhfd)[790+⍳44]←'padded as',(,⎕UCS 10),'   necessary, since blanks are con'
  (howhfd)[834+⍳44]←'sidered unknown characters.  y[i] is the',(,⎕UCS 10),'   '
  (howhfd)[878+⍳40]←'base-10 equivalent of x[i;].',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howhfd)[918+⍳29]←'--------',(,⎕UCS 10),'      4 hfd x',(,⎕UCS 8592),'0 1 16'
  (howhfd)[947+⍳23]←' 256 345 172',(,⎕UCS 10),'0000',(,⎕UCS 10),'0001',(,⎕UCS 10)
  (howhfd)[970+⍳18]←'0010',(,⎕UCS 10),'0100',(,⎕UCS 10),'0159',(,⎕UCS 10),'00a'
  (howhfd)[988+⍳44]←'c',(,⎕UCS 10),'... Note that if <n> is too small, the hex'
  (howhfd)[1032+⍳38]←' numbers are truncated.',(,⎕UCS 10),'      2 hfd x',(,⎕UCS 10)
  (howhfd)[1070+⍳17]←(,⎕UCS 48 48 10 48 49 10 49 48 10 48 48 10 53 57 10 97 99)
  (howhfd)[1087+⍳36]←(,⎕UCS 10),'... <hfd> and <dfh> are inverses.',(,⎕UCS 10),' '
  (howhfd)[1123+⍳36]←'     dfh 4 hfd x',(,⎕UCS 10),'0 1 16 256 345 172',(,⎕UCS 10)

howjc←1368⍴0 ⍝ prolog ≡1
  (howjc)[⍳62]←'--------------------------------------------------------------'
  (howjc)[62+⍳26]←'----------------',(,⎕UCS 10 114 8592),'jc x',(,⎕UCS 10),'ju'
  (howjc)[88+⍳59]←'stify centre: centre all rows of left-justified character a'
  (howjc)[147+⍳45]←'rray <x>',(,⎕UCS 10),'------------------------------------'
  (howjc)[192+⍳45]←'------------------------------------------',(,⎕UCS 10 10),'I'
  (howjc)[237+⍳32]←'ntroduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <jc'
  (howjc)[269+⍳58]←'> centres each row of a character array, that is, it posit'
  (howjc)[327+⍳45]←'ions the text',(,⎕UCS 10),'   of each row from the first n'
  (howjc)[372+⍳46]←'on-blank to the last non-blank with an equal',(,⎕UCS 10),' '
  (howjc)[418+⍳47]←'  number of blanks (if possible) on each side.',(,⎕UCS 10)
  (howjc)[465+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howjc)[488+⍳45]←'x>   Character array (any rank)',(,⎕UCS 10),'   The array '
  (howjc)[533+⍳58]←'must be left-justified if the result is to be properly cen'
  (howjc)[591+⍳22]←'tred.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howjc)[613+⍳45]←'<r>   Character array',(,⎕UCS 10),'   The result is a cent'
  (howjc)[658+⍳55]←'red version of <x> along the last coordinate; that is,',(,⎕UCS 10)
  (howjc)[713+⍳58]←'   the rows of <r> are centred with blanks on the right an'
  (howjc)[771+⍳28]←'d left.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howjc)[799+⍳16]←'      ',(,⎕UCS 9109 8592 97 8592),'''/'' ',(,⎕UCS 8710),'b'
  (howjc)[815+⍳27]←'ox ''apple/cat/x''',(,⎕UCS 10),'apple',(,⎕UCS 10),'cat',(,⎕UCS 10)
  (howjc)[842+⍳20]←(,⎕UCS 120 10),'      jc a',(,⎕UCS 10),'apple',(,⎕UCS 10),' '
  (howjc)[862+⍳30]←'cat',(,⎕UCS 10),'  x',(,⎕UCS 10 10),'...<jc> does the best'
  (howjc)[892+⍳55]←' possible fit, but text will not be exactly centred if',(,⎕UCS 10)
  (howjc)[947+⍳58]←'...there are unequal number of blanks to fit; for example,'
  (howjc)[1005+⍳29]←' ...',(,⎕UCS 10),'      frame jc a,'' ''',(,⎕UCS 10),'(ap'
  (howjc)[1034+⍳24]←'ple )',(,⎕UCS 10),'( cat  )',(,⎕UCS 10),'(  x   )',(,⎕UCS 10)
  (howjc)[1058+⍳47]←(,⎕UCS 10),'...Centre in the middle of a page 72 character'
  (howjc)[1105+⍳28]←'s wide:',(,⎕UCS 10),'      jc 72',(,⎕UCS 8593),'''Chapter'
  (howjc)[1133+⍳43]←' 1''',(,⎕UCS 10),'                               Chapter '
  (howjc)[1176+⍳42]←'1',(,⎕UCS 10 10),'...Usually the argument <a> is left-jus'
  (howjc)[1218+⍳44]←'tified, but if this condition cannot',(,⎕UCS 10),'...be a'
  (howjc)[1262+⍳47]←'ssumed, then left-justify it first with <jl>:',(,⎕UCS 10),' '
  (howjc)[1309+⍳30]←'     frame jc jl (3 2',(,⎕UCS 9076),''' ''),a',(,⎕UCS 10),'('
  (howjc)[1339+⍳29]←' apple )',(,⎕UCS 10),'(  cat  )',(,⎕UCS 10),'(   x   )',(,⎕UCS 10)

howjl←795⍴0 ⍝ prolog ≡1
  (howjl)[⍳62]←'--------------------------------------------------------------'
  (howjl)[62+⍳26]←'----------------',(,⎕UCS 10 114 8592),'jl x',(,⎕UCS 10),'ju'
  (howjl)[88+⍳46]←'stify left: justify character array <x>',(,⎕UCS 10),'------'
  (howjl)[134+⍳58]←'----------------------------------------------------------'
  (howjl)[192+⍳31]←'--------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-'
  (howjl)[223+⍳45]←'-----------',(,⎕UCS 10),'   <jl> left-justifies each row o'
  (howjl)[268+⍳45]←'f a character array, that is, it positions',(,⎕UCS 10),'  '
  (howjl)[313+⍳58]←' the text of each row so that the first non-blank starts i'
  (howjl)[371+⍳30]←'n the first',(,⎕UCS 10),'   column.',(,⎕UCS 10 10),'Argume'
  (howjl)[401+⍳32]←'nts:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<x>   Character a'
  (howjl)[433+⍳30]←'rray (any rank)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-----'
  (howjl)[463+⍳32]←'-',(,⎕UCS 10),'<r>   Character array',(,⎕UCS 10),'   The r'
  (howjl)[495+⍳58]←'esult is a left-justified version of <x> along the last co'
  (howjl)[553+⍳45]←'ordinate;',(,⎕UCS 10),'   that is, the rows of <r> are lef'
  (howjl)[598+⍳45]←'t-justified with one or more blanks on',(,⎕UCS 10),'   the'
  (howjl)[643+⍳28]←' right.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howjl)[671+⍳16]←'      ',(,⎕UCS 9109 8592 97 8592),'''/'' ',(,⎕UCS 8710),'b'
  (howjl)[687+⍳33]←'ox ''   apple/    cat/x''',(,⎕UCS 10),'   apple',(,⎕UCS 10)
  (howjl)[720+⍳26]←'    cat',(,⎕UCS 10 120 10),'      jl a',(,⎕UCS 10),'apple'
  (howjl)[746+⍳27]←(,⎕UCS 10),'cat',(,⎕UCS 10 120 10 10),'      frame jl ''   '
  (howjl)[773+⍳22]←'  apple''',(,⎕UCS 10),'(apple     )',(,⎕UCS 10)

howjr←806⍴0 ⍝ prolog ≡1
  (howjr)[⍳62]←'--------------------------------------------------------------'
  (howjr)[62+⍳26]←'----------------',(,⎕UCS 10 114 8592),'jr x',(,⎕UCS 10),'ju'
  (howjr)[88+⍳46]←'stify right: justify character array <x>',(,⎕UCS 10),'-----'
  (howjr)[134+⍳58]←'----------------------------------------------------------'
  (howjr)[192+⍳32]←'---------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-'
  (howjr)[224+⍳45]←'-----------',(,⎕UCS 10),'   <jr> right-justifies each row '
  (howjr)[269+⍳45]←'of a character array, that is, it positions',(,⎕UCS 10),' '
  (howjr)[314+⍳58]←'  the text of each row so that the last non-blank starts i'
  (howjr)[372+⍳32]←'n the last column.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howjr)[404+⍳42]←'--------',(,⎕UCS 10),'<x>   Character array (any rank)',(,⎕UCS 10)
  (howjr)[446+⍳22]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   '
  (howjr)[468+⍳45]←'Character array',(,⎕UCS 10),'   The result is a right-just'
  (howjr)[513+⍳48]←'ified version of <x> along the last coordinate;',(,⎕UCS 10)
  (howjr)[561+⍳58]←'   that is, the rows of <r> are right-justified with one o'
  (howjr)[619+⍳32]←'r more blanks on',(,⎕UCS 10),'   the left.',(,⎕UCS 10 10),'E'
  (howjr)[651+⍳25]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howjr)[676+⍳22]←(,⎕UCS 8592 97 8592),'''/'' ',(,⎕UCS 8710),'box ''apple   /'
  (howjr)[698+⍳23]←'cat   /   x''',(,⎕UCS 10),'apple',(,⎕UCS 10),'cat',(,⎕UCS 10)
  (howjr)[721+⍳25]←'   x',(,⎕UCS 10),'      jr a',(,⎕UCS 10),'   apple',(,⎕UCS 10)
  (howjr)[746+⍳30]←'     cat',(,⎕UCS 10),'       x',(,⎕UCS 10 10),'      frame'
  (howjr)[776+⍳30]←' jr ''apple     ''',(,⎕UCS 10),'(     apple)',(,⎕UCS 10)

howjulian←2358⍴0 ⍝ prolog ≡1
  (howjulian)[⍳58]←'----------------------------------------------------------'
  (howjulian)[58+⍳34]←'--------------------',(,⎕UCS 10 122 8592),'julian date'
  (howjulian)[92+⍳45]←(,⎕UCS 10),'compute Julian day number for dates <date> ='
  (howjulian)[137+⍳41]←' (mm dd yyyy style)',(,⎕UCS 10),'---------------------'
  (howjulian)[178+⍳54]←'------------------------------------------------------'
  (howjulian)[232+⍳26]←'---',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-------'
  (howjulian)[258+⍳41]←'-----',(,⎕UCS 10),'   The Julian day number is a conti'
  (howjulian)[299+⍳43]←'nuous day count that starts at 0 on noon,',(,⎕UCS 10),' '
  (howjulian)[342+⍳40]←'  1/1/',(,⎕UCS 175),'4712 (that is, 4713 B.C.) The Jul'
  (howjulian)[382+⍳41]←'ian day number for the calendar',(,⎕UCS 10),'   date <'
  (howjulian)[423+⍳44]←'date[i]> is the number of days between 1/1/',(,⎕UCS 175)
  (howjulian)[467+⍳39]←'4712 and <date[i]>.',(,⎕UCS 10 10),'   When computing '
  (howjulian)[506+⍳54]←'with Julian day counts (as with <julian> and <cjulian>'
  (howjulian)[560+⍳41]←'),',(,⎕UCS 10),'   one must take into account the styl'
  (howjulian)[601+⍳41]←'e of calendar being used.  Spcifying',(,⎕UCS 10),'   s'
  (howjulian)[642+⍳54]←'tyle is optional for these functions.  It defaults to '
  (howjulian)[696+⍳41]←'1 (new style) if',(,⎕UCS 10),'   the date is on or aft'
  (howjulian)[737+⍳53]←'er September 14, 1752, and defaults to 0 (old style)',(,⎕UCS 10)
  (howjulian)[790+⍳54]←'   if the date is before that.  However style can be s'
  (howjulian)[844+⍳41]←'pecified if the',(,⎕UCS 10),'   default value is not c'
  (howjulian)[885+⍳52]←'orrect, for example, in Russia between 1752 and the',(,⎕UCS 10)
  (howjulian)[937+⍳54]←'   Russian Revolution (1917), during which time the ol'
  (howjulian)[991+⍳41]←'d style calendar was',(,⎕UCS 10),'   still being used.'
  (howjulian)[1032+⍳23]←(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howjulian)[1055+⍳41]←'<date>   3-element numeric vector, or n',(,⎕UCS 215),'3'
  (howjulian)[1096+⍳26]←' or n',(,⎕UCS 215),'4 matrix',(,⎕UCS 10),'   A 3-elem'
  (howjulian)[1122+⍳38]←'ent vector is treated as a 1',(,⎕UCS 215),'3 matrix.'
  (howjulian)[1160+⍳32]←(,⎕UCS 10),'   date[;1] = month (1 to 12)',(,⎕UCS 10),' '
  (howjulian)[1192+⍳40]←'  date[;2] = day (1 to 31)',(,⎕UCS 10),'   date[;3] ='
  (howjulian)[1232+⍳40]←' year',(,⎕UCS 10),'   date[;4] = style of calendar (o'
  (howjulian)[1272+⍳40]←'ptional - default as described above)',(,⎕UCS 10),'  '
  (howjulian)[1312+⍳40]←'            0 = old style',(,⎕UCS 10),'              '
  (howjulian)[1352+⍳25]←'1 = new style',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'--'
  (howjulian)[1377+⍳27]←'----',(,⎕UCS 10),'<z>   Numeric vector',(,⎕UCS 10),' '
  (howjulian)[1404+⍳53]←'  <z> is the vector of Julian day numbers correspondi'
  (howjulian)[1457+⍳40]←'ng to the dates',(,⎕UCS 10),'   specified in the argu'
  (howjulian)[1497+⍳50]←'ment.  z[i] is the Julian day count for date[i;].',(,⎕UCS 10)
  (howjulian)[1547+⍳43]←(,⎕UCS 10),'   If style is specified, that style calen'
  (howjulian)[1590+⍳40]←'dar is used to compute the Julian',(,⎕UCS 10),'   day'
  (howjulian)[1630+⍳53]←' count.  Otherwise, the style of calendar to be used '
  (howjulian)[1683+⍳40]←'is computed from',(,⎕UCS 10),'   the date itself, ass'
  (howjulian)[1723+⍳53]←'uming that the new style came into effect after 1752.'
  (howjulian)[1776+⍳41]←(,⎕UCS 10 10),'   7|1+z gives the day of the week for '
  (howjulian)[1817+⍳40]←'each element of <z>, as follows:',(,⎕UCS 10),'   Sund'
  (howjulian)[1857+⍳53]←'ay=0, Monday=1, Tuesday=2, Wednesday=3, Thursday=4, F'
  (howjulian)[1910+⍳26]←'riday=5,',(,⎕UCS 10),'   Saturday=6.',(,⎕UCS 10 10),'S'
  (howjulian)[1936+⍳27]←'ource:',(,⎕UCS 10),'------',(,⎕UCS 10),'   The APL Ha'
  (howjulian)[1963+⍳53]←'ndbook of Techniques, IBM, 1978.  (Refer to <dayno>.)'
  (howjulian)[2016+⍳21]←(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howjulian)[2037+⍳31]←'      julian 6 20 1900',(,⎕UCS 10),'2415191',(,⎕UCS 10)
  (howjulian)[2068+⍳43]←(,⎕UCS 10),'...If the old style calendar was in use fo'
  (howjulian)[2111+⍳40]←'r a date after 1752, as in Russia',(,⎕UCS 10),'...bef'
  (howjulian)[2151+⍳53]←'ore 1917, the old style calendar must be specified.  '
  (howjulian)[2204+⍳40]←'For example, June',(,⎕UCS 10),'...20, 1900 has a diff'
  (howjulian)[2244+⍳49]←'erent Julian day count in the old style calendar',(,⎕UCS 10)
  (howjulian)[2293+⍳40]←'...compared with the new style.',(,⎕UCS 10),'      ju'
  (howjulian)[2333+⍳25]←'lian 6 20 1900 0',(,⎕UCS 10),'2415204',(,⎕UCS 10)

howloop←1007⍴0 ⍝ prolog ≡1
  (howloop)[⍳60]←'------------------------------------------------------------'
  (howloop)[60+⍳31]←'------------------',(,⎕UCS 10),'loop x',(,⎕UCS 10),'perfo'
  (howloop)[91+⍳49]←'rm computations for each element (or row) of <x>',(,⎕UCS 10)
  (howloop)[140+⍳56]←'--------------------------------------------------------'
  (howloop)[196+⍳38]←'----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howloop)[234+⍳43]←'------------',(,⎕UCS 10),'   <loop> performs programmer-'
  (howloop)[277+⍳46]←'supplied computations for each element in the',(,⎕UCS 10)
  (howloop)[323+⍳56]←'   list <x>.  The function contains the usually-required'
  (howloop)[379+⍳41]←' code for ''looping''',(,⎕UCS 10),'   through every row '
  (howloop)[420+⍳52]←'of a matrix.  One can insert the desired processing',(,⎕UCS 10)
  (howloop)[472+⍳55]←'   statements at the appropriate place in the function.'
  (howloop)[527+⍳42]←(,⎕UCS 10 10),'   <loop> is a ''boilerplate'' function; i'
  (howloop)[569+⍳43]←'t saves the programmer the effort of',(,⎕UCS 10),'   ret'
  (howloop)[612+⍳50]←'rieving and modifying a common piece of APL code.',(,⎕UCS 10)
  (howloop)[662+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howloop)[685+⍳31]←'x>   Vector or matrix',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howloop)[716+⍳43]←'------',(,⎕UCS 10),'   Whatever the programmer codes in '
  (howloop)[759+⍳27]←'the function.',(,⎕UCS 10 10),'Notes:',(,⎕UCS 10),'-----'
  (howloop)[786+⍳46]←(,⎕UCS 10),'   A vector is reshaped to a 1-column matrix,'
  (howloop)[832+⍳43]←' so that individual elements of',(,⎕UCS 10),'   a vector'
  (howloop)[875+⍳56]←' or matrix argument can be referenced uniformly as m[i;]'
  (howloop)[931+⍳22]←'.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howloop)[953+⍳54]←'...Consult the function listing for more information.',(,⎕UCS 10)

howmatacross←2173⍴0 ⍝ prolog ≡1
  (howmatacross)[⍳55]←'-------------------------------------------------------'
  (howmatacross)[55+⍳32]←'-----------------------',(,⎕UCS 10 121 8592),'pw mat'
  (howmatacross)[87+⍳39]←'across m',(,⎕UCS 10),'format matrix <m> in columns a'
  (howmatacross)[126+⍳38]←'cross a page of width <pw>',(,⎕UCS 10),'-----------'
  (howmatacross)[164+⍳51]←'---------------------------------------------------'
  (howmatacross)[215+⍳32]←'----------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howmatacross)[247+⍳38]←'------------',(,⎕UCS 10),'   This function formats '
  (howmatacross)[285+⍳50]←'a matrix <m> so that the rows of <m> are displayed'
  (howmatacross)[335+⍳41]←(,⎕UCS 10),'   in fields across the page (or screen)'
  (howmatacross)[376+⍳38]←' with a minimum of one blank between',(,⎕UCS 10),' '
  (howmatacross)[414+⍳38]←'  each column, like this:',(,⎕UCS 10),'      m[1;] '
  (howmatacross)[452+⍳38]←'    m[2;]     m[3;]   ...',(,⎕UCS 10),'      m[n;] '
  (howmatacross)[490+⍳38]←'    m[n+1;]   m[n+2;] ...',(,⎕UCS 10),'      ..    '
  (howmatacross)[528+⍳36]←'    ..        ..',(,⎕UCS 10 10),'   Note the compan'
  (howmatacross)[564+⍳51]←'ion function <matdown> which formats the data in co'
  (howmatacross)[615+⍳26]←'lumns',(,⎕UCS 10),'   down the page.',(,⎕UCS 10 10),'A'
  (howmatacross)[641+⍳25]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<m>  '
  (howmatacross)[666+⍳36]←' Character matrix',(,⎕UCS 10 10),'<pw>   Numeric sc'
  (howmatacross)[702+⍳38]←'alar',(,⎕UCS 10),'   Width of the page (screen) in '
  (howmatacross)[740+⍳38]←'characters.',(,⎕UCS 10),'   If pw is empty, the def'
  (howmatacross)[778+⍳21]←'ault is ',(,⎕UCS 9109),'pw.',(,⎕UCS 10 10),'Result:'
  (howmatacross)[799+⍳28]←(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Character matr'
  (howmatacross)[827+⍳37]←'ix',(,⎕UCS 10),'   The reformatted version of <m>.'
  (howmatacross)[864+⍳41]←(,⎕UCS 10),'   Note that the width of <y> may be les'
  (howmatacross)[905+⍳38]←'s than <pw>, depending on the data.',(,⎕UCS 10),'  '
  (howmatacross)[943+⍳12]←' (',(,⎕UCS 175 49 8593 9076),'y) ',(,⎕UCS 8804),' p'
  (howmatacross)[955+⍳22]←'w',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howmatacross)[977+⍳36]←'...Define an example matrix:',(,⎕UCS 10),'      m'
  (howmatacross)[1013+⍳13]←(,⎕UCS 8592),'m,[1]m',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710)
  (howmatacross)[1026+⍳49]←'box ''apple/betty/catsanddogs/egg/farm/hen/ben/jac'
  (howmatacross)[1075+⍳36]←'k/box''',(,⎕UCS 10),'...The example matrix has 18 '
  (howmatacross)[1111+⍳17]←'rows.',(,⎕UCS 10),'      ',(,⎕UCS 9076 109 10),'18'
  (howmatacross)[1128+⍳37]←' 11',(,⎕UCS 10),'...Display within a width of 72 c'
  (howmatacross)[1165+⍳19]←'haracters',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 120)
  (howmatacross)[1184+⍳25]←(,⎕UCS 8592),'72 matacross m',(,⎕UCS 10),' apple   '
  (howmatacross)[1209+⍳50]←'    betty       catsanddogs egg         farm      '
  (howmatacross)[1259+⍳37]←'  hen',(,⎕UCS 10),' ben         jack        box   '
  (howmatacross)[1296+⍳42]←'      apple       betty       catsanddogs',(,⎕UCS 10)
  (howmatacross)[1338+⍳50]←' egg         farm        hen         ben         j'
  (howmatacross)[1388+⍳23]←'ack        box',(,⎕UCS 10),'      ',(,⎕UCS 9076 120)
  (howmatacross)[1411+⍳25]←(,⎕UCS 10),'3 72',(,⎕UCS 10 10),'...Note that <mata'
  (howmatacross)[1436+⍳50]←'cross> neither adds nor deletes characters to the '
  (howmatacross)[1486+⍳37]←'matrix,',(,⎕UCS 10),'...except for the single blan'
  (howmatacross)[1523+⍳48]←'k between each field of the display.  To insert',(,⎕UCS 10)
  (howmatacross)[1571+⍳50]←'...more blanks between the columns in the result, '
  (howmatacross)[1621+⍳37]←'append the blanks to the',(,⎕UCS 10),'...argument.'
  (howmatacross)[1658+⍳26]←(,⎕UCS 10),'      72 matacross m,((1',(,⎕UCS 8593)
  (howmatacross)[1684+⍳11]←(,⎕UCS 9076),'m),3)',(,⎕UCS 9076),''' ''',(,⎕UCS 10)
  (howmatacross)[1695+⍳49]←' apple          betty          catsanddogs    egg'
  (howmatacross)[1744+⍳40]←(,⎕UCS 10),' farm           hen            ben     '
  (howmatacross)[1784+⍳37]←'       jack',(,⎕UCS 10),' box            apple    '
  (howmatacross)[1821+⍳37]←'      betty          catsanddogs',(,⎕UCS 10),' egg'
  (howmatacross)[1858+⍳46]←'            farm           hen            ben',(,⎕UCS 10)
  (howmatacross)[1904+⍳35]←' jack           box',(,⎕UCS 10 10),'...<pw> defaul'
  (howmatacross)[1939+⍳25]←'ts to ',(,⎕UCS 9109 112 119 10),'      '''' matacr'
  (howmatacross)[1964+⍳37]←'oss m',(,⎕UCS 10),' apple       betty       catsan'
  (howmatacross)[2001+⍳37]←'ddogs egg         farm        hen',(,⎕UCS 10),' be'
  (howmatacross)[2038+⍳50]←'n         jack        box         apple       bett'
  (howmatacross)[2088+⍳37]←'y       catsanddogs',(,⎕UCS 10),' egg         farm'
  (howmatacross)[2125+⍳48]←'        hen         ben         jack        box',(,⎕UCS 10)

howmatdown←2327⍴0 ⍝ prolog ≡1
  (howmatdown)[⍳57]←'---------------------------------------------------------'
  (howmatdown)[57+⍳34]←'---------------------',(,⎕UCS 10 121 8592),'a matdown '
  (howmatdown)[91+⍳41]←'m',(,⎕UCS 10),'format matrix <m> in columns down a pag'
  (howmatdown)[132+⍳40]←'e according to <a>',(,⎕UCS 10),'---------------------'
  (howmatdown)[172+⍳53]←'-----------------------------------------------------'
  (howmatdown)[225+⍳25]←'----',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-----'
  (howmatdown)[250+⍳40]←'-------',(,⎕UCS 10),'   This function formats a matri'
  (howmatdown)[290+⍳44]←'x <m> so that the rows of <m> are displayed',(,⎕UCS 10)
  (howmatdown)[334+⍳53]←'   in columns down the page (or screen) with a minimu'
  (howmatdown)[387+⍳40]←'m of one blank between',(,⎕UCS 10),'   each column, l'
  (howmatdown)[427+⍳39]←'ike this:',(,⎕UCS 10),'      m[1;]     m[n;]     ...'
  (howmatdown)[466+⍳32]←(,⎕UCS 10),'      m[2;]     m[n+1;]   ...',(,⎕UCS 10),' '
  (howmatdown)[498+⍳40]←'     m[3;]     m[n+2;]   ...',(,⎕UCS 10),'      ..   '
  (howmatdown)[538+⍳40]←'     ..',(,⎕UCS 10),'   The function computes the max'
  (howmatdown)[578+⍳43]←'imum number of columns that can fit across',(,⎕UCS 10)
  (howmatdown)[621+⍳53]←'   the page and then lays out the items in that many '
  (howmatdown)[674+⍳40]←'columns with a minimum',(,⎕UCS 10),'   of one blank b'
  (howmatdown)[714+⍳53]←'etween columns.  This is a useful arrangement that ha'
  (howmatdown)[767+⍳40]←'s',(,⎕UCS 10),'   many applications, for example, for'
  (howmatdown)[807+⍳40]←'matting telephone books and',(,⎕UCS 10),'   similar l'
  (howmatdown)[847+⍳38]←'ists.',(,⎕UCS 10 10),'   Note the companion function '
  (howmatdown)[885+⍳45]←'<matacross> that formats the data in columns',(,⎕UCS 10)
  (howmatdown)[930+⍳38]←'   reading across the page.',(,⎕UCS 10 10),'Arguments'
  (howmatdown)[968+⍳25]←':',(,⎕UCS 10),'---------',(,⎕UCS 10),'<m>   Matrix',(,⎕UCS 10)
  (howmatdown)[993+⍳33]←(,⎕UCS 10),'<a>   2-element numeric vector',(,⎕UCS 10),' '
  (howmatdown)[1026+⍳52]←'  a[1] = Width of the page (screen) in characters.  '
  (howmatdown)[1078+⍳24]←'(Default = ',(,⎕UCS 9109),'pw)',(,⎕UCS 10),'   a[2] '
  (howmatdown)[1102+⍳41]←'= Spaces between columns.  (Default = 1)',(,⎕UCS 10)
  (howmatdown)[1143+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howmatdown)[1160+⍳39]←'y>   Character matrix',(,⎕UCS 10),'   The reformatte'
  (howmatdown)[1199+⍳39]←'d version of <m>.',(,⎕UCS 10),'   Note that the widt'
  (howmatdown)[1238+⍳52]←'h of <y> may be less than <a[1]>, depending on the d'
  (howmatdown)[1290+⍳15]←'ata.',(,⎕UCS 10),'   (',(,⎕UCS 175 49 8593 9076),'y)'
  (howmatdown)[1305+⍳19]←' ',(,⎕UCS 8804),' a[1]',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howmatdown)[1324+⍳38]←'--------',(,⎕UCS 10),'...Define an example matrix:',(,⎕UCS 10)
  (howmatdown)[1362+⍳19]←'      m',(,⎕UCS 8592),'m,[1]m',(,⎕UCS 8592),'''/'' '
  (howmatdown)[1381+⍳39]←(,⎕UCS 8710),'box ''apple/betty/catsanddogs/egg/farm/'
  (howmatdown)[1420+⍳38]←'hen/ben/jack/box''',(,⎕UCS 10),'...The example matri'
  (howmatdown)[1458+⍳23]←'x has 18 rows.',(,⎕UCS 10),'      ',(,⎕UCS 9076 109)
  (howmatdown)[1481+⍳29]←(,⎕UCS 10),'18 11',(,⎕UCS 10),'...Display within a wi'
  (howmatdown)[1510+⍳28]←'dth of 72 characters',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howmatdown)[1538+⍳20]←(,⎕UCS 8592 120 8592),'72 matdown m',(,⎕UCS 10),'appl'
  (howmatdown)[1558+⍳52]←'e       egg         ben         apple       egg     '
  (howmatdown)[1610+⍳39]←'    ben',(,⎕UCS 10),'betty       farm        jack   '
  (howmatdown)[1649+⍳39]←'     betty       farm        jack',(,⎕UCS 10),'catsa'
  (howmatdown)[1688+⍳52]←'nddogs hen         box         catsanddogs hen      '
  (howmatdown)[1740+⍳19]←'   box',(,⎕UCS 10),'      ',(,⎕UCS 9076 120 10),'3 7'
  (howmatdown)[1759+⍳37]←'1',(,⎕UCS 10 10),'...To insert more blanks between t'
  (howmatdown)[1796+⍳42]←'he columns in the result, specify in the',(,⎕UCS 10),'.'
  (howmatdown)[1838+⍳38]←'..left argument.',(,⎕UCS 10),'      72 3 matdown m',(,⎕UCS 10)
  (howmatdown)[1876+⍳52]←'apple         farm          box           egg       '
  (howmatdown)[1928+⍳39]←'    jack',(,⎕UCS 10),'betty         hen           ap'
  (howmatdown)[1967+⍳39]←'ple         farm          box',(,⎕UCS 10),'catsanddo'
  (howmatdown)[2006+⍳39]←'gs   ben           betty         hen',(,⎕UCS 10),'eg'
  (howmatdown)[2045+⍳44]←'g           jack          catsanddogs   ben',(,⎕UCS 10)
  (howmatdown)[2089+⍳26]←(,⎕UCS 10),'...<a> defaults to ',(,⎕UCS 9109),'pw,1',(,⎕UCS 10)
  (howmatdown)[2115+⍳37]←'      '''' matdown m',(,⎕UCS 10),'apple       egg   '
  (howmatdown)[2152+⍳46]←'      ben         apple       egg         ben',(,⎕UCS 10)
  (howmatdown)[2198+⍳52]←'betty       farm        jack        betty       farm'
  (howmatdown)[2250+⍳39]←'        jack',(,⎕UCS 10),'catsanddogs hen         bo'
  (howmatdown)[2289+⍳38]←'x         catsanddogs hen         box',(,⎕UCS 10)

howmatrix←908⍴0 ⍝ prolog ≡1
  (howmatrix)[⍳58]←'----------------------------------------------------------'
  (howmatrix)[58+⍳32]←'--------------------',(,⎕UCS 10 121 8592),'matrix x',(,⎕UCS 10)
  (howmatrix)[90+⍳47]←'reshape any array <x> (rank 0 - n) to a matrix',(,⎕UCS 10)
  (howmatrix)[137+⍳54]←'------------------------------------------------------'
  (howmatrix)[191+⍳39]←'------------------------',(,⎕UCS 10 10),'Introduction:'
  (howmatrix)[230+⍳31]←(,⎕UCS 10),'------------',(,⎕UCS 10),'   <matrix> retur'
  (howmatrix)[261+⍳53]←'ns the matrix equivalent of an array <x> of any rank.'
  (howmatrix)[314+⍳42]←(,⎕UCS 10 10),'   The algorithm in <matrix> is short en'
  (howmatrix)[356+⍳41]←'ough to be used directly (refer to',(,⎕UCS 10),'   the'
  (howmatrix)[397+⍳54]←' function listing), but <matrix> is still useful to ha'
  (howmatrix)[451+⍳26]←'ve defined.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'--'
  (howmatrix)[477+⍳28]←'-------',(,⎕UCS 10),'<x>   Array',(,⎕UCS 10),'   Note '
  (howmatrix)[505+⍳50]←'that <x> can be numeric or character of any rank.',(,⎕UCS 10)
  (howmatrix)[555+⍳18]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y'
  (howmatrix)[573+⍳41]←'>   Matrix',(,⎕UCS 10),'   The argument <x> reshaped t'
  (howmatrix)[614+⍳26]←'o a matrix.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'---'
  (howmatrix)[640+⍳23]←'-----',(,⎕UCS 10),'...scalar',(,⎕UCS 10),'      ',(,⎕UCS 9076)
  (howmatrix)[663+⍳15]←(,⎕UCS 109 8592),'matrix 2',(,⎕UCS 10),'1 1',(,⎕UCS 10)
  (howmatrix)[678+⍳18]←(,⎕UCS 10),'...vector',(,⎕UCS 10),'      ',(,⎕UCS 9076)
  (howmatrix)[696+⍳21]←(,⎕UCS 109 8592),'matrix ''apple''',(,⎕UCS 10),'1 5',(,⎕UCS 10)
  (howmatrix)[717+⍳18]←(,⎕UCS 10),'...matrix',(,⎕UCS 10),'      ',(,⎕UCS 9076)
  (howmatrix)[735+⍳19]←(,⎕UCS 109 8592),'matrix 3 4',(,⎕UCS 9076 52 10),'3 4',(,⎕UCS 10)
  (howmatrix)[754+⍳24]←(,⎕UCS 10),'...rank-3 array',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howmatrix)[778+⍳18]←(,⎕UCS 8592 109 8592),'matrix 2 2 2',(,⎕UCS 9076 9075 56)
  (howmatrix)[796+⍳13]←(,⎕UCS 10),'1 2',(,⎕UCS 10),'3 4',(,⎕UCS 10),'5 6',(,⎕UCS 10)
  (howmatrix)[809+⍳17]←'7 8',(,⎕UCS 10),'      ',(,⎕UCS 9076 109 10),'4 2',(,⎕UCS 10)
  (howmatrix)[826+⍳24]←(,⎕UCS 10),'...empty vector',(,⎕UCS 10),'      ',(,⎕UCS 9076)
  (howmatrix)[850+⍳16]←(,⎕UCS 109 8592),'matrix ''''',(,⎕UCS 10),'1 0',(,⎕UCS 10)
  (howmatrix)[866+⍳24]←'...empty matrix',(,⎕UCS 10),'      ',(,⎕UCS 9076 109)
  (howmatrix)[890+⍳18]←(,⎕UCS 8592),'matrix 2 0',(,⎕UCS 9076 48 10),'2 0',(,⎕UCS 10)

howmdyoford←1362⍴0 ⍝ prolog ≡1
  (howmdyoford)[⍳56]←'--------------------------------------------------------'
  (howmdyoford)[56+⍳33]←'----------------------',(,⎕UCS 10 114 8592),'mdyoford'
  (howmdyoford)[89+⍳40]←' x',(,⎕UCS 10),'compute the (mm dd yyyy) format for o'
  (howmdyoford)[129+⍳39]←'rdinal dates <x>',(,⎕UCS 10),'----------------------'
  (howmdyoford)[168+⍳52]←'----------------------------------------------------'
  (howmdyoford)[220+⍳24]←'----',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'----'
  (howmdyoford)[244+⍳39]←'--------',(,⎕UCS 10),'   <mdyoford> computes the (mm'
  (howmdyoford)[283+⍳43]←' dd yyyy) format for the date <x> given in',(,⎕UCS 10)
  (howmdyoford)[326+⍳37]←'   ordinal format.',(,⎕UCS 10 10),'   This function '
  (howmdyoford)[363+⍳51]←'is the inverse of <ordofmdy>.  For a definition of '
  (howmdyoford)[414+⍳37]←'''ordinal''',(,⎕UCS 10),'   format, see examples, or'
  (howmdyoford)[451+⍳37]←' the document on <ordofmdy>.',(,⎕UCS 10 10),'Argumen'
  (howmdyoford)[488+⍳26]←'ts:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<x>   Numeri'
  (howmdyoford)[514+⍳39]←'c vector',(,⎕UCS 10),'   <x> is a vector of dates in'
  (howmdyoford)[553+⍳27]←' ordinal format.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howmdyoford)[580+⍳30]←'-----',(,⎕UCS 10),'<r>   Numeric matrix (n',(,⎕UCS 215)
  (howmdyoford)[610+⍳25]←(,⎕UCS 51 41 10),'   r[;1] = month',(,⎕UCS 10),'   r['
  (howmdyoford)[635+⍳27]←';2] = day',(,⎕UCS 10),'   r[;3] = year',(,⎕UCS 10 10)
  (howmdyoford)[662+⍳25]←'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      '
  (howmdyoford)[687+⍳14]←(,⎕UCS 9109 8592 109 8592),'5 3',(,⎕UCS 9076),'5 12 1'
  (howmdyoford)[701+⍳45]←'988 6 20 1947 12 8 1984 1 23 1950 12 31 1992',(,⎕UCS 10)
  (howmdyoford)[746+⍳30]←'   5   12 1988',(,⎕UCS 10),'   6   20 1947',(,⎕UCS 10)
  (howmdyoford)[776+⍳30]←'  12    8 1984',(,⎕UCS 10),'   1   23 1950',(,⎕UCS 10)
  (howmdyoford)[806+⍳39]←'  12   31 1992',(,⎕UCS 10),'...Compute ordinal forms'
  (howmdyoford)[845+⍳37]←' of these dates.',(,⎕UCS 10),'      m, ordofmdy m',(,⎕UCS 10)
  (howmdyoford)[882+⍳39]←'    5    12  1988 88133',(,⎕UCS 10),'    6    20  19'
  (howmdyoford)[921+⍳33]←'47 47171',(,⎕UCS 10),'   12     8  1984 84343',(,⎕UCS 10)
  (howmdyoford)[954+⍳39]←'    1    23  1950 50023',(,⎕UCS 10),'   12    31  19'
  (howmdyoford)[993+⍳39]←'92 92366',(,⎕UCS 10),'...<mdyoford> is the inverse o'
  (howmdyoford)[1032+⍳38]←'f <ordofmdy>.',(,⎕UCS 10),'      mdyoford ordofmdy '
  (howmdyoford)[1070+⍳25]←'m',(,⎕UCS 10),'   5   12 1988',(,⎕UCS 10),'   6   2'
  (howmdyoford)[1095+⍳25]←'0 1947',(,⎕UCS 10),'  12    8 1984',(,⎕UCS 10),'   '
  (howmdyoford)[1120+⍳27]←'1   23 1950',(,⎕UCS 10),'  12   31 1992',(,⎕UCS 10)
  (howmdyoford)[1147+⍳39]←(,⎕UCS 10),'...Leap years are taken into account.',(,⎕UCS 10)
  (howmdyoford)[1186+⍳40]←'      mdyoford 91059 91060 92059 92060',(,⎕UCS 10),' '
  (howmdyoford)[1226+⍳29]←'  2   28 1991',(,⎕UCS 10),'   3    1 1991',(,⎕UCS 10)
  (howmdyoford)[1255+⍳30]←'   2   28 1992',(,⎕UCS 10),'   2   29 1992',(,⎕UCS 10)
  (howmdyoford)[1285+⍳51]←'...The 60-th day of 1991 was March 1; the 60-th day'
  (howmdyoford)[1336+⍳26]←' of 1992 was February 29.',(,⎕UCS 10)

howmoonphase←1705⍴0 ⍝ prolog ≡1
  (howmoonphase)[⍳55]←'-------------------------------------------------------'
  (howmoonphase)[55+⍳32]←'-----------------------',(,⎕UCS 10 114 8592),'moonph'
  (howmoonphase)[87+⍳39]←'ase d',(,⎕UCS 10),'compute phase of moon <r> for dat'
  (howmoonphase)[126+⍳38]←'es <d> = (mm dd yyyy style)',(,⎕UCS 10),'----------'
  (howmoonphase)[164+⍳51]←'---------------------------------------------------'
  (howmoonphase)[215+⍳33]←'-----------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howmoonphase)[248+⍳38]←'------------',(,⎕UCS 10),'   <moonphase> computes t'
  (howmoonphase)[286+⍳49]←'he phase of the moon <r> for the dates <d>.  The',(,⎕UCS 10)
  (howmoonphase)[335+⍳51]←'   phase of the moon is indicated by a number in th'
  (howmoonphase)[386+⍳27]←'e range (0,1).',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howmoonphase)[413+⍳38]←'---------',(,⎕UCS 10),'<d>   3-element numeric vect'
  (howmoonphase)[451+⍳23]←'or, or n',(,⎕UCS 215),'3 or n',(,⎕UCS 215),'4 matri'
  (howmoonphase)[474+⍳38]←'x',(,⎕UCS 10),'   A 3-element vector is treated as '
  (howmoonphase)[512+⍳24]←'a 1',(,⎕UCS 215),'3 matrix.',(,⎕UCS 10),'   d[;1] ='
  (howmoonphase)[536+⍳38]←' month (1 to 12)',(,⎕UCS 10),'   d[;2] = day (1 to '
  (howmoonphase)[574+⍳25]←'31)',(,⎕UCS 10),'   d[;3] = year',(,⎕UCS 10),'   d['
  (howmoonphase)[599+⍳38]←';4] = style of calendar (optional)',(,⎕UCS 10),'   '
  (howmoonphase)[637+⍳38]←'           0 = old style',(,⎕UCS 10),'             '
  (howmoonphase)[675+⍳38]←' 1 = new style',(,⎕UCS 10),'   Note that this argum'
  (howmoonphase)[713+⍳51]←'ent is the argument required by <julian>, since thi'
  (howmoonphase)[764+⍳38]←'s',(,⎕UCS 10),'   is the function used by <moonphas'
  (howmoonphase)[802+⍳39]←'e> to compute the phase of the moon.',(,⎕UCS 10 10),'R'
  (howmoonphase)[841+⍳25]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   Vecto'
  (howmoonphase)[866+⍳38]←'r',(,⎕UCS 10),'   r[i] is the phase of the moon for'
  (howmoonphase)[904+⍳41]←' each date d[i].  <r> is a number in the',(,⎕UCS 10)
  (howmoonphase)[945+⍳51]←'   range (0,1).  0 is new moon, .5 is full moon, .7'
  (howmoonphase)[996+⍳33]←'5 is last quarter, etc.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howmoonphase)[1029+⍳37]←'------',(,⎕UCS 10),'   Adapted from The APL Handbo'
  (howmoonphase)[1066+⍳35]←'ok of Techniques, IBM, 1978.',(,⎕UCS 10 10),'Examp'
  (howmoonphase)[1101+⍳24]←'les:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...Phase o'
  (howmoonphase)[1125+⍳37]←'f the moon for various dates:',(,⎕UCS 10),'      m'
  (howmoonphase)[1162+⍳35]←'oonphase 3 3',(,⎕UCS 9076),'12 8 1984 6 20 1947 1 '
  (howmoonphase)[1197+⍳37]←'23 1950',(,⎕UCS 10),'0.515746553 0.06411893564 0.1'
  (howmoonphase)[1234+⍳35]←'664236983',(,⎕UCS 10 10),'...Phase of the moon for'
  (howmoonphase)[1269+⍳34]←' various dates of Easter:',(,⎕UCS 10),'      m',(,⎕UCS 8592)
  (howmoonphase)[1303+⍳29]←'easter 1986+',(,⎕UCS 9075 49 48 10),'      m,3 rnd'
  (howmoonphase)[1332+⍳37]←' moonphase m',(,⎕UCS 10),'   4       19     1987  '
  (howmoonphase)[1369+⍳37]←'      0.706',(,⎕UCS 10),'   4        3     1988   '
  (howmoonphase)[1406+⍳37]←'     0.558',(,⎕UCS 10),'   3       26     1989    '
  (howmoonphase)[1443+⍳37]←'    0.647',(,⎕UCS 10),'   4       15     1990     '
  (howmoonphase)[1480+⍳37]←'   0.684',(,⎕UCS 10),'   4       31     1991      '
  (howmoonphase)[1517+⍳37]←'  0.586',(,⎕UCS 10),'   4       19     1992       '
  (howmoonphase)[1554+⍳37]←' 0.574',(,⎕UCS 10),'   4       11     1993        '
  (howmoonphase)[1591+⍳37]←'0.663',(,⎕UCS 10),'   4        3     1994        0'
  (howmoonphase)[1628+⍳37]←'.752',(,⎕UCS 10),'   4       16     1995        0.'
  (howmoonphase)[1665+⍳37]←'552',(,⎕UCS 10),'   4        7     1996        0.6'
  (howmoonphase)[1702+⍳3]←'42',(,⎕UCS 10)

hownl←2348⍴0 ⍝ prolog ≡1
  (hownl)[⍳62]←'--------------------------------------------------------------'
  (hownl)[62+⍳31]←'----------------',(,⎕UCS 10),'Nly',(,⎕UCS 8592),'Nls nl Nlc'
  (hownl)[93+⍳49]←(,⎕UCS 10),'namelist of functions or variables <Nlc> within '
  (hownl)[142+⍳45]←'specification <Nls>',(,⎕UCS 10),'-------------------------'
  (hownl)[187+⍳54]←'-----------------------------------------------------',(,⎕UCS 10)
  (hownl)[241+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (hownl)[269+⍳58]←'   <nl> lists the names of variables and functions within '
  (hownl)[327+⍳45]←'the workspace.  It',(,⎕UCS 10),'   provides extensive name'
  (hownl)[372+⍳49]←' specifications for the search argument (such as',(,⎕UCS 10)
  (hownl)[421+⍳56]←'   ''wild card'' specification), and the option for output'
  (hownl)[477+⍳45]←' in compressed',(,⎕UCS 10),'   format.  <nl> uses the syst'
  (hownl)[522+⍳41]←'em function ',(,⎕UCS 9109),'nl, and has similar syntax.',(,⎕UCS 10)
  (hownl)[563+⍳48]←(,⎕UCS 10),'   <nl> is a useful tool for recalling names of'
  (hownl)[611+⍳45]←' particular functions or',(,⎕UCS 10),'   variables, and pr'
  (hownl)[656+⍳57]←'omotes the use of standardized names within a workspace.',(,⎕UCS 10)
  (hownl)[713+⍳57]←'   It is often a preferred alternative to )fns or )vars.',(,⎕UCS 10)
  (hownl)[770+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (hownl)[793+⍳45]←'s>   Character scalar or vector',(,⎕UCS 10),'   <s> determ'
  (hownl)[838+⍳58]←'ines the names selected in the result.  <s> contains one o'
  (hownl)[896+⍳45]←'r more',(,⎕UCS 10),'   search specifications, separated by'
  (hownl)[941+⍳45]←' blanks, chosen from the following set',(,⎕UCS 10),'   (x '
  (hownl)[986+⍳45]←'and y stand for one or more non-blanks):',(,⎕UCS 10),'    '
  (hownl)[1031+⍳21]←'  x    x',(,⎕UCS 8902),'    ',(,⎕UCS 8902),'x    x',(,⎕UCS 8902)
  (hownl)[1052+⍳18]←'y    ',(,⎕UCS 8902 120 8902),'    ',(,⎕UCS 8902 10),'    '
  (hownl)[1070+⍳44]←'  -    x-y    x-   -y',(,⎕UCS 10),'   For a more complete'
  (hownl)[1114+⍳51]←' description of these specifications, refer to the',(,⎕UCS 10)
  (hownl)[1165+⍳57]←'   documents on <range> and <wildcard>.  In addition, a t'
  (hownl)[1222+⍳29]←'ilde (',(,⎕UCS 8764),') can be',(,⎕UCS 10),'   placed in '
  (hownl)[1251+⍳43]←'front of any specification in <s> (e.g.  ',(,⎕UCS 8764 102)
  (hownl)[1294+⍳32]←(,⎕UCS 8902),') to specify to',(,⎕UCS 10),'   ignore names'
  (hownl)[1326+⍳42]←' within that search range.',(,⎕UCS 10 10),'<n>   Numeric '
  (hownl)[1368+⍳44]←'scalar or vector',(,⎕UCS 10),'   <|n> must be a valid arg'
  (hownl)[1412+⍳41]←'ument to ',(,⎕UCS 9109),'nl.  For example, 2 stands for',(,⎕UCS 10)
  (hownl)[1453+⍳57]←'   variables, 2 3 stands for variables and functions, etc'
  (hownl)[1510+⍳44]←'.  Negative <n>',(,⎕UCS 10),'   specifies that the output'
  (hownl)[1554+⍳35]←' be in compressed format.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (hownl)[1589+⍳31]←'------',(,⎕UCS 10),'<y>   Character matrix',(,⎕UCS 10),' '
  (hownl)[1620+⍳57]←'  The result <y> is a sorted matrix of names determined b'
  (hownl)[1677+⍳44]←'y the search',(,⎕UCS 10),'   specification in the argumen'
  (hownl)[1721+⍳42]←'t <s>.',(,⎕UCS 10 10),'   If <n> is positive, the result '
  (hownl)[1763+⍳44]←'is in standard format (a matrix with one',(,⎕UCS 10),'   '
  (hownl)[1807+⍳57]←'name per row).  If any element of <n> is negative (e.g.  '
  (hownl)[1864+⍳33]←(,⎕UCS 175),'3 or -2 3) the',(,⎕UCS 10),'   output is in c'
  (hownl)[1897+⍳56]←'ompressed format (several rows of names, each no longer',(,⎕UCS 10)
  (hownl)[1953+⍳25]←'   than ',(,⎕UCS 9109),'pw).',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (hownl)[1978+⍳43]←'--------',(,⎕UCS 10),'...Function names starting with ''a'
  (hownl)[2021+⍳20]←'r''',(,⎕UCS 10),'      ''ar',(,⎕UCS 8902),''' nl 3',(,⎕UCS 10)
  (hownl)[2041+⍳29]←'arabic',(,⎕UCS 10),'array',(,⎕UCS 10 10),'...All variable'
  (hownl)[2070+⍳34]←' names starting with ''g',(,⎕UCS 8710 39 46 10),'      '''
  (hownl)[2104+⍳17]←'g',(,⎕UCS 8710 8902),''' nl 2',(,⎕UCS 10 103 8710),'cpuco'
  (hownl)[2121+⍳13]←'n',(,⎕UCS 8710 111 116 10 103 8710 99 114 10 103 8710),'s'
  (hownl)[2134+⍳18]←'ectoday',(,⎕UCS 8710 111 116 10 103 8710),'sort',(,⎕UCS 8710)
  (hownl)[2152+⍳40]←(,⎕UCS 99 115 10 10),'...All variables from g to h except '
  (hownl)[2192+⍳42]←'those starting with ''how''.',(,⎕UCS 10),'...Use compress'
  (hownl)[2234+⍳43]←'ed format (negative right argument).',(,⎕UCS 10),'      '
  (hownl)[2277+⍳16]←'''g-h ',(,⎕UCS 8764),'how',(,⎕UCS 8902),''' nl ',(,⎕UCS 175)
  (hownl)[2293+⍳18]←(,⎕UCS 50 10 32 103 8710),'cpucon',(,⎕UCS 8710),'ot   g'
  (hownl)[2311+⍳24]←(,⎕UCS 8710),'cr          g',(,⎕UCS 8710),'sectoday',(,⎕UCS 8710)
  (hownl)[2335+⍳13]←'ot g',(,⎕UCS 8710),'sort',(,⎕UCS 8710 99 115 10)

howon←1101⍴0 ⍝ prolog ≡1
  (howon)[⍳62]←'--------------------------------------------------------------'
  (howon)[62+⍳27]←'----------------',(,⎕UCS 10 121 8592),'a on b',(,⎕UCS 10),'c'
  (howon)[89+⍳59]←'atenate array <a> to array <b> (maximum rank 2) on first co'
  (howon)[148+⍳45]←'ordinate',(,⎕UCS 10),'------------------------------------'
  (howon)[193+⍳45]←'------------------------------------------',(,⎕UCS 10 10),'I'
  (howon)[238+⍳32]←'ntroduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   Thi'
  (howon)[270+⍳58]←'s function is similar to <beside> except that <on> catenat'
  (howon)[328+⍳41]←'es along the',(,⎕UCS 10),'   first coordinate (rows).',(,⎕UCS 10)
  (howon)[369+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howon)[392+⍳42]←'a>   Array (rank',(,⎕UCS 8804),'2), numeric or character',(,⎕UCS 10)
  (howon)[434+⍳28]←(,⎕UCS 10),'<b>   Same as <a>',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howon)[462+⍳32]←'------',(,⎕UCS 10),'<y>   Matrix',(,⎕UCS 10),'   The resul'
  (howon)[494+⍳58]←'t consists of <a> catenated to <b> along the first coordin'
  (howon)[552+⍳45]←'ate.',(,⎕UCS 10),'   If an argument is a scalar or vector,'
  (howon)[597+⍳45]←' it is first reshaped to a one-row',(,⎕UCS 10),'   matrix.'
  (howon)[642+⍳58]←'  The number of rows in <y> is the sum of the number of ro'
  (howon)[700+⍳45]←'ws in',(,⎕UCS 10),'   each argument, after reshaping, that'
  (howon)[745+⍳20]←' is, (1',(,⎕UCS 8593 9076),'y) = (1',(,⎕UCS 8593 9076),'a)'
  (howon)[765+⍳20]←'+(1',(,⎕UCS 8593 9076 98 41 10 10),'Examples:',(,⎕UCS 10),'-'
  (howon)[785+⍳23]←'-------',(,⎕UCS 10),'      v',(,⎕UCS 8592),'''aaaa''',(,⎕UCS 10)
  (howon)[808+⍳16]←'      m',(,⎕UCS 8592),'2 2',(,⎕UCS 9076),'''b''',(,⎕UCS 10)
  (howon)[824+⍳24]←'      v on m',(,⎕UCS 10),'aaaa',(,⎕UCS 10 98 98 10 98 98 10)
  (howon)[848+⍳26]←'      (3 3',(,⎕UCS 9076 39 8902),''') on m on v',(,⎕UCS 10)
  (howon)[874+⍳12]←(,⎕UCS 8902 8902 8902 10 8902 8902 8902 10 8902 8902 8902 10)
  (howon)[886+⍳23]←(,⎕UCS 98 98 10 98 98 10),'aaaa',(,⎕UCS 10 10),'      10 20'
  (howon)[909+⍳29]←' 30 40 on 3 3',(,⎕UCS 9076 53 10),'10 20 30 40',(,⎕UCS 10),' '
  (howon)[938+⍳32]←'5  5  5  0',(,⎕UCS 10),' 5  5  5  0',(,⎕UCS 10),' 5  5  5 '
  (howon)[970+⍳43]←' 0',(,⎕UCS 10 10),'..... Note a difference between <on> an'
  (howon)[1013+⍳42]←'d the APL catenate function',(,⎕UCS 10),'      ''a'' on 2'
  (howon)[1055+⍳14]←' 2',(,⎕UCS 9076 39 8902 39 10 97 10 8902 8902 10 8902 8902)
  (howon)[1069+⍳23]←(,⎕UCS 10),'      ''a'',[1] 2 2',(,⎕UCS 9076 39 8902 39 10)
  (howon)[1092+⍳9]←(,⎕UCS 97 97 10 8902 8902 10 8902 8902 10)

howordofmdy←1973⍴0 ⍝ prolog ≡1
  (howordofmdy)[⍳56]←'--------------------------------------------------------'
  (howordofmdy)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'ordofmdy'
  (howordofmdy)[89+⍳40]←' d',(,⎕UCS 10),'compute the ordinal format for dates '
  (howordofmdy)[129+⍳39]←'<d> = (mm dd yyyy)',(,⎕UCS 10),'--------------------'
  (howordofmdy)[168+⍳52]←'----------------------------------------------------'
  (howordofmdy)[220+⍳24]←'------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'--'
  (howordofmdy)[244+⍳39]←'----------',(,⎕UCS 10),'   <ordofmdy> computes the o'
  (howordofmdy)[283+⍳45]←'rdinal format for a date <d> given in (mm dd',(,⎕UCS 10)
  (howordofmdy)[328+⍳37]←'   yyyy) format.',(,⎕UCS 10 10),'   The ordinal form'
  (howordofmdy)[365+⍳52]←'at is the 2-digit year representation followed by th'
  (howordofmdy)[417+⍳39]←'e day',(,⎕UCS 10),'   number within the year, that i'
  (howordofmdy)[456+⍳41]←'s, a number in the range 1 to 366.  For',(,⎕UCS 10),' '
  (howordofmdy)[497+⍳52]←'  example, the ordinal form of 6 20 1947 (June 20, 1'
  (howordofmdy)[549+⍳39]←'947) is 47171, the',(,⎕UCS 10),'   171-st day of 194'
  (howordofmdy)[588+⍳42]←'7.  The function accounts for leap years.',(,⎕UCS 10)
  (howordofmdy)[630+⍳42]←(,⎕UCS 10),'   The inverse of <ordofmdy> is <mdyoford'
  (howordofmdy)[672+⍳24]←'>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------'
  (howordofmdy)[696+⍳37]←(,⎕UCS 10),'<d>   3-element numeric vector or n',(,⎕UCS 215)
  (howordofmdy)[733+⍳39]←'3 numeric matrix',(,⎕UCS 10),'   A vector is treated'
  (howordofmdy)[772+⍳25]←' as a 1',(,⎕UCS 215),'3 matrix.',(,⎕UCS 10),'   d[;1'
  (howordofmdy)[797+⍳26]←'] = month',(,⎕UCS 10),'   d[;2] = day',(,⎕UCS 10),' '
  (howordofmdy)[823+⍳25]←'  d[;3] = year',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howordofmdy)[848+⍳28]←'-----',(,⎕UCS 10),'<x>   numeric vector',(,⎕UCS 10),' '
  (howordofmdy)[876+⍳52]←'  <x> is the vector of ordinal dates corresponding t'
  (howordofmdy)[928+⍳24]←'o <d>.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'------'
  (howordofmdy)[952+⍳15]←'--',(,⎕UCS 10),'      m',(,⎕UCS 8592),'3 3',(,⎕UCS 9076)
  (howordofmdy)[967+⍳39]←'6 20 1947 12 8 1984 1 23 1950',(,⎕UCS 10),'      m,o'
  (howordofmdy)[1006+⍳34]←'rdofmdy m',(,⎕UCS 10),'    6    20  1947 47171',(,⎕UCS 10)
  (howordofmdy)[1040+⍳38]←'   12     8  1984 84343',(,⎕UCS 10),'    1    23  1'
  (howordofmdy)[1078+⍳36]←'950 50023',(,⎕UCS 10 10),'...Leap years are taken i'
  (howordofmdy)[1114+⍳51]←'nto account.  Note the difference of 2 days between'
  (howordofmdy)[1165+⍳41]←(,⎕UCS 10),'... 2 28 1988 and 3 1 1988, because 1988'
  (howordofmdy)[1206+⍳26]←' was a leap year.',(,⎕UCS 10),'      m',(,⎕UCS 8592)
  (howordofmdy)[1232+⍳36]←'4 3',(,⎕UCS 9076),'2 28 1987 3 1 1987 2 28 1988 3 1'
  (howordofmdy)[1268+⍳26]←' 1988',(,⎕UCS 10),'      m,ordofmdy m',(,⎕UCS 10),' '
  (howordofmdy)[1294+⍳38]←'   2    28  1987 87059',(,⎕UCS 10),'    3     1  19'
  (howordofmdy)[1332+⍳33]←'87 87060',(,⎕UCS 10),'    2    28  1988 88059',(,⎕UCS 10)
  (howordofmdy)[1365+⍳36]←'    3     1  1988 88061',(,⎕UCS 10 10),'...Compute '
  (howordofmdy)[1401+⍳51]←'the ordinal format of the date 200 days from June 2'
  (howordofmdy)[1452+⍳38]←'0, 1988?',(,⎕UCS 10),'...Convert to Gregorian day c'
  (howordofmdy)[1490+⍳43]←'ount, add 200, then convert back to (mm dd',(,⎕UCS 10)
  (howordofmdy)[1533+⍳46]←'...yyyy) format and compute the ordinal form.',(,⎕UCS 10)
  (howordofmdy)[1579+⍳28]←'      days 6 20 1988',(,⎕UCS 10),'725908',(,⎕UCS 10)
  (howordofmdy)[1607+⍳32]←'      200+days 6 20 1988',(,⎕UCS 10),'726108',(,⎕UCS 10)
  (howordofmdy)[1639+⍳38]←'      cdays 200 + days 6 20 1988',(,⎕UCS 10),'   1 '
  (howordofmdy)[1677+⍳38]←'   6 1989',(,⎕UCS 10),'      ordofmdy cdays 200 + d'
  (howordofmdy)[1715+⍳25]←'ays 6 20 1988',(,⎕UCS 10),'89006',(,⎕UCS 10),'...Th'
  (howordofmdy)[1740+⍳37]←'e answer is, the 6-th day of 1989.',(,⎕UCS 10 10),'.'
  (howordofmdy)[1777+⍳51]←'..Note.  The answer is the same using Julian day co'
  (howordofmdy)[1828+⍳38]←'unts, but it is easier to',(,⎕UCS 10),'...use Grego'
  (howordofmdy)[1866+⍳51]←'rian day counts because calendar style is unnecessa'
  (howordofmdy)[1917+⍳23]←'ry.',(,⎕UCS 10),'      ordofmdy 3',(,⎕UCS 9076),'cj'
  (howordofmdy)[1940+⍳33]←'ulian 200+julian 6 20 1988',(,⎕UCS 10),'89006',(,⎕UCS 10)

howout←337⍴0 ⍝ prolog ≡1
  (howout)[⍳61]←'-------------------------------------------------------------'
  (howout)[61+⍳32]←'-----------------',(,⎕UCS 10),'out x',(,⎕UCS 10),'put text'
  (howout)[93+⍳45]←' <x> to output device',(,⎕UCS 10),'-----------------------'
  (howout)[138+⍳56]←'-------------------------------------------------------',(,⎕UCS 10)
  (howout)[194+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howout)[222+⍳57]←'   <out> is one of the core toolkit functions for output.'
  (howout)[279+⍳45]←(,⎕UCS 10 10),'   For more details, refer to the document '
  (howout)[324+⍳13]←'on <report>.',(,⎕UCS 10)

howoutclose←335⍴0 ⍝ prolog ≡1
  (howoutclose)[⍳56]←'--------------------------------------------------------'
  (howoutclose)[56+⍳32]←'----------------------',(,⎕UCS 10),'outclose',(,⎕UCS 10)
  (howoutclose)[88+⍳40]←'close output device',(,⎕UCS 10),'--------------------'
  (howoutclose)[128+⍳52]←'----------------------------------------------------'
  (howoutclose)[180+⍳24]←'------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'--'
  (howoutclose)[204+⍳39]←'----------',(,⎕UCS 10),'   <outclose> is one of the '
  (howoutclose)[243+⍳37]←'core toolkit functions for output.',(,⎕UCS 10 10),' '
  (howoutclose)[280+⍳52]←'  For more details, refer to the document on <report'
  (howoutclose)[332+⍳3]←'>.',(,⎕UCS 10)

howoutheader←309⍴0 ⍝ prolog ≡1
  (howoutheader)[⍳55]←'-------------------------------------------------------'
  (howoutheader)[55+⍳34]←'-----------------------',(,⎕UCS 10),'outheader',(,⎕UCS 10)
  (howoutheader)[89+⍳39]←'print header',(,⎕UCS 10),'--------------------------'
  (howoutheader)[128+⍳51]←'---------------------------------------------------'
  (howoutheader)[179+⍳23]←'-',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'------'
  (howoutheader)[202+⍳38]←'------',(,⎕UCS 10),'   <outheader> is a subfunction'
  (howoutheader)[240+⍳47]←' used in the output functions.  It is not used',(,⎕UCS 10)
  (howoutheader)[287+⍳22]←'   by the programmer.',(,⎕UCS 10)

howoutopen←1867⍴0 ⍝ prolog ≡1
  (howoutopen)[⍳57]←'---------------------------------------------------------'
  (howoutopen)[57+⍳39]←'---------------------',(,⎕UCS 10),'header outopen x',(,⎕UCS 10)
  (howoutopen)[96+⍳54]←'open output device specified by <x>. use heading funct'
  (howoutopen)[150+⍳40]←'ion <header>',(,⎕UCS 10),'---------------------------'
  (howoutopen)[190+⍳52]←'---------------------------------------------------',(,⎕UCS 10)
  (howoutopen)[242+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howoutopen)[270+⍳53]←'   <outopen> is one of the core toolkit functions for'
  (howoutopen)[323+⍳38]←' output.',(,⎕UCS 10 10),'   For overall usage notes, '
  (howoutopen)[361+⍳38]←'refer to the document on <report>.',(,⎕UCS 10 10),'Ar'
  (howoutopen)[399+⍳27]←'guments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<header>'
  (howoutopen)[426+⍳40]←'   Character vector',(,⎕UCS 10),'   The name of the f'
  (howoutopen)[466+⍳53]←'unction defining the report header.  The function can'
  (howoutopen)[519+⍳43]←(,⎕UCS 10),'   have any name.  The function is called '
  (howoutopen)[562+⍳40]←'to output the header text of the',(,⎕UCS 10),'   repo'
  (howoutopen)[602+⍳53]←'rt whenever necessary, i.e.  when <outpage> is called'
  (howoutopen)[655+⍳40]←', or the top of',(,⎕UCS 10),'   a new page is encount'
  (howoutopen)[695+⍳47]←'ered.  It is defined as a sequence of calls to',(,⎕UCS 10)
  (howoutopen)[742+⍳53]←'   <out>.  Refer to the function <reportheader> and <'
  (howoutopen)[795+⍳38]←'report> for examples.',(,⎕UCS 10 10),'<x>   Character'
  (howoutopen)[833+⍳40]←' vector',(,⎕UCS 10),'   The output device code and re'
  (howoutopen)[873+⍳46]←'quired parameters.  The following details the',(,⎕UCS 10)
  (howoutopen)[919+⍳53]←'   format of <x> for the supported devices, with an e'
  (howoutopen)[972+⍳38]←'xample.',(,⎕UCS 10 10),'   a  array - output in one r'
  (howoutopen)[1010+⍳28]←'ank-3 array',(,⎕UCS 10),'      ''a,xx,50''',(,⎕UCS 10)
  (howoutopen)[1038+⍳41]←(,⎕UCS 10),'   f  file - a model of a ''component-bas'
  (howoutopen)[1079+⍳24]←'ed'' file',(,⎕UCS 10),'      ''f,60''',(,⎕UCS 10 10),' '
  (howoutopen)[1103+⍳43]←'  p  printer - skeleton code for a printer',(,⎕UCS 10)
  (howoutopen)[1146+⍳35]←'      ''p,60''',(,⎕UCS 10 10),'   t  terminal - the '
  (howoutopen)[1181+⍳46]←'''quad'' device with no special characteristics',(,⎕UCS 10)
  (howoutopen)[1227+⍳33]←'      ''t,20''',(,⎕UCS 10 10),'   z  a ''hook'' for '
  (howoutopen)[1260+⍳37]←'another programmer-defined device',(,⎕UCS 10 10),'No'
  (howoutopen)[1297+⍳24]←'tes:',(,⎕UCS 10),'-----',(,⎕UCS 10),'   The ''f'' de'
  (howoutopen)[1321+⍳52]←'vice is logically equivalent to a typical component-'
  (howoutopen)[1373+⍳39]←'based file,',(,⎕UCS 10),'   but a sequence of variab'
  (howoutopen)[1412+⍳42]←'les <component1>, <component2>, etc.  are',(,⎕UCS 10)
  (howoutopen)[1454+⍳52]←'   actually defined.  The appropriate calls to the i'
  (howoutopen)[1506+⍳39]←'mplementation file',(,⎕UCS 10),'   operations need t'
  (howoutopen)[1545+⍳48]←'o be added.  The ''p'' device is only a ''skeleton'''
  (howoutopen)[1593+⍳37]←' for a',(,⎕UCS 10),'   printer.  The ''z'' device re'
  (howoutopen)[1630+⍳42]←'quires a programmer-defined function for',(,⎕UCS 10),' '
  (howoutopen)[1672+⍳52]←'  opening the device (in <outopen>), a function for '
  (howoutopen)[1724+⍳39]←'sending output to the',(,⎕UCS 10),'   device (in <ou'
  (howoutopen)[1763+⍳51]←'t>), a function for a formfeed (in <outpage>, and a'
  (howoutopen)[1814+⍳42]←(,⎕UCS 10),'   function for closing the device (in <o'
  (howoutopen)[1856+⍳11]←'utclose>).',(,⎕UCS 10)

howoutpage←340⍴0 ⍝ prolog ≡1
  (howoutpage)[⍳57]←'---------------------------------------------------------'
  (howoutpage)[57+⍳31]←'---------------------',(,⎕UCS 10),'outpage',(,⎕UCS 10),'a'
  (howoutpage)[88+⍳41]←'dvance device to new page',(,⎕UCS 10),'---------------'
  (howoutpage)[129+⍳53]←'-----------------------------------------------------'
  (howoutpage)[182+⍳27]←'----------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-'
  (howoutpage)[209+⍳40]←'-----------',(,⎕UCS 10),'   <outpage> is one of the c'
  (howoutpage)[249+⍳38]←'ore toolkit functions for output.',(,⎕UCS 10 10),'   '
  (howoutpage)[287+⍳52]←'For more details, refer to the document on <report>.'
  (howoutpage)[339+⍳1]←(,⎕UCS 10)

howpatterng←1613⍴0 ⍝ prolog ≡1
  (howpatterng)[⍳56]←'--------------------------------------------------------'
  (howpatterng)[56+⍳33]←'----------------------',(,⎕UCS 10 122 8592),'m patter'
  (howpatterng)[89+⍳40]←'ng c',(,⎕UCS 10),'random rearrangement of text <c> ba'
  (howpatterng)[129+⍳39]←'sed on <m>',(,⎕UCS 10),'----------------------------'
  (howpatterng)[168+⍳51]←'--------------------------------------------------',(,⎕UCS 10)
  (howpatterng)[219+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howpatterng)[247+⍳52]←'   This function rearranges randomly the text <c> ba'
  (howpatterng)[299+⍳39]←'sed on the numeric',(,⎕UCS 10),'   control vector <m'
  (howpatterng)[338+⍳51]←'>.  The algorithm may be determined by reading the',(,⎕UCS 10)
  (howpatterng)[389+⍳52]←'   function.  A pattern produced by this interesting'
  (howpatterng)[441+⍳39]←' function appeared on',(,⎕UCS 10),'   the cover of t'
  (howpatterng)[480+⍳51]←'he APL\360 User''s Manual (August 1968).  The patter'
  (howpatterng)[531+⍳39]←'n was',(,⎕UCS 10),'   produced by 13 13 3 5 patterng'
  (howpatterng)[570+⍳25]←' '' APL\360 ''',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howpatterng)[595+⍳39]←'---------',(,⎕UCS 10),'<m>   4-element numeric vecto'
  (howpatterng)[634+⍳39]←'r',(,⎕UCS 10),'   This argument affects the particul'
  (howpatterng)[673+⍳37]←'ar rearrangement of the text <c>.',(,⎕UCS 10 10),'<c'
  (howpatterng)[710+⍳39]←'>   Character vector',(,⎕UCS 10),'   Text to be rear'
  (howpatterng)[749+⍳23]←'ranged.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howpatterng)[772+⍳29]←(,⎕UCS 10),'<x>   Character matrix',(,⎕UCS 10),'   Th'
  (howpatterng)[801+⍳31]←'e shape of the result is (2',(,⎕UCS 8593 109 41 215)
  (howpatterng)[832+⍳34]←(,⎕UCS 40 50 8595),'m).  The result is the pattern',(,⎕UCS 10)
  (howpatterng)[866+⍳37]←'   produced by the function.',(,⎕UCS 10 10),'Source:'
  (howpatterng)[903+⍳29]←(,⎕UCS 10),'------',(,⎕UCS 10),'   This function was '
  (howpatterng)[932+⍳49]←'suggested by an algorithm due to Roger Frey (IBM',(,⎕UCS 10)
  (howpatterng)[981+⍳37]←'   Research and Yale University).',(,⎕UCS 10 10),'Ex'
  (howpatterng)[1018+⍳25]←'amples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      2 '
  (howpatterng)[1043+⍳30]←'3 2 3 patterng '' sun ',(,⎕UCS 8902),' moon ''',(,⎕UCS 10)
  (howpatterng)[1073+⍳17]←'   ooo',(,⎕UCS 8902 8902 8902 10),'   ooo',(,⎕UCS 8902)
  (howpatterng)[1090+⍳20]←(,⎕UCS 8902 8902 10),'ooommmnnn',(,⎕UCS 10),'ooommmn'
  (howpatterng)[1110+⍳35]←'nn',(,⎕UCS 10 10),'      3 5 3 10 patterng ''apple '
  (howpatterng)[1145+⍳37]←'\ betty''',(,⎕UCS 10),'ppppppppppeeeeeeeeeetttttttt'
  (howpatterng)[1182+⍳38]←'tt\\\\\\\\\\tttttttttt',(,⎕UCS 10),'ppppppppppeeeee'
  (howpatterng)[1220+⍳38]←'eeeeetttttttttt\\\\\\\\\\tttttttttt',(,⎕UCS 10),'pp'
  (howpatterng)[1258+⍳49]←'ppppppppeeeeeeeeeetttttttttt\\\\\\\\\\tttttttttt',(,⎕UCS 10)
  (howpatterng)[1307+⍳50]←'pppppppppp          ppppppppppeeeeeeeeeepppppppppp'
  (howpatterng)[1357+⍳41]←(,⎕UCS 10),'pppppppppp          ppppppppppeeeeeeeeee'
  (howpatterng)[1398+⍳38]←'pppppppppp',(,⎕UCS 10),'pppppppppp          ppppppp'
  (howpatterng)[1436+⍳38]←'pppeeeeeeeeeepppppppppp',(,⎕UCS 10),'pppppppppppppp'
  (howpatterng)[1474+⍳38]←'ppppppyyyyyyyyyyttttttttttbbbbbbbbbb',(,⎕UCS 10),'p'
  (howpatterng)[1512+⍳50]←'pppppppppppppppppppyyyyyyyyyyttttttttttbbbbbbbbbb',(,⎕UCS 10)
  (howpatterng)[1562+⍳50]←'ppppppppppppppppppppyyyyyyyyyyttttttttttbbbbbbbbbb'
  (howpatterng)[1612+⍳1]←(,⎕UCS 10)

howpayday←1631⍴0 ⍝ prolog ≡1
  (howpayday)[⍳58]←'----------------------------------------------------------'
  (howpayday)[58+⍳32]←'--------------------',(,⎕UCS 10 121 8592),'payday d',(,⎕UCS 10)
  (howpayday)[90+⍳55]←'<y> is the closest Friday on or before dates <d> = (mm '
  (howpayday)[145+⍳41]←'dd yyyy)',(,⎕UCS 10),'--------------------------------'
  (howpayday)[186+⍳47]←'----------------------------------------------',(,⎕UCS 10)
  (howpayday)[233+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howpayday)[261+⍳54]←'   For each date specified in <d>, <payday> computes t'
  (howpayday)[315+⍳41]←'he closest Friday on or',(,⎕UCS 10),'   before that da'
  (howpayday)[356+⍳53]←'te.  Thus <payday> can be used to compute the closest'
  (howpayday)[409+⍳44]←(,⎕UCS 10),'   Friday on or before the 15-th or 30-th ('
  (howpayday)[453+⍳39]←'or any other date) of the month.',(,⎕UCS 10 10),'Argum'
  (howpayday)[492+⍳28]←'ents:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<d>   3-elem'
  (howpayday)[520+⍳33]←'ent numeric vector or n',(,⎕UCS 215),'3 matrix',(,⎕UCS 10)
  (howpayday)[553+⍳39]←'   A vector is treated as a 1',(,⎕UCS 215),'3 matrix.'
  (howpayday)[592+⍳31]←(,⎕UCS 10),'   d[;1] = month',(,⎕UCS 10),'   d[;2] = da'
  (howpayday)[623+⍳26]←'y',(,⎕UCS 10),'   d[;3] = year',(,⎕UCS 10 10),'Result:'
  (howpayday)[649+⍳29]←(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Numeric matrix',(,⎕UCS 10)
  (howpayday)[678+⍳41]←'   The paydays corresponding to <d>.',(,⎕UCS 10),'   y'
  (howpayday)[719+⍳29]←'[;1] = month',(,⎕UCS 10),'   y[;2] = day',(,⎕UCS 10),' '
  (howpayday)[748+⍳27]←'  y[;3] = year',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-'
  (howpayday)[775+⍳41]←'-------',(,⎕UCS 10),'...What day is May 12, 1988?  It '
  (howpayday)[816+⍳41]←'is day 4 (Thursday).',(,⎕UCS 10),'      7|days 5 12 19'
  (howpayday)[857+⍳35]←'88',(,⎕UCS 10 52 10 10),'...The next day is Friday the'
  (howpayday)[892+⍳45]←' 13-th.  But it''s also payday for those paid',(,⎕UCS 10)
  (howpayday)[937+⍳54]←'...twice a month, because it is the closest Friday on '
  (howpayday)[991+⍳41]←'or before the 15-th of',(,⎕UCS 10),'...the month.  <Pa'
  (howpayday)[1032+⍳40]←'yday> confirms this.',(,⎕UCS 10),'      payday 5 15 1'
  (howpayday)[1072+⍳25]←'988',(,⎕UCS 10),'   5   13 1988',(,⎕UCS 10 10),'...Co'
  (howpayday)[1097+⍳53]←'mpute the closest Friday on or before the 30-th of mo'
  (howpayday)[1150+⍳37]←'nth.',(,⎕UCS 10),'      ''e'' fdate payday 5 30 1988'
  (howpayday)[1187+⍳28]←(,⎕UCS 10),'may 27, 1988',(,⎕UCS 10 10),'...<payday> a'
  (howpayday)[1215+⍳40]←'ccepts matrix arguments.',(,⎕UCS 10),'      payday 2 '
  (howpayday)[1255+⍳25]←'3',(,⎕UCS 9076),'5 15 1988 5 30 1988',(,⎕UCS 10),'   '
  (howpayday)[1280+⍳28]←'5   13 1988',(,⎕UCS 10),'   5   27 1988',(,⎕UCS 10 10)
  (howpayday)[1308+⍳37]←'Programming Notes:',(,⎕UCS 10),'-----------------',(,⎕UCS 10)
  (howpayday)[1345+⍳53]←'   Besides being a useful function on its own, <payda'
  (howpayday)[1398+⍳39]←'y> demonstrates the use',(,⎕UCS 10),'   of the ''basi'
  (howpayday)[1437+⍳52]←'c'' functions <days> and <cdays> for specialized date'
  (howpayday)[1489+⍳43]←(,⎕UCS 10),'   applications.  Note the use of matrix a'
  (howpayday)[1532+⍳40]←'rguments and results within the',(,⎕UCS 10),'   funct'
  (howpayday)[1572+⍳53]←'ion that allows <payday> to accept and return matrix '
  (howpayday)[1625+⍳6]←'data.',(,⎕UCS 10)

howpick←2482⍴0 ⍝ prolog ≡1
  (howpick)[⍳60]←'------------------------------------------------------------'
  (howpick)[60+⍳30]←'------------------',(,⎕UCS 10 121 8592),'m pick v',(,⎕UCS 10)
  (howpick)[90+⍳57]←'select (pick) rows from character <m> using name specific'
  (howpick)[147+⍳43]←'ation <v>',(,⎕UCS 10),'---------------------------------'
  (howpick)[190+⍳46]←'---------------------------------------------',(,⎕UCS 10)
  (howpick)[236+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howpick)[264+⍳56]←'   <pick> uses a name search specification to select row'
  (howpick)[320+⍳43]←'s from a character',(,⎕UCS 10),'   matrix.  Specificatio'
  (howpick)[363+⍳50]←'ns can include ''wild card'' characters, and can be',(,⎕UCS 10)
  (howpick)[413+⍳54]←'   combined to add or remove items from the ''pick'' lis'
  (howpick)[467+⍳25]←'t.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howpick)[492+⍳43]←'<m>   Character matrix',(,⎕UCS 10),'   The matrix of nam'
  (howpick)[535+⍳56]←'es to be searched.  A name is considered to be a sequenc'
  (howpick)[591+⍳43]←'e',(,⎕UCS 10),'   of non-blank characters, followed by o'
  (howpick)[634+⍳43]←'ne or more pad characters (usually',(,⎕UCS 10),'   blank'
  (howpick)[677+⍳38]←'s).',(,⎕UCS 10 10),'<v>   Character scalar or vector',(,⎕UCS 10)
  (howpick)[715+⍳56]←'   <v> determines the names selected in the result.  <v>'
  (howpick)[771+⍳43]←' contains one or more',(,⎕UCS 10),'   search specificati'
  (howpick)[814+⍳55]←'ons, separated by blanks, chosen from the following set'
  (howpick)[869+⍳46]←(,⎕UCS 10),'   (x and y stand for one or more non-blanks)'
  (howpick)[915+⍳20]←':',(,⎕UCS 10),'      x    x',(,⎕UCS 8902),'    ',(,⎕UCS 8902)
  (howpick)[935+⍳19]←'x    x',(,⎕UCS 8902),'y    ',(,⎕UCS 8902 120 8902),'    '
  (howpick)[954+⍳29]←(,⎕UCS 8902 10),'      -    x-y    x-   -y',(,⎕UCS 10),' '
  (howpick)[983+⍳56]←'  For a more complete description of these specification'
  (howpick)[1039+⍳42]←'s, refer to the',(,⎕UCS 10),'   documents on <range> an'
  (howpick)[1081+⍳40]←'d <wildcard>.  In addition, a tilde (',(,⎕UCS 8764),') '
  (howpick)[1121+⍳42]←'can be',(,⎕UCS 10),'   placed in front of any specifica'
  (howpick)[1163+⍳33]←'tion in <v> (e.g.  ',(,⎕UCS 8764 102 8902),') to specif'
  (howpick)[1196+⍳42]←'y to',(,⎕UCS 10),'   ignore names within that search ra'
  (howpick)[1238+⍳21]←'nge.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howpick)[1259+⍳42]←'<y>   Numeric vector',(,⎕UCS 10),'   y[i]=1 -- m[i;] is'
  (howpick)[1301+⍳42]←' selected.',(,⎕UCS 10),'   y[i]=0 -- m[i;] is not selec'
  (howpick)[1343+⍳40]←'ted.',(,⎕UCS 10 10),'   If a specification does not beg'
  (howpick)[1383+⍳40]←'in with the tilde <',(,⎕UCS 8764),'>, the names selecte'
  (howpick)[1423+⍳42]←'d',(,⎕UCS 10),'   are added to the current list of name'
  (howpick)[1465+⍳42]←'s.  If a specification begins with',(,⎕UCS 10),'   tild'
  (howpick)[1507+⍳55]←'e, the names selected are removed from the current list'
  (howpick)[1562+⍳42]←'.  (If a tilde',(,⎕UCS 10),'   specification is the fir'
  (howpick)[1604+⍳48]←'st one in <v>, the current list defaults to the',(,⎕UCS 10)
  (howpick)[1652+⍳55]←'   entire list, and the names are removed from that lis'
  (howpick)[1707+⍳24]←'t.)',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howpick)[1731+⍳54]←'... <m> is sorted to clarify these examples.  ''Pre-sor'
  (howpick)[1785+⍳29]←'ting'' is not needed.',(,⎕UCS 10),'      m',(,⎕UCS 8592)
  (howpick)[1814+⍳37]←''''' ',(,⎕UCS 8710),'box ''annie apple betty cars cat c'
  (howpick)[1851+⍳40]←'ats cattle egg farm flag''',(,⎕UCS 10),'      m pick '''
  (howpick)[1891+⍳25]←'a',(,⎕UCS 8902 39 10),'1 1 0 0 0 0 0 0 0 0',(,⎕UCS 10),' '
  (howpick)[1916+⍳26]←'     m pick ''a',(,⎕UCS 8902 32 102 8902 39 10),'1 1 0 '
  (howpick)[1942+⍳42]←'0 0 0 0 0 1 1',(,⎕UCS 10),'... All words starting with '
  (howpick)[1984+⍳39]←'''c'' and containing ''t'' in position 3.',(,⎕UCS 10),' '
  (howpick)[2023+⍳28]←'     ,'' '',(m pick ''c?t',(,⎕UCS 8902 39 41 9023 109 10)
  (howpick)[2051+⍳42]←' cat    cats   cattle',(,⎕UCS 10),'... Same as before b'
  (howpick)[2093+⍳40]←'ut with exactly 4 letters.',(,⎕UCS 10),'      ,'' '',(m'
  (howpick)[2133+⍳23]←' pick ''c?t?'')',(,⎕UCS 9023 109 10),' cats',(,⎕UCS 10),'.'
  (howpick)[2156+⍳51]←'.. All words between ''b'' and ''f'' except those start'
  (howpick)[2207+⍳37]←'ing with ''c''',(,⎕UCS 10),'      ,'' '',(m pick ''b-f '
  (howpick)[2244+⍳24]←(,⎕UCS 8764 99 8902 39 41 9023 109 10),' betty  egg    f'
  (howpick)[2268+⍳42]←'arm   flag',(,⎕UCS 10),'... All words except those star'
  (howpick)[2310+⍳36]←'ting with ''c'' or ''f''',(,⎕UCS 10),'      ,'' '',(m p'
  (howpick)[2346+⍳15]←'ick ''',(,⎕UCS 8764 99 8902 32 8764 102 8902 39 41 9023)
  (howpick)[2361+⍳29]←(,⎕UCS 109 10),' annie  apple  betty  egg',(,⎕UCS 10),'.'
  (howpick)[2390+⍳50]←'.. All words starting with ''c'' and ending with ''s'''
  (howpick)[2440+⍳26]←(,⎕UCS 10),'      ,'' '',(m pick ''c',(,⎕UCS 8902),'s'')'
  (howpick)[2466+⍳16]←(,⎕UCS 9023 109 10),' cars   cats',(,⎕UCS 10)

howpickn←1543⍴0 ⍝ prolog ≡1
  (howpickn)[⍳59]←'-----------------------------------------------------------'
  (howpickn)[59+⍳32]←'-------------------',(,⎕UCS 10 121 8592),'v pickn n',(,⎕UCS 10)
  (howpickn)[91+⍳54]←'pick (''select'') numbers from <n> using positive intege'
  (howpickn)[145+⍳42]←'r specification <v>',(,⎕UCS 10),'----------------------'
  (howpickn)[187+⍳55]←'-------------------------------------------------------'
  (howpickn)[242+⍳27]←'-',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'----------'
  (howpickn)[269+⍳42]←'--',(,⎕UCS 10),'   <pickn> uses a search specification '
  (howpickn)[311+⍳42]←'to select numbers from a vector.  The',(,⎕UCS 10),'   s'
  (howpickn)[353+⍳53]←'earch specification is based on a ''range'' type of sel'
  (howpickn)[406+⍳40]←'ection, for',(,⎕UCS 10),'   example, ''5-10'' selects a'
  (howpickn)[446+⍳43]←'ll numbers in the range (5,10) inclusive.',(,⎕UCS 10 10)
  (howpickn)[489+⍳55]←'   The search specification uses only positive numbers;'
  (howpickn)[544+⍳42]←' the vector <n> can',(,⎕UCS 10),'   contain any number.'
  (howpickn)[586+⍳52]←'  <pickn> has been used primarily in user-interface',(,⎕UCS 10)
  (howpickn)[638+⍳30]←'   applications.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howpickn)[668+⍳41]←'--------',(,⎕UCS 10),'<v>   Character vector or matrix'
  (howpickn)[709+⍳45]←(,⎕UCS 10),'   Vector <v> represents one or more search '
  (howpickn)[754+⍳42]←'specifications.  Matrix <v>',(,⎕UCS 10),'   contains on'
  (howpickn)[796+⍳55]←'e or more specifications in each row.  In the table bel'
  (howpickn)[851+⍳42]←'ow of',(,⎕UCS 10),'   valid specifications, x and y rep'
  (howpickn)[893+⍳40]←'resent positive integers.',(,⎕UCS 10 10),'   x     Sele'
  (howpickn)[933+⍳42]←'ct exact match on x.',(,⎕UCS 10),'   x-y   Select numbe'
  (howpickn)[975+⍳42]←'rs between x and y inclusive.',(,⎕UCS 10),'   x-    Sel'
  (howpickn)[1017+⍳32]←'ect numbers ',(,⎕UCS 8805 120 46 10),'   -y    Select '
  (howpickn)[1049+⍳32]←'numbers ',(,⎕UCS 8804 121 46 10),'   -     Select all '
  (howpickn)[1081+⍳31]←'numbers.',(,⎕UCS 10 10),'<n>   Numeric vector',(,⎕UCS 10)
  (howpickn)[1112+⍳42]←'   The vector of numbers to be searched.',(,⎕UCS 10 10)
  (howpickn)[1154+⍳28]←'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Numeric'
  (howpickn)[1182+⍳39]←' vector',(,⎕UCS 10),'   y[i]=1 -- n[i] is selected.',(,⎕UCS 10)
  (howpickn)[1221+⍳39]←'   y[i]=0 -- n[i] is not selected.',(,⎕UCS 10 10),'Exa'
  (howpickn)[1260+⍳26]←'mples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ''5'' '
  (howpickn)[1286+⍳33]←'pickn ',(,⎕UCS 9075 49 50 10),'0 0 0 0 1 0 0 0 0 0 0 0'
  (howpickn)[1319+⍳23]←(,⎕UCS 10),'      ''5-'' pickn ',(,⎕UCS 9075 49 50 10),'0'
  (howpickn)[1342+⍳39]←' 0 0 0 1 1 1 1 1 1 1 1',(,⎕UCS 10),'      ''-4 10-'' p'
  (howpickn)[1381+⍳32]←'ickn ',(,⎕UCS 9075 49 50 10),'1 1 1 1 0 0 0 0 0 1 1 1'
  (howpickn)[1413+⍳25]←(,⎕UCS 10 10),'      ''3-10'' pickn n',(,⎕UCS 8592),'1.'
  (howpickn)[1438+⍳38]←'1 5 90 ',(,⎕UCS 175),'303 14 3.13 3.141592 10.1 10 ',(,⎕UCS 175)
  (howpickn)[1476+⍳27]←(,⎕UCS 56 54 10),'0 1 0 0 0 1 1 0 1 0',(,⎕UCS 10),'    '
  (howpickn)[1503+⍳39]←'  (''3-10'' pickn n)/n',(,⎕UCS 10),'5 3.13 3.141592 10'
  (howpickn)[1542+⍳1]←(,⎕UCS 10)

howprint←687⍴0 ⍝ prolog ≡1
  (howprint)[⍳59]←'-----------------------------------------------------------'
  (howprint)[59+⍳32]←'-------------------',(,⎕UCS 10),'print text',(,⎕UCS 10),'e'
  (howprint)[91+⍳55]←'xample print cover function to print <text> on printer',(,⎕UCS 10)
  (howprint)[146+⍳55]←'-------------------------------------------------------'
  (howprint)[201+⍳39]←'-----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howprint)[240+⍳41]←'------------',(,⎕UCS 10),'   <print> is an example ''co'
  (howprint)[281+⍳48]←'ver'' function to print text on a printer, using',(,⎕UCS 10)
  (howprint)[329+⍳53]←'   the ''z'' device.  The programmer is expected to pro'
  (howprint)[382+⍳42]←'vide the required',(,⎕UCS 10),'   functions to support '
  (howprint)[424+⍳40]←'the desired device.',(,⎕UCS 10 10),'   The function can'
  (howprint)[464+⍳55]←' be modified to direct output to some other device, or '
  (howprint)[519+⍳42]←'the',(,⎕UCS 10),'   device parameters can be supplied a'
  (howprint)[561+⍳40]←'s an explicit argument, e.g.',(,⎕UCS 10 10),'   x print'
  (howprint)[601+⍳40]←' text',(,⎕UCS 10 10),'   so that text can be directed t'
  (howprint)[641+⍳46]←'o one of several devices at ''execution'' time.',(,⎕UCS 10)

howputtag←1050⍴0 ⍝ prolog ≡1
  (howputtag)[⍳58]←'----------------------------------------------------------'
  (howputtag)[58+⍳36]←'--------------------',(,⎕UCS 10 89 8592),'Text puttag F'
  (howputtag)[94+⍳41]←'ns',(,⎕UCS 10),'put tag line <text> on functions <fns>'
  (howputtag)[135+⍳44]←(,⎕UCS 10),'-------------------------------------------'
  (howputtag)[179+⍳39]←'-----------------------------------',(,⎕UCS 10 10),'In'
  (howputtag)[218+⍳28]←'troduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   '
  (howputtag)[246+⍳54]←'<puttag> is the library utility for putting the specif'
  (howputtag)[300+⍳41]←'ied tag line <Text>',(,⎕UCS 10),'   into a set of spec'
  (howputtag)[341+⍳39]←'ified functions.',(,⎕UCS 10 10),'   This function is u'
  (howputtag)[380+⍳49]←'seful for quickly inserting a tag line into many',(,⎕UCS 10)
  (howputtag)[429+⍳53]←'   functions at once.  For more information about ''ta'
  (howputtag)[482+⍳40]←'g lines'', consult the',(,⎕UCS 10),'   documentation o'
  (howputtag)[522+⍳26]←'n <gettag>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'--'
  (howputtag)[548+⍳34]←'-------',(,⎕UCS 10),'<Text>   Character vector',(,⎕UCS 10)
  (howputtag)[582+⍳54]←'   This argument specifies the code (first character),'
  (howputtag)[636+⍳41]←' a space, and the text',(,⎕UCS 10),'   of the tag line'
  (howputtag)[677+⍳38]←'.',(,⎕UCS 10 10),'<Fns>   Character vector or matrix',(,⎕UCS 10)
  (howputtag)[715+⍳35]←'   Namelist of functions.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howputtag)[750+⍳29]←'------',(,⎕UCS 10),'<Y>   Numeric vector',(,⎕UCS 10),' '
  (howputtag)[779+⍳54]←'  Binary vector indicating success or failure of fixin'
  (howputtag)[833+⍳35]←'g the changed function.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howputtag)[868+⍳41]←'--------',(,⎕UCS 10),'...Insert (change) category name'
  (howputtag)[909+⍳40]←' in the specified functions.',(,⎕UCS 10),'      ''k ne'
  (howputtag)[949+⍳38]←'wname'' puttag ''func1 func2 func3''',(,⎕UCS 10),'1 1 '
  (howputtag)[987+⍳37]←'1',(,⎕UCS 10),'      ''k'' gettag ''func1 func2 func3'
  (howputtag)[1024+⍳18]←'''',(,⎕UCS 10),'newmane',(,⎕UCS 10),'newname',(,⎕UCS 10)
  (howputtag)[1042+⍳8]←'newname',(,⎕UCS 10)

howqstop←441⍴0 ⍝ prolog ≡1
  (howqstop)[⍳59]←'-----------------------------------------------------------'
  (howqstop)[59+⍳32]←'-------------------',(,⎕UCS 10 89 8592),'L qstop N',(,⎕UCS 10)
  (howqstop)[91+⍳56]←'set stop vector for functions <N> on lines <L>, but not '
  (howqstop)[147+⍳42]←'comments',(,⎕UCS 10),'---------------------------------'
  (howqstop)[189+⍳46]←'---------------------------------------------',(,⎕UCS 10)
  (howqstop)[235+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howqstop)[263+⍳55]←'   <qstop> sets the APL stop vector for one or more fun'
  (howqstop)[318+⍳40]←'ctions.',(,⎕UCS 10 10),'   <qstop> has the same syntax '
  (howqstop)[358+⍳44]←'and arguments as <qtrace>.  See the latter',(,⎕UCS 10),' '
  (howqstop)[402+⍳39]←'  function for a complete description.',(,⎕UCS 10)

howqtrace←2335⍴0 ⍝ prolog ≡1
  (howqtrace)[⍳58]←'----------------------------------------------------------'
  (howqtrace)[58+⍳35]←'---------------------',(,⎕UCS 10 89 8592),'L qtrace N',(,⎕UCS 10)
  (howqtrace)[93+⍳55]←'set trace for functions <N> on lines <L>, optionally av'
  (howqtrace)[148+⍳41]←'oid comments',(,⎕UCS 10),'----------------------------'
  (howqtrace)[189+⍳51]←'--------------------------------------------------',(,⎕UCS 10)
  (howqtrace)[240+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howqtrace)[268+⍳54]←'   <qtrace> sets the APL trace vector for one or more '
  (howqtrace)[322+⍳41]←'functions.  <qtrace>',(,⎕UCS 10),'   executes the stan'
  (howqtrace)[363+⍳39]←'dard APL trace function <t',(,⎕UCS 8710),'>, and has s'
  (howqtrace)[402+⍳41]←'imilar arguments',(,⎕UCS 10),'   and syntax.  However,'
  (howqtrace)[443+⍳53]←' it provides several convenient features, including:',(,⎕UCS 10)
  (howqtrace)[496+⍳44]←(,⎕UCS 10),'       (1) Several functions can be set at '
  (howqtrace)[540+⍳41]←'one time.',(,⎕UCS 10),'       (2) A negative line spec'
  (howqtrace)[581+⍳42]←'ification avoids tracing a comment line.',(,⎕UCS 10),' '
  (howqtrace)[623+⍳54]←'      (3) An empty line specification defaults to all '
  (howqtrace)[677+⍳39]←'non-comment lines.',(,⎕UCS 10 10),'   The same remarks'
  (howqtrace)[716+⍳54]←' apply to the companion toolkit function <qstop> which'
  (howqtrace)[770+⍳44]←(,⎕UCS 10),'   sets the APL stop vector for one or more'
  (howqtrace)[814+⍳26]←' functions.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'--'
  (howqtrace)[840+⍳39]←'-------',(,⎕UCS 10),'<l>   Numeric scalar or vector',(,⎕UCS 10)
  (howqtrace)[879+⍳43]←'   <l> determines the lines to be traced.',(,⎕UCS 10),' '
  (howqtrace)[922+⍳54]←'  l is empty -- trace all non-comment lines in the spe'
  (howqtrace)[976+⍳41]←'cified function',(,⎕UCS 10),'   l[i]>0     -- trace li'
  (howqtrace)[1017+⍳40]←'ne numbered l[i]',(,⎕UCS 10),'   l[i]<0     -- trace '
  (howqtrace)[1057+⍳40]←'line |l[i] if line is not a comment',(,⎕UCS 10),'   l'
  (howqtrace)[1097+⍳40]←'=0        -- remove trace vector',(,⎕UCS 10),'   Note'
  (howqtrace)[1137+⍳47]←': The definition of the empty argument l for t',(,⎕UCS 8710)
  (howqtrace)[1184+⍳40]←' is different, and the',(,⎕UCS 10),'   definition for'
  (howqtrace)[1224+⍳38]←' l<0 does not exist.',(,⎕UCS 10 10),'<n>   Character '
  (howqtrace)[1262+⍳40]←'vector or matrix',(,⎕UCS 10),'   Namelist of function'
  (howqtrace)[1302+⍳26]←'s to be traced.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howqtrace)[1328+⍳28]←'-----',(,⎕UCS 10),'<y>   Numeric vector',(,⎕UCS 10),' '
  (howqtrace)[1356+⍳53]←'  The vector of line numbers to be traced for the las'
  (howqtrace)[1409+⍳35]←'t function in the',(,⎕UCS 10),'   namelist <n>.',(,⎕UCS 10)
  (howqtrace)[1444+⍳43]←(,⎕UCS 10),'   <qtrace> computes the required vector o'
  (howqtrace)[1487+⍳40]←'f line numbers for each function',(,⎕UCS 10),'   spec'
  (howqtrace)[1527+⍳53]←'ified.  If a function is not present in the workspace'
  (howqtrace)[1580+⍳40]←', a warning',(,⎕UCS 10),'   message is issued and no '
  (howqtrace)[1620+⍳42]←'trace vector is applied to any function.',(,⎕UCS 10),' '
  (howqtrace)[1662+⍳53]←'  (<qtrace> and <qstop> call the subfunction <stoptra'
  (howqtrace)[1715+⍳31]←'ce> which executes',(,⎕UCS 10),'   either t',(,⎕UCS 8710)
  (howqtrace)[1746+⍳20]←' or s',(,⎕UCS 8710 46 41 10 10),'Examples:',(,⎕UCS 10)
  (howqtrace)[1766+⍳19]←'--------',(,⎕UCS 10),'    ',(,⎕UCS 8711),' foo',(,⎕UCS 10)
  (howqtrace)[1785+⍳26]←'[1]  ',(,⎕UCS 9053),'first line comment',(,⎕UCS 10),'['
  (howqtrace)[1811+⍳19]←'2]   y',(,⎕UCS 8592 57 10),'[3]  ',(,⎕UCS 9053),'anot'
  (howqtrace)[1830+⍳23]←'her comment',(,⎕UCS 10),'[4]   y',(,⎕UCS 8592 48 10),' '
  (howqtrace)[1853+⍳27]←'   ',(,⎕UCS 8711 10),'      '''' qtrace ''foo''',(,⎕UCS 10)
  (howqtrace)[1880+⍳40]←'2 4',(,⎕UCS 10),'...(This replaces a statement like t'
  (howqtrace)[1920+⍳26]←(,⎕UCS 8710),'foo',(,⎕UCS 8592),'99 which is not so co'
  (howqtrace)[1946+⍳40]←'nvenient.)',(,⎕UCS 10),'...In the following examples '
  (howqtrace)[1986+⍳40]←'the result is not shown.',(,⎕UCS 10),'...Trace the fi'
  (howqtrace)[2026+⍳43]←'rst line of all functions between a and z',(,⎕UCS 10),' '
  (howqtrace)[2069+⍳38]←'     1 qtrace ''a-z'' nl 3',(,⎕UCS 10),'...Trace all '
  (howqtrace)[2107+⍳52]←'non-comments lines in all functions in the workspace'
  (howqtrace)[2159+⍳23]←(,⎕UCS 10),'      '''' qtrace ',(,⎕UCS 9109),'nl 3',(,⎕UCS 10)
  (howqtrace)[2182+⍳45]←'...Trace all non-comment lines from 20 to 30',(,⎕UCS 10)
  (howqtrace)[2227+⍳33]←'      (-19',(,⎕UCS 8595 9075),'30) qtrace ''functionn'
  (howqtrace)[2260+⍳39]←'ame''',(,⎕UCS 10),'...Turn trace off all functions in'
  (howqtrace)[2299+⍳31]←' the workspace',(,⎕UCS 10),'      0 qtrace ',(,⎕UCS 9109)
  (howqtrace)[2330+⍳5]←'nl 3',(,⎕UCS 10)

howrange←2177⍴0 ⍝ prolog ≡1
  (howrange)[⍳59]←'-----------------------------------------------------------'
  (howrange)[59+⍳32]←'-------------------',(,⎕UCS 10 121 8592),'m range s',(,⎕UCS 10)
  (howrange)[91+⍳54]←'select names in matrix <m> using ''range'' search specif'
  (howrange)[145+⍳42]←'ication <s>',(,⎕UCS 10),'------------------------------'
  (howrange)[187+⍳49]←'------------------------------------------------',(,⎕UCS 10)
  (howrange)[236+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howrange)[264+⍳55]←'   <range> uses a search specification to select names '
  (howrange)[319+⍳42]←'from a matrix of',(,⎕UCS 10),'   names.  The search spe'
  (howrange)[361+⍳52]←'cification is based on a ''range'' type of selection,',(,⎕UCS 10)
  (howrange)[413+⍳53]←'   for example, ''a-d'' selects all names starting with'
  (howrange)[466+⍳32]←' ''a'', ''b'', ''c'', or ''d''.',(,⎕UCS 10 10),'Argumen'
  (howrange)[498+⍳29]←'ts:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<m>   Character'
  (howrange)[527+⍳42]←' matrix',(,⎕UCS 10),'   A left-justified matrix of name'
  (howrange)[569+⍳43]←'s.  A name is considered to be a sequence',(,⎕UCS 10),' '
  (howrange)[612+⍳40]←'  of non-blank characters.',(,⎕UCS 10 10),'<s>   Charac'
  (howrange)[652+⍳42]←'ter vector or scalar',(,⎕UCS 10),'   <s> represents one'
  (howrange)[694+⍳55]←' search specification (no blanks).  Valid specification'
  (howrange)[749+⍳42]←'s',(,⎕UCS 10),'   are listed in the table below.  x and'
  (howrange)[791+⍳42]←' y represent any non-blank sequence',(,⎕UCS 10),'   of '
  (howrange)[833+⍳40]←'one or more characters.',(,⎕UCS 10 10),'   x-y   Select'
  (howrange)[873+⍳55]←' names starting with any character sequence between x a'
  (howrange)[928+⍳29]←'md y',(,⎕UCS 10),'         (inclusive).',(,⎕UCS 10),'  '
  (howrange)[957+⍳55]←' x-    Select names starting with any sequence between '
  (howrange)[1012+⍳41]←'x and the last',(,⎕UCS 10),'         letter in the col'
  (howrange)[1053+⍳41]←'lating order.',(,⎕UCS 10),'   -y    Select names start'
  (howrange)[1094+⍳50]←'ing with any sequence between the first letter in',(,⎕UCS 10)
  (howrange)[1144+⍳41]←'         the collating order and y.',(,⎕UCS 10),'   - '
  (howrange)[1185+⍳39]←'    Select all names.',(,⎕UCS 10 10),'   Also, the spe'
  (howrange)[1224+⍳52]←'cial character ''?'' is permitted within <x> or <y>, b'
  (howrange)[1276+⍳41]←'ut in the',(,⎕UCS 10),'   nature of the definition of '
  (howrange)[1317+⍳41]←'<s> has no significance; for example,',(,⎕UCS 10),'   '
  (howrange)[1358+⍳42]←'''ar?-c?x'' has the same meaning as ''ar-c''.',(,⎕UCS 10)
  (howrange)[1400+⍳18]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y'
  (howrange)[1418+⍳41]←'>   Numeric vector',(,⎕UCS 10),'   y[i]=1 -- m[i;] is '
  (howrange)[1459+⍳41]←'selected.',(,⎕UCS 10),'   y[i]=0 -- m[i;] is not selec'
  (howrange)[1500+⍳25]←'ted.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howrange)[1525+⍳53]←'... <m> is sorted to clarify these examples.  ''Pre-so'
  (howrange)[1578+⍳30]←'rting'' is not needed.',(,⎕UCS 10),'      m',(,⎕UCS 8592)
  (howrange)[1608+⍳36]←''''' ',(,⎕UCS 8710),'box ''annie apple betty car cars '
  (howrange)[1644+⍳40]←'cat cats cradle egg farm flag''',(,⎕UCS 10),'... All w'
  (howrange)[1684+⍳37]←'ords starting with ''b'' or ''c''',(,⎕UCS 10),'      m'
  (howrange)[1721+⍳35]←' range ''b-c''',(,⎕UCS 10),'0 0 1 1 1 1 1 1 0 0 0',(,⎕UCS 10)
  (howrange)[1756+⍳44]←(,⎕UCS 10),'... All words starting with letters between'
  (howrange)[1800+⍳36]←' ''ap'' and ''car'' inclusive.',(,⎕UCS 10),'... Note:'
  (howrange)[1836+⍳44]←(,⎕UCS 10),'    This is not meant to be the same as all'
  (howrange)[1880+⍳37]←' words between ''ap'' and ''car''.',(,⎕UCS 10),'      '
  (howrange)[1917+⍳30]←','' '',(m range ''ap-car'')',(,⎕UCS 9023 109 10),' app'
  (howrange)[1947+⍳39]←'le  betty  car    cars',(,⎕UCS 10 10),'... All words s'
  (howrange)[1986+⍳47]←'tarting with letters between ''ca'' and the end.',(,⎕UCS 10)
  (howrange)[2033+⍳30]←'      ,'' '',(m range ''ca-'')',(,⎕UCS 9023 109 10),' '
  (howrange)[2063+⍳53]←'car    cars   cat    cats   cradle egg    farm   flag'
  (howrange)[2116+⍳29]←(,⎕UCS 10 10),'... All the words.',(,⎕UCS 10),'      m '
  (howrange)[2145+⍳32]←'range ''-''',(,⎕UCS 10),'1 1 1 1 1 1 1 1 1 1 1',(,⎕UCS 10)

howreformat←2410⍴0 ⍝ prolog ≡1
  (howreformat)[⍳56]←'--------------------------------------------------------'
  (howreformat)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'a reform'
  (howreformat)[89+⍳40]←'at m',(,⎕UCS 10),'reformat <m> to matrix a[1] charact'
  (howreformat)[129+⍳41]←'ers wide, including a[2] initial blanks',(,⎕UCS 10),'-'
  (howreformat)[170+⍳52]←'----------------------------------------------------'
  (howreformat)[222+⍳37]←'-------------------------',(,⎕UCS 10 10),'Introducti'
  (howreformat)[259+⍳26]←'on:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <refor'
  (howreformat)[285+⍳52]←'mat> reformats text to a left-justified ragged-right'
  (howreformat)[337+⍳39]←' block paragraph',(,⎕UCS 10),'   with a maximum line'
  (howreformat)[376+⍳50]←' length.  Redundant spaces are removed.  A double',(,⎕UCS 10)
  (howreformat)[426+⍳52]←'   space is placed at the end of each sentence.  The'
  (howreformat)[478+⍳39]←' lines may be optionally',(,⎕UCS 10),'   indented fr'
  (howreformat)[517+⍳52]←'om the left margin (i.e.  each row starts with a spe'
  (howreformat)[569+⍳39]←'cified',(,⎕UCS 10),'   number of blanks).  This para'
  (howreformat)[608+⍳45]←'graph is a good example of a typical result.',(,⎕UCS 10)
  (howreformat)[653+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howreformat)[675+⍳39]←'<a>   2-element numeric vector',(,⎕UCS 10),'   a[1] '
  (howreformat)[714+⍳39]←'= Width of the result matrix.',(,⎕UCS 10),'   a[2] ='
  (howreformat)[753+⍳52]←' Number of blanks to preceed each line.  (Default = '
  (howreformat)[805+⍳22]←'0)',(,⎕UCS 10 10),'   a[1] > a[2]',(,⎕UCS 10 10),'<m'
  (howreformat)[827+⍳39]←'>   Character array',(,⎕UCS 10),'   Text to be refor'
  (howreformat)[866+⍳52]←'matted.  A period or question mark followed by at le'
  (howreformat)[918+⍳39]←'ast',(,⎕UCS 10),'   one space is considered to be th'
  (howreformat)[957+⍳30]←'e end of a sentence.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howreformat)[987+⍳30]←'------',(,⎕UCS 10),'<y>   Character matrix',(,⎕UCS 10)
  (howreformat)[1017+⍳51]←'   This is the reformatted text with dimensions <n,'
  (howreformat)[1068+⍳38]←'a[1]>.  <n> is the number',(,⎕UCS 10),'   of rows r'
  (howreformat)[1106+⍳51]←'equired for the text.  The first <a[2]> columns are'
  (howreformat)[1157+⍳22]←' blank.',(,⎕UCS 10 10),'Notes:',(,⎕UCS 10),'-----',(,⎕UCS 10)
  (howreformat)[1179+⍳51]←'   A matrix argument is first ravelled with one bla'
  (howreformat)[1230+⍳38]←'nk appended to each row.',(,⎕UCS 10),'   This ensur'
  (howreformat)[1268+⍳51]←'es that a word ending exactly at the end of one row'
  (howreformat)[1319+⍳37]←' of the',(,⎕UCS 10),'   matrix does not ''run toget'
  (howreformat)[1356+⍳45]←'her'' with a word beginning on the subsequent',(,⎕UCS 10)
  (howreformat)[1401+⍳46]←'   line.  Redundant blanks are later removed.',(,⎕UCS 10)
  (howreformat)[1447+⍳41]←(,⎕UCS 10),'   The line-breaking algorithm is the <s'
  (howreformat)[1488+⍳38]←'plit> function, which ensures that',(,⎕UCS 10),'   '
  (howreformat)[1526+⍳51]←'words are not split in the middle.  No test is made'
  (howreformat)[1577+⍳38]←' for text within',(,⎕UCS 10),'   quotes; therefore '
  (howreformat)[1615+⍳50]←'quoted text could end up running over two or more',(,⎕UCS 10)
  (howreformat)[1665+⍳51]←'   lines.  (Another line-breaking algorithm could b'
  (howreformat)[1716+⍳36]←'e substituted if desired.)',(,⎕UCS 10 10),'Examples'
  (howreformat)[1752+⍳19]←':',(,⎕UCS 10),'--------',(,⎕UCS 10),'      v',(,⎕UCS 8592)
  (howreformat)[1771+⍳50]←'''The quick brown fox jumped over the lazy red hen.'
  (howreformat)[1821+⍳24]←' The dog dug ''',(,⎕UCS 10),'      v',(,⎕UCS 8592),'v'
  (howreformat)[1845+⍳50]←','' an egg from a field on the farm.  Then the goat'
  (howreformat)[1895+⍳25]←' ate the hat. ''',(,⎕UCS 10),'      v',(,⎕UCS 8592),'v'
  (howreformat)[1920+⍳34]←',''That''''s the end of my story.''',(,⎕UCS 10),'..'
  (howreformat)[1954+⍳39]←'.reformat text to 60 character width.',(,⎕UCS 10),' '
  (howreformat)[1993+⍳23]←'     ',(,⎕UCS 9109 8592 109 8592),'60 reformat v',(,⎕UCS 10)
  (howreformat)[2016+⍳51]←'The quick brown fox jumped over the lazy red hen.  '
  (howreformat)[2067+⍳38]←'The dog',(,⎕UCS 10),'dug an egg from a field on the'
  (howreformat)[2105+⍳38]←' farm.  Then the goat ate',(,⎕UCS 10),'the hat.  Th'
  (howreformat)[2143+⍳35]←'at''s the end of my story.',(,⎕UCS 10 10),'...Refor'
  (howreformat)[2178+⍳48]←'mat matrix to width 60 with 3-character indent.',(,⎕UCS 10)
  (howreformat)[2226+⍳38]←'      60 3 reformat m',(,⎕UCS 10),'   The quick bro'
  (howreformat)[2264+⍳42]←'wn fox jumped over the lazy red hen.  The',(,⎕UCS 10)
  (howreformat)[2306+⍳51]←'   dog dug an egg from a field on the farm.  Then t'
  (howreformat)[2357+⍳37]←'he goat',(,⎕UCS 10),'   ate the hat.  That''s the e'
  (howreformat)[2394+⍳16]←'nd of my story.',(,⎕UCS 10)

howreparray←1413⍴0 ⍝ prolog ≡1
  (howreparray)[⍳56]←'--------------------------------------------------------'
  (howreparray)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'a reparr'
  (howreparray)[89+⍳40]←'ay m',(,⎕UCS 10),'replicate array <m>.  replicate <a['
  (howreparray)[129+⍳39]←'1]> times along coordinate <a[2]>',(,⎕UCS 10),'-----'
  (howreparray)[168+⍳52]←'----------------------------------------------------'
  (howreparray)[220+⍳36]←'---------------------',(,⎕UCS 10 10),'Introduction:'
  (howreparray)[256+⍳28]←(,⎕UCS 10),'------------',(,⎕UCS 10),'   <reparray> '
  (howreparray)[284+⍳48]←'''replicates'' (that is, ''repeats'') slices of the '
  (howreparray)[332+⍳39]←'array <m> along',(,⎕UCS 10),'   the coordinate speci'
  (howreparray)[371+⍳52]←'fied by <a[2]>.  For example, the function replicate'
  (howreparray)[423+⍳39]←'s',(,⎕UCS 10),'   rows or columns of a matrix along '
  (howreparray)[462+⍳39]←'the first or second coordinate,',(,⎕UCS 10),'   resp'
  (howreparray)[501+⍳52]←'ectively; it replicates planes, rows, or columns of '
  (howreparray)[553+⍳39]←'a rank-3 array',(,⎕UCS 10),'   along the first, seco'
  (howreparray)[592+⍳50]←'nd, or third coordinate, respectively; and so on.',(,⎕UCS 10)
  (howreparray)[642+⍳52]←'   The replication factor <a[1]> is the same for all'
  (howreparray)[694+⍳24]←' slices.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---'
  (howreparray)[718+⍳29]←'------',(,⎕UCS 10),'<a>   Numeric vector',(,⎕UCS 10),' '
  (howreparray)[747+⍳37]←'  a[1] -- Number of ''slices''',(,⎕UCS 10),'   a[2] '
  (howreparray)[784+⍳51]←'-- Coordinate along which replication takes place.',(,⎕UCS 10)
  (howreparray)[835+⍳41]←'           a[2] must be in the range (1,',(,⎕UCS 9076)
  (howreparray)[876+⍳36]←(,⎕UCS 9076),'m), that is, less than or equal to',(,⎕UCS 10)
  (howreparray)[912+⍳52]←'           the rank of <m>.  a[2]=1 means the first '
  (howreparray)[964+⍳39]←'coordinate, a[2]=2 means',(,⎕UCS 10),'           the'
  (howreparray)[1003+⍳51]←' second coordinate, and so on.  If a[2] is left out'
  (howreparray)[1054+⍳38]←', it',(,⎕UCS 10),'           defaults to the last c'
  (howreparray)[1092+⍳36]←'oordinate.',(,⎕UCS 10 10),'<m>   Numeric or charact'
  (howreparray)[1128+⍳36]←'er array',(,⎕UCS 10),'   Array to be replicated.',(,⎕UCS 10)
  (howreparray)[1164+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howreparray)[1181+⍳37]←'y>   Array',(,⎕UCS 10),'   <y> consists of ''slices'
  (howreparray)[1218+⍳37]←''' of <m> replicated <a[1]> times.  (',(,⎕UCS 9076)
  (howreparray)[1255+⍳13]←(,⎕UCS 9076),'y) = (',(,⎕UCS 9076 9076),'m).',(,⎕UCS 10)
  (howreparray)[1268+⍳20]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howreparray)[1288+⍳14]←'      ',(,⎕UCS 9109 8592 109 8592),'3 3',(,⎕UCS 9076)
  (howreparray)[1302+⍳16]←'''abc123',(,⎕UCS 8902),'-+''',(,⎕UCS 10),'abc',(,⎕UCS 10)
  (howreparray)[1318+⍳28]←'123',(,⎕UCS 10 8902 45 43 10),'      2 1 reparray m'
  (howreparray)[1346+⍳13]←(,⎕UCS 10),'abc',(,⎕UCS 10),'abc',(,⎕UCS 10),'123',(,⎕UCS 10)
  (howreparray)[1359+⍳18]←'123',(,⎕UCS 10 8902 45 43 10 8902 45 43 10),'      '
  (howreparray)[1377+⍳25]←'2 2 reparray m',(,⎕UCS 10),'aabbcc',(,⎕UCS 10),'112'
  (howreparray)[1402+⍳11]←'233',(,⎕UCS 10 8902 8902),'--++',(,⎕UCS 10)

howreport←2240⍴0 ⍝ prolog ≡1
  (howreport)[⍳58]←'----------------------------------------------------------'
  (howreport)[58+⍳34]←'--------------------',(,⎕UCS 10),'report parms',(,⎕UCS 10)
  (howreport)[92+⍳42]←'example of using the output functions',(,⎕UCS 10),'----'
  (howreport)[134+⍳54]←'------------------------------------------------------'
  (howreport)[188+⍳36]←'--------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howreport)[224+⍳41]←'------------',(,⎕UCS 10),'   <report> is an executable'
  (howreport)[265+⍳48]←' example of using the output functions.  For an',(,⎕UCS 10)
  (howreport)[313+⍳50]←'   example of output to the ''terminal'' or ''screen'''
  (howreport)[363+⍳41]←', execute the following in',(,⎕UCS 10),'   the toolkit'
  (howreport)[404+⍳30]←' workspace:',(,⎕UCS 10 10),'   report ''t,20''',(,⎕UCS 10)
  (howreport)[434+⍳44]←(,⎕UCS 10),'   For a description of the supported outpu'
  (howreport)[478+⍳41]←'t devices, see the document on',(,⎕UCS 10),'   <outope'
  (howreport)[519+⍳39]←'n>.',(,⎕UCS 10 10),'   For a summary of how to use the'
  (howreport)[558+⍳41]←' output functions, study the function',(,⎕UCS 10),'   '
  (howreport)[599+⍳40]←'<report> and consult the notes below.',(,⎕UCS 10 10),'N'
  (howreport)[639+⍳28]←'otes:',(,⎕UCS 10),'-----',(,⎕UCS 10),'   When incorpor'
  (howreport)[667+⍳54]←'ating the output functions into application programs, '
  (howreport)[721+⍳41]←'the',(,⎕UCS 10),'   first step is to specify the outpu'
  (howreport)[762+⍳39]←'t device and to ''open'' (i.e.',(,⎕UCS 10),'   initial'
  (howreport)[801+⍳47]←'ize) it.  This is done by executing <outopen>.',(,⎕UCS 10)
  (howreport)[848+⍳44]←(,⎕UCS 10),'   Then the functions <out> and <outpage> a'
  (howreport)[892+⍳41]←'re used.  Every line of text that',(,⎕UCS 10),'   is i'
  (howreport)[933+⍳54]←'ntended for the output device is passed through <out>.'
  (howreport)[987+⍳41]←'  If enough',(,⎕UCS 10),'   text is sent that the end '
  (howreport)[1028+⍳45]←'of the page is reached, subsequent output is',(,⎕UCS 10)
  (howreport)[1073+⍳53]←'   directed to a new page and a specified page headin'
  (howreport)[1126+⍳40]←'g is printed.  If a new',(,⎕UCS 10),'   page needs to'
  (howreport)[1166+⍳53]←' be forced before filling the current page, then <out'
  (howreport)[1219+⍳40]←'page>',(,⎕UCS 10),'   is is used.  <out> and <outpage'
  (howreport)[1259+⍳40]←'> are programmed to direct output and',(,⎕UCS 10),'  '
  (howreport)[1299+⍳51]←' ''form feeds'' in the manner appropriate for the sel'
  (howreport)[1350+⍳38]←'ected device.',(,⎕UCS 10 10),'   The last step, after'
  (howreport)[1388+⍳50]←' completing the output, is to ''close'' the device.',(,⎕UCS 10)
  (howreport)[1438+⍳42]←'   This is done by executing <outclose>.',(,⎕UCS 10 10)
  (howreport)[1480+⍳53]←'   Note that if the selected device does not require '
  (howreport)[1533+⍳40]←'special initialization',(,⎕UCS 10),'   or closing act'
  (howreport)[1573+⍳52]←'ions, then <outopen> and <outclose> are ''pass-throug'
  (howreport)[1625+⍳24]←'h''',(,⎕UCS 10),'   functions only.',(,⎕UCS 10 10),' '
  (howreport)[1649+⍳53]←'  Overall, these functions provide a minimal set of o'
  (howreport)[1702+⍳40]←'perations for any',(,⎕UCS 10),'   output device.  The'
  (howreport)[1742+⍳53]←'se functions always appear in programs in the sequenc'
  (howreport)[1795+⍳40]←'e',(,⎕UCS 10),'   described, and therefore, no matter'
  (howreport)[1835+⍳40]←' what device is selected, (1) the',(,⎕UCS 10),'   dev'
  (howreport)[1875+⍳53]←'ice is opened -- <outopen>, (2) text output is format'
  (howreport)[1928+⍳40]←'ted and directed',(,⎕UCS 10),'   to the device approp'
  (howreport)[1968+⍳53]←'riately -- <out> and <outpage>, and (3) the device is'
  (howreport)[2021+⍳28]←(,⎕UCS 10),'   closed -- <outclose>.',(,⎕UCS 10 10),' '
  (howreport)[2049+⍳53]←'  Since these functions are ordinary APL functions, t'
  (howreport)[2102+⍳40]←'hey may also be',(,⎕UCS 10),'   executed in immediate'
  (howreport)[2142+⍳52]←' execution mode to achieve their purpose - provided',(,⎕UCS 10)
  (howreport)[2194+⍳46]←'   they are executed in the correct sequence.',(,⎕UCS 10)

howreportheader←395⍴0 ⍝ prolog ≡1
  (howreportheader)[⍳52]←'----------------------------------------------------'
  (howreportheader)[52+⍳36]←'--------------------------',(,⎕UCS 10),'reporthea'
  (howreportheader)[88+⍳36]←'der',(,⎕UCS 10),'example of report header functio'
  (howreportheader)[124+⍳35]←'n (used in <report>)',(,⎕UCS 10),'--------------'
  (howreportheader)[159+⍳48]←'------------------------------------------------'
  (howreportheader)[207+⍳32]←'----------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howreportheader)[239+⍳35]←'------------',(,⎕UCS 10),'   This function defin'
  (howreportheader)[274+⍳48]←'es the report header for the function <report>, '
  (howreportheader)[322+⍳35]←'which',(,⎕UCS 10),'   provides a complete exampl'
  (howreportheader)[357+⍳38]←'e of the use of the output functions.',(,⎕UCS 10)

howriota←1162⍴0 ⍝ prolog ≡1
  (howriota)[⍳59]←'-----------------------------------------------------------'
  (howriota)[59+⍳32]←'-------------------',(,⎕UCS 10 114 8592),'x riota y',(,⎕UCS 10)
  (howriota)[91+⍳47]←'in matrix <x> where is each row of matrix <y>?',(,⎕UCS 10)
  (howriota)[138+⍳55]←'-------------------------------------------------------'
  (howriota)[193+⍳39]←'-----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howriota)[232+⍳34]←'------------',(,⎕UCS 10),'   <riota> is like x',(,⎕UCS 9075)
  (howriota)[266+⍳32]←'y but for matrices.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howriota)[298+⍳27]←'---------',(,⎕UCS 10),'<x>   Matrix',(,⎕UCS 10 10),'<y>'
  (howriota)[325+⍳42]←'   Array (rank 0 to 2)',(,⎕UCS 10),'   A scalar or vect'
  (howriota)[367+⍳43]←'or argument is treated as a 1-row matrix.',(,⎕UCS 10 10)
  (howriota)[410+⍳28]←'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   Vector',(,⎕UCS 10)
  (howriota)[438+⍳55]←'   r[i] gives the row position of x[i;] in <y>.  If x[i'
  (howriota)[493+⍳42]←';] is not found in',(,⎕UCS 10),'   <y>, then r[i] is 1+'
  (howriota)[535+⍳36]←'1',(,⎕UCS 8593 9076),'y.  <x> and <y> do not have to be'
  (howriota)[571+⍳42]←' conformable with',(,⎕UCS 10),'   respect to columns, a'
  (howriota)[613+⍳43]←'s the arguments are padded appropriately.',(,⎕UCS 10 10)
  (howriota)[656+⍳29]←'Source:',(,⎕UCS 10),'------',(,⎕UCS 10),'   From The AP'
  (howriota)[685+⍳40]←'L Handbook of Techniques, 1978, IBM.',(,⎕UCS 10 10),'Ex'
  (howriota)[725+⍳24]←'amples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howriota)[749+⍳12]←(,⎕UCS 8592 109 8592),'5 5',(,⎕UCS 9076),'''/'' ',(,⎕UCS 8710)
  (howriota)[761+⍳29]←'box ''apple/betty/cat''',(,⎕UCS 10),'apple',(,⎕UCS 10),'b'
  (howriota)[790+⍳16]←'etty',(,⎕UCS 10),'cat',(,⎕UCS 10),'apple',(,⎕UCS 10),'b'
  (howriota)[806+⍳28]←'etty',(,⎕UCS 10),'      m riota ''apple''',(,⎕UCS 10 49)
  (howriota)[834+⍳27]←(,⎕UCS 10),'      m riota m',(,⎕UCS 10),'1 2 3 1 2',(,⎕UCS 10)
  (howriota)[861+⍳34]←'      m riota ''bat''',(,⎕UCS 10 54 10),'      ''apple'
  (howriota)[895+⍳26]←''' riota m',(,⎕UCS 10),'1 2 2 1 2',(,⎕UCS 10 10),'     '
  (howriota)[921+⍳11]←' ',(,⎕UCS 9109 8592 109 8592),'4 4',(,⎕UCS 9076 9075 49)
  (howriota)[932+⍳26]←(,⎕UCS 50 10),' 1  2  3  4',(,⎕UCS 10),' 5  6  7  8',(,⎕UCS 10)
  (howriota)[958+⍳29]←' 9 10 11 12',(,⎕UCS 10),' 1  2  3  4',(,⎕UCS 10),'     '
  (howriota)[987+⍳38]←' m riota 1 2 3 4',(,⎕UCS 10 49 10),'      m riota 1 2 3'
  (howriota)[1025+⍳26]←(,⎕UCS 10 53 10),'      m riota m',(,⎕UCS 10),'1 2 3 1'
  (howriota)[1051+⍳33]←(,⎕UCS 10 10),'...First occurence of each row',(,⎕UCS 10)
  (howriota)[1084+⍳25]←'      (m riota m)=',(,⎕UCS 9075 49 8593 9076 109 10),'1'
  (howriota)[1109+⍳31]←' 1 1 0',(,⎕UCS 10),'...Compare with <first>',(,⎕UCS 10)
  (howriota)[1140+⍳22]←'      first m',(,⎕UCS 10),'1 1 1 0',(,⎕UCS 10)

howrnd←563⍴0 ⍝ prolog ≡1
  (howrnd)[⍳61]←'-------------------------------------------------------------'
  (howrnd)[61+⍳28]←'-----------------',(,⎕UCS 10 114 8592),'n rnd x',(,⎕UCS 10)
  (howrnd)[89+⍳45]←'round numbers <x> to <n> decimal places',(,⎕UCS 10),'-----'
  (howrnd)[134+⍳57]←'---------------------------------------------------------'
  (howrnd)[191+⍳30]←'----------------',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howrnd)[221+⍳31]←'--------',(,⎕UCS 10),'<x>   numeric array',(,⎕UCS 10 10),'<'
  (howrnd)[252+⍳44]←'n>   integer scalar',(,⎕UCS 10),'   The number of digits '
  (howrnd)[296+⍳42]←'after the decimal point to round <x>.',(,⎕UCS 10 10),'Res'
  (howrnd)[338+⍳31]←'ult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   numeric array'
  (howrnd)[369+⍳29]←(,⎕UCS 10),'   The rounded numbers',(,⎕UCS 10),'   (',(,⎕UCS 9076)
  (howrnd)[398+⍳20]←'r)=(',(,⎕UCS 9076 120 41 10 10),'Examples:',(,⎕UCS 10),'-'
  (howrnd)[418+⍳29]←'-------',(,⎕UCS 10),'      y',(,⎕UCS 8592),'45.345 45.344'
  (howrnd)[447+⍳34]←' 2.136 10.36 5.7 66',(,⎕UCS 10),'      2 rnd y',(,⎕UCS 10)
  (howrnd)[481+⍳42]←'45.35 45.34 2.14 10.36 5.7 66',(,⎕UCS 10 10),'      2 rnd'
  (howrnd)[523+⍳26]←' 2 3',(,⎕UCS 9076 121 10),'45.35 45.34  2.14',(,⎕UCS 10),'1'
  (howrnd)[549+⍳14]←'0.36  5.7  66',(,⎕UCS 10)

howrnde←727⍴0 ⍝ prolog ≡1
  (howrnde)[⍳60]←'------------------------------------------------------------'
  (howrnde)[60+⍳28]←'------------------',(,⎕UCS 10 114 8592),'rnde x',(,⎕UCS 10)
  (howrnde)[88+⍳57]←'round <x> to nearest integer (.5 case goes to nearest eve'
  (howrnde)[145+⍳43]←'n integer)',(,⎕UCS 10),'--------------------------------'
  (howrnde)[188+⍳47]←'----------------------------------------------',(,⎕UCS 10)
  (howrnde)[235+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howrnde)[258+⍳29]←'x>   numeric array',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howrnde)[287+⍳30]←'-----',(,⎕UCS 10),'<r>   numeric array',(,⎕UCS 10),'   T'
  (howrnde)[317+⍳56]←'he numbers <x> are rounded to the nearest integer.  Howe'
  (howrnde)[373+⍳43]←'ver, x.5 is',(,⎕UCS 10),'   rounded to the nearest even '
  (howrnde)[416+⍳46]←'integer; that is, if x is odd, x.5 is rounded',(,⎕UCS 10)
  (howrnde)[462+⍳56]←'   up (to x+1), but if x is even, x.5 is rounded down (t'
  (howrnde)[518+⍳26]←'o x).',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howrnde)[544+⍳43]←'      rnde 9.5 10.5 11.5 12.5 13.5 14.5',(,⎕UCS 10),'10 '
  (howrnde)[587+⍳43]←'10 12 12 14 14',(,⎕UCS 10),'      rnde 11.1 11.2 11.3 11'
  (howrnde)[630+⍳32]←'.4 11.5 11.6',(,⎕UCS 10),'11 11 11 11 12 12',(,⎕UCS 10),' '
  (howrnde)[662+⍳46]←'     rnde 11.457 432.67 23.14 23.6 24.14 24.6',(,⎕UCS 10)
  (howrnde)[708+⍳19]←'11 433 23 24 24 25',(,⎕UCS 10)

howroman←760⍴0 ⍝ prolog ≡1
  (howroman)[⍳59]←'-----------------------------------------------------------'
  (howroman)[59+⍳30]←'-------------------',(,⎕UCS 10 121 8592),'roman x',(,⎕UCS 10)
  (howroman)[89+⍳56]←'character roman numeral equivalent of arabic (base 10) n'
  (howroman)[145+⍳42]←'umber <x>',(,⎕UCS 10),'--------------------------------'
  (howroman)[187+⍳47]←'----------------------------------------------',(,⎕UCS 10)
  (howroman)[234+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howroman)[262+⍳55]←'   <roman> returns the Roman numeral equivalent (as a c'
  (howroman)[317+⍳40]←'haracter vector) of an',(,⎕UCS 10),'   ''Arabic'' numbe'
  (howroman)[357+⍳40]←'r given as a numeric quantity.',(,⎕UCS 10 10),'Argument'
  (howroman)[397+⍳29]←'s:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<x>   1-element '
  (howroman)[426+⍳42]←'numeric scalar or vector',(,⎕UCS 10),'   A number (in b'
  (howroman)[468+⍳28]←'ase-10 notation).',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (howroman)[496+⍳30]←'-----',(,⎕UCS 10),'<y>   Character vector',(,⎕UCS 10),' '
  (howroman)[526+⍳55]←'  The corresponding number given in Roman numeral notat'
  (howroman)[581+⍳25]←'ion.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howroman)[606+⍳32]←'      roman 4',(,⎕UCS 10 105 118 10),'      roman 14',(,⎕UCS 10)
  (howroman)[638+⍳28]←'xiv',(,⎕UCS 10),'      roman 537',(,⎕UCS 10),'dxxxvii',(,⎕UCS 10)
  (howroman)[666+⍳40]←(,⎕UCS 10),'... <roman> and <arabic> are inverses.',(,⎕UCS 10)
  (howroman)[706+⍳29]←'      roman 1992',(,⎕UCS 10),'mcmxcii',(,⎕UCS 10),'    '
  (howroman)[735+⍳25]←'  arabic roman 1992',(,⎕UCS 10),'1992',(,⎕UCS 10)

howscript←2883⍴0 ⍝ prolog ≡1
  (howscript)[⍳58]←'----------------------------------------------------------'
  (howscript)[58+⍳35]←'--------------------',(,⎕UCS 10 89 8592),'script Text',(,⎕UCS 10)
  (howscript)[93+⍳55]←'return document <Y> using script in character matrix <T'
  (howscript)[148+⍳41]←'ext>',(,⎕UCS 10),'------------------------------------'
  (howscript)[189+⍳43]←'------------------------------------------',(,⎕UCS 10)
  (howscript)[232+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howscript)[260+⍳52]←'   <script> computes a document <y> using a ''script'''
  (howscript)[312+⍳41]←' (the argument <text>).',(,⎕UCS 10),'   The function e'
  (howscript)[353+⍳53]←'xecutes APL statements and merges computer-generated',(,⎕UCS 10)
  (howscript)[406+⍳54]←'   examples with plain text.  This general capability '
  (howscript)[460+⍳41]←'has many applications,',(,⎕UCS 10),'   such as documen'
  (howscript)[501+⍳54]←'tation of APL functions, sets of test examples, analys'
  (howscript)[555+⍳41]←'is',(,⎕UCS 10),'   of algorithms, etc.  <script> was u'
  (howscript)[596+⍳41]←'sed to document the toolkit workspace.',(,⎕UCS 10 10),' '
  (howscript)[637+⍳53]←'  <text> contains text optionally prefaced by ''action'
  (howscript)[690+⍳40]←' codes''.  <script>',(,⎕UCS 10),'   identifies each co'
  (howscript)[730+⍳54]←'de and performs the specified action.  For example, th'
  (howscript)[784+⍳39]←'e',(,⎕UCS 10),'   ''.t'' action code specifies that an'
  (howscript)[823+⍳41]←' APL statement and its result be be',(,⎕UCS 10),'   in'
  (howscript)[864+⍳54]←'serted into the result text.  However, <script> does n'
  (howscript)[918+⍳29]←'ot format text.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howscript)[947+⍳41]←'--------',(,⎕UCS 10),'<text>   Character vector or mat'
  (howscript)[988+⍳41]←'rix',(,⎕UCS 10),'   If <text> is a vector, it is assum'
  (howscript)[1029+⍳40]←'ed to be a set of lines delimited by',(,⎕UCS 10),'   '
  (howscript)[1069+⍳51]←'''return'' characters.  If a matrix, each row is one '
  (howscript)[1120+⍳36]←'line.',(,⎕UCS 10 10),'   <text> is the ''script'' con'
  (howscript)[1156+⍳45]←'sisting of a set of lines.  If a line begins',(,⎕UCS 10)
  (howscript)[1201+⍳53]←'   with a code, the specified action is performed on '
  (howscript)[1254+⍳40]←'the text that follows',(,⎕UCS 10),'   the code.  A co'
  (howscript)[1294+⍳52]←'de consists of the three characters (period, letter,'
  (howscript)[1346+⍳43]←(,⎕UCS 10),'   blank) at the beginning of a line.  If '
  (howscript)[1389+⍳40]←'a line does not begin with a code,',(,⎕UCS 10),'   it'
  (howscript)[1429+⍳53]←' is considered as plain text and included without cha'
  (howscript)[1482+⍳38]←'nge.',(,⎕UCS 10 10),'   For definitions of the codes,'
  (howscript)[1520+⍳42]←' refer to the document <howscriptcodes>.',(,⎕UCS 10 10)
  (howscript)[1562+⍳27]←'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Charac'
  (howscript)[1589+⍳40]←'ter matrix',(,⎕UCS 10),'   The text produced after pr'
  (howscript)[1629+⍳38]←'ocessing the argument <text>.',(,⎕UCS 10 10),'Example'
  (howscript)[1667+⍳27]←'s:',(,⎕UCS 10),'--------',(,⎕UCS 10),'   The document'
  (howscript)[1694+⍳53]←' <howscriptcodes> mentionned above contains examples.'
  (howscript)[1747+⍳40]←'  Also,',(,⎕UCS 10),'   the document <examplescript> '
  (howscript)[1787+⍳32]←'is an example argument.',(,⎕UCS 10 10),'Notes:',(,⎕UCS 10)
  (howscript)[1819+⍳40]←'-----',(,⎕UCS 10),'   (1) Typically the programmer wh'
  (howscript)[1859+⍳43]←'o uses <script> wants <script> to control',(,⎕UCS 10),' '
  (howscript)[1902+⍳50]←'  the entire result.  For this reason, note that ',(,⎕UCS 9109)
  (howscript)[1952+⍳38]←' output within a',(,⎕UCS 10),'   statement (e.g.  a'
  (howscript)[1990+⍳24]←(,⎕UCS 8592 50 43 9109 8592 98 215),'5) will cause a d'
  (howscript)[2014+⍳40]←'isplay while <script> is',(,⎕UCS 10),'   executing, a'
  (howscript)[2054+⍳50]←'nd this display will not be captured.  (However, ',(,⎕UCS 9109)
  (howscript)[2104+⍳40]←' at the end',(,⎕UCS 10),'   of a line will be capture'
  (howscript)[2144+⍳49]←'d.) Any quad output within functions executed by',(,⎕UCS 10)
  (howscript)[2193+⍳42]←'   <script> will not be captured either.',(,⎕UCS 10 10)
  (howscript)[2235+⍳53]←'   (2) <script> is programmed under the assumption th'
  (howscript)[2288+⍳25]←'at ',(,⎕UCS 9038),' follows the ISO',(,⎕UCS 10),'   s'
  (howscript)[2313+⍳26]←'tandard that x',(,⎕UCS 8592 9038 39 97 8592),'express'
  (howscript)[2339+⍳46]←'ion'' is valid and <x> takes the value of <a>.',(,⎕UCS 10)
  (howscript)[2385+⍳28]←(,⎕UCS 10),'   (3) ',(,⎕UCS 9109),'io is localized to '
  (howscript)[2413+⍳33]←'1 within <script> and setting ',(,⎕UCS 9109 105 111)
  (howscript)[2446+⍳28]←(,⎕UCS 8592),'0 within the',(,⎕UCS 10),'   script will'
  (howscript)[2474+⍳38]←' cause unexpected results.',(,⎕UCS 10 10),'   (4) Inv'
  (howscript)[2512+⍳53]←'alid APL statements may cause <script> to suspend.  R'
  (howscript)[2565+⍳40]←'efer to the',(,⎕UCS 10),'   notes within the function'
  (howscript)[2605+⍳38]←' for debugging hints.',(,⎕UCS 10 10),'   (5) The code'
  (howscript)[2643+⍳53]←'s are designed to provide flexibility and power in de'
  (howscript)[2696+⍳40]←'veloping',(,⎕UCS 10),'   computer-generated documenta'
  (howscript)[2736+⍳45]←'tion.  If one code does not do the work, try',(,⎕UCS 10)
  (howscript)[2781+⍳53]←'   a combination of codes, possibly in combination wi'
  (howscript)[2834+⍳39]←'th an APL function',(,⎕UCS 10),'   executed by the '''
  (howscript)[2873+⍳10]←'.e'' code.',(,⎕UCS 10)

howscriptcodes←4566⍴0 ⍝ prolog ≡1
  (howscriptcodes)[⍳53]←'-----------------------------------------------------'
  (howscriptcodes)[53+⍳37]←'-------------------------',(,⎕UCS 10),'Description'
  (howscriptcodes)[90+⍳37]←' of <script> Action Codes',(,⎕UCS 10),'-----------'
  (howscriptcodes)[127+⍳49]←'-------------------------------------------------'
  (howscriptcodes)[176+⍳34]←'------------------',(,⎕UCS 10 10),'   The followi'
  (howscriptcodes)[210+⍳49]←'ng provides a description of each script action c'
  (howscriptcodes)[259+⍳36]←'ode, its',(,⎕UCS 10),'   mnemonic significance, a'
  (howscriptcodes)[295+⍳24]←'nd examples.',(,⎕UCS 10 10),'Summary:',(,⎕UCS 10),'-'
  (howscriptcodes)[319+⍳36]←'------',(,⎕UCS 10),'   b   build -- build a text '
  (howscriptcodes)[355+⍳39]←'matrix and optionally fix as function',(,⎕UCS 10),' '
  (howscriptcodes)[394+⍳48]←'  c   comment -- comment within the script text',(,⎕UCS 10)
  (howscriptcodes)[442+⍳43]←'   d   display -- ''display'' specified text',(,⎕UCS 10)
  (howscriptcodes)[485+⍳43]←'   e   execute -- execute an APL statement',(,⎕UCS 10)
  (howscriptcodes)[528+⍳49]←'   n   niladic execute -- execute a niladic APL s'
  (howscriptcodes)[577+⍳35]←'tatement',(,⎕UCS 10),'   p   capture -- ''display'
  (howscriptcodes)[612+⍳46]←''' an APL statement and its result (including x'
  (howscriptcodes)[658+⍳23]←(,⎕UCS 8592),'exp)',(,⎕UCS 10),'   r   result -- '
  (howscriptcodes)[681+⍳41]←'''display'' the result of an APL statement',(,⎕UCS 10)
  (howscriptcodes)[722+⍳47]←'   t   terminal -- ''display'' an APL statement a'
  (howscriptcodes)[769+⍳34]←'nd its ''terminal'' result',(,⎕UCS 10),'   x   ex'
  (howscriptcodes)[803+⍳43]←'punge -- expunge (erase) specified objects',(,⎕UCS 10)
  (howscriptcodes)[846+⍳18]←(,⎕UCS 10),'Details:',(,⎕UCS 10),'-------',(,⎕UCS 10)
  (howscriptcodes)[864+⍳36]←'   b   build',(,⎕UCS 10),'        - Build a text '
  (howscriptcodes)[900+⍳49]←'matrix in the local variable Scriptbuffer using a'
  (howscriptcodes)[949+⍳32]←'ll',(,⎕UCS 10),'        lines prefaced by .b',(,⎕UCS 10)
  (howscriptcodes)[981+⍳49]←'        - Fix the matrix as a function on encount'
  (howscriptcodes)[1030+⍳31]←'ering .b ',(,⎕UCS 8711 10),'        - Scriptbuff'
  (howscriptcodes)[1061+⍳48]←'er is initialized as empty when <script> begins,'
  (howscriptcodes)[1109+⍳35]←' and is',(,⎕UCS 10),'        re-initialized when'
  (howscriptcodes)[1144+⍳45]←' the contents are fixed so the buffer can be',(,⎕UCS 10)
  (howscriptcodes)[1189+⍳48]←'        re-used.  Alternatively, one can use Scr'
  (howscriptcodes)[1237+⍳35]←'iptbuffer in the script,',(,⎕UCS 10),'        an'
  (howscriptcodes)[1272+⍳43]←'d re-initialize explicitly by Scriptbuffer',(,⎕UCS 8592)
  (howscriptcodes)[1315+⍳23]←'0 0',(,⎕UCS 9076 39 39 10),'           .b y',(,⎕UCS 8592)
  (howscriptcodes)[1338+⍳22]←'foo x',(,⎕UCS 10),'           .b y',(,⎕UCS 8592)
  (howscriptcodes)[1360+⍳29]←(,⎕UCS 120 8902 50 10),'           .c Fix the con'
  (howscriptcodes)[1389+⍳41]←'tents of Scriptbuffer and re-initialize.',(,⎕UCS 10)
  (howscriptcodes)[1430+⍳29]←'           .b ',(,⎕UCS 8711 10 10),'   c   comme'
  (howscriptcodes)[1459+⍳35]←'nt',(,⎕UCS 10),'        - comment text within sc'
  (howscriptcodes)[1494+⍳36]←'ript.  <script> ignores this text.',(,⎕UCS 10),' '
  (howscriptcodes)[1530+⍳40]←'         .c Script prepared April 1992.',(,⎕UCS 10)
  (howscriptcodes)[1570+⍳48]←'          .c The following part of the script et'
  (howscriptcodes)[1618+⍳29]←'c. etc. etc.',(,⎕UCS 10 10),'   d   display',(,⎕UCS 10)
  (howscriptcodes)[1647+⍳35]←'        - Display specified text.',(,⎕UCS 10),' '
  (howscriptcodes)[1682+⍳48]←'       - This code is not often used, as it is e'
  (howscriptcodes)[1730+⍳35]←'quivalent to text with no',(,⎕UCS 10),'        c'
  (howscriptcodes)[1765+⍳48]←'ode.  However, it is required for displaying lin'
  (howscriptcodes)[1813+⍳35]←'es that begin with',(,⎕UCS 10),'        an actio'
  (howscriptcodes)[1848+⍳26]←'n code.',(,⎕UCS 10),'          .d .t a',(,⎕UCS 8592)
  (howscriptcodes)[1874+⍳35]←'2+2',(,⎕UCS 10),'          .d arbitrary text (pe'
  (howscriptcodes)[1909+⍳32]←'rhaps a comment)',(,⎕UCS 10 10),'   e   execute'
  (howscriptcodes)[1941+⍳38]←(,⎕UCS 10),'        - Execute the specified expre'
  (howscriptcodes)[1979+⍳41]←'ssion but do not display anything.  This',(,⎕UCS 10)
  (howscriptcodes)[2020+⍳48]←'        code can be used with assignment stateme'
  (howscriptcodes)[2068+⍳35]←'nts and all statements',(,⎕UCS 10),'        retu'
  (howscriptcodes)[2103+⍳35]←'rning an explicit result.',(,⎕UCS 10),'        -'
  (howscriptcodes)[2138+⍳46]←' This code is typically used to ''set up'' funct'
  (howscriptcodes)[2184+⍳35]←'ions and variables for',(,⎕UCS 10),'        the '
  (howscriptcodes)[2219+⍳48]←'document creation process, and to affect the exe'
  (howscriptcodes)[2267+⍳28]←'cution',(,⎕UCS 10),'        environment.',(,⎕UCS 10)
  (howscriptcodes)[2295+⍳20]←'          .e ',(,⎕UCS 9109 112 119 8592 55 56 10)
  (howscriptcodes)[2315+⍳20]←'          .e ',(,⎕UCS 9109 105 111 8592 48 10),' '
  (howscriptcodes)[2335+⍳30]←'         .e foo',(,⎕UCS 10),'          .e ',(,⎕UCS 9109)
  (howscriptcodes)[2365+⍳30]←'ex ''x''',(,⎕UCS 10 10),'   n   niladic execute'
  (howscriptcodes)[2395+⍳38]←(,⎕UCS 10),'        - Execute an expression that '
  (howscriptcodes)[2433+⍳38]←'does not return a result (typically a',(,⎕UCS 10)
  (howscriptcodes)[2471+⍳48]←'        niladic function) but do not display exp'
  (howscriptcodes)[2519+⍳35]←'ression.',(,⎕UCS 10),'        - This code is the'
  (howscriptcodes)[2554+⍳46]←' same as code ''r'' but for niladic expressions,'
  (howscriptcodes)[2600+⍳38]←(,⎕UCS 10),'        which require special program'
  (howscriptcodes)[2638+⍳30]←'ming (i.e.  ',(,⎕UCS 9038),'text rather than',(,⎕UCS 10)
  (howscriptcodes)[2668+⍳21]←'        Sink',(,⎕UCS 8592 9038),'text).',(,⎕UCS 10)
  (howscriptcodes)[2689+⍳33]←'          .n niladicfunction',(,⎕UCS 10 10),'   '
  (howscriptcodes)[2722+⍳35]←'p   capture',(,⎕UCS 10),'        - Execute the t'
  (howscriptcodes)[2757+⍳48]←'ext, then display the text and the result of the'
  (howscriptcodes)[2805+⍳38]←(,⎕UCS 10),'        execution, no matter what kin'
  (howscriptcodes)[2843+⍳35]←'d of APL statement was executed',(,⎕UCS 10),'   '
  (howscriptcodes)[2878+⍳47]←'     (assignment, non-assignment, quad output).'
  (howscriptcodes)[2925+⍳38]←(,⎕UCS 10),'        - This is useful for computer'
  (howscriptcodes)[2963+⍳38]←'-generated examples and also it is an',(,⎕UCS 10)
  (howscriptcodes)[3001+⍳46]←'        useful ''trace'' facility for studying a'
  (howscriptcodes)[3047+⍳35]←' series of expressions.',(,⎕UCS 10),'           '
  (howscriptcodes)[3082+⍳48]←'.c At the next line <script> will pause for quad'
  (howscriptcodes)[3130+⍳31]←' input for ''x''.',(,⎕UCS 10),'           .p x'
  (howscriptcodes)[3161+⍳19]←(,⎕UCS 8592 9109 10),'           .p a',(,⎕UCS 8592)
  (howscriptcodes)[3180+⍳21]←(,⎕UCS 120 215),'expression1',(,⎕UCS 10),'       '
  (howscriptcodes)[3201+⍳23]←'    .p b',(,⎕UCS 8592 97 215),'expression2',(,⎕UCS 10)
  (howscriptcodes)[3224+⍳25]←(,⎕UCS 10),'   r   result',(,⎕UCS 10),'        - '
  (howscriptcodes)[3249+⍳46]←'Execute the text following code ''r'' and merge '
  (howscriptcodes)[3295+⍳35]←'the result into the',(,⎕UCS 10),'        documen'
  (howscriptcodes)[3330+⍳48]←'t.  However, do not display the expression being'
  (howscriptcodes)[3378+⍳35]←' executed.',(,⎕UCS 10),'        - This is used f'
  (howscriptcodes)[3413+⍳41]←'or computer-generated text and examples.',(,⎕UCS 10)
  (howscriptcodes)[3454+⍳34]←'           .r ''''displayfunction ',(,⎕UCS 9109),'c'
  (howscriptcodes)[3488+⍳25]←'r ''foo''',(,⎕UCS 10 10),'   t   terminal',(,⎕UCS 10)
  (howscriptcodes)[3513+⍳48]←'        - Display text indented 6 spaces as thou'
  (howscriptcodes)[3561+⍳35]←'gh entered at the terminal',(,⎕UCS 10),'        '
  (howscriptcodes)[3596+⍳48]←'(keyboard), then execute the text and display an'
  (howscriptcodes)[3644+⍳35]←'y results normally',(,⎕UCS 10),'        displaye'
  (howscriptcodes)[3679+⍳35]←'d.',(,⎕UCS 10),'        - For assignment stateme'
  (howscriptcodes)[3714+⍳46]←'nts, the statement is displayed and executed,',(,⎕UCS 10)
  (howscriptcodes)[3760+⍳41]←'        but the result is not displayed.',(,⎕UCS 10)
  (howscriptcodes)[3801+⍳38]←'        - For statements ending with ',(,⎕UCS 9109)
  (howscriptcodes)[3839+⍳26]←(,⎕UCS 8592),', the statement without ',(,⎕UCS 9109)
  (howscriptcodes)[3865+⍳35]←' is executed,',(,⎕UCS 10),'        the entire st'
  (howscriptcodes)[3900+⍳48]←'atement displayed in the document, and the resul'
  (howscriptcodes)[3948+⍳35]←'t shown',(,⎕UCS 10),'        beneath it (just li'
  (howscriptcodes)[3983+⍳35]←'ke on a terminal).',(,⎕UCS 10),'        - Commen'
  (howscriptcodes)[4018+⍳33]←'ts (statements beginning with ',(,⎕UCS 9053),') '
  (howscriptcodes)[4051+⍳35]←'are shown but not executed.',(,⎕UCS 10),'       '
  (howscriptcodes)[4086+⍳45]←' - .t is the most commonly used script code.',(,⎕UCS 10)
  (howscriptcodes)[4131+⍳25]←'          .t 2 2',(,⎕UCS 9076 9075 52 10),'     '
  (howscriptcodes)[4156+⍳20]←'     .t a',(,⎕UCS 8592),'2+2',(,⎕UCS 10),'      '
  (howscriptcodes)[4176+⍳14]←'    .t ',(,⎕UCS 9109 8592),'mat',(,⎕UCS 8592),'2'
  (howscriptcodes)[4190+⍳24]←' 2',(,⎕UCS 9076 52 10),'          .t foo x',(,⎕UCS 10)
  (howscriptcodes)[4214+⍳33]←'          .t ',(,⎕UCS 9053),'the quick brown fox'
  (howscriptcodes)[4247+⍳23]←(,⎕UCS 10 10),'   x   expunge',(,⎕UCS 10),'      '
  (howscriptcodes)[4270+⍳48]←'  - Expunge objects specified in the list.  This'
  (howscriptcodes)[4318+⍳35]←' is a convenience code',(,⎕UCS 10),'        whic'
  (howscriptcodes)[4353+⍳48]←'h makes it easy to expunge objects from the work'
  (howscriptcodes)[4401+⍳35]←'space created by',(,⎕UCS 10),'        script dur'
  (howscriptcodes)[4436+⍳36]←'ing the document creation process.',(,⎕UCS 10),' '
  (howscriptcodes)[4472+⍳46]←'         .c Action code ''x'' expunges (erases) '
  (howscriptcodes)[4518+⍳29]←'objects ''a'' ''m'' and ''foo''.',(,⎕UCS 10),'  '
  (howscriptcodes)[4547+⍳19]←'        .x a m foo',(,⎕UCS 10)

howsearch←1490⍴0 ⍝ prolog ≡1
  (howsearch)[⍳58]←'----------------------------------------------------------'
  (howsearch)[58+⍳34]←'--------------------',(,⎕UCS 10 121 8592),'m search s',(,⎕UCS 10)
  (howsearch)[92+⍳54]←'y[i]=1 if row <m[i;]> contains the search sequence <s>'
  (howsearch)[146+⍳44]←(,⎕UCS 10),'-------------------------------------------'
  (howsearch)[190+⍳39]←'-----------------------------------',(,⎕UCS 10 10),'In'
  (howsearch)[229+⍳28]←'troduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   '
  (howsearch)[257+⍳54]←'<search> is a simple general function for selecting th'
  (howsearch)[311+⍳41]←'e rows of a matrix',(,⎕UCS 10),'   that contain the sp'
  (howsearch)[352+⍳43]←'ecified character or numeric sequence <s>.',(,⎕UCS 10)
  (howsearch)[395+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howsearch)[417+⍳41]←'<m>   Matrix',(,⎕UCS 10),'   The matrix to be searched'
  (howsearch)[458+⍳26]←'.',(,⎕UCS 10 10),'<s>   Vector',(,⎕UCS 10),'   The sea'
  (howsearch)[484+⍳39]←'rch sequence.',(,⎕UCS 10 10),'<m> and <s> must be both'
  (howsearch)[523+⍳37]←' numeric or both character.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howsearch)[560+⍳29]←'------',(,⎕UCS 10),'<y>   Numeric vector',(,⎕UCS 10),' '
  (howsearch)[589+⍳54]←'  y[i]=1 -- m[i;] is selected (it contains the sequenc'
  (howsearch)[643+⍳41]←'e <s>).',(,⎕UCS 10),'   y[i]=0 -- m[i;] is not selecte'
  (howsearch)[684+⍳23]←'d.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howsearch)[707+⍳26]←'... Character',(,⎕UCS 10),'      data',(,⎕UCS 8592),''''
  (howsearch)[733+⍳52]←'John Doe/Jane Doe/Richard Roe/Jim Crow/Jim Schmidt/'''
  (howsearch)[785+⍳28]←(,⎕UCS 10),'      data',(,⎕UCS 8592),'data,''Jim Schnei'
  (howsearch)[813+⍳50]←'derman/Man Rey/Dick Black/Dick Blank/Jane Smith/''',(,⎕UCS 10)
  (howsearch)[863+⍳38]←'      data',(,⎕UCS 8592),'data,''John Smith/John Black'
  (howsearch)[901+⍳41]←'/John Black/John Blacksmith/Dick Smith''',(,⎕UCS 10),' '
  (howsearch)[942+⍳16]←'     ',(,⎕UCS 9076),'data',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710)
  (howsearch)[958+⍳26]←'box data',(,⎕UCS 10),'15 16',(,⎕UCS 10 10),'      data'
  (howsearch)[984+⍳39]←' search ''Black''',(,⎕UCS 10),'0 0 0 0 0 0 0 1 0 0 0 1'
  (howsearch)[1023+⍳38]←' 1 1 0',(,⎕UCS 10),'      '''' matacross (data search'
  (howsearch)[1061+⍳23]←' ''Black'')',(,⎕UCS 9023),'data',(,⎕UCS 10),' Dick Bl'
  (howsearch)[1084+⍳53]←'ack       John Black       John Black       John Blac'
  (howsearch)[1137+⍳30]←'ksmith',(,⎕UCS 10),'      data search ''gg''',(,⎕UCS 10)
  (howsearch)[1167+⍳38]←'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0',(,⎕UCS 10 10),'... <se'
  (howsearch)[1205+⍳53]←'arch> is sensitive to case (Man Rey is not selected).'
  (howsearch)[1258+⍳43]←(,⎕UCS 10),'... If case-sensitivity is not desired, da'
  (howsearch)[1301+⍳40]←'ta must be pre-processed.',(,⎕UCS 10),'      (data se'
  (howsearch)[1341+⍳23]←'arch ''man'')',(,⎕UCS 9023),'data',(,⎕UCS 10),'Jim Sc'
  (howsearch)[1364+⍳34]←'hneiderman',(,⎕UCS 10 10),'... Numeric arguments',(,⎕UCS 10)
  (howsearch)[1398+⍳16]←'      ',(,⎕UCS 9109 8592),'data',(,⎕UCS 8592),'4 5'
  (howsearch)[1414+⍳20]←(,⎕UCS 9076 9075 55 10),'1 2 3 4 5',(,⎕UCS 10),'6 7 1 '
  (howsearch)[1434+⍳24]←'2 3',(,⎕UCS 10),'4 5 6 7 1',(,⎕UCS 10),'2 3 4 5 6',(,⎕UCS 10)
  (howsearch)[1458+⍳32]←'      data search 2 3 4',(,⎕UCS 10),'1 0 0 1',(,⎕UCS 10)

howsignalerror←2008⍴0 ⍝ prolog ≡1
  (howsignalerror)[⍳53]←'-----------------------------------------------------'
  (howsignalerror)[53+⍳31]←'-------------------------',(,⎕UCS 10 89 8592),'C s'
  (howsignalerror)[84+⍳37]←'ignalerror T',(,⎕UCS 10),'display message <T> if c'
  (howsignalerror)[121+⍳36]←'ondition <C> is true',(,⎕UCS 10),'---------------'
  (howsignalerror)[157+⍳49]←'-------------------------------------------------'
  (howsignalerror)[206+⍳30]←'--------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howsignalerror)[236+⍳36]←'------------',(,⎕UCS 10),'   <signalerror> is a c'
  (howsignalerror)[272+⍳47]←'onvenient ''basic'' function for checking any con'
  (howsignalerror)[319+⍳36]←'dition,',(,⎕UCS 10),'   issuing an error message '
  (howsignalerror)[355+⍳42]←'if the condition is true, and exiting the',(,⎕UCS 10)
  (howsignalerror)[397+⍳49]←'   function that invoked <signalerror>.  A nice f'
  (howsignalerror)[446+⍳36]←'eature of <signalerror> is',(,⎕UCS 10),'   that i'
  (howsignalerror)[482+⍳49]←'f the condition <C> is true, the function invokin'
  (howsignalerror)[531+⍳36]←'g <signalerror>',(,⎕UCS 10),'   can easily be exi'
  (howsignalerror)[567+⍳40]←'ted and suspended at the calling level.',(,⎕UCS 10)
  (howsignalerror)[607+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howsignalerror)[629+⍳41]←'<C>   Numeric scalar or 1-element vector',(,⎕UCS 10)
  (howsignalerror)[670+⍳34]←'   <C> is 0 or 1.',(,⎕UCS 10 10),'<T>   Character'
  (howsignalerror)[704+⍳36]←' vector',(,⎕UCS 10),'   <T> has the format: /x/l1'
  (howsignalerror)[740+⍳32]←'/l2...',(,⎕UCS 10 10),'   ''/'' represents an arb'
  (howsignalerror)[772+⍳33]←'itrary separater character.',(,⎕UCS 10 10),'   '''
  (howsignalerror)[805+⍳48]←'x'' represents a name.  It is typically the name '
  (howsignalerror)[853+⍳36]←'of the result variable of',(,⎕UCS 10),'   the fun'
  (howsignalerror)[889+⍳33]←'ction calling <signalerror>.',(,⎕UCS 10 10),'   '
  (howsignalerror)[922+⍳47]←'''l1/l2...'' represents a suitable character argu'
  (howsignalerror)[969+⍳21]←'ment for the <',(,⎕UCS 8710),'box>',(,⎕UCS 10),' '
  (howsignalerror)[990+⍳49]←'  function.  The text will be reshaped to an arra'
  (howsignalerror)[1039+⍳35]←'y and used if necessary',(,⎕UCS 10),'   for the '
  (howsignalerror)[1074+⍳24]←'error message.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howsignalerror)[1098+⍳35]←'------',(,⎕UCS 10),'<Y>   1-element numeric vect'
  (howsignalerror)[1133+⍳35]←'or',(,⎕UCS 10),'   If <C> is 1, <Y> is a vector '
  (howsignalerror)[1168+⍳33]←'0 (1=',(,⎕UCS 9076),'Y).  If <C> is 0, <Y> is th'
  (howsignalerror)[1201+⍳30]←'e empty',(,⎕UCS 10),'   numeric vector (0=',(,⎕UCS 9076)
  (howsignalerror)[1231+⍳33]←'Y).',(,⎕UCS 10 10),'   Also, if <C> is 1, the er'
  (howsignalerror)[1264+⍳33]←'ror message is displayed using ',(,⎕UCS 9109),','
  (howsignalerror)[1297+⍳33]←' and the',(,⎕UCS 10),'   variable ''x'' expunged'
  (howsignalerror)[1330+⍳48]←'.  If this variable is the return variable of th'
  (howsignalerror)[1378+⍳35]←'e',(,⎕UCS 10),'   function calling <signalerror>'
  (howsignalerror)[1413+⍳38]←', and the function is exited without',(,⎕UCS 10),' '
  (howsignalerror)[1451+⍳48]←'  re-assigning the variable, the function will r'
  (howsignalerror)[1499+⍳35]←'eturn with a result error',(,⎕UCS 10),'   at the'
  (howsignalerror)[1534+⍳27]←' calling level.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howsignalerror)[1561+⍳35]←'--------',(,⎕UCS 10),'   In the following exampl'
  (howsignalerror)[1596+⍳45]←'e, if the argument <x> has rank 2, the error',(,⎕UCS 10)
  (howsignalerror)[1641+⍳48]←'   message (in two lines) is displayed, and <sig'
  (howsignalerror)[1689+⍳35]←'nalerror> returns 0 (with',(,⎕UCS 10),'   the co'
  (howsignalerror)[1724+⍳48]←'nsequence the function calling <signalerror> ret'
  (howsignalerror)[1772+⍳35]←'urns).  If the',(,⎕UCS 10),'   argument <x> has '
  (howsignalerror)[1807+⍳40]←'some other rank, <signalerror> returns ',(,⎕UCS 9075)
  (howsignalerror)[1847+⍳35]←'0 (with the',(,⎕UCS 10),'   consequence the func'
  (howsignalerror)[1882+⍳48]←'tion calling <signalerror> continues execution).'
  (howsignalerror)[1930+⍳12]←(,⎕UCS 10),'      ',(,⎕UCS 8594),'(2=',(,⎕UCS 9076)
  (howsignalerror)[1942+⍳35]←(,⎕UCS 9076),'x) signalerror ''/y/foo domain erro'
  (howsignalerror)[1977+⍳31]←'r/left arg cannot have rank 2''',(,⎕UCS 10)

howsixline←2158⍴0 ⍝ prolog ≡1
  (howsixline)[⍳57]←'---------------------------------------------------------'
  (howsixline)[57+⍳27]←'---------------------',(,⎕UCS 10),'plt',(,⎕UCS 8592),'s'
  (howsixline)[84+⍳41]←'ixline v',(,⎕UCS 10),'return sixline plot given x and '
  (howsixline)[125+⍳28]←'y data in <v> = n',(,⎕UCS 215),'2 matrix',(,⎕UCS 10),'-'
  (howsixline)[153+⍳53]←'-----------------------------------------------------'
  (howsixline)[206+⍳38]←'------------------------',(,⎕UCS 10 10),'Introduction'
  (howsixline)[244+⍳27]←':',(,⎕UCS 10),'------------',(,⎕UCS 10),'   The six-l'
  (howsixline)[271+⍳53]←'ine plot was designed by Andrews and Tukey for fast, '
  (howsixline)[324+⍳40]←'concise',(,⎕UCS 10),'   plotting.  It is as relevant '
  (howsixline)[364+⍳40]←'and useful today as it was when it was',(,⎕UCS 10),' '
  (howsixline)[404+⍳38]←'  invented.',(,⎕UCS 10 10),'   This plot uses an arbi'
  (howsixline)[442+⍳49]←'trary number of horizontal spaces for the x-axis',(,⎕UCS 10)
  (howsixline)[491+⍳53]←'   (abscissa).  The six printed lines for the y-axis '
  (howsixline)[544+⍳40]←'(ordinate) represent',(,⎕UCS 10),'   y-values whose i'
  (howsixline)[584+⍳53]←'nteger parts are +2, +1, +0, -0, -1, -2.  The fractio'
  (howsixline)[637+⍳40]←'nal',(,⎕UCS 10),'   part of a y-value is represented '
  (howsixline)[677+⍳40]←'by one of the digits 1 to 4, depending',(,⎕UCS 10),' '
  (howsixline)[717+⍳53]←'  on the size of the fractional part measured in unit'
  (howsixline)[770+⍳40]←'s of .25.  Y-values',(,⎕UCS 10),'   between 3 and 4.2'
  (howsixline)[810+⍳53]←'5 (or -3 and -4.25) are plotted on the line labelled '
  (howsixline)[863+⍳40]←'+2',(,⎕UCS 10),'   (-2) using the digits 5 to 9.  All'
  (howsixline)[903+⍳40]←' other numbers are plotted with the',(,⎕UCS 10),'   s'
  (howsixline)[943+⍳51]←'ymbol ''x''.  This range is very suitable for a varie'
  (howsixline)[994+⍳40]←'ty of data,',(,⎕UCS 10),'   especially if the data is'
  (howsixline)[1034+⍳47]←' appropriately standardized.  It is especially',(,⎕UCS 10)
  (howsixline)[1081+⍳43]←'   suitable for the analysis of residuals.',(,⎕UCS 10)
  (howsixline)[1124+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howsixline)[1146+⍳26]←'<v>   n',(,⎕UCS 215),'2 numeric matrix',(,⎕UCS 10),' '
  (howsixline)[1172+⍳39]←'  v[;1] = x-axis values.',(,⎕UCS 10),'   v[;2] = y-a'
  (howsixline)[1211+⍳24]←'xis values.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'---'
  (howsixline)[1235+⍳25]←'---',(,⎕UCS 10),'<plt>   6',(,⎕UCS 215),'n character'
  (howsixline)[1260+⍳39]←' matrix.',(,⎕UCS 10),'   This matrix is the six-line'
  (howsixline)[1299+⍳23]←' plot.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howsixline)[1322+⍳52]←'   A Design for APL Software for Man-Machine Dialogu'
  (howsixline)[1374+⍳39]←'e with Statistical',(,⎕UCS 10),'   Applications, Fri'
  (howsixline)[1413+⍳47]←'endly and Levine, in Proceedings of the APL 75',(,⎕UCS 10)
  (howsixline)[1460+⍳52]←'   Conference, Pisa, Italy, 1975.  Adapted from the '
  (howsixline)[1512+⍳39]←'paper: Teletypewriter',(,⎕UCS 10),'   Plots for Data'
  (howsixline)[1551+⍳51]←' Analysis Can be Fast, Andrews and Tukey, (Applied',(,⎕UCS 10)
  (howsixline)[1602+⍳40]←'   Statistics, 1973, V.  22, 192-202.)',(,⎕UCS 10 10)
  (howsixline)[1642+⍳26]←'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...Exam'
  (howsixline)[1668+⍳24]←'ple 1',(,⎕UCS 10),'      sixline (',(,⎕UCS 9075),'11'
  (howsixline)[1692+⍳22]←'),[1.5] (.5',(,⎕UCS 215 175 53 43 9075),'10),0',(,⎕UCS 10)
  (howsixline)[1714+⍳39]←'+2|                        1  3',(,⎕UCS 10),'+1|    '
  (howsixline)[1753+⍳39]←'              1  3',(,⎕UCS 10),'+0|            0  3 '
  (howsixline)[1792+⍳29]←'            0',(,⎕UCS 10),'-0|         3',(,⎕UCS 10),'-'
  (howsixline)[1821+⍳24]←'1|   3  1',(,⎕UCS 10),'-2|1',(,⎕UCS 10 10),'...Examp'
  (howsixline)[1845+⍳39]←'le 2',(,⎕UCS 10),'...Let x be the data points, and y'
  (howsixline)[1884+⍳41]←' the residuals from a regression curve.',(,⎕UCS 10),' '
  (howsixline)[1925+⍳36]←'     x',(,⎕UCS 8592),'28 29 29 34 40 41 42 51 68 76'
  (howsixline)[1961+⍳16]←(,⎕UCS 10),'      y',(,⎕UCS 8592),'2.34 ',(,⎕UCS 175),'1'
  (howsixline)[1977+⍳19]←'.87 ',(,⎕UCS 175),'.17 ',(,⎕UCS 175),'.14 .99 ',(,⎕UCS 175)
  (howsixline)[1996+⍳24]←'1.82 1.4 ',(,⎕UCS 175),'2.52 4.11 ',(,⎕UCS 175),'2.3'
  (howsixline)[2020+⍳26]←'2',(,⎕UCS 10),'      sixline x,[1.5]y',(,⎕UCS 10),'+'
  (howsixline)[2046+⍳39]←'2|2                        9',(,⎕UCS 10),'+1|       '
  (howsixline)[2085+⍳25]←'  2',(,⎕UCS 10),'+0|        4',(,⎕UCS 10),'-0| 1  1'
  (howsixline)[2110+⍳29]←(,⎕UCS 10),'-1| 4      4',(,⎕UCS 10),'-2|            '
  (howsixline)[2139+⍳19]←'  3              2',(,⎕UCS 10)

howsort←1921⍴0 ⍝ prolog ≡1
  (howsort)[⍳60]←'------------------------------------------------------------'
  (howsort)[60+⍳31]←'------------------',(,⎕UCS 10 121 8592),'cs sort m',(,⎕UCS 10)
  (howsort)[91+⍳57]←'sort character vector or matrix <m> using collating seque'
  (howsort)[148+⍳43]←'nce <cs>',(,⎕UCS 10),'----------------------------------'
  (howsort)[191+⍳45]←'--------------------------------------------',(,⎕UCS 10)
  (howsort)[236+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howsort)[264+⍳56]←'   <sort> provides a useful syntax for computing a sorte'
  (howsort)[320+⍳43]←'d result without',(,⎕UCS 10),'   having to use an indexi'
  (howsort)[363+⍳47]←'ng operation on the argument.  Thus, it allows',(,⎕UCS 10)
  (howsort)[410+⍳26]←'   m',(,⎕UCS 8592),'cs sort m or even m',(,⎕UCS 8592),'c'
  (howsort)[436+⍳41]←'s sort <expression> rather than m',(,⎕UCS 8592),'m[cs gr'
  (howsort)[477+⍳43]←'adeup',(,⎕UCS 10),'   m;].  <sort> sorts over columns sp'
  (howsort)[520+⍳41]←'ecified in a global argument.',(,⎕UCS 10 10),'Arguments:'
  (howsort)[561+⍳33]←(,⎕UCS 10),'---------',(,⎕UCS 10),'<m>   Character vecter'
  (howsort)[594+⍳38]←' or matrix',(,⎕UCS 10),'   The array to be sorted.',(,⎕UCS 10)
  (howsort)[632+⍳33]←(,⎕UCS 10),'<cs>   Character vector',(,⎕UCS 10),'   This '
  (howsort)[665+⍳56]←'argument specifies the collating sequence.  An empty vec'
  (howsort)[721+⍳28]←'tor means',(,⎕UCS 10),'   defaults to ',(,⎕UCS 9109),'av'
  (howsort)[749+⍳33]←' as the collating sequence.',(,⎕UCS 10 10 60 103 8710),'s'
  (howsort)[782+⍳39]←'ort',(,⎕UCS 8710),'columns>   Numeric vector (global)',(,⎕UCS 10)
  (howsort)[821+⍳56]←'   This global argument specifies the columns on which t'
  (howsort)[877+⍳42]←'o sort.  An empty',(,⎕UCS 10),'   vector defaults to ''a'
  (howsort)[919+⍳50]←'ll columns''.  An undefined variable is treated as',(,⎕UCS 10)
  (howsort)[969+⍳56]←'   though the default were specified.  A global vector i'
  (howsort)[1025+⍳42]←'s used as it is',(,⎕UCS 10),'   inconvenient to pass th'
  (howsort)[1067+⍳47]←'ree explicit arguments, but it is advisable to',(,⎕UCS 10)
  (howsort)[1114+⍳25]←'   localize <g',(,⎕UCS 8710),'sort',(,⎕UCS 8710),'colum'
  (howsort)[1139+⍳48]←'ns> within the function calling <sort>.  It may',(,⎕UCS 10)
  (howsort)[1187+⍳55]←'   either be defined within that function, or for conve'
  (howsort)[1242+⍳42]←'nience left undefined',(,⎕UCS 10),'   and therefore the'
  (howsort)[1284+⍳54]←' default is used, which is usually a suitable choice.',(,⎕UCS 10)
  (howsort)[1338+⍳19]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>'
  (howsort)[1357+⍳42]←'   Character vector or matrix',(,⎕UCS 10),'   The sorte'
  (howsort)[1399+⍳55]←'d version of <m>.  If <m> is a vector, <y> is a vector.'
  (howsort)[1454+⍳42]←'  If <m>',(,⎕UCS 10),'   is a matrix, the result is a m'
  (howsort)[1496+⍳26]←'atrix.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------'
  (howsort)[1522+⍳15]←(,⎕UCS 10),'      m',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'b'
  (howsort)[1537+⍳40]←'ox ''zebra/apple/catch/cat/annie/dig''',(,⎕UCS 10),'...'
  (howsort)[1577+⍳54]←'Sort by first column only.  Ensure blank sorts first.',(,⎕UCS 10)
  (howsort)[1631+⍳21]←'      g',(,⎕UCS 8710),'sort',(,⎕UCS 8710),'columns',(,⎕UCS 8592)
  (howsort)[1652+⍳25]←(,⎕UCS 49 10),'      ('' '',',(,⎕UCS 9109),'av) sort m',(,⎕UCS 10)
  (howsort)[1677+⍳19]←'apple',(,⎕UCS 10),'annie',(,⎕UCS 10),'catch',(,⎕UCS 10),'c'
  (howsort)[1696+⍳16]←'at',(,⎕UCS 10),'dig',(,⎕UCS 10),'zebra',(,⎕UCS 10),'...'
  (howsort)[1712+⍳29]←'Sort by all columns',(,⎕UCS 10),'      g',(,⎕UCS 8710),'s'
  (howsort)[1741+⍳17]←'ort',(,⎕UCS 8710),'columns',(,⎕UCS 8592 9075 48 10),'  '
  (howsort)[1758+⍳25]←'    ('' '',',(,⎕UCS 9109),'av) sort m',(,⎕UCS 10),'anni'
  (howsort)[1783+⍳16]←'e',(,⎕UCS 10),'apple',(,⎕UCS 10),'cat',(,⎕UCS 10),'catc'
  (howsort)[1799+⍳14]←'h',(,⎕UCS 10),'dig',(,⎕UCS 10),'zebra',(,⎕UCS 10 10),'.'
  (howsort)[1813+⍳27]←'..Sort a vector.',(,⎕UCS 10),'      g',(,⎕UCS 8710),'so'
  (howsort)[1840+⍳17]←'rt',(,⎕UCS 8710),'columns',(,⎕UCS 8592 9075 48 10),'   '
  (howsort)[1857+⍳38]←'   (',(,⎕UCS 9021),'''abcdefghijklmnopqrstuvwxyz'') sor'
  (howsort)[1895+⍳26]←'t ''zarsttguia''',(,⎕UCS 10),'zuttsrigaa',(,⎕UCS 10)

howsortl←1052⍴0 ⍝ prolog ≡1
  (howsortl)[⍳59]←'-----------------------------------------------------------'
  (howsortl)[59+⍳30]←'-------------------',(,⎕UCS 10 90 8592),'sortl N',(,⎕UCS 10)
  (howsortl)[89+⍳56]←'sort local names in header of function <N> and fix resul'
  (howsortl)[145+⍳42]←'t',(,⎕UCS 10),'----------------------------------------'
  (howsortl)[187+⍳41]←'--------------------------------------',(,⎕UCS 10 10),'I'
  (howsortl)[228+⍳29]←'ntroduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   '
  (howsortl)[257+⍳55]←'<sortl> sorts the names localized in the function heade'
  (howsortl)[312+⍳42]←'r of the function',(,⎕UCS 10),'   named <n>.  <sortl> i'
  (howsortl)[354+⍳42]←'s the ''driver'' function for <sortlocal>.',(,⎕UCS 10 10)
  (howsortl)[396+⍳29]←'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<n>   Ch'
  (howsortl)[425+⍳38]←'aracter vector',(,⎕UCS 10),'   Name of a function.',(,⎕UCS 10)
  (howsortl)[463+⍳19]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<z>'
  (howsortl)[482+⍳42]←'   Character or numeric vector',(,⎕UCS 10),'   <z> is t'
  (howsortl)[524+⍳40]←'he result returned by ',(,⎕UCS 9109),'fx applied to the'
  (howsortl)[564+⍳42]←' changed text of the',(,⎕UCS 10),'   specified function'
  (howsortl)[606+⍳40]←' <n>.  If ',(,⎕UCS 9109),'fx is successful, <z> is the '
  (howsortl)[646+⍳30]←'name of the',(,⎕UCS 10),'   function.  If ',(,⎕UCS 9109)
  (howsortl)[676+⍳54]←'fx is not successful, the usual standard result (i.e.',(,⎕UCS 10)
  (howsortl)[730+⍳55]←'   line number of text giving the problem) is returned.'
  (howsortl)[785+⍳21]←(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howsortl)[806+⍳54]←'...Suppose the sample function <foo> looks like this:',(,⎕UCS 10)
  (howsortl)[860+⍳19]←'      ',(,⎕UCS 9109),'cr ''foo''',(,⎕UCS 10 121 8592),'f'
  (howsortl)[879+⍳23]←'oo x;z;a;b;',(,⎕UCS 9109),'io;t',(,⎕UCS 10 9053),'sampl'
  (howsortl)[902+⍳27]←'e function for sortl',(,⎕UCS 10 122 8592 57 10 97 8592)
  (howsortl)[929+⍳19]←(,⎕UCS 49 49 10 121 8592),'a+z',(,⎕UCS 10 10),'...<sortl'
  (howsortl)[948+⍳42]←'> sorts the header line of the function',(,⎕UCS 10),'  '
  (howsortl)[990+⍳27]←'    sortl ''foo''',(,⎕UCS 10),'foo',(,⎕UCS 10),'      ('
  (howsortl)[1017+⍳20]←(,⎕UCS 9109),'cr ''foo'')[1;]',(,⎕UCS 10 121 8592),'foo'
  (howsortl)[1037+⍳15]←' x;',(,⎕UCS 9109),'io;a;b;t;z',(,⎕UCS 10)

howsortlocal←1349⍴0 ⍝ prolog ≡1
  (howsortlocal)[⍳55]←'-------------------------------------------------------'
  (howsortlocal)[55+⍳32]←'-----------------------',(,⎕UCS 10 121 8592),'sortlo'
  (howsortlocal)[87+⍳39]←'cal x',(,⎕UCS 10),'sort local variables in first lin'
  (howsortlocal)[126+⍳38]←'e of <x> = canonical matrix',(,⎕UCS 10),'----------'
  (howsortlocal)[164+⍳51]←'---------------------------------------------------'
  (howsortlocal)[215+⍳33]←'-----------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howsortlocal)[248+⍳38]←'------------',(,⎕UCS 10),'   This function puts the'
  (howsortlocal)[286+⍳50]←' local variables in the header line of a function',(,⎕UCS 10)
  (howsortlocal)[336+⍳51]←'   into sorted order.  The function is presented st'
  (howsortlocal)[387+⍳38]←'rictly as a text',(,⎕UCS 10),'   formatting functio'
  (howsortlocal)[425+⍳51]←'n, as it does not actually change the function in t'
  (howsortlocal)[476+⍳38]←'he',(,⎕UCS 10),'   workspace.  However, it is used '
  (howsortlocal)[514+⍳42]←'in the program development process with a',(,⎕UCS 10)
  (howsortlocal)[556+⍳49]←'   ''driver'' function such as the toolkit function'
  (howsortlocal)[605+⍳23]←' <sortl>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (howsortlocal)[628+⍳32]←'--------',(,⎕UCS 10),'<x>   Character matrix',(,⎕UCS 10)
  (howsortlocal)[660+⍳51]←'   The canonical matrix of a function.  (Actually t'
  (howsortlocal)[711+⍳38]←'he function will accept',(,⎕UCS 10),'   any text ma'
  (howsortlocal)[749+⍳51]←'trix as an argument, but the result is different on'
  (howsortlocal)[800+⍳38]←'ly if the',(,⎕UCS 10),'   first line contains semic'
  (howsortlocal)[838+⍳23]←'olons.)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howsortlocal)[861+⍳28]←(,⎕UCS 10),'<y>   Character matrix',(,⎕UCS 10),'   <'
  (howsortlocal)[889+⍳51]←'y> is the same as <x> except that the local names i'
  (howsortlocal)[940+⍳38]←'n the first row of <y>',(,⎕UCS 10),'   are sorted. '
  (howsortlocal)[978+⍳51]←' If <x> is a valid canonical matrix, <y> will also '
  (howsortlocal)[1029+⍳22]←'be valid.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-'
  (howsortlocal)[1051+⍳37]←'-------',(,⎕UCS 10),'...Suppose the sample functio'
  (howsortlocal)[1088+⍳32]←'n <foo> looks like this:',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howsortlocal)[1120+⍳24]←'cr ''foo''',(,⎕UCS 10 121 8592),'foo x;z;a;b;',(,⎕UCS 9109)
  (howsortlocal)[1144+⍳33]←'io;t',(,⎕UCS 10 9053),'sample function for sortloc'
  (howsortlocal)[1177+⍳13]←'al',(,⎕UCS 10 122 8592 57 10 97 8592 49 49 10 121)
  (howsortlocal)[1190+⍳23]←(,⎕UCS 8592),'a+z',(,⎕UCS 10 10),'...<sortlocal> so'
  (howsortlocal)[1213+⍳44]←'rts the header line of the canonical matrix',(,⎕UCS 10)
  (howsortlocal)[1257+⍳26]←'      sortlocal ',(,⎕UCS 9109),'cr ''foo''',(,⎕UCS 10)
  (howsortlocal)[1283+⍳19]←(,⎕UCS 121 8592),'foo x;',(,⎕UCS 9109),'io;a;b;t;z'
  (howsortlocal)[1302+⍳32]←(,⎕UCS 10 9053),'sample function for sortlocal',(,⎕UCS 10)
  (howsortlocal)[1334+⍳12]←(,⎕UCS 122 8592 57 10 97 8592 49 49 10 121 8592),'a'
  (howsortlocal)[1346+⍳3]←'+z',(,⎕UCS 10)

howsplit←2360⍴0 ⍝ prolog ≡1
  (howsplit)[⍳59]←'-----------------------------------------------------------'
  (howsplit)[59+⍳35]←'-------------------',(,⎕UCS 10 121 8592),'w split line',(,⎕UCS 10)
  (howsplit)[94+⍳46]←'split text vector <line> into <w>-size pieces',(,⎕UCS 10)
  (howsplit)[140+⍳55]←'-------------------------------------------------------'
  (howsplit)[195+⍳39]←'-----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howsplit)[234+⍳40]←'------------',(,⎕UCS 10),'   This function ''splits'' ('
  (howsplit)[274+⍳49]←'or reformats) a character vector into pieces and',(,⎕UCS 10)
  (howsplit)[323+⍳53]←'   reformats into a matrix.  ''Words'' (i.e.  sequences'
  (howsplit)[376+⍳42]←' of non-blank',(,⎕UCS 10),'   characters) are not broke'
  (howsplit)[418+⍳47]←'n apart unless they are too long.  <split> can',(,⎕UCS 10)
  (howsplit)[465+⍳55]←'   be used for arbitrary text, but is particularly suit'
  (howsplit)[520+⍳42]←'able for reformatting',(,⎕UCS 10),'   long function lin'
  (howsplit)[562+⍳33]←'es and data vectors.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howsplit)[595+⍳42]←'---------',(,⎕UCS 10),'<w>   Integer scalar (or 1-eleme'
  (howsplit)[637+⍳27]←'nt vector)',(,⎕UCS 10),'   w>0',(,⎕UCS 10 10),'<line>  '
  (howsplit)[664+⍳42]←' Character vector',(,⎕UCS 10),'   A scalar is treated a'
  (howsplit)[706+⍳31]←'s a 1-element vector.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howsplit)[737+⍳31]←'------',(,⎕UCS 10),'<y>   Character vector',(,⎕UCS 10),' '
  (howsplit)[768+⍳55]←'  <y> will have shape (n,w) where n is the number of ro'
  (howsplit)[823+⍳42]←'ws required to contain',(,⎕UCS 10),'   <line>.  If <lin'
  (howsplit)[865+⍳27]←'e> is empty, n=0.',(,⎕UCS 10 10),'Notes:',(,⎕UCS 10),'-'
  (howsplit)[892+⍳42]←'----',(,⎕UCS 10),'   The only characters in the result '
  (howsplit)[934+⍳42]←'matrix <y> not in the original argument',(,⎕UCS 10),'  '
  (howsplit)[976+⍳55]←' <line> are blanks to pad the ends of the rows.  The te'
  (howsplit)[1031+⍳41]←'xt is always split',(,⎕UCS 10),'   at the last possibl'
  (howsplit)[1072+⍳54]←'e non-blank character c.  The blank characters between'
  (howsplit)[1126+⍳44]←(,⎕UCS 10),'   c and the beginning of the next non-blan'
  (howsplit)[1170+⍳41]←'k sequence are placed at the',(,⎕UCS 10),'   beginning'
  (howsplit)[1211+⍳54]←' of the next row.  Therefore, the second and succeedin'
  (howsplit)[1265+⍳41]←'g rows of',(,⎕UCS 10),'   the result are indented by t'
  (howsplit)[1306+⍳44]←'he actual number of blanks in the argument.',(,⎕UCS 10)
  (howsplit)[1350+⍳54]←'   If there is a non-blank sequence longer than <w> ch'
  (howsplit)[1404+⍳41]←'aracters, it is',(,⎕UCS 10),'   placed at the beginnin'
  (howsplit)[1445+⍳44]←'g of the left margin, and split at the w+1',(,⎕UCS 10),' '
  (howsplit)[1489+⍳39]←'  character for the next line.',(,⎕UCS 10 10),'Example'
  (howsplit)[1528+⍳28]←'s:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...Note the posi'
  (howsplit)[1556+⍳48]←'tions of the blanks as you review the examples.',(,⎕UCS 10)
  (howsplit)[1604+⍳24]←'      30 split 40',(,⎕UCS 9076),'''x''',(,⎕UCS 10),'xx'
  (howsplit)[1628+⍳40]←'xxxxxxxxxxxxxxxxxxxxxxxxxxxx',(,⎕UCS 10),'xxxxxxxxxx',(,⎕UCS 10)
  (howsplit)[1668+⍳31]←'      30 split 40',(,⎕UCS 9076),'''xxxx.xxxx ''',(,⎕UCS 10)
  (howsplit)[1699+⍳40]←'xxxx.xxxx xxxx.xxxx xxxx.xxxx',(,⎕UCS 10),' xxxx.xxxx'
  (howsplit)[1739+⍳14]←(,⎕UCS 10 10),'      v',(,⎕UCS 8592),'v,v',(,⎕UCS 8592)
  (howsplit)[1753+⍳53]←'''The quick brown fox jumped over   the lazy red dinos'
  (howsplit)[1806+⍳18]←'aurs. ''',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592 109 8592)
  (howsplit)[1824+⍳41]←'65 split v',(,⎕UCS 10),'The quick brown fox jumped ove'
  (howsplit)[1865+⍳41]←'r   the lazy red dinosaurs. The',(,⎕UCS 10),' quick br'
  (howsplit)[1906+⍳46]←'own fox jumped over   the lazy red dinosaurs.',(,⎕UCS 10)
  (howsplit)[1952+⍳21]←'      ',(,⎕UCS 9076 109 10),'2 65',(,⎕UCS 10),'...For '
  (howsplit)[1973+⍳54]←'a left-justified result, use the <jl> (justify left) f'
  (howsplit)[2027+⍳30]←'unction.',(,⎕UCS 10),'      jl 65 split v',(,⎕UCS 10),'T'
  (howsplit)[2057+⍳54]←'he quick brown fox jumped over   the lazy red dinosaur'
  (howsplit)[2111+⍳41]←'s. The',(,⎕UCS 10),'quick brown fox jumped over   the '
  (howsplit)[2152+⍳39]←'lazy red dinosaurs.',(,⎕UCS 10 10),'...Sample long APL'
  (howsplit)[2191+⍳24]←' statement',(,⎕UCS 10),'      line',(,⎕UCS 10 114 8592)
  (howsplit)[2215+⍳32]←'(m,[1]-/[2](+\[1] 0,[1] m)[',(,⎕UCS 9021),'p+(',(,⎕UCS 9076)
  (howsplit)[2247+⍳16]←(,⎕UCS 112 41 9076),' 0 1 ;])[',(,⎕UCS 9035 40 9075 49)
  (howsplit)[2263+⍳25]←(,⎕UCS 8593 9076),'m),p[;2];]',(,⎕UCS 10),'      40 spl'
  (howsplit)[2288+⍳34]←'it line',(,⎕UCS 10 114 8592),'(m,[1]-/[2](+\[1] 0,[1] '
  (howsplit)[2322+⍳13]←'m)[',(,⎕UCS 9021),'p+(',(,⎕UCS 9076 112 41 9076 32 48)
  (howsplit)[2335+⍳15]←(,⎕UCS 10),' 1 ;])[',(,⎕UCS 9035 40 9075 49 8593 9076),'m'
  (howsplit)[2350+⍳10]←'),p[;2];]',(,⎕UCS 10)

howsr←1966⍴0 ⍝ prolog ≡1
  (howsr)[⍳62]←'--------------------------------------------------------------'
  (howsr)[62+⍳27]←'----------------',(,⎕UCS 10 108 8592),'v sr s',(,⎕UCS 10),'s'
  (howsr)[89+⍳55]←'earch for ''old'' sequence and replace by ''new'' in <v>.  '
  (howsr)[144+⍳45]←'<s>=/old/new',(,⎕UCS 10),'--------------------------------'
  (howsr)[189+⍳47]←'----------------------------------------------',(,⎕UCS 10)
  (howsr)[236+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howsr)[264+⍳56]←'   <sr> is a ''search and replace'' function.  Given a vec'
  (howsr)[320+⍳45]←'tor <v>, the function',(,⎕UCS 10),'   replaces a specified'
  (howsr)[365+⍳50]←' sequence in <v> with another sequence.  (<sr> is',(,⎕UCS 10)
  (howsr)[415+⍳58]←'   very common and appears in several APL implementations '
  (howsr)[473+⍳30]←'as the system',(,⎕UCS 10),'   function ',(,⎕UCS 9109),'sr.'
  (howsr)[503+⍳24]←')',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howsr)[527+⍳45]←'<v>   Character or numeric vector',(,⎕UCS 10),'   The vect'
  (howsr)[572+⍳45]←'or containing the sequence to be replaced.',(,⎕UCS 10 10),'<'
  (howsr)[617+⍳45]←'s>   Character or numeric vector',(,⎕UCS 10),'   This vect'
  (howsr)[662+⍳56]←'or specifies the ''old'' sequence (the sequence to be sear'
  (howsr)[718+⍳43]←'ched for)',(,⎕UCS 10),'   and the ''new'' sequence (the re'
  (howsr)[761+⍳45]←'placement sequence).  <s> has the form:',(,⎕UCS 10),'   /o'
  (howsr)[806+⍳56]←'ld/new.  The first element (here indicated by the ''/'') i'
  (howsr)[862+⍳45]←'s an arbitrary',(,⎕UCS 10),'   element not occurring in th'
  (howsr)[907+⍳45]←'e data, and is taken to be the delimiter',(,⎕UCS 10),'   c'
  (howsr)[952+⍳58]←'haracter that separates the old sequence from the new sequ'
  (howsr)[1010+⍳22]←'ence.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howsr)[1032+⍳44]←'<l>   Vector',(,⎕UCS 10),'   <l> is the vector <v> with a'
  (howsr)[1076+⍳45]←'ll occurrences (if any) of the old sequence',(,⎕UCS 10),' '
  (howsr)[1121+⍳42]←'  replaced by the new sequence.',(,⎕UCS 10 10),'   Howeve'
  (howsr)[1163+⍳55]←'r, if the ''old'' sequence is an overlapping sequence, an'
  (howsr)[1218+⍳44]←' error',(,⎕UCS 10),'   message is returned.  An overlappi'
  (howsr)[1262+⍳44]←'ng sequence is one in which an',(,⎕UCS 10),'   occurrence'
  (howsr)[1306+⍳57]←' of the sequence begins within a previous occurrence.  Fo'
  (howsr)[1363+⍳42]←'r',(,⎕UCS 10),'   example, in the vector ''.....'', the s'
  (howsr)[1405+⍳42]←'equence ''..'' is an overlapping',(,⎕UCS 10),'   sequence'
  (howsr)[1447+⍳42]←'.  ''..'' is not overlapping within ''x..x''.',(,⎕UCS 10)
  (howsr)[1489+⍳21]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),' '
  (howsr)[1510+⍳53]←'     ''The apple on the apple tree'' sr ''/apple/orange'''
  (howsr)[1563+⍳33]←(,⎕UCS 10),'The orange on the orange tree',(,⎕UCS 10 10),'.'
  (howsr)[1596+⍳44]←'.. Search sequence not found - no change',(,⎕UCS 10),'   '
  (howsr)[1640+⍳50]←'   ''The pear on the pear tree'' sr ''/apple/orange''',(,⎕UCS 10)
  (howsr)[1690+⍳42]←'The pear on the pear tree',(,⎕UCS 10 10),'... A sequence '
  (howsr)[1732+⍳44]←'can be replaced by nothing, i.e. removed.',(,⎕UCS 10),'  '
  (howsr)[1776+⍳47]←'    ''The apple on the apple tree'' sr ''/apple/''',(,⎕UCS 10)
  (howsr)[1823+⍳42]←'The  on the  tree',(,⎕UCS 10 10),'... Numeric arguments. '
  (howsr)[1865+⍳44]←' 99 is an arbitrary delimiter number.',(,⎕UCS 10),'      '
  (howsr)[1909+⍳44]←'1 2 3 4 5 1 2 3 4 5 sr 99 3 4 99 100',(,⎕UCS 10),'1 2 100'
  (howsr)[1953+⍳13]←' 5 1 2 100 5',(,⎕UCS 10)

howsrn←1514⍴0 ⍝ prolog ≡1
  (howsrn)[⍳61]←'-------------------------------------------------------------'
  (howsrn)[61+⍳31]←'-----------------',(,⎕UCS 10 108 8592),'text srn s',(,⎕UCS 10)
  (howsrn)[92+⍳56]←'search and replace name by ''new'' sequence in <text>. <s>'
  (howsrn)[148+⍳44]←'=/name/new',(,⎕UCS 10),'---------------------------------'
  (howsrn)[192+⍳46]←'---------------------------------------------',(,⎕UCS 10)
  (howsrn)[238+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howsrn)[266+⍳55]←'   <srn> is a ''search and replace'' function that replac'
  (howsrn)[321+⍳40]←'es only complete words',(,⎕UCS 10),'   or APL names.',(,⎕UCS 10)
  (howsrn)[361+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howsrn)[384+⍳44]←'text>   Character vector',(,⎕UCS 10),'   The vector conta'
  (howsrn)[428+⍳42]←'ining the sequence to be replaced.',(,⎕UCS 10 10),'<s>   '
  (howsrn)[470+⍳44]←'Character vector',(,⎕UCS 10),'   This vector specifies th'
  (howsrn)[514+⍳51]←'e ''old'' sequence (the sequence to be searched for)',(,⎕UCS 10)
  (howsrn)[565+⍳55]←'   and the ''new'' sequence (the replacement sequence).  '
  (howsrn)[620+⍳44]←'<s> has the form:',(,⎕UCS 10),'   /old/new.  The first el'
  (howsrn)[664+⍳50]←'ement (here indicated by the ''/'') is an arbitrary',(,⎕UCS 10)
  (howsrn)[714+⍳57]←'   element not occurring in the data, and is taken to be '
  (howsrn)[771+⍳44]←'the delimiter',(,⎕UCS 10),'   character that separates th'
  (howsrn)[815+⍳42]←'e old sequence from the ''new'' sequence.',(,⎕UCS 10 10),' '
  (howsrn)[857+⍳57]←'  The old sequence is taken to be a complete word or APL '
  (howsrn)[914+⍳44]←'name.  Therefore,',(,⎕UCS 10),'   it will not contain bla'
  (howsrn)[958+⍳42]←'nks.',(,⎕UCS 10 10),'   The new sequence is typically ano'
  (howsrn)[1000+⍳43]←'ther name, but it could be any sequence',(,⎕UCS 10),'   '
  (howsrn)[1043+⍳28]←'of characters.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'----'
  (howsrn)[1071+⍳30]←'--',(,⎕UCS 10),'<l>   Vector',(,⎕UCS 10),'   <l> is the '
  (howsrn)[1101+⍳56]←'vector <v> with all occurrences (if any) of the old sequ'
  (howsrn)[1157+⍳38]←'ence',(,⎕UCS 10),'   replaced by the new sequence.',(,⎕UCS 10)
  (howsrn)[1195+⍳21]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),' '
  (howsrn)[1216+⍳21]←'     text',(,⎕UCS 8592 39 97 8592 97 51 215),'vara',(,⎕UCS 247)
  (howsrn)[1237+⍳32]←(,⎕UCS 97 215 50 39 10),'      text srn ''/a/factor''',(,⎕UCS 10)
  (howsrn)[1269+⍳20]←'factor',(,⎕UCS 8592 97 51 215),'vara',(,⎕UCS 247),'facto'
  (howsrn)[1289+⍳28]←'r',(,⎕UCS 215 50 10 10),'... Compare with <sr>.',(,⎕UCS 10)
  (howsrn)[1317+⍳33]←'      text sr ''/a/factor''',(,⎕UCS 10),'factor',(,⎕UCS 8592)
  (howsrn)[1350+⍳28]←'factor3',(,⎕UCS 215),'vfactorrfactor',(,⎕UCS 247),'facto'
  (howsrn)[1378+⍳31]←'r',(,⎕UCS 215 50 10 10),'      ''x[i;] + iorate + i',(,⎕UCS 215)
  (howsrn)[1409+⍳40]←'4'' srn ''/i/index''',(,⎕UCS 10),'x[index;] + iorate + i'
  (howsrn)[1449+⍳34]←'ndex',(,⎕UCS 215 52 10 10),'      ''The cat in the hat'''
  (howsrn)[1483+⍳31]←' srn ''/the/a''',(,⎕UCS 10),'The cat in a hat',(,⎕UCS 10)

howss←1420⍴0 ⍝ prolog ≡1
  (howss)[⍳62]←'--------------------------------------------------------------'
  (howss)[62+⍳27]←'----------------',(,⎕UCS 10 121 8592),'v ss s',(,⎕UCS 10),'r'
  (howss)[89+⍳50]←'eturn all locations of sequence <s> in vector <v>',(,⎕UCS 10)
  (howss)[139+⍳58]←'----------------------------------------------------------'
  (howss)[197+⍳36]←'--------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howss)[233+⍳45]←'------------',(,⎕UCS 10),'   <ss> (sequence search) return'
  (howss)[278+⍳45]←'s the starting coordinates for all',(,⎕UCS 10),'   occurre'
  (howss)[323+⍳46]←'nces of the sequence <s> in the vector <v>.',(,⎕UCS 10 10),' '
  (howss)[369+⍳43]←'  Note that the syntax y',(,⎕UCS 8592),'v ss s is similar '
  (howss)[412+⍳36]←'to the APL ''index of'' function',(,⎕UCS 10),'   y',(,⎕UCS 8592)
  (howss)[448+⍳42]←(,⎕UCS 118 9075),'s.  (''Where in vector <v> is <s> located'
  (howss)[490+⍳44]←'?'').  However, <ss> treats',(,⎕UCS 10),'   <s> as a one u'
  (howss)[534+⍳57]←'nit; and it returns all coordinates, not just the first.',(,⎕UCS 10)
  (howss)[591+⍳23]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<'
  (howss)[614+⍳42]←'v>   Vector',(,⎕UCS 10),'   The vector to be searched.',(,⎕UCS 10)
  (howss)[656+⍳35]←(,⎕UCS 10),'<s>   Scalar or vector.',(,⎕UCS 10),'   The sea'
  (howss)[691+⍳29]←'rch sequence.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------'
  (howss)[720+⍳35]←(,⎕UCS 10),'<y>   Numeric vector',(,⎕UCS 10),'   The indice'
  (howss)[755+⍳58]←'s of all starting locations of <s> within <v>.  Overlappin'
  (howss)[813+⍳45]←'g',(,⎕UCS 10),'   occurrences are counted.  The result is '
  (howss)[858+⍳45]←'in origin 1, no matter what the',(,⎕UCS 10),'   origin in '
  (howss)[903+⍳58]←'the calling environment.  If either of <v> or <s> is empty'
  (howss)[961+⍳29]←', <y>',(,⎕UCS 10),'   is empty.',(,⎕UCS 10 10),'Examples:'
  (howss)[990+⍳35]←(,⎕UCS 10),'--------',(,⎕UCS 10),'... Find all locations of'
  (howss)[1025+⍳30]←' the sequence ''apple''',(,⎕UCS 10),'      v',(,⎕UCS 8592)
  (howss)[1055+⍳38]←'''the apple in the apple tree''',(,⎕UCS 10),'      s',(,⎕UCS 8592)
  (howss)[1093+⍳26]←'''apple''',(,⎕UCS 10),'      v ss s',(,⎕UCS 10),'5 18',(,⎕UCS 10)
  (howss)[1119+⍳27]←'... Compare with ',(,⎕UCS 9075 10),'      v',(,⎕UCS 9075)
  (howss)[1146+⍳29]←(,⎕UCS 115 10),'5 6 6 8 3',(,⎕UCS 10 10),'... Return empty'
  (howss)[1175+⍳29]←' vector if not found',(,⎕UCS 10),'      ',(,⎕UCS 9076),'v'
  (howss)[1204+⍳36]←' ss ''orange''',(,⎕UCS 10 48 10 10),'... Numeric argument'
  (howss)[1240+⍳41]←'s',(,⎕UCS 10),'      11 22 33 44 55 66 22 33 ss 22 33',(,⎕UCS 10)
  (howss)[1281+⍳33]←'2 7',(,⎕UCS 10 10),'... Overlapping occurrences',(,⎕UCS 10)
  (howss)[1314+⍳29]←'      ''bababa'' ss ''baba''',(,⎕UCS 10),'1 3',(,⎕UCS 10)
  (howss)[1343+⍳43]←(,⎕UCS 10),'... Empty arguments return empty results.',(,⎕UCS 10)
  (howss)[1386+⍳23]←'      ',(,⎕UCS 9076),''''' ss s',(,⎕UCS 10 48 10),'      '
  (howss)[1409+⍳11]←(,⎕UCS 9076),'v ss ''''',(,⎕UCS 10 48 10)

howssn←1933⍴0 ⍝ prolog ≡1
  (howssn)[⍳61]←'-------------------------------------------------------------'
  (howssn)[61+⍳31]←'-----------------',(,⎕UCS 10 121 8592),'text ssn s',(,⎕UCS 10)
  (howssn)[92+⍳58]←'return locations of occurrences of the name <s> in vector '
  (howssn)[150+⍳44]←'<text>',(,⎕UCS 10),'-------------------------------------'
  (howssn)[194+⍳44]←'-----------------------------------------',(,⎕UCS 10 10),'I'
  (howssn)[238+⍳31]←'ntroduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   <s'
  (howssn)[269+⍳57]←'sn> (sequence search for name) returns the starting coord'
  (howssn)[326+⍳44]←'inates of all',(,⎕UCS 10),'   occurrences of the APL name'
  (howssn)[370+⍳45]←' <s> in the vector <text>.  This means that',(,⎕UCS 10),' '
  (howssn)[415+⍳57]←'  occurrences of the search sequence <s> contained within'
  (howssn)[472+⍳37]←' longer names are',(,⎕UCS 10),'   not considered.',(,⎕UCS 10)
  (howssn)[509+⍳47]←(,⎕UCS 10),'   Since words are valid APL names, <ssn> can '
  (howssn)[556+⍳44]←'also be used to locate complete',(,⎕UCS 10),'   words wit'
  (howssn)[600+⍳32]←'hin arbitrary text.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howssn)[632+⍳36]←'---------',(,⎕UCS 10),'<text>   Character vector',(,⎕UCS 10)
  (howssn)[668+⍳42]←'   The vector to be searched.',(,⎕UCS 10 10),'<s>   Chara'
  (howssn)[710+⍳44]←'cter scalar or vector.',(,⎕UCS 10),'   The search sequenc'
  (howssn)[754+⍳56]←'e.  <s> must be a syntactically valid APL name; that is,'
  (howssn)[810+⍳47]←(,⎕UCS 10),'   it can contain only those characters allowe'
  (howssn)[857+⍳31]←'d in a name (a-z A-Z 0-9 ',(,⎕UCS 8710 9049 9109 41 46 10)
  (howssn)[888+⍳57]←'   (Note: In particular, if <s> is taken to be a word, it'
  (howssn)[945+⍳44]←' cannot contain',(,⎕UCS 10),'   hyphens, single-quotes, o'
  (howssn)[989+⍳47]←'r other non-letter characters.) Also, <s> must',(,⎕UCS 10)
  (howssn)[1036+⍳42]←'   not have leading or trailing blanks.',(,⎕UCS 10 10),'R'
  (howssn)[1078+⍳30]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Numeric ve'
  (howssn)[1108+⍳43]←'ctor',(,⎕UCS 10),'   The indices of all starting locatio'
  (howssn)[1151+⍳43]←'ns of the name <s> within <text>.  The',(,⎕UCS 10),'   r'
  (howssn)[1194+⍳56]←'esult is in origin 1, no matter what the origin in the c'
  (howssn)[1250+⍳43]←'alling',(,⎕UCS 10),'   environment.  If either argument '
  (howssn)[1293+⍳35]←'is empty, <y> is empty.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howssn)[1328+⍳43]←'--------',(,⎕UCS 10),'... Find all locations of the name'
  (howssn)[1371+⍳40]←' ''a'' within an APL statement.',(,⎕UCS 10),'      text'
  (howssn)[1411+⍳15]←(,⎕UCS 8592 39 97 8592 97 51 215),'vara',(,⎕UCS 247),'a+2'
  (howssn)[1426+⍳26]←'''',(,⎕UCS 10),'      text ssn ''a''',(,⎕UCS 10),'1 11',(,⎕UCS 10)
  (howssn)[1452+⍳40]←'... Compare with <ss>',(,⎕UCS 10),'      text ss ''a''',(,⎕UCS 10)
  (howssn)[1492+⍳25]←'1 3 7 9 11',(,⎕UCS 10 10),'      ''x',(,⎕UCS 8592),'(4,1'
  (howssn)[1517+⍳25]←'0)+.',(,⎕UCS 215),'(x,xx)'' ssn ''x''',(,⎕UCS 10),'1 13'
  (howssn)[1542+⍳25]←(,⎕UCS 10),'      ''',(,⎕UCS 9109),'io starts with ',(,⎕UCS 9109)
  (howssn)[1567+⍳18]←', not ',(,⎕UCS 9109 9109),''' ssn ''',(,⎕UCS 9109 39 10)
  (howssn)[1585+⍳31]←(,⎕UCS 49 55 10),'      ''The index origin is ',(,⎕UCS 9109)
  (howssn)[1616+⍳23]←'io, not ',(,⎕UCS 9109),'ior'' ssn ''',(,⎕UCS 9109),'io'''
  (howssn)[1639+⍳38]←(,⎕UCS 10 50 49 10 10),'... Words in arbitrary text. The '
  (howssn)[1677+⍳44]←'name (i.e. word) ''apple'' occurs just once.',(,⎕UCS 10),' '
  (howssn)[1721+⍳38]←'     v',(,⎕UCS 8592),'''the apples in the apple tree''',(,⎕UCS 10)
  (howssn)[1759+⍳26]←'      s',(,⎕UCS 8592),'''apple''',(,⎕UCS 10),'      v ss'
  (howssn)[1785+⍳35]←'n s',(,⎕UCS 10 49 57 10 10),'... Return empty vector if '
  (howssn)[1820+⍳27]←'not found',(,⎕UCS 10),'      ',(,⎕UCS 9076),'v ssn ''ora'
  (howssn)[1847+⍳36]←'nge''',(,⎕UCS 10 48 10 10),'... Empty arguments return e'
  (howssn)[1883+⍳26]←'mpty results.',(,⎕UCS 10),'      ',(,⎕UCS 9076),''''' ss'
  (howssn)[1909+⍳21]←'n s',(,⎕UCS 10 48 10),'      ',(,⎕UCS 9076),'v ssn '''''
  (howssn)[1930+⍳3]←(,⎕UCS 10 48 10)

howstemleaf←1110⍴0 ⍝ prolog ≡1
  (howstemleaf)[⍳56]←'--------------------------------------------------------'
  (howstemleaf)[56+⍳30]←'----------------------',(,⎕UCS 10 115 108 8592),'stem'
  (howstemleaf)[86+⍳38]←'leaf z',(,⎕UCS 10),'stem and leaf plot of data <z>',(,⎕UCS 10)
  (howstemleaf)[124+⍳52]←'----------------------------------------------------'
  (howstemleaf)[176+⍳37]←'--------------------------',(,⎕UCS 10 10),'Introduct'
  (howstemleaf)[213+⍳26]←'ion:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   A ste'
  (howstemleaf)[239+⍳52]←'m and leaf plot is a type of histogram created from '
  (howstemleaf)[291+⍳39]←'of the digits of',(,⎕UCS 10),'   the data.  It is us'
  (howstemleaf)[330+⍳52]←'eful for analyzing the spread and outliers of a set '
  (howstemleaf)[382+⍳39]←'of',(,⎕UCS 10),'   data, as the outliers can often b'
  (howstemleaf)[421+⍳37]←'e read directly from the data.',(,⎕UCS 10 10),'Argum'
  (howstemleaf)[458+⍳26]←'ents:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<z>   Nume'
  (howstemleaf)[484+⍳38]←'ric vector',(,⎕UCS 10),'   The data to be graphed.',(,⎕UCS 10)
  (howstemleaf)[522+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howstemleaf)[539+⍳39]←'sl>   Character matrix',(,⎕UCS 10),'   The represent'
  (howstemleaf)[578+⍳31]←'ation of the graph.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howstemleaf)[609+⍳26]←'--------',(,⎕UCS 10),'      stemleaf ',(,⎕UCS 175 50)
  (howstemleaf)[635+⍳21]←(,⎕UCS 32 175),'23 23 34,(',(,⎕UCS 9075),'10), (4',(,⎕UCS 215)
  (howstemleaf)[656+⍳19]←(,⎕UCS 9075),'10), 45 86 44',(,⎕UCS 10),'   ',(,⎕UCS 175)
  (howstemleaf)[675+⍳15]←'2|3',(,⎕UCS 10),'   ',(,⎕UCS 175 49 124 10),'   ',(,⎕UCS 175)
  (howstemleaf)[690+⍳26]←'0|2',(,⎕UCS 10),'    0|12344567889',(,⎕UCS 10),'    '
  (howstemleaf)[716+⍳26]←'1|026',(,⎕UCS 10),'    2|0348',(,⎕UCS 10),'    3|246'
  (howstemleaf)[742+⍳19]←(,⎕UCS 10),'    4|045',(,⎕UCS 10),'    5|',(,⎕UCS 10),' '
  (howstemleaf)[761+⍳21]←'   6|',(,⎕UCS 10),'    7|',(,⎕UCS 10),'    8|6',(,⎕UCS 10)
  (howstemleaf)[782+⍳52]←'...The graph clearly shows that the data point 86 is'
  (howstemleaf)[834+⍳35]←' an ''outlier''.',(,⎕UCS 10 10),'      stemleaf 10.5'
  (howstemleaf)[869+⍳46]←'6 10.89 11.1 14.89 15 10.34 16.7 10.45 14.567',(,⎕UCS 10)
  (howstemleaf)[915+⍳39]←'    1|000014456',(,⎕UCS 10),'...The data can be read'
  (howstemleaf)[954+⍳52]←' directly from the graph.  There are 4 occurrences o'
  (howstemleaf)[1006+⍳37]←'f',(,⎕UCS 10),'...10 (i.e.  4 0''s), 1 occurrence o'
  (howstemleaf)[1043+⍳42]←'f 11 (i.e.  one ''1''), 2 occurrences of 14',(,⎕UCS 10)
  (howstemleaf)[1085+⍳25]←'...(i.e.  two 4''s), etc.',(,⎕UCS 10)

howsubtotal←2260⍴0 ⍝ prolog ≡1
  (howsubtotal)[⍳56]←'--------------------------------------------------------'
  (howsubtotal)[56+⍳33]←'----------------------',(,⎕UCS 10 114 8592),'p subtot'
  (howsubtotal)[89+⍳40]←'al m',(,⎕UCS 10),'compute and merge subtotals of <m> '
  (howsubtotal)[129+⍳39]←'determined by positions <p>',(,⎕UCS 10),'-----------'
  (howsubtotal)[168+⍳52]←'----------------------------------------------------'
  (howsubtotal)[220+⍳31]←'---------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howsubtotal)[251+⍳39]←'------------',(,⎕UCS 10),'   This subtotalling funct'
  (howsubtotal)[290+⍳48]←'ion is flexible, easy-to-use, and general.  The',(,⎕UCS 10)
  (howsubtotal)[338+⍳52]←'   argument <p> specifies which rows are to be subto'
  (howsubtotal)[390+⍳39]←'talled in the data',(,⎕UCS 10),'   matrix <m>.  The '
  (howsubtotal)[429+⍳46]←'subtotal rows are merged into the data in the',(,⎕UCS 10)
  (howsubtotal)[475+⍳52]←'   specified locations.  Together with a text matrix'
  (howsubtotal)[527+⍳39]←' of row titles, the',(,⎕UCS 10),'   function provide'
  (howsubtotal)[566+⍳46]←'s a simple and powerful reporting capability.',(,⎕UCS 10)
  (howsubtotal)[612+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howsubtotal)[634+⍳29]←'<p>   Numeric matrix, (',(,⎕UCS 9076),'p)=n',(,⎕UCS 215)
  (howsubtotal)[663+⍳38]←(,⎕UCS 50 10),'   This ''order'' matrix has as many r'
  (howsubtotal)[701+⍳41]←'ows as the number of subtotal rows, and',(,⎕UCS 10),' '
  (howsubtotal)[742+⍳52]←'  two columns.  The first column defines the startin'
  (howsubtotal)[794+⍳39]←'g position of a',(,⎕UCS 10),'   subtotal row, and th'
  (howsubtotal)[833+⍳52]←'e second column defines the ending row.  The subtota'
  (howsubtotal)[885+⍳39]←'l',(,⎕UCS 10),'   row will be merged into the data a'
  (howsubtotal)[924+⍳39]←'t the row immediately following the',(,⎕UCS 10),'   '
  (howsubtotal)[963+⍳52]←'last row comprising the subtotal, or immediately fol'
  (howsubtotal)[1015+⍳38]←'lowing the previous',(,⎕UCS 10),'   subtotal.  Only'
  (howsubtotal)[1053+⍳51]←' contiguous rows can be subtotalled.  For example, '
  (howsubtotal)[1104+⍳38]←'rows 1,',(,⎕UCS 10),'   3, and 5 cannot be subtotal'
  (howsubtotal)[1142+⍳36]←'led into one row.',(,⎕UCS 10 10),'<m>   Numeric mat'
  (howsubtotal)[1178+⍳35]←'rix',(,⎕UCS 10),'   The data to be subtotalled.',(,⎕UCS 10)
  (howsubtotal)[1213+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howsubtotal)[1230+⍳38]←'r>   numeric array',(,⎕UCS 10),'   The original dat'
  (howsubtotal)[1268+⍳50]←'a with the subtotal rows inserted in the specified'
  (howsubtotal)[1318+⍳24]←(,⎕UCS 10),'   locations.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howsubtotal)[1342+⍳35]←'------',(,⎕UCS 10),'   An old utility workspace',(,⎕UCS 10)
  (howsubtotal)[1377+⍳20]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howsubtotal)[1397+⍳51]←'...Suppose <m> represents quantity and sales of fru'
  (howsubtotal)[1448+⍳27]←'its and vegetables',(,⎕UCS 10),'      m',(,⎕UCS 8592)
  (howsubtotal)[1475+⍳34]←'5 2',(,⎕UCS 9076),'100 5 100 15 100 25 12 7 96 7',(,⎕UCS 10)
  (howsubtotal)[1509+⍳22]←'      itemlabels',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710)
  (howsubtotal)[1531+⍳47]←'box ''apples/oranges/peaches/tomatoes/potatoes''',(,⎕UCS 10)
  (howsubtotal)[1578+⍳29]←'      itemlabels,'' '',',(,⎕UCS 9045 109 10),'apple'
  (howsubtotal)[1607+⍳29]←'s   100   5',(,⎕UCS 10),'oranges  100  15',(,⎕UCS 10)
  (howsubtotal)[1636+⍳34]←'peaches  100  25',(,⎕UCS 10),'tomatoes  12   7',(,⎕UCS 10)
  (howsubtotal)[1670+⍳38]←'potatoes  96   7',(,⎕UCS 10),'...Compute and insert'
  (howsubtotal)[1708+⍳51]←' subtotals of fruits and vegetables, and grand tota'
  (howsubtotal)[1759+⍳14]←'l',(,⎕UCS 10),'      p',(,⎕UCS 8592),'3 2',(,⎕UCS 9076)
  (howsubtotal)[1773+⍳23]←'1 3 4 5 1 5',(,⎕UCS 10),'      r',(,⎕UCS 8592),'p s'
  (howsubtotal)[1796+⍳36]←'ubtotal m',(,⎕UCS 10 10),'...To display a labelled '
  (howsubtotal)[1832+⍳50]←'report, define and merge the total labels into the'
  (howsubtotal)[1882+⍳28]←(,⎕UCS 10),'...item labels.',(,⎕UCS 10),'      total'
  (howsubtotal)[1910+⍳18]←'labels',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''-'
  (howsubtotal)[1928+⍳49]←' total fruits/- total vegetables/-- grand total''',(,⎕UCS 10)
  (howsubtotal)[1977+⍳36]←'      (itemlabels on totallabels)[',(,⎕UCS 9035 40)
  (howsubtotal)[2013+⍳27]←(,⎕UCS 9075 49 8593 9076),'itemlabels),p[;2];],'' '''
  (howsubtotal)[2040+⍳30]←',',(,⎕UCS 9045 114 10),'apples             100   5'
  (howsubtotal)[2070+⍳29]←(,⎕UCS 10),'oranges            100  15',(,⎕UCS 10),'p'
  (howsubtotal)[2099+⍳38]←'eaches            100  25',(,⎕UCS 10),'- total frui'
  (howsubtotal)[2137+⍳38]←'ts     300  45',(,⎕UCS 10),'tomatoes            12 '
  (howsubtotal)[2175+⍳31]←'  7',(,⎕UCS 10),'potatoes            96   7',(,⎕UCS 10)
  (howsubtotal)[2206+⍳38]←'- total vegetables 108  14',(,⎕UCS 10),'-- grand to'
  (howsubtotal)[2244+⍳16]←'tal     408  59',(,⎕UCS 10)

howsuppress←2281⍴0 ⍝ prolog ≡1
  (howsuppress)[⍳56]←'--------------------------------------------------------'
  (howsuppress)[56+⍳33]←'----------------------',(,⎕UCS 13 112 8592),'d suppre'
  (howsuppress)[89+⍳40]←'ss v',(,⎕UCS 13),'suppress characters in matrix <v> d'
  (howsuppress)[129+⍳39]←'elimited by delimiters <d>',(,⎕UCS 13),'------------'
  (howsuppress)[168+⍳52]←'----------------------------------------------------'
  (howsuppress)[220+⍳30]←'--------------',(,⎕UCS 13 13),'Introduction:',(,⎕UCS 13)
  (howsuppress)[250+⍳39]←'------------',(,⎕UCS 13),'   This function is includ'
  (howsuppress)[289+⍳49]←'ed in the toolkit partly because it uses several',(,⎕UCS 13)
  (howsuppress)[338+⍳52]←'   very interesting and useful algorithms for analyz'
  (howsuppress)[390+⍳37]←'ing and ''massaging''',(,⎕UCS 13),'   character vect'
  (howsuppress)[427+⍳37]←'ors.',(,⎕UCS 13 13),'   Note the method used to dete'
  (howsuppress)[464+⍳42]←'rmine the characters that lie between two',(,⎕UCS 13)
  (howsuppress)[506+⍳35]←'   ''delimiter'' characters.',(,⎕UCS 13 13),'   Also'
  (howsuppress)[541+⍳52]←' note the method of replacing characters with blanks'
  (howsuppress)[593+⍳39]←' within a matrix.',(,⎕UCS 13),'   The function appen'
  (howsuppress)[632+⍳46]←'ds a second plane of blanks to create a third',(,⎕UCS 13)
  (howsuppress)[678+⍳52]←'   dimension, then rotates the unwanted characters i'
  (howsuppress)[730+⍳39]←'nto the second plane in',(,⎕UCS 13),'   order to rep'
  (howsuppress)[769+⍳52]←'lace them with blanks, and discards the second plane'
  (howsuppress)[821+⍳30]←' by',(,⎕UCS 13),'   reshaping, as follows:',(,⎕UCS 13)
  (howsuppress)[851+⍳22]←'        p',(,⎕UCS 8592),'mask',(,⎕UCS 9021),'[1] v,['
  (howsuppress)[873+⍳22]←'0.5] '' ''',(,⎕UCS 13),'        p',(,⎕UCS 8592),'sha'
  (howsuppress)[895+⍳21]←'pe',(,⎕UCS 9076),'p[1;;]',(,⎕UCS 13 13),'Arguments:'
  (howsuppress)[916+⍳29]←(,⎕UCS 13),'---------',(,⎕UCS 13),'<d>  2-element cha'
  (howsuppress)[945+⍳39]←'racter vector',(,⎕UCS 13),'   This vector represents'
  (howsuppress)[984+⍳52]←' the two delimiters between which the characters are'
  (howsuppress)[1036+⍳41]←(,⎕UCS 13),'   suppressed.  Delimiters can be the sa'
  (howsuppress)[1077+⍳38]←'me or different symbols.',(,⎕UCS 13),'   d[1] = d[2'
  (howsuppress)[1115+⍳51]←']   In this case no nesting of delimiters is allowe'
  (howsuppress)[1166+⍳23]←'d.',(,⎕UCS 13),'   d[1] ',(,⎕UCS 8800),' d[2]   In '
  (howsuppress)[1189+⍳51]←'this case nesting level analyzed is set to 1 within'
  (howsuppress)[1240+⍳32]←' the',(,⎕UCS 13),'                 function.',(,⎕UCS 13)
  (howsuppress)[1272+⍳34]←(,⎕UCS 13),'<v>   character vector or matrix',(,⎕UCS 13)
  (howsuppress)[1306+⍳51]←'   A vector is treated as a 1-row matrix.  This mat'
  (howsuppress)[1357+⍳38]←'rix is analyzed for the',(,⎕UCS 13),'   presence of'
  (howsuppress)[1395+⍳35]←' the delimiter characters.',(,⎕UCS 13 13),'Result:'
  (howsuppress)[1430+⍳28]←(,⎕UCS 13),'------',(,⎕UCS 13),'<p>   character vect'
  (howsuppress)[1458+⍳38]←'or or matrix',(,⎕UCS 13),'   The array <v> with the'
  (howsuppress)[1496+⍳51]←' characters between delimiters removed (suppressed)'
  (howsuppress)[1547+⍳21]←(,⎕UCS 13 13),'Examples:',(,⎕UCS 13),'--------',(,⎕UCS 13)
  (howsuppress)[1568+⍳51]←'...Here is a complex but syntactically correct APL '
  (howsuppress)[1619+⍳36]←'statement in a character',(,⎕UCS 13),'...vector.',(,⎕UCS 13)
  (howsuppress)[1655+⍳20]←'     ',(,⎕UCS 9109 8592 118 13 114 8592),'(m,[1]-/['
  (howsuppress)[1675+⍳23]←'2](+\[1] 0,[1] m)[',(,⎕UCS 9021),'p+(',(,⎕UCS 9076)
  (howsuppress)[1698+⍳15]←(,⎕UCS 112 41 9076),' 0 1 ;])[',(,⎕UCS 9035 40 9075)
  (howsuppress)[1713+⍳20]←(,⎕UCS 49 8593 9076),'m),p[;2];]',(,⎕UCS 13),'...sup'
  (howsuppress)[1733+⍳51]←'press characters between parentheses (i.e. replace '
  (howsuppress)[1784+⍳36]←'them with blanks)',(,⎕UCS 13),'      ''()'' suppres'
  (howsuppress)[1820+⍳31]←'s v',(,⎕UCS 13 114 8592),'                         '
  (howsuppress)[1851+⍳35]←'                  [',(,⎕UCS 9035),'       ,p[;2];]'
  (howsuppress)[1886+⍳41]←(,⎕UCS 13),'...suppress characters between square br'
  (howsuppress)[1927+⍳29]←'ackets',(,⎕UCS 13),'      ''[]'' suppress v',(,⎕UCS 13)
  (howsuppress)[1956+⍳36]←(,⎕UCS 114 8592),'(m,   -/   (+\    0,    m)        '
  (howsuppress)[1992+⍳19]←'        )',(,⎕UCS 13 13),'      ',(,⎕UCS 9109 8592)
  (howsuppress)[2011+⍳32]←(,⎕UCS 118 8592),'''The book ''''The Cat in the Hat'
  (howsuppress)[2043+⍳33]←''''' is a book for ''''children''''.''',(,⎕UCS 13),'T'
  (howsuppress)[2076+⍳48]←'he book ''The Cat in the Hat'' is a book for ''chil'
  (howsuppress)[2124+⍳37]←'dren''.',(,⎕UCS 13),'...Assign two quote characters'
  (howsuppress)[2161+⍳41]←' (the delimiters) to the left argument.',(,⎕UCS 13),' '
  (howsuppress)[2202+⍳32]←'     '''''''''''' suppress v',(,⎕UCS 13),'The book '
  (howsuppress)[2234+⍳47]←'                     is a book for           .',(,⎕UCS 13)

howthru←915⍴0 ⍝ prolog ≡1
  (howthru)[⍳60]←'------------------------------------------------------------'
  (howthru)[60+⍳31]←'------------------',(,⎕UCS 10 114 8592),'f thru tb',(,⎕UCS 10)
  (howthru)[91+⍳46]←'generate equal-interval vector from <f> to <1',(,⎕UCS 8593)
  (howthru)[137+⍳29]←'tb>, increment=',(,⎕UCS 175 49 8593 116 98 10),'--------'
  (howthru)[166+⍳56]←'--------------------------------------------------------'
  (howthru)[222+⍳31]←'--------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'-'
  (howthru)[253+⍳43]←'-----------',(,⎕UCS 10),'   <thru> generates a numeric v'
  (howthru)[296+⍳43]←'ector of equal increment boundary points',(,⎕UCS 10),'  '
  (howthru)[339+⍳56]←' (integer or fractional increments or decrements) from a'
  (howthru)[395+⍳43]←' specified lower',(,⎕UCS 10),'   bound to an upper bound'
  (howthru)[438+⍳24]←'.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howthru)[462+⍳40]←'<f>   Numeric scalar',(,⎕UCS 10),'   The lower bound',(,⎕UCS 10)
  (howthru)[502+⍳35]←(,⎕UCS 10),'<tb>  Numeric vector (2-element)',(,⎕UCS 10),' '
  (howthru)[537+⍳43]←'  tb[1] -- The upper bound',(,⎕UCS 10),'   tb[2] -- The '
  (howthru)[580+⍳47]←'increment to be used to generate the intervals',(,⎕UCS 10)
  (howthru)[627+⍳20]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r> '
  (howthru)[647+⍳43]←'  Numeric vector',(,⎕UCS 10),'   The vector of boundary '
  (howthru)[690+⍳23]←'points',(,⎕UCS 10 10),'Source:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howthru)[713+⍳56]←'   Adapted from The APL Handbook of Techniques, 1978, IB'
  (howthru)[769+⍳23]←'M.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howthru)[792+⍳32]←'      6 thru 15 2',(,⎕UCS 10),'6 8 10 12 14',(,⎕UCS 10),' '
  (howthru)[824+⍳43]←'     49 thru 45 .5',(,⎕UCS 10),'49 48.5 48 47.5 47 46.5 '
  (howthru)[867+⍳32]←'46 45.5 45',(,⎕UCS 10),'      0 thru 360 90',(,⎕UCS 10),'0'
  (howthru)[899+⍳16]←' 90 180 270 360',(,⎕UCS 10)

howtime←753⍴0 ⍝ prolog ≡1
  (howtime)[⍳60]←'------------------------------------------------------------'
  (howtime)[60+⍳27]←'------------------',(,⎕UCS 10 121 8592),'time',(,⎕UCS 10),'r'
  (howtime)[87+⍳54]←'eturn current time of day in format  hh:mm:ss (am/pm)',(,⎕UCS 10)
  (howtime)[141+⍳56]←'--------------------------------------------------------'
  (howtime)[197+⍳38]←'----------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howtime)[235+⍳43]←'------------',(,⎕UCS 10),'   <time> returns the current '
  (howtime)[278+⍳46]←'time of day as a formatted character vector.',(,⎕UCS 10),' '
  (howtime)[324+⍳44]←'  This result is commonly used in reports.',(,⎕UCS 10 10)
  (howtime)[368+⍳24]←'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10 60 9109),'t'
  (howtime)[392+⍳39]←'s>   System variable (global)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howtime)[431+⍳31]←'------',(,⎕UCS 10),'<y>   Character vector',(,⎕UCS 10),' '
  (howtime)[462+⍳56]←'  <y> is the current time in the format  hh:mm:ss (am/pm'
  (howtime)[518+⍳22]←')',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howtime)[540+⍳29]←'      time',(,⎕UCS 10),'12:43:38 pm',(,⎕UCS 10),'      '
  (howtime)[569+⍳23]←(,⎕UCS 9076),'time',(,⎕UCS 10 49 49 10 10),'... Note the '
  (howtime)[592+⍳56]←'associated function <ftime> that formats an arbitrary ar'
  (howtime)[648+⍳30]←'gument.',(,⎕UCS 10),'      ftime 6 47 23',(,⎕UCS 10),'06'
  (howtime)[678+⍳32]←':47:23 am',(,⎕UCS 10),'      ftime 11 11 21',(,⎕UCS 10),'1'
  (howtime)[710+⍳26]←'1:11:21 am',(,⎕UCS 10),'      ftime 3',(,⎕UCS 8593 51)
  (howtime)[736+⍳17]←(,⎕UCS 8595 9109 116 115 10),'12:43:39 pm',(,⎕UCS 10)

howtimer←2633⍴0 ⍝ prolog ≡1
  (howtimer)[⍳59]←'-----------------------------------------------------------'
  (howtimer)[59+⍳30]←'-------------------',(,⎕UCS 10 121 8592),'timer n',(,⎕UCS 10)
  (howtimer)[89+⍳56]←'time <n> executions of an expression for cpu and connect'
  (howtimer)[145+⍳42]←' time',(,⎕UCS 10),'------------------------------------'
  (howtimer)[187+⍳44]←'------------------------------------------',(,⎕UCS 10 10)
  (howtimer)[231+⍳29]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'  '
  (howtimer)[260+⍳55]←' <timer> returns the elapsed time for <n> executions of'
  (howtimer)[315+⍳42]←' a specifed set of',(,⎕UCS 10),'   APL statements.  The'
  (howtimer)[357+⍳46]←' result provides an approximate but effective',(,⎕UCS 10)
  (howtimer)[403+⍳55]←'   assessment of the performance of specific expression'
  (howtimer)[458+⍳42]←'s using standard APL',(,⎕UCS 10),'   features.  <timer>'
  (howtimer)[500+⍳51]←' is useful when more sophisticated but proprietary',(,⎕UCS 10)
  (howtimer)[551+⍳48]←'   system monitoring features are not provided.',(,⎕UCS 10)
  (howtimer)[599+⍳45]←(,⎕UCS 10),'   The suggested procedure for using <timer>'
  (howtimer)[644+⍳42]←' is as follows:',(,⎕UCS 10),'   (1) Make a copy of <tim'
  (howtimer)[686+⍳42]←'er>.  Call it <ff> for example.',(,⎕UCS 10),'   (2) Set'
  (howtimer)[728+⍳55]←' <n> to some appropriate values, e.g. 1, 10, 100, and r'
  (howtimer)[783+⍳42]←'ecord the',(,⎕UCS 10),'       times. This step times <n'
  (howtimer)[825+⍳45]←'> executions doing nothing through the loop.',(,⎕UCS 10)
  (howtimer)[870+⍳40]←'       It assesses the ''overhead''.',(,⎕UCS 10),'   (3'
  (howtimer)[910+⍳55]←') Insert the expression into <ff> in the place provided'
  (howtimer)[965+⍳39]←'.  (Refer to',(,⎕UCS 10),'       function listing.)',(,⎕UCS 10)
  (howtimer)[1004+⍳54]←'   (4) Execute <ff n> several times and record the res'
  (howtimer)[1058+⍳41]←'ults, but ignore the',(,⎕UCS 10),'       first result.'
  (howtimer)[1099+⍳54]←' Orders of magnitude are useful, e.g. ff 1, ff 10, ff '
  (howtimer)[1153+⍳41]←'100.',(,⎕UCS 10),'   (5) Adjust the results for overhe'
  (howtimer)[1194+⍳41]←'ad.',(,⎕UCS 10),'   (6) If desired, compute the median'
  (howtimer)[1235+⍳41]←' for a good approximation to the cpu',(,⎕UCS 10),'    '
  (howtimer)[1276+⍳52]←'   required for n executions, even with ''spread out'''
  (howtimer)[1328+⍳35]←' results.  median',(,⎕UCS 247 110 10),'       is a sui'
  (howtimer)[1363+⍳54]←'table approximation to the time required for one execu'
  (howtimer)[1417+⍳39]←'tion.',(,⎕UCS 10 10),'   For very fast operations, set'
  (howtimer)[1456+⍳45]←' <n> to a value that requires a large enough',(,⎕UCS 10)
  (howtimer)[1501+⍳54]←'   cpu value, such as 2-10 seconds.  The elapsed time '
  (howtimer)[1555+⍳41]←'<y[2]> is for',(,⎕UCS 10),'   information only; interp'
  (howtimer)[1596+⍳48]←'ret according to the time-shared or single-user',(,⎕UCS 10)
  (howtimer)[1644+⍳54]←'   system being used.  Two or more algorithms can be c'
  (howtimer)[1698+⍳41]←'ompared by following',(,⎕UCS 10),'   the procedure onc'
  (howtimer)[1739+⍳34]←'e for each algorithm.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howtimer)[1773+⍳31]←'---------',(,⎕UCS 10),'<n>   numeric scalar',(,⎕UCS 10)
  (howtimer)[1804+⍳54]←'   The number of times the expression will be executed'
  (howtimer)[1858+⍳39]←'.',(,⎕UCS 10 10),'The expression to be timed must be w'
  (howtimer)[1897+⍳39]←'ritten in the functiion itself.',(,⎕UCS 10 10),'Result'
  (howtimer)[1936+⍳28]←':',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   2-element num'
  (howtimer)[1964+⍳41]←'eric vector',(,⎕UCS 10),'   y[1] -- elapsed cpu time ('
  (howtimer)[2005+⍳38]←'milliseconds).  Computed from ',(,⎕UCS 9109),'ai[2].',(,⎕UCS 10)
  (howtimer)[2043+⍳54]←'   y[2] -- elapsed connect time (milliseconds).  Compu'
  (howtimer)[2097+⍳24]←'ted from ',(,⎕UCS 9109),'ai[3].',(,⎕UCS 10 10),'Exampl'
  (howtimer)[2121+⍳28]←'es:',(,⎕UCS 10),'--------',(,⎕UCS 10),'... Assess exec'
  (howtimer)[2149+⍳51]←'ution with ''empty'' loop.  <ff> is a copy of timer.',(,⎕UCS 10)
  (howtimer)[2200+⍳41]←'     (ff 1),(ff 10),(ff 10), ff 100',(,⎕UCS 10),'55 55'
  (howtimer)[2241+⍳41]←' 109 109 110 110 769 769',(,⎕UCS 10),'... Put expressi'
  (howtimer)[2282+⍳41]←'on to be timed into <ff> and execute',(,⎕UCS 10),'    '
  (howtimer)[2323+⍳17]←(,⎕UCS 8711 32 121 8592),'ff n;tt',(,⎕UCS 10),'[1]  '
  (howtimer)[2340+⍳42]←(,⎕UCS 9053),'time <n> executions of an expression for '
  (howtimer)[2382+⍳28]←'cpu and connect time',(,⎕UCS 10),'[2]  ',(,⎕UCS 9053),'.'
  (howtimer)[2410+⍳30]←'t 1992.3.28.16.40.50',(,⎕UCS 10),'[3]   tt',(,⎕UCS 8592)
  (howtimer)[2440+⍳17]←(,⎕UCS 50 8593 49 8595 9109 97 105 10),'[4]  l1:',(,⎕UCS 8594)
  (howtimer)[2457+⍳21]←'(0>n',(,⎕UCS 8592),'n-1)/l2',(,⎕UCS 10),'[5]   a',(,⎕UCS 8592)
  (howtimer)[2478+⍳17]←'+/((?',(,⎕UCS 9075),'200)',(,⎕UCS 9075 63 9075),'200)'
  (howtimer)[2495+⍳13]←(,⎕UCS 8712 40 63 9075),'200)',(,⎕UCS 9075 63 9075),'20'
  (howtimer)[2508+⍳19]←'0',(,⎕UCS 10),'[6]   ',(,⎕UCS 8594 108 49 10),'[7]  l2'
  (howtimer)[2527+⍳15]←':',(,⎕UCS 10),'[8]   y',(,⎕UCS 8592 40 50 8593 49 8595)
  (howtimer)[2542+⍳15]←(,⎕UCS 9109),'ai)-tt',(,⎕UCS 10),'    ',(,⎕UCS 8711 10),' '
  (howtimer)[2557+⍳41]←'    (ff 1),(ff 10), (ff 10), ff 100',(,⎕UCS 10),'165 1'
  (howtimer)[2598+⍳35]←'65 1428 1428 1483 1483 14171 14171',(,⎕UCS 10)

howtiming←839⍴0 ⍝ prolog ≡1
  (howtiming)[⍳58]←'----------------------------------------------------------'
  (howtiming)[58+⍳30]←'--------------------',(,⎕UCS 10 121 8592),'timing',(,⎕UCS 10)
  (howtiming)[88+⍳55]←'cover function to call and format elapsed cpu and conne'
  (howtiming)[143+⍳41]←'ct time',(,⎕UCS 10),'---------------------------------'
  (howtiming)[184+⍳46]←'---------------------------------------------',(,⎕UCS 10)
  (howtiming)[230+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howtiming)[258+⍳54]←'   <timing> is a cover function that calls <cpucon> an'
  (howtiming)[312+⍳41]←'d returns a formatted',(,⎕UCS 10),'   result using <fc'
  (howtiming)[353+⍳53]←'pucon>.  It is typically the timing function that one'
  (howtiming)[406+⍳29]←(,⎕UCS 10),'   uses in applications.',(,⎕UCS 10 10),'  '
  (howtiming)[435+⍳54]←' While it is useful to have separate computation and f'
  (howtiming)[489+⍳41]←'ormatting functions',(,⎕UCS 10),'   for the timing too'
  (howtiming)[530+⍳54]←'ls, in case one requires particular timing functions f'
  (howtiming)[584+⍳41]←'or',(,⎕UCS 10),'   the APL implementation, the formatt'
  (howtiming)[625+⍳41]←'ing functions are still useful, and',(,⎕UCS 10),'   fo'
  (howtiming)[666+⍳52]←'r practical purposes one timing ''cover'' function is '
  (howtiming)[718+⍳39]←'preferable.',(,⎕UCS 10 10),'   For more information on'
  (howtiming)[757+⍳52]←' <timing>, refer to the listing of the function and',(,⎕UCS 10)
  (howtiming)[809+⍳30]←'   the document on <fcpucon>.',(,⎕UCS 10)

howtower←2656⍴0 ⍝ prolog ≡1
  (howtower)[⍳59]←'-----------------------------------------------------------'
  (howtower)[59+⍳30]←'-------------------',(,⎕UCS 10 122 8592),'tower x',(,⎕UCS 10)
  (howtower)[89+⍳56]←'tower chart (skyscraper diagram) for contingency table <'
  (howtower)[145+⍳42]←'x>',(,⎕UCS 10),'---------------------------------------'
  (howtower)[187+⍳42]←'---------------------------------------',(,⎕UCS 10 10),'I'
  (howtower)[229+⍳29]←'ntroduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   '
  (howtower)[258+⍳55]←'<tower> is a useful 3-dimensional representation of con'
  (howtower)[313+⍳33]←'tingency table data.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howtower)[346+⍳32]←'---------',(,⎕UCS 10),'<x>   Numeric matrix',(,⎕UCS 10),' '
  (howtower)[378+⍳54]←'  The argument <x> represents the data to be graphed.',(,⎕UCS 10)
  (howtower)[432+⍳19]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<z>'
  (howtower)[451+⍳42]←'   Character matrix',(,⎕UCS 10),'   The matrix represen'
  (howtower)[493+⍳27]←'ts the chart.',(,⎕UCS 10 10),'Notes:',(,⎕UCS 10),'-----'
  (howtower)[520+⍳45]←(,⎕UCS 10),'   Automatic scaling takes place and the res'
  (howtower)[565+⍳42]←'ult is a 3-dimensional diagram in',(,⎕UCS 10),'   the f'
  (howtower)[607+⍳55]←'orm of a character matrix with (2+7r) rows and (7r+17c)'
  (howtower)[662+⍳42]←' columns,',(,⎕UCS 10),'   where r and c are the number '
  (howtower)[704+⍳40]←'of rows and columns in <x>.  If ',(,⎕UCS 9109),'pw=132 '
  (howtower)[744+⍳42]←'it',(,⎕UCS 10),'   is thus possible to graph tables of '
  (howtower)[786+⍳20]←'up to 14',(,⎕UCS 215),'2, 11',(,⎕UCS 215),'3, 9',(,⎕UCS 215)
  (howtower)[806+⍳19]←'4, 6',(,⎕UCS 215),'5, and 4',(,⎕UCS 215 54 46 10 10),'S'
  (howtower)[825+⍳29]←'ource:',(,⎕UCS 10),'------',(,⎕UCS 10),'   APL Quote Qu'
  (howtower)[854+⍳55]←'ad 15, 13, March 1985, Algorithm 164, by Carina Heiselb'
  (howtower)[909+⍳42]←'etz.',(,⎕UCS 10),'   Also refer to the article on Cross'
  (howtower)[951+⍳42]←'tab, APL Quote Quad 13, 4, June 1983,',(,⎕UCS 10),'   A'
  (howtower)[993+⍳27]←'lgorithm 159.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--'
  (howtower)[1020+⍳26]←'------',(,⎕UCS 10),'      tower 3 3',(,⎕UCS 9076),'29 '
  (howtower)[1046+⍳39]←'16 5 26 12 20 28 30 17',(,⎕UCS 10 10),'               '
  (howtower)[1085+⍳30]←'        /',(,⎕UCS 175 175 47 124 10),'                '
  (howtower)[1115+⍳22]←'      |',(,⎕UCS 8902 8902),'| |',(,⎕UCS 10),'         '
  (howtower)[1137+⍳22]←'             |',(,⎕UCS 8902 8902),'| |',(,⎕UCS 10),'  '
  (howtower)[1159+⍳27]←'                    |',(,⎕UCS 8902 8902),'| |',(,⎕UCS 10)
  (howtower)[1186+⍳29]←'                      |',(,⎕UCS 8902 8902),'| |',(,⎕UCS 10)
  (howtower)[1215+⍳35]←'                     _|',(,⎕UCS 8902 8902),'| |_______'
  (howtower)[1250+⍳37]←'_____/',(,⎕UCS 175 175),'/|___________________________'
  (howtower)[1287+⍳27]←(,⎕UCS 10),'                    / |',(,⎕UCS 8902 8902),'|'
  (howtower)[1314+⍳35]←' |         / |',(,⎕UCS 8902 8902),'| |         /      '
  (howtower)[1349+⍳36]←'          /',(,⎕UCS 10),'                   /  |',(,⎕UCS 8902)
  (howtower)[1385+⍳23]←(,⎕UCS 8902),'| |        /  |',(,⎕UCS 8902 8902),'| |  '
  (howtower)[1408+⍳41]←'      /                /',(,⎕UCS 10),'                '
  (howtower)[1449+⍳18]←'/',(,⎕UCS 175 175),'/| |',(,⎕UCS 8902 8902),'| |      '
  (howtower)[1467+⍳25]←' /   |',(,⎕UCS 8902 8902),'| |       /    /',(,⎕UCS 175)
  (howtower)[1492+⍳28]←(,⎕UCS 175),'/|       /',(,⎕UCS 10),'              1|'
  (howtower)[1520+⍳19]←(,⎕UCS 8902 8902),'| | |',(,⎕UCS 8902 8902),'| |      /'
  (howtower)[1539+⍳23]←'    |',(,⎕UCS 8902 8902),'| |      /    |',(,⎕UCS 8902)
  (howtower)[1562+⍳28]←(,⎕UCS 8902),'| |      /',(,⎕UCS 10),'               |'
  (howtower)[1590+⍳19]←(,⎕UCS 8902 8902),'| | |',(,⎕UCS 8902 8902),'|/      / '
  (howtower)[1609+⍳19]←'    |',(,⎕UCS 8902 8902),'|/      /',(,⎕UCS 175 175),'/'
  (howtower)[1628+⍳22]←'| |',(,⎕UCS 8902 8902),'|/      /',(,⎕UCS 10),'       '
  (howtower)[1650+⍳35]←'        |',(,⎕UCS 8902 8902),'| |           /         '
  (howtower)[1685+⍳26]←'       |',(,⎕UCS 8902 8902),'| |           /',(,⎕UCS 10)
  (howtower)[1711+⍳35]←'              /|',(,⎕UCS 8902 8902),'| |__________/___'
  (howtower)[1746+⍳32]←'_____________/|',(,⎕UCS 8902 8902),'| |__________/',(,⎕UCS 10)
  (howtower)[1778+⍳34]←'             / |',(,⎕UCS 8902 8902),'| |         /  /'
  (howtower)[1812+⍳21]←(,⎕UCS 175 175),'/|         / |',(,⎕UCS 8902 8902),'| |'
  (howtower)[1833+⍳28]←'         /',(,⎕UCS 10),'            /  |',(,⎕UCS 8902)
  (howtower)[1861+⍳17]←(,⎕UCS 8902),'| |     /',(,⎕UCS 175 175),'/| |',(,⎕UCS 8902)
  (howtower)[1878+⍳23]←(,⎕UCS 8902),'| |        /  |',(,⎕UCS 8902 8902),'| |  '
  (howtower)[1901+⍳24]←'      /',(,⎕UCS 10),'         /',(,⎕UCS 175 175),'/| |'
  (howtower)[1925+⍳17]←(,⎕UCS 8902 8902),'| |    |',(,⎕UCS 8902 8902),'| | |'
  (howtower)[1942+⍳20]←(,⎕UCS 8902 8902),'| |       /   |',(,⎕UCS 8902 8902),'|'
  (howtower)[1962+⍳23]←' |       /',(,⎕UCS 10),'       2|',(,⎕UCS 8902 8902),'|'
  (howtower)[1985+⍳17]←' | |',(,⎕UCS 8902 8902),'| |    |',(,⎕UCS 8902 8902),'|'
  (howtower)[2002+⍳22]←' | |',(,⎕UCS 8902 8902),'| |      /    |',(,⎕UCS 8902)
  (howtower)[2024+⍳22]←(,⎕UCS 8902),'| |      /',(,⎕UCS 10),'        |',(,⎕UCS 8902)
  (howtower)[2046+⍳17]←(,⎕UCS 8902),'| | |',(,⎕UCS 8902 8902),'|/     |',(,⎕UCS 8902)
  (howtower)[2063+⍳23]←(,⎕UCS 8902),'| | |',(,⎕UCS 8902 8902),'|/      /     |'
  (howtower)[2086+⍳22]←(,⎕UCS 8902 8902),'|/      /',(,⎕UCS 10),'        |',(,⎕UCS 8902)
  (howtower)[2108+⍳23]←(,⎕UCS 8902),'| |           |',(,⎕UCS 8902 8902),'| |  '
  (howtower)[2131+⍳28]←'         //',(,⎕UCS 175 175),'/|           /',(,⎕UCS 10)
  (howtower)[2159+⍳27]←'       /|',(,⎕UCS 8902 8902),'| |__________/|',(,⎕UCS 8902)
  (howtower)[2186+⍳23]←(,⎕UCS 8902),'| |__________/|',(,⎕UCS 8902 8902),'| |__'
  (howtower)[2209+⍳22]←'________/',(,⎕UCS 10),'      / |',(,⎕UCS 8902 8902),'|'
  (howtower)[2231+⍳32]←' |         / |',(,⎕UCS 8902 8902),'| |         / |',(,⎕UCS 8902)
  (howtower)[2263+⍳25]←(,⎕UCS 8902),'| |         /',(,⎕UCS 10),'     /  |',(,⎕UCS 8902)
  (howtower)[2288+⍳23]←(,⎕UCS 8902),'| |        /  |',(,⎕UCS 8902 8902),'| |  '
  (howtower)[2311+⍳25]←'      /  |',(,⎕UCS 8902 8902),'| |        /',(,⎕UCS 10)
  (howtower)[2336+⍳27]←'    /   |',(,⎕UCS 8902 8902),'| |       /   |',(,⎕UCS 8902)
  (howtower)[2363+⍳23]←(,⎕UCS 8902),'| |       /   |',(,⎕UCS 8902 8902),'| |  '
  (howtower)[2386+⍳22]←'     /',(,⎕UCS 10),'3  /    |',(,⎕UCS 8902 8902),'| | '
  (howtower)[2408+⍳29]←'     /    |',(,⎕UCS 8902 8902),'| |      /    |',(,⎕UCS 8902)
  (howtower)[2437+⍳22]←(,⎕UCS 8902),'| |      /',(,⎕UCS 10),'  /     |',(,⎕UCS 8902)
  (howtower)[2459+⍳23]←(,⎕UCS 8902),'|/      /     |',(,⎕UCS 8902 8902),'|/   '
  (howtower)[2482+⍳23]←'   /     |',(,⎕UCS 8902 8902),'|/      /',(,⎕UCS 10),' '
  (howtower)[2505+⍳53]←'/                /                /                /',(,⎕UCS 10)
  (howtower)[2558+⍳53]←'/________________/________________/________________/',(,⎕UCS 10)
  (howtower)[2611+⍳45]←'         a                b                c',(,⎕UCS 10)

howtriangle←1312⍴0 ⍝ prolog ≡1
  (howtriangle)[⍳56]←'--------------------------------------------------------'
  (howtriangle)[56+⍳33]←'----------------------',(,⎕UCS 10 121 8592),'triangle'
  (howtriangle)[89+⍳34]←' n',(,⎕UCS 10),'print a pretty triangle using ',(,⎕UCS 8800)
  (howtriangle)[123+⍳39]←'\ where <n> is a power of 2',(,⎕UCS 10),'-----------'
  (howtriangle)[162+⍳52]←'----------------------------------------------------'
  (howtriangle)[214+⍳31]←'---------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howtriangle)[245+⍳39]←'------------',(,⎕UCS 10),'   This little function pr'
  (howtriangle)[284+⍳49]←'oduces as a result a triangular pattern based on',(,⎕UCS 10)
  (howtriangle)[333+⍳49]←'   the characteristics of repeating the function '
  (howtriangle)[382+⍳26]←(,⎕UCS 8800),'\ on a boolean vector.',(,⎕UCS 10 10),'A'
  (howtriangle)[408+⍳26]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<n>   '
  (howtriangle)[434+⍳39]←'Numeric scalar',(,⎕UCS 10),'   The best results are '
  (howtriangle)[473+⍳51]←'obtained when <n> is a power of 2, e.g.  4, 8, 16,',(,⎕UCS 10)
  (howtriangle)[524+⍳52]←'   32, etc.  If n is not a power of 2, the resulting'
  (howtriangle)[576+⍳30]←' pattern is not so',(,⎕UCS 10),'   pretty!',(,⎕UCS 10)
  (howtriangle)[606+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howtriangle)[623+⍳39]←'y>   Character matrix',(,⎕UCS 10),'   The matrix whe'
  (howtriangle)[662+⍳51]←'n displayed is a pattern of triangles of gradually',(,⎕UCS 10)
  (howtriangle)[713+⍳29]←'   increasing size.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howtriangle)[742+⍳39]←'------',(,⎕UCS 10),'   Working Memorandum No. 106, E'
  (howtriangle)[781+⍳37]←'dited by Robert Smith, STSC, 1975.',(,⎕UCS 10 10),'E'
  (howtriangle)[818+⍳26]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      tr'
  (howtriangle)[844+⍳16]←'iangle 16',(,⎕UCS 10 8902 8902 8902 8902 8902 8902)
  (howtriangle)[860+⍳9]←(,⎕UCS 8902 8902 8902 8902 8902 8902 8902 8902 8902)
  (howtriangle)[869+⍳12]←(,⎕UCS 8902 10 8902 32 8902 32 8902 32 8902 32 8902 32)
  (howtriangle)[881+⍳11]←(,⎕UCS 8902 32 8902 32 8902 10 8902 8902 32 32 8902)
  (howtriangle)[892+⍳12]←(,⎕UCS 8902 32 32 8902 8902 32 32 8902 8902 10 8902),' '
  (howtriangle)[904+⍳11]←'  ',(,⎕UCS 8902),'   ',(,⎕UCS 8902),'   ',(,⎕UCS 8902)
  (howtriangle)[915+⍳11]←(,⎕UCS 10 8902 8902 8902 8902),'    ',(,⎕UCS 8902 8902)
  (howtriangle)[926+⍳12]←(,⎕UCS 8902 8902 10 8902 32 8902),'     ',(,⎕UCS 8902)
  (howtriangle)[938+⍳13]←(,⎕UCS 32 8902 10 8902 8902),'      ',(,⎕UCS 8902 8902)
  (howtriangle)[951+⍳13]←(,⎕UCS 10 8902),'       ',(,⎕UCS 8902 10 8902 8902)
  (howtriangle)[964+⍳10]←(,⎕UCS 8902 8902 8902 8902 8902 8902 10 8902 32 8902)
  (howtriangle)[974+⍳12]←(,⎕UCS 32 8902 32 8902 10 8902 8902 32 32 8902 8902 10)
  (howtriangle)[986+⍳10]←(,⎕UCS 8902),'   ',(,⎕UCS 8902 10 8902 8902 8902 8902)
  (howtriangle)[996+⍳12]←(,⎕UCS 10 8902 32 8902 10 8902 8902 10 8902 10 10),' '
  (howtriangle)[1008+⍳18]←'     (m,',(,⎕UCS 9021),'m),[1]',(,⎕UCS 8854 109 44)
  (howtriangle)[1026+⍳15]←(,⎕UCS 9021 109 8592),'triangle 8',(,⎕UCS 10 8902)
  (howtriangle)[1041+⍳9]←(,⎕UCS 8902 8902 8902 8902 8902 8902 8902 8902 8902)
  (howtriangle)[1050+⍳10]←(,⎕UCS 8902 8902 8902 8902 8902 8902 10 8902 32 8902)
  (howtriangle)[1060+⍳12]←(,⎕UCS 32 8902 32 8902 32 32 8902 32 8902 32 8902 32)
  (howtriangle)[1072+⍳13]←(,⎕UCS 8902 10 8902 8902 32 32 8902 8902),'    ',(,⎕UCS 8902)
  (howtriangle)[1085+⍳11]←(,⎕UCS 8902 32 32 8902 8902 10 8902),'   ',(,⎕UCS 8902)
  (howtriangle)[1096+⍳14]←'      ',(,⎕UCS 8902),'   ',(,⎕UCS 8902 10 8902 8902)
  (howtriangle)[1110+⍳13]←(,⎕UCS 8902 8902),'        ',(,⎕UCS 8902 8902 8902)
  (howtriangle)[1123+⍳16]←(,⎕UCS 8902 10 8902 32 8902),'          ',(,⎕UCS 8902)
  (howtriangle)[1139+⍳18]←(,⎕UCS 32 8902 10 8902 8902),'            ',(,⎕UCS 8902)
  (howtriangle)[1157+⍳19]←(,⎕UCS 8902 10 8902),'              ',(,⎕UCS 8902 10)
  (howtriangle)[1176+⍳18]←(,⎕UCS 8902),'              ',(,⎕UCS 8902 10 8902)
  (howtriangle)[1194+⍳17]←(,⎕UCS 8902),'            ',(,⎕UCS 8902 8902 10 8902)
  (howtriangle)[1211+⍳16]←(,⎕UCS 32 8902),'          ',(,⎕UCS 8902 32 8902 10)
  (howtriangle)[1227+⍳13]←(,⎕UCS 8902 8902 8902 8902),'        ',(,⎕UCS 8902)
  (howtriangle)[1240+⍳10]←(,⎕UCS 8902 8902 8902 10 8902),'   ',(,⎕UCS 8902),' '
  (howtriangle)[1250+⍳13]←'     ',(,⎕UCS 8902),'   ',(,⎕UCS 8902 10 8902 8902)
  (howtriangle)[1263+⍳12]←(,⎕UCS 32 32 8902 8902),'    ',(,⎕UCS 8902 8902 32 32)
  (howtriangle)[1275+⍳11]←(,⎕UCS 8902 8902 10 8902 32 8902 32 8902 32 8902 32)
  (howtriangle)[1286+⍳11]←(,⎕UCS 32 8902 32 8902 32 8902 32 8902 10 8902 8902)
  (howtriangle)[1297+⍳9]←(,⎕UCS 8902 8902 8902 8902 8902 8902 8902 8902 8902)
  (howtriangle)[1306+⍳6]←(,⎕UCS 8902 8902 8902 8902 8902 10)

howunbox←1554⍴0 ⍝ prolog ≡1
  (howunbox)[⍳59]←'-----------------------------------------------------------'
  (howunbox)[59+⍳32]←'-------------------',(,⎕UCS 10 114 8592),'c unbox x',(,⎕UCS 10)
  (howunbox)[91+⍳56]←'unbox matrix <x>. remove trailing <c[2]>, delimit vector'
  (howunbox)[147+⍳42]←' <x> by <c[1]>',(,⎕UCS 10),'---------------------------'
  (howunbox)[189+⍳52]←'---------------------------------------------------',(,⎕UCS 10)
  (howunbox)[241+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howunbox)[269+⍳40]←'   <unbox> is the inverse of <',(,⎕UCS 8710),'box>.  Th'
  (howunbox)[309+⍳42]←'e function takes a matrix right',(,⎕UCS 10),'   argumen'
  (howunbox)[351+⍳42]←'t and returns the corresponding vector.',(,⎕UCS 10 10),'A'
  (howunbox)[393+⍳29]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<c>   2-e'
  (howunbox)[422+⍳42]←'lement vector, numeric or character',(,⎕UCS 10),'   c[1'
  (howunbox)[464+⍳55]←'] -- Separater character (or number) to be used in the '
  (howunbox)[519+⍳42]←'result <r>',(,⎕UCS 10),'   c[2] -- Fill element being u'
  (howunbox)[561+⍳42]←'sed in the matrix <m>',(,⎕UCS 10),'           (The fill'
  (howunbox)[603+⍳55]←' element is the element, if needed, that is used to pad'
  (howunbox)[658+⍳45]←(,⎕UCS 10),'           irregular rows, and is determined'
  (howunbox)[703+⍳42]←' by its presence in the argument',(,⎕UCS 10),'         '
  (howunbox)[745+⍳55]←'  <x>.) <c[2]> defaults to blank for character argument'
  (howunbox)[800+⍳42]←'s, and 0 for',(,⎕UCS 10),'           numeric arguments.'
  (howunbox)[842+⍳36]←(,⎕UCS 10 10),'<x>   Numeric or character matrix',(,⎕UCS 10)
  (howunbox)[878+⍳45]←(,⎕UCS 10),'<x> and <c> must be both character or both n'
  (howunbox)[923+⍳24]←'umeric.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howunbox)[947+⍳42]←'<r>   Vector',(,⎕UCS 10),'   The result <r> is the logi'
  (howunbox)[989+⍳49]←'cally delimited vector corresponding to argument',(,⎕UCS 10)
  (howunbox)[1038+⍳52]←'   <x>.  The result is delimited into ''fields'' separ'
  (howunbox)[1090+⍳41]←'ated by c[1].  All',(,⎕UCS 10),'   trailing occurrence'
  (howunbox)[1131+⍳42]←'s of the fill element c[2] are removed.',(,⎕UCS 10 10),'E'
  (howunbox)[1173+⍳25]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ',(,⎕UCS 9109)
  (howunbox)[1198+⍳17]←(,⎕UCS 8592 120 8592),'''/'' ',(,⎕UCS 8710),'box ''appl'
  (howunbox)[1215+⍳27]←'e/betty/cat/dog''',(,⎕UCS 10),'apple',(,⎕UCS 10),'bett'
  (howunbox)[1242+⍳15]←'y',(,⎕UCS 10),'cat',(,⎕UCS 10),'dog',(,⎕UCS 10),'... <'
  (howunbox)[1257+⍳53]←'unbox> returns a vector with trailing blanks removed.'
  (howunbox)[1310+⍳19]←(,⎕UCS 10),'      ''',(,⎕UCS 8902),''' unbox x',(,⎕UCS 10)
  (howunbox)[1329+⍳16]←'apple',(,⎕UCS 8902),'betty',(,⎕UCS 8902),'cat',(,⎕UCS 8902)
  (howunbox)[1345+⍳23]←'dog',(,⎕UCS 8902 10),'...<unbox> and <',(,⎕UCS 8710),'b'
  (howunbox)[1368+⍳27]←'ox> are inverses.',(,⎕UCS 10),'      ''',(,⎕UCS 8902 39)
  (howunbox)[1395+⍳18]←(,⎕UCS 32 8710),'box ''',(,⎕UCS 8902),''' unbox x',(,⎕UCS 10)
  (howunbox)[1413+⍳17]←'apple',(,⎕UCS 10),'betty',(,⎕UCS 10),'cat',(,⎕UCS 10),'d'
  (howunbox)[1430+⍳14]←'og',(,⎕UCS 10 10),'      ',(,⎕UCS 9109 8592 120 8592)
  (howunbox)[1444+⍳21]←(,⎕UCS 175 49 32 8710),'box 1 2 ',(,⎕UCS 175),'1 10 20 '
  (howunbox)[1465+⍳22]←'30 ',(,⎕UCS 175),'1 100',(,⎕UCS 10),'  1   2   0',(,⎕UCS 10)
  (howunbox)[1487+⍳28]←' 10  20  30',(,⎕UCS 10),'100   0   0',(,⎕UCS 10),'    '
  (howunbox)[1515+⍳18]←'  ',(,⎕UCS 175),'1 unbox x',(,⎕UCS 10),'1 2 ',(,⎕UCS 175)
  (howunbox)[1533+⍳21]←'1 10 20 30 ',(,⎕UCS 175),'1 100 ',(,⎕UCS 175 49 10)

howvi←1427⍴0 ⍝ prolog ≡1
  (howvi)[⍳62]←'--------------------------------------------------------------'
  (howvi)[62+⍳26]←'----------------',(,⎕UCS 10 114 8592),'vi a',(,⎕UCS 10),'va'
  (howvi)[88+⍳46]←'lidate numeric input <a>',(,⎕UCS 10),'---------------------'
  (howvi)[134+⍳57]←'---------------------------------------------------------'
  (howvi)[191+⍳29]←(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howvi)[220+⍳58]←'   <vi> validates that the character vector <a> represents'
  (howvi)[278+⍳45]←' a valid set of',(,⎕UCS 10),'   numbers in standard APL fo'
  (howvi)[323+⍳43]←'rmat.  E-notation is supported.',(,⎕UCS 10 10),'Arguments:'
  (howvi)[366+⍳34]←(,⎕UCS 10),'---------',(,⎕UCS 10),'<a>   Character vector',(,⎕UCS 10)
  (howvi)[400+⍳58]←'   This vector represents one or more numbers.  An empty o'
  (howvi)[458+⍳41]←'r blank vector',(,⎕UCS 10),'   gives an empty result.',(,⎕UCS 10)
  (howvi)[499+⍳22]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   '
  (howvi)[521+⍳45]←'Numeric vector',(,⎕UCS 10),'   r[i]=1 -- the i-th non-blan'
  (howvi)[566+⍳46]←'k sequence in <a> represents a valid number.',(,⎕UCS 10),' '
  (howvi)[612+⍳58]←'  r[i]=0 -- the i-th non-blank sequence is an invalid numb'
  (howvi)[670+⍳24]←'er.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (howvi)[694+⍳41]←'      vi ''0 1.10 10009 .45 5.6e',(,⎕UCS 175),'5 5.6e7 ',(,⎕UCS 175)
  (howvi)[735+⍳30]←(,⎕UCS 55 39 10),'1 1 1 1 1 1 1',(,⎕UCS 10),'      vi ''0.0'
  (howvi)[765+⍳30]←'.0 2 1a e5 43.56''',(,⎕UCS 10),'0 1 0 0 1',(,⎕UCS 10 10),'P'
  (howvi)[795+⍳36]←'rogramming Notes:',(,⎕UCS 10),'-----------------',(,⎕UCS 10)
  (howvi)[831+⍳56]←'   The technique used to analyze the ''tokens'' is as foll'
  (howvi)[887+⍳45]←'ows.  A sequence of',(,⎕UCS 10),'   of one or more digits '
  (howvi)[932+⍳52]←'is represented by 1, a period by 2, a negative sign',(,⎕UCS 10)
  (howvi)[984+⍳56]←'   by 3, an ''e'' by 4, and any other character by 5.  The'
  (howvi)[1040+⍳44]←'refore, a sequence',(,⎕UCS 10),'   (i.e.  token) such as '
  (howvi)[1084+⍳52]←'45.899 is represented by the number 121, a sequence',(,⎕UCS 10)
  (howvi)[1136+⍳43]←'   such as ',(,⎕UCS 175),'4.34 is represented by 3121, an'
  (howvi)[1179+⍳44]←'d so on.  An invalid sequence',(,⎕UCS 10),'   such as 1.1'
  (howvi)[1223+⍳57]←'.1 is represented by 12121.  Any representation containin'
  (howvi)[1280+⍳44]←'g 5',(,⎕UCS 10),'   represents an invalid sequence.  The '
  (howvi)[1324+⍳44]←'represenations of all tokens in the',(,⎕UCS 10),'   argum'
  (howvi)[1368+⍳57]←'ent are computed, and the valid represenations identified'
  (howvi)[1425+⍳2]←'.',(,⎕UCS 10)

howvnames←2479⍴0 ⍝ prolog ≡1
  (howvnames)[⍳58]←'----------------------------------------------------------'
  (howvnames)[58+⍳32]←'--------------------',(,⎕UCS 10 121 8592),'vnames v',(,⎕UCS 10)
  (howvnames)[90+⍳42]←'validate name specifications in <v>',(,⎕UCS 10),'------'
  (howvnames)[132+⍳54]←'------------------------------------------------------'
  (howvnames)[186+⍳34]←'------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howvnames)[220+⍳41]←'------------',(,⎕UCS 10),'   <vnames> validates a set '
  (howvnames)[261+⍳46]←'of name specifications for correct syntax and',(,⎕UCS 10)
  (howvnames)[307+⍳54]←'   returns the corresponding tokens.  This function is'
  (howvnames)[361+⍳41]←' used in several',(,⎕UCS 10),'   toolkit functions tha'
  (howvnames)[402+⍳51]←'t require name specifications as arguments, and it',(,⎕UCS 10)
  (howvnames)[453+⍳39]←'   is also of general utility.',(,⎕UCS 10 10),'   The '
  (howvnames)[492+⍳54]←'semantic definition (i.e.  the meaning) of each specif'
  (howvnames)[546+⍳41]←'ication is',(,⎕UCS 10),'   determined by the programs '
  (howvnames)[587+⍳44]←'that use them.  For examples, refer to the',(,⎕UCS 10),' '
  (howvnames)[631+⍳45]←'  functions <wildcard>, <range>, and <pick>.',(,⎕UCS 10)
  (howvnames)[676+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howvnames)[698+⍳41]←'<v>   Character vector',(,⎕UCS 10),'   Vector containi'
  (howvnames)[739+⍳54]←'ng the name specifications.  (See section on result fo'
  (howvnames)[793+⍳24]←'r',(,⎕UCS 10),'   details.)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (howvnames)[817+⍳29]←'------',(,⎕UCS 10),'<y>   Numeric vector',(,⎕UCS 10),' '
  (howvnames)[846+⍳54]←'  y[i]=token -- the i-th non-blank sequence in <v> is '
  (howvnames)[900+⍳41]←'a valid specification.',(,⎕UCS 10),'   y[i]=0     -- t'
  (howvnames)[941+⍳54]←'he i-th non-blank sequence is an invalid specification'
  (howvnames)[995+⍳39]←'.',(,⎕UCS 10 10),'   The following is a table of valid'
  (howvnames)[1034+⍳40]←' name specifications and their',(,⎕UCS 10),'   corres'
  (howvnames)[1074+⍳38]←'ponding tokens:',(,⎕UCS 10 10),'      x     1        '
  (howvnames)[1112+⍳25]←'-     3',(,⎕UCS 10),'      ',(,⎕UCS 8902),'     2    '
  (howvnames)[1137+⍳25]←'    x-y   131',(,⎕UCS 10),'      x',(,⎕UCS 8902),'   '
  (howvnames)[1162+⍳27]←'12        x-    13',(,⎕UCS 10),'      ',(,⎕UCS 8902),'x'
  (howvnames)[1189+⍳30]←'   21        -x    31',(,⎕UCS 10),'      x',(,⎕UCS 8902)
  (howvnames)[1219+⍳18]←'y  121',(,⎕UCS 10),'      ',(,⎕UCS 8902 120 8902),'  '
  (howvnames)[1237+⍳34]←'212',(,⎕UCS 10 10),'   ''x'' and ''y'' represent sequ'
  (howvnames)[1271+⍳46]←'ences of non-blank characters, including <?>,',(,⎕UCS 10)
  (howvnames)[1317+⍳53]←'   chosen from the set <an> defined within the functi'
  (howvnames)[1370+⍳40]←'on.  If a name',(,⎕UCS 10),'   specification begins w'
  (howvnames)[1410+⍳31]←'ith a tilde <',(,⎕UCS 8764),'>, for example, ',(,⎕UCS 8764)
  (howvnames)[1441+⍳17]←(,⎕UCS 120 8902),' and ',(,⎕UCS 8764),'x-y, the',(,⎕UCS 10)
  (howvnames)[1458+⍳40]←'   corresponding token begins with 4.',(,⎕UCS 10 10),'E'
  (howvnames)[1498+⍳27]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      vna'
  (howvnames)[1525+⍳23]←'mes ''abc cr-de a',(,⎕UCS 8902 32 8764),'how',(,⎕UCS 8902)
  (howvnames)[1548+⍳26]←(,⎕UCS 39 10),'1 131 12 412',(,⎕UCS 10 10),'... A larg'
  (howvnames)[1574+⍳48]←'e set of examples (valid and invalid sequences)',(,⎕UCS 10)
  (howvnames)[1622+⍳16]←'      v',(,⎕UCS 8592 39 97 8902 8902 32 8764 97 8902)
  (howvnames)[1638+⍳16]←(,⎕UCS 8902 32 8764 8764),' -x-x ',(,⎕UCS 8902),'x- 7a'
  (howvnames)[1654+⍳21]←' a7 a a? ',(,⎕UCS 8902),' - aa?aa',(,⎕UCS 8902 32 8902)
  (howvnames)[1675+⍳20]←'a a',(,⎕UCS 8902 97 32 8902 97 114 8902),' a- ?- -a '
  (howvnames)[1695+⍳23]←'''',(,⎕UCS 10),'      v',(,⎕UCS 8592),'v,''aaa-b a?-c'
  (howvnames)[1718+⍳12]←' ',(,⎕UCS 8764),'a?-b ',(,⎕UCS 8764),'ab ',(,⎕UCS 8764)
  (howvnames)[1730+⍳14]←'a? ',(,⎕UCS 8764 8902 32 8764),'aa?aa',(,⎕UCS 8902 32)
  (howvnames)[1744+⍳12]←(,⎕UCS 8764 8902 97 32 8764 8902),'aa? ',(,⎕UCS 8764 97)
  (howvnames)[1756+⍳12]←(,⎕UCS 8902 97 32 8764 45 32 8764),'a- ',(,⎕UCS 8764),'?'
  (howvnames)[1768+⍳22]←'- ',(,⎕UCS 8764),'-a''',(,⎕UCS 10 10),'... Format res'
  (howvnames)[1790+⍳40]←'ult using toolkit functions',(,⎕UCS 10),'      78 10 '
  (howvnames)[1830+⍳21]←'matdown ('''' ',(,⎕UCS 8710),'box ',(,⎕UCS 8710),'db '
  (howvnames)[1851+⍳28]←'v) beside ',(,⎕UCS 9045 9033),'matrix vnames v',(,⎕UCS 10)
  (howvnames)[1879+⍳35]←(,⎕UCS 97 8902 8902),'       0          a?        1   '
  (howvnames)[1914+⍳35]←'       ?-       13          ',(,⎕UCS 8764),'aa?aa',(,⎕UCS 8902)
  (howvnames)[1949+⍳26]←' 412',(,⎕UCS 10 8764 97 8902 8902),'      0          '
  (howvnames)[1975+⍳41]←(,⎕UCS 8902),'         2          -a       31         '
  (howvnames)[2016+⍳16]←' ',(,⎕UCS 8764 8902),'a     421',(,⎕UCS 10 8764 8764),' '
  (howvnames)[2032+⍳53]←'       0          -         3          aaa-b   131   '
  (howvnames)[2085+⍳21]←'       ',(,⎕UCS 8764 8902),'aa?   421',(,⎕UCS 10),'-x'
  (howvnames)[2106+⍳38]←'-x      0          aa?aa',(,⎕UCS 8902),'   12        '
  (howvnames)[2144+⍳32]←'  a?-c    131          ',(,⎕UCS 8764 97 8902),'a   41'
  (howvnames)[2176+⍳25]←'21',(,⎕UCS 10 8902),'x-       0          ',(,⎕UCS 8902)
  (howvnames)[2201+⍳38]←'a       21          ',(,⎕UCS 8764),'a?-b  4131       '
  (howvnames)[2239+⍳25]←'   ',(,⎕UCS 8764),'-       43',(,⎕UCS 10),'7a        '
  (howvnames)[2264+⍳33]←'1          a',(,⎕UCS 8902),'a     121          ',(,⎕UCS 8764)
  (howvnames)[2297+⍳32]←'ab      41          ',(,⎕UCS 8764),'a-     413',(,⎕UCS 10)
  (howvnames)[2329+⍳29]←'a7        1          ',(,⎕UCS 8902 97 114 8902),'    '
  (howvnames)[2358+⍳35]←'212          ',(,⎕UCS 8764),'a?      41          ',(,⎕UCS 8764)
  (howvnames)[2393+⍳40]←'?-     413',(,⎕UCS 10),'a         1          a-      '
  (howvnames)[2433+⍳34]←' 13          ',(,⎕UCS 8764 8902),'       42          '
  (howvnames)[2467+⍳12]←(,⎕UCS 8764),'-a     431',(,⎕UCS 10)

howvpis←1216⍴0 ⍝ prolog ≡1
  (howvpis)[⍳60]←'------------------------------------------------------------'
  (howvpis)[60+⍳28]←'------------------',(,⎕UCS 10 121 8592),'vpis v',(,⎕UCS 10)
  (howvpis)[88+⍳45]←'validate positive integer specification <v>',(,⎕UCS 10),'-'
  (howvpis)[133+⍳56]←'--------------------------------------------------------'
  (howvpis)[189+⍳37]←'---------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (howvpis)[226+⍳43]←'------------',(,⎕UCS 10),'   <vnames> validates a set of'
  (howvpis)[269+⍳46]←' positive integer specifications for correct',(,⎕UCS 10),' '
  (howvpis)[315+⍳56]←'  syntax and returns the corresponding tokens.  This fun'
  (howvpis)[371+⍳43]←'ction is used by',(,⎕UCS 10),'   <pickn> and it is also '
  (howvpis)[414+⍳32]←'of general utility.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (howvpis)[446+⍳33]←'---------',(,⎕UCS 10),'<v>   Character vector',(,⎕UCS 10)
  (howvpis)[479+⍳56]←'   Vector containing the specifications.  (See section o'
  (howvpis)[535+⍳28]←'n result for',(,⎕UCS 10),'   details.)',(,⎕UCS 10 10),'R'
  (howvpis)[563+⍳30]←'esult:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   Numeric ma'
  (howvpis)[593+⍳43]←'trix',(,⎕UCS 10),'   The first column is 1 or 0, dependi'
  (howvpis)[636+⍳43]←'ng if the i-th specification is valid',(,⎕UCS 10),'   or'
  (howvpis)[679+⍳56]←' invalid, respectively.  The second column is the set of'
  (howvpis)[735+⍳30]←' tokens.',(,⎕UCS 10),'   y[i;1] -- 1 or 0',(,⎕UCS 10),' '
  (howvpis)[765+⍳43]←'  y[i;2] -- token for i-th specification',(,⎕UCS 10 10),' '
  (howvpis)[808+⍳56]←'  The following is a table of valid positive integer spe'
  (howvpis)[864+⍳43]←'cifications and',(,⎕UCS 10),'   their corresponding toke'
  (howvpis)[907+⍳30]←'ns:',(,⎕UCS 10),'   integer      n      1',(,⎕UCS 10),' '
  (howvpis)[937+⍳43]←'  n to n       n-n    121',(,⎕UCS 10),'   n to end     n'
  (howvpis)[980+⍳35]←'-     12',(,⎕UCS 10),'   start to n   -n     21',(,⎕UCS 10)
  (howvpis)[1015+⍳38]←'   all          -      2',(,⎕UCS 10 10),'   ''n'' repre'
  (howvpis)[1053+⍳40]←'sents a positive integer (or 0).',(,⎕UCS 10 10),'Exampl'
  (howvpis)[1093+⍳28]←'es:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      vpis ''- 5'
  (howvpis)[1121+⍳27]←'- -5 5-6 7''',(,⎕UCS 10),'  1   2',(,⎕UCS 10),'  1  12'
  (howvpis)[1148+⍳19]←(,⎕UCS 10),'  1  21',(,⎕UCS 10),'  1 121',(,⎕UCS 10),'  '
  (howvpis)[1167+⍳26]←'1   1',(,⎕UCS 10 10),'      ''5-7'' pickn ',(,⎕UCS 9075)
  (howvpis)[1193+⍳23]←(,⎕UCS 49 48 10),'0 0 0 0 1 1 1 0 0 0',(,⎕UCS 10)

howvrepl←2233⍴0 ⍝ prolog ≡1
  (howvrepl)[⍳59]←'-----------------------------------------------------------'
  (howvrepl)[59+⍳32]←'-------------------',(,⎕UCS 10 101 8592),'v vrepl a',(,⎕UCS 10)
  (howvrepl)[91+⍳56]←'replace in <v> single-character abbreviations defined in'
  (howvrepl)[147+⍳42]←' <a>',(,⎕UCS 10),'-------------------------------------'
  (howvrepl)[189+⍳43]←'-----------------------------------------',(,⎕UCS 10 10)
  (howvrepl)[232+⍳29]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'  '
  (howvrepl)[261+⍳55]←' <vrepl> uses a table of single-character abbreviations'
  (howvrepl)[316+⍳42]←' and expands them',(,⎕UCS 10),'   wherever they appear '
  (howvrepl)[358+⍳48]←'within a character vector.  The table typically',(,⎕UCS 10)
  (howvrepl)[406+⍳55]←'   consists of commonly-appearing words, names, or phra'
  (howvrepl)[461+⍳42]←'ses.  <vrepl> is very',(,⎕UCS 10),'   useful for prepar'
  (howvrepl)[503+⍳27]←'ing text.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-----'
  (howvrepl)[530+⍳29]←'----',(,⎕UCS 10),'<v>   Character vector',(,⎕UCS 10),' '
  (howvrepl)[559+⍳40]←'  Text containing the abbreviations',(,⎕UCS 10 10),'<a>'
  (howvrepl)[599+⍳42]←'   Character matrix',(,⎕UCS 10),'   <a> is the abbrevia'
  (howvrepl)[641+⍳55]←'tion table.  The first column contains the abbreviation'
  (howvrepl)[696+⍳45]←(,⎕UCS 10),'   code.  The remaining columns in each row '
  (howvrepl)[741+⍳42]←'contain the corresponding',(,⎕UCS 10),'   expansion of '
  (howvrepl)[783+⍳26]←'the code.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (howvrepl)[809+⍳42]←'<e>   Character vector',(,⎕UCS 10),'   <e> is the vecto'
  (howvrepl)[851+⍳46]←'r <v> after abbreviations have been replaced.',(,⎕UCS 10)
  (howvrepl)[897+⍳19]←(,⎕UCS 10),'Notes:',(,⎕UCS 10),'-----',(,⎕UCS 10),'   Th'
  (howvrepl)[916+⍳55]←'e abbreviations must be characters which never appear o'
  (howvrepl)[971+⍳42]←'therwise, for',(,⎕UCS 10),'   they will be replaced reg'
  (howvrepl)[1013+⍳39]←'ardless of context.',(,⎕UCS 10 10),'   Refer to the li'
  (howvrepl)[1052+⍳54]←'ne in the function that determines the length of the s'
  (howvrepl)[1106+⍳41]←'tring',(,⎕UCS 10),'   to replace each code.  Since it '
  (howvrepl)[1147+⍳38]←'compares against the ''fill value'' (1',(,⎕UCS 8593 48)
  (howvrepl)[1185+⍳35]←(,⎕UCS 9076 118 41 10),'   derived from the vector, thi'
  (howvrepl)[1220+⍳42]←'s process may also be used when entering',(,⎕UCS 10),' '
  (howvrepl)[1262+⍳54]←'  numeric data, with single-number (not necessarily si'
  (howvrepl)[1316+⍳41]←'ngle-digit) codes',(,⎕UCS 10),'   representing numeric'
  (howvrepl)[1357+⍳53]←' vectors.  Since it searches for non-fill values from'
  (howvrepl)[1410+⍳44]←(,⎕UCS 10),'   the end of the row, the inserted string '
  (howvrepl)[1454+⍳41]←'will not end with blank (or',(,⎕UCS 10),'   zero), alt'
  (howvrepl)[1495+⍳53]←'hough it may contain or begin with some.  The ''expans'
  (howvrepl)[1548+⍳40]←'ion'' may,',(,⎕UCS 10),'   for special purposes, even '
  (howvrepl)[1588+⍳30]←'be of length 1 or 0.',(,⎕UCS 10 10),'Source:',(,⎕UCS 10)
  (howvrepl)[1618+⍳41]←'------',(,⎕UCS 10),'   Algorithm 148 - Expansion of Si'
  (howvrepl)[1659+⍳41]←'ngle-Character Abbreviations (APL Quote',(,⎕UCS 10),' '
  (howvrepl)[1700+⍳54]←'  Quad, 11, 2, December 1980), K.  H.  Glatting and G.'
  (howvrepl)[1754+⍳26]←'  Osterburg.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--'
  (howvrepl)[1780+⍳21]←'------',(,⎕UCS 10),'      ',(,⎕UCS 9109 8592),'codes',(,⎕UCS 10)
  (howvrepl)[1801+⍳41]←'Ddear sir;',(,⎕UCS 10),'I     in reply to your letter '
  (howvrepl)[1842+⍳28]←'of',(,⎕UCS 10),'Wwe are shipping',(,⎕UCS 10),'Nwe cann'
  (howvrepl)[1870+⍳35]←'ot ship',(,⎕UCS 10),'Tthank you for your order.',(,⎕UCS 10)
  (howvrepl)[1905+⍳41]←'Rwe regret the inconvenience.',(,⎕UCS 10),'Yyours, the'
  (howvrepl)[1946+⍳26]←' XYZ company.',(,⎕UCS 10 10),'      text',(,⎕UCS 8592)
  (howvrepl)[1972+⍳46]←'''D I 13 august, W 3 manuals. T Y'' vrepl codes',(,⎕UCS 10)
  (howvrepl)[2018+⍳44]←(,⎕UCS 10),'... The derived text is long.  Fold it for '
  (howvrepl)[2062+⍳39]←'neat presentation.',(,⎕UCS 10),'      50 split text',(,⎕UCS 10)
  (howvrepl)[2101+⍳45]←'dear sir;      in reply to your letter of 13',(,⎕UCS 10)
  (howvrepl)[2146+⍳50]←' august, we are shipping 3 manuals. thank you for',(,⎕UCS 10)
  (howvrepl)[2196+⍳37]←' your order. yours, the XYZ company.',(,⎕UCS 10)

howvtype←1502⍴0 ⍝ prolog ≡1
  (howvtype)[⍳59]←'-----------------------------------------------------------'
  (howvtype)[59+⍳30]←'-------------------',(,⎕UCS 10 114 8592),'vtype x',(,⎕UCS 10)
  (howvtype)[89+⍳54]←'return <r> = ''type'' of variable <x> (logical,character'
  (howvtype)[143+⍳42]←',integer,real)',(,⎕UCS 10),'---------------------------'
  (howvtype)[185+⍳52]←'---------------------------------------------------',(,⎕UCS 10)
  (howvtype)[237+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howvtype)[265+⍳55]←'   <vtype> is a system-dependent function that determin'
  (howvtype)[320+⍳40]←'es the ''type'' of the',(,⎕UCS 10),'   data given in th'
  (howvtype)[360+⍳38]←'e argument <x>.',(,⎕UCS 10 10),'   ''Type'' is an imple'
  (howvtype)[398+⍳55]←'mentation concept and the function considers four types'
  (howvtype)[453+⍳41]←':',(,⎕UCS 10),'   logical (or boolean, that is, 1''s an'
  (howvtype)[494+⍳41]←'d 0''s only), character, integer, and',(,⎕UCS 10),'   r'
  (howvtype)[535+⍳55]←'eal.  <vtype> determines type by a size calculation bas'
  (howvtype)[590+⍳42]←'ed on the',(,⎕UCS 10),'   assumption that the APL syste'
  (howvtype)[632+⍳44]←'m stores boolean data using one byte ( = 8',(,⎕UCS 10),' '
  (howvtype)[676+⍳55]←'  bits) for each 8 elements, character data using 1 byt'
  (howvtype)[731+⍳42]←'e per character, and',(,⎕UCS 10),'   integer and real d'
  (howvtype)[773+⍳51]←'ata using 4 and 8 bytes, respectively, per number.',(,⎕UCS 10)
  (howvtype)[824+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howvtype)[846+⍳40]←'<x>   Numeric or character array',(,⎕UCS 10 10),'Result'
  (howvtype)[886+⍳29]←':',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   Numeric scalar'
  (howvtype)[915+⍳45]←(,⎕UCS 10),'   <r> reports the type of the variable <x> '
  (howvtype)[960+⍳42]←'according to the following table:',(,⎕UCS 10),'        '
  (howvtype)[1002+⍳36]←'1 -- boolean',(,⎕UCS 10),'        2 -- character',(,⎕UCS 10)
  (howvtype)[1038+⍳39]←'        3 -- integer',(,⎕UCS 10),'        4 -- real',(,⎕UCS 10)
  (howvtype)[1077+⍳21]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'.'
  (howvtype)[1098+⍳54]←'..<vtype> may well return different results on differe'
  (howvtype)[1152+⍳41]←'nt APL systems.',(,⎕UCS 10),'      vtype 2 = 1 2 3 4 5'
  (howvtype)[1193+⍳35]←(,⎕UCS 10 49 10),'      vtype ''this is character''',(,⎕UCS 10)
  (howvtype)[1228+⍳26]←(,⎕UCS 50 10),'      vtype 10 20 30',(,⎕UCS 10 51 10),' '
  (howvtype)[1254+⍳35]←'     vtype 1.1 14.5',(,⎕UCS 10 52 10 10),'...<vtype> n'
  (howvtype)[1289+⍳46]←'eeds only part of the data to determine type.',(,⎕UCS 10)
  (howvtype)[1335+⍳22]←'      vtype 2',(,⎕UCS 8593),'100',(,⎕UCS 9076),'5.6',(,⎕UCS 10)
  (howvtype)[1357+⍳39]←(,⎕UCS 52 10 10),'...Note that data consisting of 1''s '
  (howvtype)[1396+⍳40]←'and 0''s may be held as integer if the',(,⎕UCS 10),'..'
  (howvtype)[1436+⍳43]←'.data results from arithmetic operations.',(,⎕UCS 10),' '
  (howvtype)[1479+⍳23]←'     vtype 1 0 + 0 0',(,⎕UCS 10 51 10)

howwildcard←2243⍴0 ⍝ prolog ≡1
  (howwildcard)[⍳56]←'--------------------------------------------------------'
  (howwildcard)[56+⍳34]←'----------------------',(,⎕UCS 10 98 8592),'m wildcar'
  (howwildcard)[90+⍳39]←'d s',(,⎕UCS 10),'select names in matrix <m> using ''w'
  (howwildcard)[129+⍳38]←'ildcard'' search specification <s>',(,⎕UCS 10),'----'
  (howwildcard)[167+⍳52]←'----------------------------------------------------'
  (howwildcard)[219+⍳37]←'----------------------',(,⎕UCS 10 10),'Introduction:'
  (howwildcard)[256+⍳29]←(,⎕UCS 10),'------------',(,⎕UCS 10),'   <wildcard> u'
  (howwildcard)[285+⍳52]←'ses a search specification to select names from a ma'
  (howwildcard)[337+⍳39]←'trix of',(,⎕UCS 10),'   names.  The search specifica'
  (howwildcard)[376+⍳39]←'tion is based on a ''wildcard'' type of',(,⎕UCS 10),' '
  (howwildcard)[415+⍳35]←'  selection, for example, ''f',(,⎕UCS 8902),''' sele'
  (howwildcard)[450+⍳35]←'cts all names starting with ''f''.',(,⎕UCS 10 10),'A'
  (howwildcard)[485+⍳26]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<m>   '
  (howwildcard)[511+⍳39]←'Character matrix',(,⎕UCS 10),'   A left-justified ma'
  (howwildcard)[550+⍳52]←'trix of names.  A name can be a sequence with embedd'
  (howwildcard)[602+⍳39]←'ed',(,⎕UCS 10),'   blanks; however, the function is '
  (howwildcard)[641+⍳39]←'typically used with one name per row,',(,⎕UCS 10),' '
  (howwildcard)[680+⍳52]←'  that is, one non-blank sequence (no embedded blank'
  (howwildcard)[732+⍳37]←'s) per row.',(,⎕UCS 10 10),'<s>   Character vector o'
  (howwildcard)[769+⍳39]←'r scalar',(,⎕UCS 10),'   <s> represents one search s'
  (howwildcard)[808+⍳48]←'pecification (no blanks).  Valid specifications',(,⎕UCS 10)
  (howwildcard)[856+⍳52]←'   are listed in the table below.  x and y represent'
  (howwildcard)[908+⍳39]←' any non-blank sequence',(,⎕UCS 10),'   of one or mo'
  (howwildcard)[947+⍳37]←'re characters.',(,⎕UCS 10 10),'   x     Select exact'
  (howwildcard)[984+⍳24]←' match on x.',(,⎕UCS 10),'   x',(,⎕UCS 8902),'    Se'
  (howwildcard)[1008+⍳41]←'lect names starting with the sequence x.',(,⎕UCS 10)
  (howwildcard)[1049+⍳36]←'   ',(,⎕UCS 8902),'x    Select names ending with th'
  (howwildcard)[1085+⍳23]←'e sequence x.',(,⎕UCS 10),'   x',(,⎕UCS 8902),'y   '
  (howwildcard)[1108+⍳48]←'Select names starting with x and ending with y.',(,⎕UCS 10)
  (howwildcard)[1156+⍳29]←'   ',(,⎕UCS 8902 120 8902),'   Select names contain'
  (howwildcard)[1185+⍳25]←'ing the sequence x.',(,⎕UCS 10),'   ',(,⎕UCS 8902),' '
  (howwildcard)[1210+⍳36]←'    Select all names.',(,⎕UCS 10 10),'   In summary'
  (howwildcard)[1246+⍳34]←', ''',(,⎕UCS 8902),''' matches an arbitrary sequenc'
  (howwildcard)[1280+⍳38]←'e of any length, including 0.',(,⎕UCS 10),'   Also,'
  (howwildcard)[1318+⍳49]←' the special character ''?'' is permitted within <x'
  (howwildcard)[1367+⍳38]←'> or <y>, and has',(,⎕UCS 10),'   the significance '
  (howwildcard)[1405+⍳44]←'of matching any single non-blank character.',(,⎕UCS 10)
  (howwildcard)[1449+⍳17]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<'
  (howwildcard)[1466+⍳38]←'y>   Numeric vector',(,⎕UCS 10),'   y[i]=1 -- m[i;]'
  (howwildcard)[1504+⍳38]←' is selected.',(,⎕UCS 10),'   y[i]=0 -- m[i;] is no'
  (howwildcard)[1542+⍳24]←'t selected.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'-'
  (howwildcard)[1566+⍳38]←'-------',(,⎕UCS 10),'... <m> is sorted to clarify t'
  (howwildcard)[1604+⍳45]←'hese examples.  ''Pre-sorting'' is not needed.',(,⎕UCS 10)
  (howwildcard)[1649+⍳18]←'      m',(,⎕UCS 8592),''''' ',(,⎕UCS 8710),'box ''a'
  (howwildcard)[1667+⍳51]←'nnie apple betty car cars cat cats cradle egg farm '
  (howwildcard)[1718+⍳28]←'flag''',(,⎕UCS 10),'... Select all names.',(,⎕UCS 10)
  (howwildcard)[1746+⍳31]←'      m wildcard ''',(,⎕UCS 8902 39 10),'1 1 1 1 1 '
  (howwildcard)[1777+⍳38]←'1 1 1 1 1 1',(,⎕UCS 10),'... Select exact match wit'
  (howwildcard)[1815+⍳31]←'h ''car''',(,⎕UCS 10),'      m wildcard ''car''',(,⎕UCS 10)
  (howwildcard)[1846+⍳38]←'0 0 0 1 0 0 0 0 0 0 0',(,⎕UCS 10),'... Select names'
  (howwildcard)[1884+⍳34]←' beginning with ''ca''',(,⎕UCS 10),'      ,'' '',(m'
  (howwildcard)[1918+⍳22]←' wildcard ''ca',(,⎕UCS 8902 39 41 9023 109 10),' ca'
  (howwildcard)[1940+⍳38]←'r    cars   cat    cats',(,⎕UCS 10),'... Select nam'
  (howwildcard)[1978+⍳47]←'es starting with ''c'' and containing ''r'' in the '
  (howwildcard)[2025+⍳36]←'third position.',(,⎕UCS 10),'      ,'' '',(m wildca'
  (howwildcard)[2061+⍳22]←'rd ''c?r',(,⎕UCS 8902 39 41 9023 109 10),' car    c'
  (howwildcard)[2083+⍳35]←'ars',(,⎕UCS 10),'... Select names ending in ''e''',(,⎕UCS 10)
  (howwildcard)[2118+⍳29]←'      ,'' '',(m wildcard ''',(,⎕UCS 8902),'e'')',(,⎕UCS 9023)
  (howwildcard)[2147+⍳25]←(,⎕UCS 109 10),' annie  apple  cradle',(,⎕UCS 10),'.'
  (howwildcard)[2172+⍳36]←'.. Anything ending in ''g''?',(,⎕UCS 10),'      m w'
  (howwildcard)[2208+⍳28]←'ildcard ''',(,⎕UCS 8902 103 39 10),'0 0 0 0 0 0 0 0'
  (howwildcard)[2236+⍳7]←' 1 0 1',(,⎕UCS 10)

howxfade←2943⍴0 ⍝ prolog ≡1
  (howxfade)[⍳59]←'-----------------------------------------------------------'
  (howxfade)[59+⍳32]←'-------------------',(,⎕UCS 10 114 8592),'s xfade c',(,⎕UCS 10)
  (howxfade)[91+⍳54]←'transform text in <c> using a ''fading'' algorithm contr'
  (howxfade)[145+⍳42]←'olled by <s>',(,⎕UCS 10),'-----------------------------'
  (howxfade)[187+⍳50]←'-------------------------------------------------',(,⎕UCS 10)
  (howxfade)[237+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (howxfade)[265+⍳55]←'   The algorithm of <xfade> transforms the letters of o'
  (howxfade)[320+⍳42]←'ne text into the',(,⎕UCS 10),'   letters of a second te'
  (howxfade)[362+⍳45]←'xt.  The letters of the first text gradually',(,⎕UCS 10)
  (howxfade)[407+⍳53]←'   disappear (or ''fade away'') while the letters of th'
  (howxfade)[460+⍳40]←'e second text gradually',(,⎕UCS 10),'   ''fade in'', ev'
  (howxfade)[500+⍳47]←'entually to completely replace the first text.',(,⎕UCS 10)
  (howxfade)[547+⍳22]←(,⎕UCS 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (howxfade)[569+⍳42]←'<s>   2-element numeric vector',(,⎕UCS 10),'   s[1] = N'
  (howxfade)[611+⍳42]←'umber of rows in result',(,⎕UCS 10),'   s[2] = Number o'
  (howxfade)[653+⍳40]←'f columns in result',(,⎕UCS 10 10),'<c>   Character vec'
  (howxfade)[693+⍳42]←'tor',(,⎕UCS 10),'   The syntax to specify the two text '
  (howxfade)[735+⍳42]←'phrases is:  /first text/second text',(,⎕UCS 10),'   c['
  (howxfade)[777+⍳43]←'1] is treated as the delimiter character.',(,⎕UCS 10 10)
  (howxfade)[820+⍳29]←'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   Characte'
  (howxfade)[849+⍳42]←'r matrix',(,⎕UCS 10),'   The matrix represents the firs'
  (howxfade)[891+⍳45]←'t text gradually fading into the second text',(,⎕UCS 10)
  (howxfade)[936+⍳55]←'   from the first row to the last row.  The greater the'
  (howxfade)[991+⍳42]←' value of s[1], that',(,⎕UCS 10),'   is, the more rows,'
  (howxfade)[1033+⍳51]←' the more gradually the fading effect takes place.',(,⎕UCS 10)
  (howxfade)[1084+⍳18]←(,⎕UCS 10),'Source:',(,⎕UCS 10),'------',(,⎕UCS 10),'  '
  (howxfade)[1102+⍳53]←' Phil Last (David Saunder''s competition, UK APLUG New'
  (howxfade)[1155+⍳31]←'sletter, June 1982)',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (howxfade)[1186+⍳40]←'--------',(,⎕UCS 10),'      6 40 xfade ''/Welcome to t'
  (howxfade)[1226+⍳40]←'his meeting of /The APL SIG ''',(,⎕UCS 10),'Welcome to'
  (howxfade)[1266+⍳41]←' this me ting of Welcome to t',(,⎕UCS 10),'W l ome t  '
  (howxfade)[1307+⍳41]←'this me t         lco    o t',(,⎕UCS 10),' el A   S   '
  (howxfade)[1348+⍳41]←'hi    e S    f WAl  mI to t',(,⎕UCS 10),'T   omL S    '
  (howxfade)[1389+⍳41]←'i  APL SI  oh  A   S G  h',(,⎕UCS 10),' he A   SIG  he'
  (howxfade)[1430+⍳41]←' APe   G  h  AP  SI',(,⎕UCS 10),'The APL SIG The APL S'
  (howxfade)[1471+⍳38]←'IG The A L SIG The',(,⎕UCS 10 10),'      5 70 xfade '''
  (howxfade)[1509+⍳40]←'/son /moon ''',(,⎕UCS 10),'son son son son son s n son'
  (howxfade)[1549+⍳44]←' son son son s n son s n son  on son son so',(,⎕UCS 10)
  (howxfade)[1593+⍳54]←'son     so oson s n so  son      n  so      s n s     '
  (howxfade)[1647+⍳41]←'n so    n s n so',(,⎕UCS 10),'s   s     n so  son   nn'
  (howxfade)[1688+⍳42]←'  n     so         ns        o    n m  n',(,⎕UCS 10),' '
  (howxfade)[1730+⍳54]←'o n moon m on m  n mo n m      o   oon   o  m      oo '
  (howxfade)[1784+⍳41]←'m     o   m',(,⎕UCS 10),'moon moon moon moon moon moon'
  (howxfade)[1825+⍳42]←' moon moon mo n moon moon mo   moon m on',(,⎕UCS 10 10)
  (howxfade)[1867+⍳39]←'      15 70 xfade ''/son /moon ''',(,⎕UCS 10),'son son'
  (howxfade)[1906+⍳54]←' son son son son son son son son son son son son son s'
  (howxfade)[1960+⍳41]←'on son so',(,⎕UCS 10),'son son son son son son son son'
  (howxfade)[2001+⍳41]←' son so  son son son son so  son so   o',(,⎕UCS 10),'s'
  (howxfade)[2042+⍳54]←'on so  son son son son son son s n son son son  on  o '
  (howxfade)[2096+⍳41]←' so  son sonoso',(,⎕UCS 10),'s n so  so  s nmson   n s'
  (howxfade)[2137+⍳45]←' n so  s n  o  son so  so   on s   s n so  s',(,⎕UCS 10)
  (howxfade)[2182+⍳54]←'mo  so  s     n   n son  o  son     s n s   son s n so'
  (howxfade)[2236+⍳41]←'   o  son  on',(,⎕UCS 10),'     o      s n   n  o    n'
  (howxfade)[2277+⍳41]←'  on  o   o  so    n  on s       s   s',(,⎕UCS 10),'  '
  (howxfade)[2318+⍳54]←' n on n n so  so    n so      so       o  s         n '
  (howxfade)[2372+⍳41]←'o    on s    o',(,⎕UCS 10),'     o    no   mson m     '
  (howxfade)[2413+⍳42]←'  som    m on     s n  o osn           m',(,⎕UCS 10),' '
  (howxfade)[2455+⍳54]←' n s o     s     n m nn   on  o o m on s    o    n   n'
  (howxfade)[2509+⍳41]←'   n  oo  mo s',(,⎕UCS 10),'   n moos  o n  o        o'
  (howxfade)[2550+⍳44]←'      oo moon moon m    m o  m on    n   o',(,⎕UCS 10),'m'
  (howxfade)[2594+⍳54]←'oon  n n m  n   on      m on mo   m  n   on  o n  ooo '
  (howxfade)[2648+⍳41]←'mo n        on',(,⎕UCS 10),'mo n  o   moon  oon mo n m'
  (howxfade)[2689+⍳44]←'o n moon moo  s o    on moon moo   o   m  n',(,⎕UCS 10)
  (howxfade)[2733+⍳54]←'moo  mo n moon moo  moon moon moon  oo  m o    on moon'
  (howxfade)[2787+⍳41]←'  o n  oon moon',(,⎕UCS 10),'moon mo n moon mo n moon '
  (howxfade)[2828+⍳45]←'moon moon  oon moon moon moon moon moon m on',(,⎕UCS 10)
  (howxfade)[2873+⍳54]←'moon moon moon moon moon moon moon moon moon moon moon'
  (howxfade)[2927+⍳16]←' moon moon moon',(,⎕UCS 10)

how∆←1492⍴0 ⍝ prolog ≡1
  (how∆)[⍳63]←'---------------------------------------------------------------'
  (how∆)[63+⍳25]←'---------------',(,⎕UCS 10 121 8592 108 32 8710 32 114 10),'g'
  (how∆)[88+⍳47]←'lue function. return left argument <l>',(,⎕UCS 10),'--------'
  (how∆)[135+⍳59]←'-----------------------------------------------------------'
  (how∆)[194+⍳31]←'-----------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'----'
  (how∆)[225+⍳46]←'--------',(,⎕UCS 10),'   There is no straightforward facili'
  (how∆)[271+⍳46]←'ty in standard APL of combining two or',(,⎕UCS 10),'   more'
  (how∆)[317+⍳59]←' separate APL statements on one line, although there are se'
  (how∆)[376+⍳39]←'veral',(,⎕UCS 10),'   common workarounds (such as a',(,⎕UCS 8592)
  (how∆)[415+⍳21]←'10,0',(,⎕UCS 9076 98 8592),'20).',(,⎕UCS 10 10),'   The <'
  (how∆)[436+⍳45]←(,⎕UCS 8710),'> function is a fairly ''clean'' way of doing '
  (how∆)[481+⍳46]←'this in standard APL.',(,⎕UCS 10),'   The function returns '
  (how∆)[527+⍳52]←'its left argument.  This has the effect of ignoring',(,⎕UCS 10)
  (how∆)[579+⍳59]←'   in the rest of the statement whatever result was compute'
  (how∆)[638+⍳46]←'d by that part of',(,⎕UCS 10),'   the APL statement to the '
  (how∆)[684+⍳44]←'right of the function.',(,⎕UCS 10 10),'   The examples show'
  (how∆)[728+⍳44]←' some applications where the use of <',(,⎕UCS 8710),'> is w'
  (how∆)[772+⍳46]←'ell-accepted.',(,⎕UCS 10),'   But note that some programmer'
  (how∆)[818+⍳46]←'s avoid using this technique, because the',(,⎕UCS 10),'   t'
  (how∆)[864+⍳44]←'echnique may lead to unreadable programs.',(,⎕UCS 10 10),'A'
  (how∆)[908+⍳32]←'rguments:',(,⎕UCS 10),'---------',(,⎕UCS 10),'<l>   Array',(,⎕UCS 10)
  (how∆)[940+⍳23]←(,⎕UCS 10),'<n>   Array',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'-'
  (how∆)[963+⍳33]←'-----',(,⎕UCS 10),'<y>   Array',(,⎕UCS 10),'   The result <'
  (how∆)[996+⍳35]←'y> is the argument <l>.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (how∆)[1031+⍳22]←'--------',(,⎕UCS 10),'      a',(,⎕UCS 8592),'101 ',(,⎕UCS 8710)
  (how∆)[1053+⍳15]←(,⎕UCS 32 98 8592),'202 ',(,⎕UCS 8710 32 99 8592),'303',(,⎕UCS 10)
  (how∆)[1068+⍳30]←'      a,b,c',(,⎕UCS 10),'101 202 303',(,⎕UCS 10 10),'...Re'
  (how∆)[1098+⍳43]←'member that <',(,⎕UCS 8710),'> is simply a defined functio'
  (how∆)[1141+⍳45]←'n, and that APL order of',(,⎕UCS 10),'...execution is pres'
  (how∆)[1186+⍳57]←'erved.  The example above is equivalent to the following',(,⎕UCS 10)
  (how∆)[1243+⍳45]←'...three statements in the order given.',(,⎕UCS 10),'     '
  (how∆)[1288+⍳16]←' c',(,⎕UCS 8592),'303',(,⎕UCS 10),'      b',(,⎕UCS 8592),'2'
  (how∆)[1304+⍳17]←'02',(,⎕UCS 10),'      a',(,⎕UCS 8592),'101',(,⎕UCS 10 10),'.'
  (how∆)[1321+⍳58]←'..display a message and exit the function  (result not sho'
  (how∆)[1379+⍳16]←'wn)',(,⎕UCS 10),'      ',(,⎕UCS 8594 48 32 8710 32 9109)
  (how∆)[1395+⍳29]←(,⎕UCS 8592),'''error message''',(,⎕UCS 10 10),'...Put a co'
  (how∆)[1424+⍳35]←'mment at the end of a line',(,⎕UCS 10),'      a',(,⎕UCS 8592)
  (how∆)[1459+⍳33]←'10 ',(,⎕UCS 8710),' ''define order of magnitude''',(,⎕UCS 10)

how∆box←2087⍴0 ⍝ prolog ≡1
  (how∆box)[⍳60]←'------------------------------------------------------------'
  (how∆box)[60+⍳28]←'------------------',(,⎕UCS 10 121 8592),'chars ',(,⎕UCS 8710)
  (how∆box)[88+⍳42]←'box x',(,⎕UCS 10),'''box'' vector <x> using separator and'
  (how∆box)[130+⍳43]←' fill character <chars>',(,⎕UCS 10),'-------------------'
  (how∆box)[173+⍳56]←'--------------------------------------------------------'
  (how∆box)[229+⍳28]←'---',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'---------'
  (how∆box)[257+⍳28]←'---',(,⎕UCS 10),'   <',(,⎕UCS 8710),'box> returns the ma'
  (how∆box)[285+⍳46]←'trix corresponding to a vector <x> logically',(,⎕UCS 10),' '
  (how∆box)[331+⍳54]←'  delimited into fields by a ''separater'' value.  The f'
  (how∆box)[385+⍳43]←'unction accepts',(,⎕UCS 10),'   numeric or character arg'
  (how∆box)[428+⍳26]←'uments.',(,⎕UCS 10 10),'   <',(,⎕UCS 8710),'box> is well'
  (how∆box)[454+⍳55]←'-known and very useful.  It mimics the ''non-ISO-standar'
  (how∆box)[509+⍳27]←'d''',(,⎕UCS 10),'   ',(,⎕UCS 9109),'box system function '
  (how∆box)[536+⍳41]←'found in some versions of APL.  ',(,⎕UCS 8710),'box is o'
  (how∆box)[577+⍳43]←'ften used',(,⎕UCS 10),'   in conjunction with its invers'
  (how∆box)[620+⍳32]←'e function <unbox>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (how∆box)[652+⍳43]←'---------',(,⎕UCS 10),'<chars>   Numeric or character ve'
  (how∆box)[695+⍳43]←'ctor',(,⎕UCS 10),'   chars[1] -- Separater character (or'
  (how∆box)[738+⍳43]←' number) appearing in the argument <x>',(,⎕UCS 10),'   c'
  (how∆box)[781+⍳56]←'hars[2] -- Fill character (or number) to be used to pad '
  (how∆box)[837+⍳43]←'irregular rows',(,⎕UCS 10),'   If chars is empty or a sc'
  (how∆box)[880+⍳44]←'alar or one-element array, it defaults to 2',(,⎕UCS 8593)
  (how∆box)[924+⍳41]←'chars.',(,⎕UCS 10 10),'<x>   Numeric or character vector'
  (how∆box)[965+⍳44]←(,⎕UCS 10 10),'<chars> and <x> must be both character or '
  (how∆box)[1009+⍳27]←'both numeric.',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'----'
  (how∆box)[1036+⍳29]←'--',(,⎕UCS 10),'<x>   matrix',(,⎕UCS 10),'   The result'
  (how∆box)[1065+⍳53]←' is the matrix produced by taking each logical ''field'
  (how∆box)[1118+⍳41]←''' of <x> to',(,⎕UCS 10),'   be a row of <y>.  Irregula'
  (how∆box)[1159+⍳43]←'r rows are padded with the fill element.',(,⎕UCS 10 10),'E'
  (how∆box)[1202+⍳27]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'      ''/'''
  (how∆box)[1229+⍳25]←' ',(,⎕UCS 8710),'box ''apple/betty/cat''',(,⎕UCS 10),'a'
  (how∆box)[1254+⍳16]←'pple',(,⎕UCS 10),'betty',(,⎕UCS 10),'cat',(,⎕UCS 10),' '
  (how∆box)[1270+⍳30]←'     ''/',(,⎕UCS 8902 39 32 8710),'box ''apple//betty/c'
  (how∆box)[1300+⍳14]←'at''',(,⎕UCS 10),'apple',(,⎕UCS 10 8902 8902 8902 8902)
  (how∆box)[1314+⍳13]←(,⎕UCS 8902 10),'betty',(,⎕UCS 10),'cat',(,⎕UCS 8902 8902)
  (how∆box)[1327+⍳42]←(,⎕UCS 10 10),'...Note that the right argument has a ''c'
  (how∆box)[1369+⍳41]←'anonical'' form, namely, a separater',(,⎕UCS 10),'...at'
  (how∆box)[1410+⍳53]←' the end of each field.  This means that ''dog/cat'' pr'
  (how∆box)[1463+⍳39]←'oduces the same',(,⎕UCS 10),'...result as ''dog/cat/'''
  (how∆box)[1502+⍳26]←(,⎕UCS 10),'      (''/'' ',(,⎕UCS 8710),'box ''dog/cat'''
  (how∆box)[1528+⍳28]←'),'' '',(''/'' ',(,⎕UCS 8710),'box ''dog/cat/'')',(,⎕UCS 10)
  (how∆box)[1556+⍳27]←'dog dog',(,⎕UCS 10),'cat cat',(,⎕UCS 10 10),'... unbox '
  (how∆box)[1583+⍳40]←'is the inverse of ',(,⎕UCS 8710),'box.  (Note the final'
  (how∆box)[1623+⍳40]←' separater in the result.)',(,⎕UCS 10),'      ''/'' unb'
  (how∆box)[1663+⍳30]←'ox ''/'' ',(,⎕UCS 8710),'box ''apple/betty/cat''',(,⎕UCS 10)
  (how∆box)[1693+⍳31]←'apple/betty/cat/',(,⎕UCS 10 10),'      0 999 ',(,⎕UCS 8710)
  (how∆box)[1724+⍳42]←'box 1 2 3 0 10 20 30 40 50',(,⎕UCS 10),'  1   2   3 999'
  (how∆box)[1766+⍳27]←' 999',(,⎕UCS 10),' 10  20  30  40  50',(,⎕UCS 10 10),'P'
  (how∆box)[1793+⍳36]←'rogramming Notes:',(,⎕UCS 10),'-----------------',(,⎕UCS 10)
  (how∆box)[1829+⍳55]←'   The fill character is specified in the left argument'
  (how∆box)[1884+⍳42]←' rather than as the',(,⎕UCS 10),'   first character of '
  (how∆box)[1926+⍳52]←'the right argument because (1) vectors separated by',(,⎕UCS 10)
  (how∆box)[1978+⍳55]←'   the return character display nicely and (2) the fill'
  (how∆box)[2033+⍳42]←' character is also',(,⎕UCS 10),'   specified in the lef'
  (how∆box)[2075+⍳12]←'t argument.',(,⎕UCS 10)

how∆centh←2715⍴0 ⍝ prolog ≡1
  (how∆centh)[⍳58]←'----------------------------------------------------------'
  (how∆centh)[58+⍳28]←'--------------------',(,⎕UCS 10 121 8592),'fld ',(,⎕UCS 8710)
  (how∆centh)[86+⍳42]←'centh label',(,⎕UCS 10),'centre column headings <label>'
  (how∆centh)[128+⍳41]←' within fields specified by <fld>',(,⎕UCS 10),'-------'
  (how∆centh)[169+⍳54]←'------------------------------------------------------'
  (how∆centh)[223+⍳33]←'-----------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (how∆centh)[256+⍳41]←'------------',(,⎕UCS 10),'   When doing reports, align'
  (how∆centh)[297+⍳46]←'ing the column headings over the columns in a',(,⎕UCS 10)
  (how∆centh)[343+⍳54]←'   suitable manner can be a tedious undertaking.  With'
  (how∆centh)[397+⍳41]←'out a utility function',(,⎕UCS 10),'   we can only att'
  (how∆centh)[438+⍳51]←'empt a lot of careful counting or trial and error.',(,⎕UCS 10)
  (how∆centh)[489+⍳39]←'   <',(,⎕UCS 8710),'centh> provides a systematic techn'
  (how∆centh)[528+⍳39]←'ique for this task.',(,⎕UCS 10 10),'   A companion fun'
  (how∆centh)[567+⍳39]←'ction for this function is <',(,⎕UCS 8710),'centt> (ce'
  (how∆centh)[606+⍳33]←'ntre report titles).',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (how∆centh)[639+⍳34]←'---------',(,⎕UCS 10),'<fld>   Numeric vector.',(,⎕UCS 10)
  (how∆centh)[673+⍳54]←'   This argument controls the spacing of each column h'
  (how∆centh)[727+⍳41]←'eading.  In general, a',(,⎕UCS 10),'   triplet of numb'
  (how∆centh)[768+⍳54]←'ers is used to control each column heading.  The first'
  (how∆centh)[822+⍳44]←(,⎕UCS 10),'   determines the total width of a heading '
  (how∆centh)[866+⍳41]←'field.  The second controls the',(,⎕UCS 10),'   positi'
  (how∆centh)[907+⍳54]←'on of the text within the field, using the values 1=le'
  (how∆centh)[961+⍳31]←'ft-justify,',(,⎕UCS 10),'   0=centred, and ',(,⎕UCS 175)
  (how∆centh)[992+⍳54]←'1=right-justify.  The third specifies the inter-column'
  (how∆centh)[1046+⍳28]←(,⎕UCS 10),'   (I-C) spacing.',(,⎕UCS 10 10),'   For e'
  (how∆centh)[1074+⍳53]←'xample, the specification 10 0 1 15 1 0 means to cent'
  (how∆centh)[1127+⍳40]←'re the first',(,⎕UCS 10),'   heading in a field of 10'
  (how∆centh)[1167+⍳47]←' spaces, insert 1 space, then left-justify the',(,⎕UCS 10)
  (how∆centh)[1214+⍳53]←'   second heading in a field of 15 spaces.  The last '
  (how∆centh)[1267+⍳40]←'inter-column space',(,⎕UCS 10),'   specification has '
  (how∆centh)[1307+⍳41]←'no meaning and is therefore never used.',(,⎕UCS 10 10)
  (how∆centh)[1348+⍳53]←'   It is not necessary to specify 3 numbers for each '
  (how∆centh)[1401+⍳40]←'column heading.  Let',(,⎕UCS 10),'   n=the number of '
  (how∆centh)[1441+⍳53]←'column headings.  The permissible dimensions for <fld'
  (how∆centh)[1494+⍳25]←'>',(,⎕UCS 10),'   are as follows:',(,⎕UCS 10 10),'   '
  (how∆centh)[1519+⍳53]←'1 number:     (width).  Extends to n triplets of the '
  (how∆centh)[1572+⍳40]←'form (width, 0 1),i.e.',(,⎕UCS 10),'                 '
  (how∆centh)[1612+⍳50]←'each centred (0), with space between each column.',(,⎕UCS 10)
  (how∆centh)[1662+⍳53]←'   3 numbers:    (width, position, inter-column space'
  (how∆centh)[1715+⍳40]←').  Extends to n triplets',(,⎕UCS 10),'              '
  (how∆centh)[1755+⍳40]←'   each with the same specification.',(,⎕UCS 10),'   '
  (how∆centh)[1795+⍳39]←'n',(,⎕UCS 215),'3 numbers:  n triplets of (width, pos'
  (how∆centh)[1834+⍳40]←'ition, inter-column spacing) to',(,⎕UCS 10),'        '
  (how∆centh)[1874+⍳38]←'         control each of n headings',(,⎕UCS 10 10),'<'
  (how∆centh)[1912+⍳40]←'label>   Text vector.',(,⎕UCS 10),'   Text vector of '
  (how∆centh)[1952+⍳53]←'column headings.  The first character is considered t'
  (how∆centh)[2005+⍳40]←'he',(,⎕UCS 10),'   delimiter.  Example: /name/sales/t'
  (how∆centh)[2045+⍳25]←'otal/percent',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'---'
  (how∆centh)[2070+⍳27]←'---',(,⎕UCS 10),'<y>   Text vector.',(,⎕UCS 10),'   V'
  (how∆centh)[2097+⍳52]←'ector with column headings positioned as specified.',(,⎕UCS 10)
  (how∆centh)[2149+⍳20]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (how∆centh)[2169+⍳53]←'...Put each header in a field of 10 spaces (all centr'
  (how∆centh)[2222+⍳36]←'ed, 1 inter-column space)',(,⎕UCS 10),'      10 ',(,⎕UCS 8710)
  (how∆centh)[2258+⍳37]←'centh labels',(,⎕UCS 8592),'''/name/sales/total/perce'
  (how∆centh)[2295+⍳39]←'nt''',(,⎕UCS 10),'   name      sales      total     p'
  (how∆centh)[2334+⍳38]←'ercent',(,⎕UCS 10 10),'...Now each field is 15 spaces'
  (how∆centh)[2372+⍳41]←', left-justified, 2 inter-column spaces',(,⎕UCS 10),'.'
  (how∆centh)[2413+⍳53]←'..Recall that the inter-column specification for the '
  (how∆centh)[2466+⍳38]←'final header is ignored.',(,⎕UCS 10),'      15 1 2 '
  (how∆centh)[2504+⍳28]←(,⎕UCS 8710),'centh labels',(,⎕UCS 10),'name          '
  (how∆centh)[2532+⍳45]←'   sales            total            percent',(,⎕UCS 10)
  (how∆centh)[2577+⍳36]←(,⎕UCS 10),'...Now each field is as specified:',(,⎕UCS 10)
  (how∆centh)[2613+⍳32]←'      15 1 2 10 0 2 10 ',(,⎕UCS 175),'1 2 10 ',(,⎕UCS 175)
  (how∆centh)[2645+⍳25]←'1 0 ',(,⎕UCS 8710),'centh labels',(,⎕UCS 10),'name   '
  (how∆centh)[2670+⍳45]←'            sales          total     percent',(,⎕UCS 10)

how∆centt←1805⍴0 ⍝ prolog ≡1
  (how∆centt)[⍳58]←'----------------------------------------------------------'
  (how∆centt)[58+⍳27]←'--------------------',(,⎕UCS 10 121 8592 119 32 8710),'c'
  (how∆centt)[85+⍳42]←'entt text',(,⎕UCS 10),'centre <text> with left, middle,'
  (how∆centt)[127+⍳41]←' and right phrases in <w> spaces',(,⎕UCS 10),'--------'
  (how∆centt)[168+⍳54]←'------------------------------------------------------'
  (how∆centt)[222+⍳32]←'----------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (how∆centt)[254+⍳41]←'------------',(,⎕UCS 10),'   When doing reports, this '
  (how∆centt)[295+⍳43]←'function provides a convenient method for',(,⎕UCS 10),' '
  (how∆centt)[338+⍳39]←'  formatting neat report titles.',(,⎕UCS 10 10),'   Up'
  (how∆centt)[377+⍳54]←' to three text fields can be specified.  The programme'
  (how∆centt)[431+⍳41]←'r has complete',(,⎕UCS 10),'   flexibility to specify '
  (how∆centt)[472+⍳44]←'whatever text is required; for example, the',(,⎕UCS 10)
  (how∆centt)[516+⍳54]←'   centred phrase can be the title of the report, the '
  (how∆centt)[570+⍳41]←'left and right fields',(,⎕UCS 10),'   (phrases) can be'
  (how∆centt)[611+⍳39]←' the page, date, time, etc.',(,⎕UCS 10 10),'Arguments:'
  (how∆centt)[650+⍳31]←(,⎕UCS 10),'---------',(,⎕UCS 10),'<w>   1-element nume'
  (how∆centt)[681+⍳41]←'ric vector, or scalar',(,⎕UCS 10),'   Width of result '
  (how∆centt)[722+⍳37]←'in characters.',(,⎕UCS 10 10),'<text>   Text vector',(,⎕UCS 10)
  (how∆centt)[759+⍳54]←'   This vector contains the text for the left, middle,'
  (how∆centt)[813+⍳41]←' and right fields,',(,⎕UCS 10),'   where the first cha'
  (how∆centt)[854+⍳53]←'racter is the delimiter.  See examples.  A field can',(,⎕UCS 10)
  (how∆centt)[907+⍳44]←'   be empty or blank if it is not required.',(,⎕UCS 10)
  (how∆centt)[951+⍳18]←(,⎕UCS 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y'
  (how∆centt)[969+⍳41]←'>   Text vector',(,⎕UCS 10),'   The result contains th'
  (how∆centt)[1010+⍳51]←'e fields within a vector of length <w>.  The first',(,⎕UCS 10)
  (how∆centt)[1061+⍳53]←'   field is left-justified, the second field is centr'
  (how∆centt)[1114+⍳40]←'ed, and the third field',(,⎕UCS 10),'   is right-just'
  (how∆centt)[1154+⍳22]←'ified.',(,⎕UCS 10),'   (',(,⎕UCS 9076),'text) = w',(,⎕UCS 10)
  (how∆centt)[1176+⍳20]←(,⎕UCS 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (how∆centt)[1196+⍳37]←'      72 ',(,⎕UCS 8710),'centt ''/Page 1/Sales Report'
  (how∆centt)[1233+⍳39]←'/May 13, 1998''',(,⎕UCS 10),'Page 1                  '
  (how∆centt)[1272+⍳49]←'      Sales Report                  May 13, 1998',(,⎕UCS 10)
  (how∆centt)[1321+⍳43]←(,⎕UCS 10),'...If a field is not needed, leave it empt'
  (how∆centt)[1364+⍳25]←'y or blank.',(,⎕UCS 10),'      72 ',(,⎕UCS 8710),'cen'
  (how∆centt)[1389+⍳38]←'tt ''/Page 1/Sales Report''',(,⎕UCS 10),'Page 1      '
  (how∆centt)[1427+⍳40]←'                  Sales Report',(,⎕UCS 10),'      72 '
  (how∆centt)[1467+⍳37]←(,⎕UCS 8710),'centt ''//Sales Report/May 13, 1988''',(,⎕UCS 10)
  (how∆centt)[1504+⍳53]←'                              Sales Report           '
  (how∆centt)[1557+⍳38]←'       May 13, 1988',(,⎕UCS 10 10),'...Any of the fie'
  (how∆centt)[1595+⍳53]←'lds can be computed.  For example, to provide the cur'
  (how∆centt)[1648+⍳39]←'rent',(,⎕UCS 10),'...date, use the <date> function.',(,⎕UCS 10)
  (how∆centt)[1687+⍳37]←'      72 ',(,⎕UCS 8710),'centt ''/Page 1/Sales Report'
  (how∆centt)[1724+⍳39]←'/'',date',(,⎕UCS 10),'Page 1                        S'
  (how∆centt)[1763+⍳42]←'ales Report                march 14, 1992',(,⎕UCS 10)

how∆db←1679⍴0 ⍝ prolog ≡1
  (how∆db)[⍳61]←'-------------------------------------------------------------'
  (how∆db)[61+⍳26]←'-----------------',(,⎕UCS 10 121 8592 8710),'db v',(,⎕UCS 10)
  (how∆db)[87+⍳58]←'delete blanks (leading, trailing and multiple) from v (ran'
  (how∆db)[145+⍳44]←'k 0 - 2)',(,⎕UCS 10),'-----------------------------------'
  (how∆db)[189+⍳45]←'-------------------------------------------',(,⎕UCS 10 10)
  (how∆db)[234+⍳31]←'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   D'
  (how∆db)[265+⍳55]←'eleting ''redundant'' blanks is a very useful and common '
  (how∆db)[320+⍳44]←'operation.  One',(,⎕UCS 10),'   advantage of the definiti'
  (how∆db)[364+⍳44]←'on given here is that the function accepts',(,⎕UCS 10),' '
  (how∆db)[408+⍳42]←'  matrices as well as vectors.',(,⎕UCS 10 10),'   The com'
  (how∆db)[450+⍳30]←'panion functions <',(,⎕UCS 8710),'dlb> and <',(,⎕UCS 8710)
  (how∆db)[480+⍳44]←'dtb>, to delete leading and trailing',(,⎕UCS 10),'   blan'
  (how∆db)[524+⍳57]←'ks, respectively, are also often needed, and are included'
  (how∆db)[581+⍳43]←' in this',(,⎕UCS 10),'   toolkit with compatible syntax.'
  (how∆db)[624+⍳23]←(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'---------',(,⎕UCS 10)
  (how∆db)[647+⍳42]←'<v>   character array (rank 0 to 2)',(,⎕UCS 10 10),'Resul'
  (how∆db)[689+⍳31]←'t:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   character array'
  (how∆db)[720+⍳47]←(,⎕UCS 10),'   The result is <v> with all leading and trai'
  (how∆db)[767+⍳44]←'ling blanks removed.  For a',(,⎕UCS 10),'   matrix, leadi'
  (how∆db)[811+⍳57]←'ng blank columns (i.e.  columns which are completely blan'
  (how∆db)[868+⍳44]←'k)',(,⎕UCS 10),'   and trailing blank columns are removed'
  (how∆db)[912+⍳44]←'.  Also, all internal blank fields',(,⎕UCS 10),'   (or co'
  (how∆db)[956+⍳57]←'ncurrent blank columns) are replaced by a single blank fi'
  (how∆db)[1013+⍳28]←'eld (or',(,⎕UCS 10),'   column).',(,⎕UCS 10 10),'Example'
  (how∆db)[1041+⍳22]←'s:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...vector',(,⎕UCS 10)
  (how∆db)[1063+⍳40]←'      frame v',(,⎕UCS 8592),'''   apple   betty   cat   '
  (how∆db)[1103+⍳31]←'''',(,⎕UCS 10),'(   apple   betty   cat   )',(,⎕UCS 10),' '
  (how∆db)[1134+⍳28]←'     frame ',(,⎕UCS 8710),'db v',(,⎕UCS 10),'(apple bett'
  (how∆db)[1162+⍳25]←'y cat)',(,⎕UCS 10 10),'...matrix',(,⎕UCS 10),'      m'
  (how∆db)[1187+⍳26]←(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''apple/betty/cat'
  (how∆db)[1213+⍳21]←'''',(,⎕UCS 10),'      frame m',(,⎕UCS 8592),'(3 2',(,⎕UCS 9076)
  (how∆db)[1234+⍳24]←''' ''),m,(3 2',(,⎕UCS 9076),''' ''),m,'' ''',(,⎕UCS 10),'('
  (how∆db)[1258+⍳35]←'  apple  apple )',(,⎕UCS 10),'(  betty  betty )',(,⎕UCS 10)
  (how∆db)[1293+⍳31]←'(  cat    cat   )',(,⎕UCS 10),'      frame ',(,⎕UCS 8710)
  (how∆db)[1324+⍳30]←'db m',(,⎕UCS 10),'(apple apple)',(,⎕UCS 10),'(betty bett'
  (how∆db)[1354+⍳28]←'y)',(,⎕UCS 10),'(cat   cat  )',(,⎕UCS 10 10),'...empty v'
  (how∆db)[1382+⍳25]←'ector',(,⎕UCS 10),'      frame ',(,⎕UCS 8710),'db ''''',(,⎕UCS 10)
  (how∆db)[1407+⍳27]←(,⎕UCS 40 41 10 10),'...empty matrix',(,⎕UCS 10),'      f'
  (how∆db)[1434+⍳18]←'rame ',(,⎕UCS 8710),'db 2 0',(,⎕UCS 9076 39 39 10 40 41)
  (how∆db)[1452+⍳38]←(,⎕UCS 10 40 41 10 10),'...definition of <frame> used to '
  (how∆db)[1490+⍳42]←'highlight leading and trailing blanks',(,⎕UCS 10),'    '
  (how∆db)[1532+⍳18]←(,⎕UCS 8711 32 121 8592),'frame x',(,⎕UCS 10),'[1]  ',(,⎕UCS 9053)
  (how∆db)[1550+⍳52]←'frame (i.e. surround) an array <x> with a character',(,⎕UCS 10)
  (how∆db)[1602+⍳28]←'[2]  ',(,⎕UCS 9053),'.k library-utility',(,⎕UCS 10),'[3]'
  (how∆db)[1630+⍳28]←'  ',(,⎕UCS 9053),'.t 1992.3.10.20.44.14',(,⎕UCS 10),'[4]'
  (how∆db)[1658+⍳20]←'   y',(,⎕UCS 8592),'''('',x,'')''',(,⎕UCS 10),'    ',(,⎕UCS 8711)
  (how∆db)[1678+⍳1]←(,⎕UCS 10)

how∆dc←1869⍴0 ⍝ prolog ≡1
  (how∆dc)[⍳61]←'-------------------------------------------------------------'
  (how∆dc)[61+⍳28]←'-----------------',(,⎕UCS 10 121 8592 99 32 8710),'dc v',(,⎕UCS 10)
  (how∆dc)[89+⍳58]←'delete characters (leading, trailing and multiple) from v '
  (how∆dc)[147+⍳44]←'(rank 0 - 2)',(,⎕UCS 10),'-------------------------------'
  (how∆dc)[191+⍳48]←'-----------------------------------------------',(,⎕UCS 10)
  (how∆dc)[239+⍳28]←(,⎕UCS 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (how∆dc)[267+⍳42]←'   The function <',(,⎕UCS 8710),'dc> deletes redundant oc'
  (how∆dc)[309+⍳44]←'currences of the specified',(,⎕UCS 10),'   character <c> '
  (how∆dc)[353+⍳40]←'from the array <v>.  <',(,⎕UCS 8710),'dc> with c='' '' is'
  (how∆dc)[393+⍳35]←' equivalent to ',(,⎕UCS 8710 100 98 10),'   (delete redun'
  (how∆dc)[428+⍳57]←'dant blanks).  If it were possible within standard APL to'
  (how∆dc)[485+⍳47]←(,⎕UCS 10),'   leave out the left argument of a defined fu'
  (how∆dc)[532+⍳44]←'nction, the toolkit would',(,⎕UCS 10),'   allow the synta'
  (how∆dc)[576+⍳38]←'x y',(,⎕UCS 8592 8710),'dc v to delete blanks, and would '
  (how∆dc)[614+⍳29]←'not have <',(,⎕UCS 8710),'db>.  For',(,⎕UCS 10),'   ease '
  (how∆dc)[643+⍳42]←'of use, however, ',(,⎕UCS 8710),'db is included in the to'
  (how∆dc)[685+⍳38]←'olkit.',(,⎕UCS 10 10),'   Similar remarks apply to <',(,⎕UCS 8710)
  (how∆dc)[723+⍳27]←'dlc> and <',(,⎕UCS 8710),'dlb>, and <',(,⎕UCS 8710),'dtc>'
  (how∆dc)[750+⍳25]←' and <',(,⎕UCS 8710),'dtb>.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (how∆dc)[775+⍳43]←'---------',(,⎕UCS 10),'<c>   scalar or 1-element vector',(,⎕UCS 10)
  (how∆dc)[818+⍳44]←'   Character to be deleted',(,⎕UCS 10),'   If <c> is empt'
  (how∆dc)[862+⍳42]←'y, it is taken to be a blank.',(,⎕UCS 10 10),'<v>   chara'
  (how∆dc)[904+⍳34]←'cter array (rank 0 to 2)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (how∆dc)[938+⍳31]←'------',(,⎕UCS 10),'<y>   character array',(,⎕UCS 10),'  '
  (how∆dc)[969+⍳57]←' The result is <v> with all leading and trailing characte'
  (how∆dc)[1026+⍳43]←'rs <c> removed.',(,⎕UCS 10),'   For a matrix, leading an'
  (how∆dc)[1069+⍳49]←'d trailing columns that are entirely filled with',(,⎕UCS 10)
  (how∆dc)[1118+⍳56]←'   <c> are removed.  Also, all internal <c> fields (or c'
  (how∆dc)[1174+⍳43]←'oncurrent columns)',(,⎕UCS 10),'   are replaced by a sin'
  (how∆dc)[1217+⍳41]←'gle occurrence (or column) of <c>.',(,⎕UCS 10 10),'Examp'
  (how∆dc)[1258+⍳24]←'les:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...vector',(,⎕UCS 10)
  (how∆dc)[1282+⍳24]←'      frame v',(,⎕UCS 8592 39 8902 8902 8902),'apple',(,⎕UCS 8902)
  (how∆dc)[1306+⍳14]←(,⎕UCS 8902 8902),'betty',(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902)
  (how∆dc)[1320+⍳13]←(,⎕UCS 8902 39 10 40 8902 8902 8902),'apple',(,⎕UCS 8902)
  (how∆dc)[1333+⍳14]←(,⎕UCS 8902 8902),'betty',(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902)
  (how∆dc)[1347+⍳20]←(,⎕UCS 8902 41 10),'      frame ''',(,⎕UCS 8902 39 32 8710)
  (how∆dc)[1367+⍳18]←'dc v',(,⎕UCS 10),'(apple',(,⎕UCS 8902),'betty',(,⎕UCS 8902)
  (how∆dc)[1385+⍳24]←'cat)',(,⎕UCS 10 10),'...matrix',(,⎕UCS 10),'      m',(,⎕UCS 8592)
  (how∆dc)[1409+⍳28]←(,⎕UCS 39 47 8902 39 32 8710),'box ''apple/betty/cat''',(,⎕UCS 10)
  (how∆dc)[1437+⍳22]←'      frame m',(,⎕UCS 8592),'(3 2',(,⎕UCS 9076 39 8902),''''
  (how∆dc)[1459+⍳19]←'),m,(3 2',(,⎕UCS 9076 39 8902),'''),m,''',(,⎕UCS 8902 39)
  (how∆dc)[1478+⍳16]←(,⎕UCS 10 40 8902 8902),'apple',(,⎕UCS 8902 8902),'apple'
  (how∆dc)[1494+⍳14]←(,⎕UCS 8902 41 10 40 8902 8902),'betty',(,⎕UCS 8902 8902),'b'
  (how∆dc)[1508+⍳14]←'etty',(,⎕UCS 8902 41 10 40 8902 8902),'cat',(,⎕UCS 8902)
  (how∆dc)[1522+⍳12]←(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902 8902 8902 41 10),' '
  (how∆dc)[1534+⍳22]←'     frame ''',(,⎕UCS 8902 39 32 8710),'dc m',(,⎕UCS 10),'('
  (how∆dc)[1556+⍳20]←'apple',(,⎕UCS 8902),'apple)',(,⎕UCS 10),'(betty',(,⎕UCS 8902)
  (how∆dc)[1576+⍳17]←'betty)',(,⎕UCS 10),'(cat',(,⎕UCS 8902 8902 8902),'cat'
  (how∆dc)[1593+⍳22]←(,⎕UCS 8902 8902 41 10 10),'...empty vector',(,⎕UCS 10),' '
  (how∆dc)[1615+⍳22]←'     frame ''',(,⎕UCS 8902 39 32 8710),'dc ''''',(,⎕UCS 10)
  (how∆dc)[1637+⍳29]←(,⎕UCS 40 41 10),'...empty matrix',(,⎕UCS 10),'      fram'
  (how∆dc)[1666+⍳16]←'e ''',(,⎕UCS 8902 39 32 8710),'dc 2 0',(,⎕UCS 9076 39 39)
  (how∆dc)[1682+⍳33]←(,⎕UCS 10 40 41 10 40 41 10),'...Delete blanks when <c>='
  (how∆dc)[1715+⍳28]←''' '' or <c>=''''',(,⎕UCS 10),'      frame v',(,⎕UCS 8592)
  (how∆dc)[1743+⍳41]←'''   apple  betty cat  ''',(,⎕UCS 10),'(   apple  betty '
  (how∆dc)[1784+⍳26]←'cat  )',(,⎕UCS 10),'      frame '' ''',(,⎕UCS 8710),'dc '
  (how∆dc)[1810+⍳30]←'v',(,⎕UCS 10),'(apple betty cat)',(,⎕UCS 10),'      fram'
  (how∆dc)[1840+⍳26]←'e '''' ',(,⎕UCS 8710),'dc v',(,⎕UCS 10),'(apple betty ca'
  (how∆dc)[1866+⍳3]←'t)',(,⎕UCS 10)

how∆dlb←1019⍴0 ⍝ prolog ≡1
  (how∆dlb)[⍳60]←'------------------------------------------------------------'
  (how∆dlb)[60+⍳28]←'------------------',(,⎕UCS 10 121 8592 8710),'dlb v',(,⎕UCS 10)
  (how∆dlb)[88+⍳44]←'delete leading blanks from v (rank 0 - 2)',(,⎕UCS 10),'--'
  (how∆dlb)[132+⍳56]←'--------------------------------------------------------'
  (how∆dlb)[188+⍳36]←'--------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (how∆dlb)[224+⍳43]←'------------',(,⎕UCS 10),'   This function deletes leadi'
  (how∆dlb)[267+⍳43]←'ng blanks from vectors, or leading blank',(,⎕UCS 10),'  '
  (how∆dlb)[310+⍳36]←' columns from matrices.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (how∆dlb)[346+⍳43]←'---------',(,⎕UCS 10),'<v>   character array (rank 0 to '
  (how∆dlb)[389+⍳19]←'2)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (how∆dlb)[408+⍳43]←'<y>   character array',(,⎕UCS 10),'   The result is <v> '
  (how∆dlb)[451+⍳55]←'with all leading blanks removed.  For a matrix, leading'
  (how∆dlb)[506+⍳46]←(,⎕UCS 10),'   blank columns (i.e.  columns which are com'
  (how∆dlb)[552+⍳39]←'pletely blank) are removed.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10)
  (how∆dlb)[591+⍳30]←'--------',(,⎕UCS 10),'...vector',(,⎕UCS 10),'      frame'
  (how∆dlb)[621+⍳31]←' v',(,⎕UCS 8592),'''   apple   betty   cat   ''',(,⎕UCS 10)
  (how∆dlb)[652+⍳40]←'(   apple   betty   cat   )',(,⎕UCS 10),'      frame '
  (how∆dlb)[692+⍳31]←(,⎕UCS 8710),'dlb v',(,⎕UCS 10),'(apple   betty   cat   )'
  (how∆dlb)[723+⍳20]←(,⎕UCS 10 10),'...matrix',(,⎕UCS 10),'      m',(,⎕UCS 8592)
  (how∆dlb)[743+⍳27]←'''/'' ',(,⎕UCS 8710),'box ''apple/betty/cat''',(,⎕UCS 10)
  (how∆dlb)[770+⍳24]←'      frame m',(,⎕UCS 8592),'(3 2',(,⎕UCS 9076),''' ''),'
  (how∆dlb)[794+⍳24]←'m,(3 2',(,⎕UCS 9076),''' ''),m,'' ''',(,⎕UCS 10),'(  app'
  (how∆dlb)[818+⍳31]←'le  apple )',(,⎕UCS 10),'(  betty  betty )',(,⎕UCS 10),'('
  (how∆dlb)[849+⍳31]←'  cat    cat   )',(,⎕UCS 10),'      frame ',(,⎕UCS 8710),'d'
  (how∆dlb)[880+⍳30]←'lb m',(,⎕UCS 10),'(apple  apple )',(,⎕UCS 10),'(betty  b'
  (how∆dlb)[910+⍳28]←'etty )',(,⎕UCS 10),'(cat    cat   )',(,⎕UCS 10 10),'...e'
  (how∆dlb)[938+⍳28]←'mpty vector',(,⎕UCS 10),'      frame ',(,⎕UCS 8710),'dlb'
  (how∆dlb)[966+⍳24]←' ''''',(,⎕UCS 10 40 41 10),'...empty matrix',(,⎕UCS 10),' '
  (how∆dlb)[990+⍳23]←'     frame ',(,⎕UCS 8710),'dlb 2 0',(,⎕UCS 9076 39 39 10)
  (how∆dlb)[1013+⍳6]←(,⎕UCS 40 41 10 40 41 10)

how∆dlc←1410⍴0 ⍝ prolog ≡1
  (how∆dlc)[⍳60]←'------------------------------------------------------------'
  (how∆dlc)[60+⍳29]←'------------------',(,⎕UCS 10 121 8592 99 32 8710),'dlc v'
  (how∆dlc)[89+⍳47]←(,⎕UCS 10),'delete leading character c from v (rank 0 - 2)'
  (how∆dlc)[136+⍳46]←(,⎕UCS 10),'---------------------------------------------'
  (how∆dlc)[182+⍳41]←'---------------------------------',(,⎕UCS 10 10),'Introd'
  (how∆dlc)[223+⍳30]←'uction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   The fu'
  (how∆dlc)[253+⍳41]←'nction <',(,⎕UCS 8710),'dlc> deletes all leading occurre'
  (how∆dlc)[294+⍳43]←'nces of the specified',(,⎕UCS 10),'   character <c> from'
  (how∆dlc)[337+⍳39]←' the array <v>.  <',(,⎕UCS 8710),'dlc> with c='' '' is e'
  (how∆dlc)[376+⍳28]←'quivalent to',(,⎕UCS 10),'   ',(,⎕UCS 8710),'dlb (delete'
  (how∆dlc)[404+⍳31]←' leading blanks).',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (how∆dlc)[435+⍳42]←'--------',(,⎕UCS 10),'<c>   scalar or 1-element vector',(,⎕UCS 10)
  (how∆dlc)[477+⍳43]←'   Character to be deleted',(,⎕UCS 10),'   If <c> is emp'
  (how∆dlc)[520+⍳41]←'ty, it is taken to be a blank.',(,⎕UCS 10 10),'<v>   cha'
  (how∆dlc)[561+⍳36]←'racter array (rank 0 to 2)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10)
  (how∆dlc)[597+⍳30]←'------',(,⎕UCS 10),'<y>   character array',(,⎕UCS 10),' '
  (how∆dlc)[627+⍳56]←'  The result is <v> with all leading characters <c> remo'
  (how∆dlc)[683+⍳43]←'ved.  For a matrix,',(,⎕UCS 10),'   leading columns that'
  (how∆dlc)[726+⍳44]←' are entirely filled with <c> are removed.',(,⎕UCS 10 10)
  (how∆dlc)[770+⍳29]←'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...vector',(,⎕UCS 10)
  (how∆dlc)[799+⍳24]←'      frame v',(,⎕UCS 8592 39 8902 8902 8902),'apple',(,⎕UCS 8902)
  (how∆dlc)[823+⍳14]←(,⎕UCS 8902 8902),'betty',(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902)
  (how∆dlc)[837+⍳13]←(,⎕UCS 8902 39 10 40 8902 8902 8902),'apple',(,⎕UCS 8902)
  (how∆dlc)[850+⍳14]←(,⎕UCS 8902 8902),'betty',(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902)
  (how∆dlc)[864+⍳20]←(,⎕UCS 8902 41 10),'      frame ''',(,⎕UCS 8902 39 32 8710)
  (how∆dlc)[884+⍳20]←'dlc v',(,⎕UCS 10),'(apple',(,⎕UCS 8902 8902 8902),'betty'
  (how∆dlc)[904+⍳12]←(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902 8902 41 10 10),'.'
  (how∆dlc)[916+⍳21]←'..matrix',(,⎕UCS 10),'      m',(,⎕UCS 8592 39 47 8902 39)
  (how∆dlc)[937+⍳27]←(,⎕UCS 32 8710),'box ''apple/betty/cat''',(,⎕UCS 10),'   '
  (how∆dlc)[964+⍳19]←'   frame m',(,⎕UCS 8592),'(3 2',(,⎕UCS 9076 39 8902),''''
  (how∆dlc)[983+⍳19]←'),m,(3 2',(,⎕UCS 9076 39 8902),'''),m,''',(,⎕UCS 8902 39)
  (how∆dlc)[1002+⍳16]←(,⎕UCS 10 40 8902 8902),'apple',(,⎕UCS 8902 8902),'apple'
  (how∆dlc)[1018+⍳13]←(,⎕UCS 8902 41 10 40 8902 8902),'betty',(,⎕UCS 8902 8902)
  (how∆dlc)[1031+⍳15]←'betty',(,⎕UCS 8902 41 10 40 8902 8902),'cat',(,⎕UCS 8902)
  (how∆dlc)[1046+⍳11]←(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902 8902 8902 41 10)
  (how∆dlc)[1057+⍳23]←'      frame ''',(,⎕UCS 8902 39 32 8710),'dlc m',(,⎕UCS 10)
  (how∆dlc)[1080+⍳17]←'(apple',(,⎕UCS 8902 8902),'apple',(,⎕UCS 8902 41 10),'('
  (how∆dlc)[1097+⍳17]←'betty',(,⎕UCS 8902 8902),'betty',(,⎕UCS 8902 41 10),'(c'
  (how∆dlc)[1114+⍳11]←'at',(,⎕UCS 8902 8902 8902 8902),'cat',(,⎕UCS 8902 8902)
  (how∆dlc)[1125+⍳24]←(,⎕UCS 8902 41 10 10),'...empty vector',(,⎕UCS 10),'    '
  (how∆dlc)[1149+⍳20]←'  frame ''',(,⎕UCS 8902 39 32 8710),'dlc ''''',(,⎕UCS 10)
  (how∆dlc)[1169+⍳28]←(,⎕UCS 40 41 10),'...empty matrix',(,⎕UCS 10),'      fra'
  (how∆dlc)[1197+⍳17]←'me ''',(,⎕UCS 8902 39 32 8710),'dlc 2 0',(,⎕UCS 9076 39)
  (how∆dlc)[1214+⍳31]←(,⎕UCS 39 10 40 41 10 40 41 10),'...Delete blanks when <'
  (how∆dlc)[1245+⍳31]←'c>='' '' or <c>=''''',(,⎕UCS 10),'      frame v',(,⎕UCS 8592)
  (how∆dlc)[1276+⍳40]←'''   apple  betty cat  ''',(,⎕UCS 10),'(   apple  betty'
  (how∆dlc)[1316+⍳25]←' cat  )',(,⎕UCS 10),'      frame '' ''',(,⎕UCS 8710),'d'
  (how∆dlc)[1341+⍳29]←'lc v',(,⎕UCS 10),'(apple  betty cat  )',(,⎕UCS 10),'   '
  (how∆dlc)[1370+⍳25]←'   frame '''' ',(,⎕UCS 8710),'dlc v',(,⎕UCS 10),'(apple'
  (how∆dlc)[1395+⍳15]←'  betty cat  )',(,⎕UCS 10)

how∆dtb←1032⍴0 ⍝ prolog ≡1
  (how∆dtb)[⍳60]←'------------------------------------------------------------'
  (how∆dtb)[60+⍳28]←'------------------',(,⎕UCS 10 121 8592 8710),'dtb v',(,⎕UCS 10)
  (how∆dtb)[88+⍳46]←'delete trailing blanks from <v> (rank 0 - 2)',(,⎕UCS 10),'-'
  (how∆dtb)[134+⍳56]←'--------------------------------------------------------'
  (how∆dtb)[190+⍳37]←'---------------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (how∆dtb)[227+⍳43]←'------------',(,⎕UCS 10),'   This function deletes trail'
  (how∆dtb)[270+⍳44]←'ing blanks from vectors, or trailing blank',(,⎕UCS 10),' '
  (how∆dtb)[314+⍳37]←'  columns from matrices.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (how∆dtb)[351+⍳43]←'---------',(,⎕UCS 10),'<v>   character array (rank 0 to '
  (how∆dtb)[394+⍳19]←'2)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (how∆dtb)[413+⍳43]←'<y>   character array',(,⎕UCS 10),'   The result is <v> '
  (how∆dtb)[456+⍳49]←'with all trailing blanks removed.  For a matrix,',(,⎕UCS 10)
  (how∆dtb)[505+⍳56]←'   trailing blank columns (i.e.  columns which are compl'
  (how∆dtb)[561+⍳31]←'etely blank) are',(,⎕UCS 10),'   removed.',(,⎕UCS 10 10),'E'
  (how∆dtb)[592+⍳28]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'...vector',(,⎕UCS 10)
  (how∆dtb)[620+⍳40]←'      frame v',(,⎕UCS 8592),'''   apple   betty   cat   '
  (how∆dtb)[660+⍳31]←'''',(,⎕UCS 10),'(   apple   betty   cat   )',(,⎕UCS 10),' '
  (how∆dtb)[691+⍳28]←'     frame ',(,⎕UCS 8710),'dtb v',(,⎕UCS 10),'(   apple '
  (how∆dtb)[719+⍳28]←'  betty   cat)',(,⎕UCS 10 10),'...matrix',(,⎕UCS 10),'  '
  (how∆dtb)[747+⍳23]←'    m',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''apple/b'
  (how∆dtb)[770+⍳27]←'etty/cat''',(,⎕UCS 10),'      frame m',(,⎕UCS 8592),'(3 '
  (how∆dtb)[797+⍳21]←'2',(,⎕UCS 9076),''' ''),m,(3 2',(,⎕UCS 9076),''' ''),m,'
  (how∆dtb)[818+⍳28]←''' ''',(,⎕UCS 10),'(  apple  apple )',(,⎕UCS 10),'(  bet'
  (how∆dtb)[846+⍳31]←'ty  betty )',(,⎕UCS 10),'(  cat    cat   )',(,⎕UCS 10),' '
  (how∆dtb)[877+⍳28]←'     frame ',(,⎕UCS 8710),'dtb m',(,⎕UCS 10),'(  apple  '
  (how∆dtb)[905+⍳30]←'apple)',(,⎕UCS 10),'(  betty  betty)',(,⎕UCS 10),'(  cat'
  (how∆dtb)[935+⍳29]←'    cat  )',(,⎕UCS 10 10),'...empty vector',(,⎕UCS 10),' '
  (how∆dtb)[964+⍳23]←'     frame ',(,⎕UCS 8710),'dtb ''''',(,⎕UCS 10 40 41 10),'.'
  (how∆dtb)[987+⍳29]←'..empty matrix',(,⎕UCS 10),'      frame ',(,⎕UCS 8710),'d'
  (how∆dtb)[1016+⍳16]←'tb 2 0',(,⎕UCS 9076 39 39 10 40 41 10 40 41 10)

how∆dtc←1421⍴0 ⍝ prolog ≡1
  (how∆dtc)[⍳60]←'------------------------------------------------------------'
  (how∆dtc)[60+⍳29]←'------------------',(,⎕UCS 10 121 8592 99 32 8710),'dtc v'
  (how∆dtc)[89+⍳47]←(,⎕UCS 10),'delete trailing character c from v (rank 0 - 2'
  (how∆dtc)[136+⍳43]←')',(,⎕UCS 10),'-----------------------------------------'
  (how∆dtc)[179+⍳41]←'-------------------------------------',(,⎕UCS 10 10),'In'
  (how∆dtc)[220+⍳30]←'troduction:',(,⎕UCS 10),'------------',(,⎕UCS 10),'   Th'
  (how∆dtc)[250+⍳41]←'e function <',(,⎕UCS 8710),'dtc> deletes all trailing oc'
  (how∆dtc)[291+⍳43]←'currences of the specified',(,⎕UCS 10),'   character <c>'
  (how∆dtc)[334+⍳39]←' from the array <v>.  <',(,⎕UCS 8710),'dtc> with c='' '''
  (how∆dtc)[373+⍳28]←' is equivalent to',(,⎕UCS 10),'   ',(,⎕UCS 8710),'dtb (d'
  (how∆dtc)[401+⍳36]←'elete trailing blanks).',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (how∆dtc)[437+⍳42]←'---------',(,⎕UCS 10),'<c>   scalar or 1-element vector'
  (how∆dtc)[479+⍳33]←(,⎕UCS 10),'   Character to be deleted',(,⎕UCS 10),'   If'
  (how∆dtc)[512+⍳44]←' <c> is empty, it is taken to be a blank.',(,⎕UCS 10 10),'<'
  (how∆dtc)[556+⍳41]←'v>   character array (rank 0 to 2)',(,⎕UCS 10 10),'Resul'
  (how∆dtc)[597+⍳30]←'t:',(,⎕UCS 10),'------',(,⎕UCS 10),'<y>   character arra'
  (how∆dtc)[627+⍳43]←'y',(,⎕UCS 10),'   The result is <v> with all trailing ch'
  (how∆dtc)[670+⍳43]←'aracters <c> removed.  For a matrix,',(,⎕UCS 10),'   tra'
  (how∆dtc)[713+⍳56]←'iling columns that are entirely filled with <c> are remo'
  (how∆dtc)[769+⍳25]←'ved.',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'--------',(,⎕UCS 10)
  (how∆dtc)[794+⍳26]←'...vector',(,⎕UCS 10),'      frame v',(,⎕UCS 8592 39 8902)
  (how∆dtc)[820+⍳15]←(,⎕UCS 8902 8902),'apple',(,⎕UCS 8902 8902 8902),'betty'
  (how∆dtc)[835+⍳11]←(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902 8902 39 10 40)
  (how∆dtc)[846+⍳13]←(,⎕UCS 8902 8902 8902),'apple',(,⎕UCS 8902 8902 8902),'be'
  (how∆dtc)[859+⍳13]←'tty',(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902 8902 41 10)
  (how∆dtc)[872+⍳23]←'      frame ''',(,⎕UCS 8902 39 32 8710),'dtc v',(,⎕UCS 10)
  (how∆dtc)[895+⍳13]←(,⎕UCS 40 8902 8902 8902),'apple',(,⎕UCS 8902 8902 8902),'b'
  (how∆dtc)[908+⍳18]←'etty',(,⎕UCS 8902 8902 8902),'cat)',(,⎕UCS 10 10),'...ma'
  (how∆dtc)[926+⍳18]←'trix',(,⎕UCS 10),'      m',(,⎕UCS 8592 39 47 8902 39 32)
  (how∆dtc)[944+⍳29]←(,⎕UCS 8710),'box ''apple/betty/cat''',(,⎕UCS 10),'      '
  (how∆dtc)[973+⍳19]←'frame m',(,⎕UCS 8592),'(3 2',(,⎕UCS 9076 39 8902),'''),m'
  (how∆dtc)[992+⍳17]←',(3 2',(,⎕UCS 9076 39 8902),'''),m,''',(,⎕UCS 8902 39 10)
  (how∆dtc)[1009+⍳15]←(,⎕UCS 40 8902 8902),'apple',(,⎕UCS 8902 8902),'apple'
  (how∆dtc)[1024+⍳13]←(,⎕UCS 8902 41 10 40 8902 8902),'betty',(,⎕UCS 8902 8902)
  (how∆dtc)[1037+⍳15]←'betty',(,⎕UCS 8902 41 10 40 8902 8902),'cat',(,⎕UCS 8902)
  (how∆dtc)[1052+⍳11]←(,⎕UCS 8902 8902 8902),'cat',(,⎕UCS 8902 8902 8902 41 10)
  (how∆dtc)[1063+⍳23]←'      frame ''',(,⎕UCS 8902 39 32 8710),'dtc m',(,⎕UCS 10)
  (how∆dtc)[1086+⍳17]←(,⎕UCS 40 8902 8902),'apple',(,⎕UCS 8902 8902),'apple)',(,⎕UCS 10)
  (how∆dtc)[1103+⍳17]←(,⎕UCS 40 8902 8902),'betty',(,⎕UCS 8902 8902),'betty)',(,⎕UCS 10)
  (how∆dtc)[1120+⍳11]←(,⎕UCS 40 8902 8902),'cat',(,⎕UCS 8902 8902 8902 8902),'c'
  (how∆dtc)[1131+⍳23]←'at',(,⎕UCS 8902 8902 41 10 10),'...empty vector',(,⎕UCS 10)
  (how∆dtc)[1154+⍳24]←'      frame ''',(,⎕UCS 8902 39 32 8710),'dtc ''''',(,⎕UCS 10)
  (how∆dtc)[1178+⍳28]←(,⎕UCS 40 41 10),'...empty matrix',(,⎕UCS 10),'      fra'
  (how∆dtc)[1206+⍳17]←'me ''',(,⎕UCS 8902 39 32 8710),'dtc 2 0',(,⎕UCS 9076 39)
  (how∆dtc)[1223+⍳31]←(,⎕UCS 39 10 40 41 10 40 41 10),'...Delete blanks when <'
  (how∆dtc)[1254+⍳31]←'c>='' '' or <c>=''''',(,⎕UCS 10),'      frame v',(,⎕UCS 8592)
  (how∆dtc)[1285+⍳40]←'''   apple  betty cat  ''',(,⎕UCS 10),'(   apple  betty'
  (how∆dtc)[1325+⍳25]←' cat  )',(,⎕UCS 10),'      frame '' ''',(,⎕UCS 8710),'d'
  (how∆dtc)[1350+⍳29]←'tc v',(,⎕UCS 10),'(   apple  betty cat)',(,⎕UCS 10),'  '
  (how∆dtc)[1379+⍳25]←'    frame '''' ',(,⎕UCS 8710),'dtc v',(,⎕UCS 10),'(   a'
  (how∆dtc)[1404+⍳17]←'pple  betty cat)',(,⎕UCS 10)

how∆if←2018⍴0 ⍝ prolog ≡1
  (how∆if)[⍳61]←'-------------------------------------------------------------'
  (how∆if)[61+⍳27]←'-----------------',(,⎕UCS 10 121 8592),'label ',(,⎕UCS 8710)
  (how∆if)[88+⍳45]←'if condition',(,⎕UCS 10),'if statement.  return <label[i]>'
  (how∆if)[133+⍳44]←' if <condition[i]> = 1',(,⎕UCS 10),'---------------------'
  (how∆if)[177+⍳57]←'---------------------------------------------------------'
  (how∆if)[234+⍳29]←(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10),'------------',(,⎕UCS 10)
  (how∆if)[263+⍳42]←'   <',(,⎕UCS 8710),'if> is a function that provides the i'
  (how∆if)[305+⍳37]←'ntuitive ''if then'' statement:',(,⎕UCS 10),'      ',(,⎕UCS 8594)
  (how∆if)[342+⍳29]←'label ',(,⎕UCS 8710),'if condition',(,⎕UCS 10),'   This s'
  (how∆if)[371+⍳57]←'yntax may be used in place of several less intuitive alte'
  (how∆if)[428+⍳30]←'rnatives',(,⎕UCS 10),'   such as ...',(,⎕UCS 10),'      '
  (how∆if)[458+⍳24]←(,⎕UCS 8594),'condition/label',(,⎕UCS 10),'      ',(,⎕UCS 8594)
  (how∆if)[482+⍳23]←'condition',(,⎕UCS 9076),'label',(,⎕UCS 10),'      ',(,⎕UCS 8594)
  (how∆if)[505+⍳29]←'condition',(,⎕UCS 8593),'label',(,⎕UCS 10),'   Since mult'
  (how∆if)[534+⍳56]←'iple conditions and multiple corresponding labels can be'
  (how∆if)[590+⍳32]←(,⎕UCS 10),'   specified, ',(,⎕UCS 8710),'if can be used a'
  (how∆if)[622+⍳44]←'s an ''if then'' statement, an ''if then else''',(,⎕UCS 10)
  (how∆if)[666+⍳55]←'   statement, or a ''case'' statement with or without an '
  (how∆if)[721+⍳32]←'''otherwise'' clause.',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10)
  (how∆if)[753+⍳35]←'---------',(,⎕UCS 10),'<label>   Numeric vector',(,⎕UCS 10)
  (how∆if)[788+⍳46]←'   This is typically a vector of line labels.',(,⎕UCS 10)
  (how∆if)[834+⍳40]←(,⎕UCS 10),'<condition>   Numeric vector (boolean)',(,⎕UCS 10)
  (how∆if)[874+⍳54]←'   This is a boolean vector corresponding to <label>.',(,⎕UCS 10)
  (how∆if)[928+⍳18]←(,⎕UCS 10),'   (',(,⎕UCS 9076),'label) = (',(,⎕UCS 9076),'c'
  (how∆if)[946+⍳32]←'ondition)   or   (',(,⎕UCS 9076),'label) = (1+',(,⎕UCS 9076)
  (how∆if)[978+⍳27]←'condition)',(,⎕UCS 10 10),'Result:',(,⎕UCS 10),'------',(,⎕UCS 10)
  (how∆if)[1005+⍳43]←'<y>   Numeric vector',(,⎕UCS 10),'   The result <r> is o'
  (how∆if)[1048+⍳54]←'ne or more elements of <label>, or empty.  The result',(,⎕UCS 10)
  (how∆if)[1102+⍳53]←'   <r> is intended to be the argument to the branch ',(,⎕UCS 8594)
  (how∆if)[1155+⍳41]←' function.',(,⎕UCS 10 10),'   If the dimensions of <labe'
  (how∆if)[1196+⍳47]←'l> and <condition> are the same, the result is',(,⎕UCS 10)
  (how∆if)[1243+⍳56]←'   condition/label.  The statement can be interpreted as'
  (how∆if)[1299+⍳42]←' ''if condition[i] is',(,⎕UCS 10),'   the first true con'
  (how∆if)[1341+⍳50]←'dition, go to line label[i], otherwise continue''.',(,⎕UCS 10)
  (how∆if)[1391+⍳46]←(,⎕UCS 10),'   If the dimension of <label> is one greater'
  (how∆if)[1437+⍳43]←' than <condition>, the result is',(,⎕UCS 10),'   (condit'
  (how∆if)[1480+⍳54]←'ion,1)/label.  The statement can be interpreted as ''If'
  (how∆if)[1534+⍳46]←(,⎕UCS 10),'   condition[i] is the first true condition, '
  (how∆if)[1580+⍳43]←'go to line label[i], otherwise',(,⎕UCS 10),'   go to lin'
  (how∆if)[1623+⍳35]←'e ',(,⎕UCS 175 49 8593),'label'' (i.e.  the last label i'
  (how∆if)[1658+⍳28]←'n the list).',(,⎕UCS 10 10),'Examples:',(,⎕UCS 10),'----'
  (how∆if)[1686+⍳39]←'----',(,⎕UCS 10),'...Define the following ''labels''.',(,⎕UCS 10)
  (how∆if)[1725+⍳23]←'      l10',(,⎕UCS 8592 55 10),'      l20',(,⎕UCS 8592 49)
  (how∆if)[1748+⍳23]←(,⎕UCS 51 10),'      l30',(,⎕UCS 8592 50 49 10),'      l4'
  (how∆if)[1771+⍳31]←'0',(,⎕UCS 8592 51 53 10),'...An ''if then'' statement',(,⎕UCS 10)
  (how∆if)[1802+⍳22]←'      x',(,⎕UCS 8592 48 10),'      l10 ',(,⎕UCS 8710),'i'
  (how∆if)[1824+⍳24]←'f x=0',(,⎕UCS 10 55 10),'      l10 ',(,⎕UCS 8710),'if x>'
  (how∆if)[1848+⍳26]←'0',(,⎕UCS 10 10),'...A ''case'' statement',(,⎕UCS 10),' '
  (how∆if)[1874+⍳26]←'     x',(,⎕UCS 8592),'''c''',(,⎕UCS 10),'      (l10,l20,'
  (how∆if)[1900+⍳21]←'l30) ',(,⎕UCS 8710),'if x=''abc''',(,⎕UCS 10 50 49 10),'.'
  (how∆if)[1921+⍳46]←'..A case statement with an ''otherwise'' clause',(,⎕UCS 10)
  (how∆if)[1967+⍳26]←'      x',(,⎕UCS 8592),'''d''',(,⎕UCS 10),'      (l10,l20'
  (how∆if)[1993+⍳24]←',l30,l40) ',(,⎕UCS 8710),'if x=''abc''',(,⎕UCS 10 51 53)
  (how∆if)[2017+⍳1]←(,⎕UCS 10)

how∆rowmem←1590⍴0 ⍝ prolog ≡1
  (how∆rowmem)[⍳57]←'---------------------------------------------------------'
  (how∆rowmem)[57+⍳28]←'---------------------',(,⎕UCS 10 114 8592 120 32 8710),'r'
  (how∆rowmem)[85+⍳41]←'owmem y',(,⎕UCS 10),'r[i]=1 if <x[i;]> is a row in <y>'
  (how∆rowmem)[126+⍳40]←' (trailing blanks ignored)',(,⎕UCS 10),'-------------'
  (how∆rowmem)[166+⍳53]←'-----------------------------------------------------'
  (how∆rowmem)[219+⍳28]←'------------',(,⎕UCS 10 10),'Introduction:',(,⎕UCS 10)
  (how∆rowmem)[247+⍳40]←'------------',(,⎕UCS 10),'   For given matrices <x> a'
  (how∆rowmem)[287+⍳38]←'nd <y>, the function <',(,⎕UCS 8710),'rowmem> returns'
  (how∆rowmem)[325+⍳40]←' 1 for each',(,⎕UCS 10),'   row of <x> that belongs t'
  (how∆rowmem)[365+⍳34]←'o <y>.',(,⎕UCS 10 10),'   Note that the syntax r',(,⎕UCS 8592)
  (how∆rowmem)[399+⍳35]←(,⎕UCS 120 32 8710),'rowmem y is similar to the APL '''
  (how∆rowmem)[434+⍳26]←'membership''',(,⎕UCS 10),'   function r',(,⎕UCS 8592)
  (how∆rowmem)[460+⍳36]←(,⎕UCS 120 8712),'y.  (''Is x[i] a member of <y>?''). '
  (how∆rowmem)[496+⍳28]←' However, <',(,⎕UCS 8710),'rowmem> treats',(,⎕UCS 10),' '
  (how∆rowmem)[524+⍳52]←'  rows as single units, and asks ''Is x[i;] a row mem'
  (how∆rowmem)[576+⍳26]←'ber of <y>?''',(,⎕UCS 10 10),'Arguments:',(,⎕UCS 10),'-'
  (how∆rowmem)[602+⍳40]←'--------',(,⎕UCS 10),'<x>   Numeric or character matr'
  (how∆rowmem)[642+⍳40]←'ix  (or scalar or vector)',(,⎕UCS 10),'   A scalar or'
  (how∆rowmem)[682+⍳45]←' vector is treated as a matrix with one row.',(,⎕UCS 10)
  (how∆rowmem)[727+⍳27]←(,⎕UCS 10),'<y>   same as <x>',(,⎕UCS 10 10),'Result:'
  (how∆rowmem)[754+⍳29]←(,⎕UCS 10),'------',(,⎕UCS 10),'<r>   Numeric vector',(,⎕UCS 10)
  (how∆rowmem)[783+⍳40]←'   r[i]=1 -- x[i;] is a row in <y>.',(,⎕UCS 10),'   r'
  (how∆rowmem)[823+⍳40]←'[i]=0 -- x[i;] is not a row in <y>.',(,⎕UCS 10),'   ('
  (how∆rowmem)[863+⍳13]←(,⎕UCS 9076),'r)=(1',(,⎕UCS 8593 9076 120 41 10 10),'E'
  (how∆rowmem)[876+⍳27]←'xamples:',(,⎕UCS 10),'--------',(,⎕UCS 10),'... Defin'
  (how∆rowmem)[903+⍳26]←'e example data.',(,⎕UCS 10),'      m1',(,⎕UCS 8592),'3'
  (how∆rowmem)[929+⍳23]←' 5',(,⎕UCS 9076),'''applebettycat  ''',(,⎕UCS 10),'  '
  (how∆rowmem)[952+⍳20]←'    m2',(,⎕UCS 8592),'''/'' ',(,⎕UCS 8710),'box ''app'
  (how∆rowmem)[972+⍳39]←'le/betty/dog/egg/farm''',(,⎕UCS 10),'      m1 beside '
  (how∆rowmem)[1011+⍳27]←''' '' beside m2',(,⎕UCS 10),'apple apple',(,⎕UCS 10),'b'
  (how∆rowmem)[1038+⍳26]←'etty betty',(,⎕UCS 10),'cat   dog',(,⎕UCS 10),'     '
  (how∆rowmem)[1064+⍳24]←' egg',(,⎕UCS 10),'      farm',(,⎕UCS 10 10),'      m'
  (how∆rowmem)[1088+⍳19]←'1 ',(,⎕UCS 8710),'rowmem m2',(,⎕UCS 10),'1 1 0',(,⎕UCS 10)
  (how∆rowmem)[1107+⍳42]←(,⎕UCS 10),'...Find all rows of m1 that are in m2.  H'
  (how∆rowmem)[1149+⍳39]←'int: To understand the next',(,⎕UCS 10),'...expressi'
  (how∆rowmem)[1188+⍳37]←'on, recall that the length of (m1 ',(,⎕UCS 8710),'ro'
  (how∆rowmem)[1225+⍳23]←'wmem m2) is 1',(,⎕UCS 8593 9076),'m1, the',(,⎕UCS 10)
  (how∆rowmem)[1248+⍳52]←'...correct size to compress m1 along the first coord'
  (how∆rowmem)[1300+⍳24]←'inate.',(,⎕UCS 10),'      (m1 ',(,⎕UCS 8710),'rowmem'
  (how∆rowmem)[1324+⍳17]←' m2)',(,⎕UCS 9023 109 49 10),'apple',(,⎕UCS 10),'bet'
  (how∆rowmem)[1341+⍳37]←'ty',(,⎕UCS 10 10),'... Find all rows of m1 not in m2'
  (how∆rowmem)[1378+⍳14]←(,⎕UCS 10),'      (',(,⎕UCS 8764),'m1 ',(,⎕UCS 8710),'r'
  (how∆rowmem)[1392+⍳18]←'owmem m2)',(,⎕UCS 9023 109 49 10),'cat',(,⎕UCS 10),'.'
  (how∆rowmem)[1410+⍳52]←'.. Now the other way around -- all rows of m2 not in'
  (how∆rowmem)[1462+⍳17]←' m1.',(,⎕UCS 10),'      (',(,⎕UCS 8764),'m2 ',(,⎕UCS 8710)
  (how∆rowmem)[1479+⍳19]←'rowmem m1)',(,⎕UCS 9023 109 50 10),'dog',(,⎕UCS 10),'e'
  (how∆rowmem)[1498+⍳26]←'gg',(,⎕UCS 10),'farm',(,⎕UCS 10),'... Numeric argume'
  (how∆rowmem)[1524+⍳24]←'nts',(,⎕UCS 10),'      (3 2',(,⎕UCS 9076),'1 2 1 4 1'
  (how∆rowmem)[1548+⍳22]←' 6) ',(,⎕UCS 8710),'rowmem 5 2',(,⎕UCS 9076),'1 2 3 '
  (how∆rowmem)[1570+⍳20]←'6 4 7 5 8 1 6',(,⎕UCS 10),'1 0 1',(,⎕UCS 10)

readme←3280⍴' ' ⍝ prolog ≡1
  (readme)[⍳51]←'                  The Toronto ACM SIGAPL Toolkit ',(,⎕UCS 10),' '
  (readme)[51+⍳45]←'                          Version 2.1',(,⎕UCS 10),'       '
  (readme)[96+⍳43]←'                     1992-05-12',(,⎕UCS 10 10),'The Toront'
  (readme)[139+⍳57]←'o Toolkit is a collection of useful ISO Standard APL util'
  (readme)[196+⍳44]←'ity ',(,⎕UCS 10),'functions collected by the Toronto Chap'
  (readme)[240+⍳44]←'ter of ACM SIGAPL, and provided ',(,⎕UCS 10),'without cha'
  (readme)[284+⍳46]←'rge as a service to the computing community.',(,⎕UCS 10 10)
  (readme)[330+⍳57]←'The functions conform to the 1984 ISO (International Stan'
  (readme)[387+⍳44]←'dards Organization) ',(,⎕UCS 10),'APL Standard N8485.    '
  (readme)[431+⍳42]←'               ',(,⎕UCS 10 10),'The Toronto Chapter of AC'
  (readme)[473+⍳45]←'M SIGAPL is a group of people interested in',(,⎕UCS 10),'A'
  (readme)[518+⍳42]←'PL, based in Toronto, Canada.  ',(,⎕UCS 10 10),'         '
  (readme)[560+⍳42]←'                Using the Toolkit',(,⎕UCS 10 10),'The Too'
  (readme)[602+⍳51]←'lkit consists of APL workspaces for SHARP APL, APL',(,⎕UCS 8902)
  (readme)[653+⍳44]←'PLUS, ',(,⎕UCS 10),'IBM APL2, and DYALOG APL systems, as '
  (readme)[697+⍳44]←'well as an ISO Workspace Interchange',(,⎕UCS 10),'format '
  (readme)[741+⍳57]←'file. Loading the workspace "toolkit" from one of these s'
  (readme)[798+⍳44]←'ystems, then ',(,⎕UCS 10),'typing "describe", will lead y'
  (readme)[842+⍳47]←'ou through a description of the workspace and ',(,⎕UCS 10)
  (readme)[889+⍳42]←'its documentation. ',(,⎕UCS 10 10),'                     '
  (readme)[931+⍳42]←'    Distribution Policy',(,⎕UCS 10 10),'All functions in '
  (readme)[973+⍳47]←'these workspaces are Copyright (c) 1992 by the',(,⎕UCS 10)
  (readme)[1020+⍳56]←'author of the function or by the Toronto Chapter of ACM '
  (readme)[1076+⍳43]←'SIGAPL.',(,⎕UCS 10),'However, the Toronto Chapter of SIG'
  (readme)[1119+⍳43]←'APL is making this toolkit available',(,⎕UCS 10),'with t'
  (readme)[1162+⍳56]←'he understanding that any or all of the contents may be '
  (readme)[1218+⍳43]←'freely',(,⎕UCS 10),'reproduced and/or used.  No charge m'
  (readme)[1261+⍳43]←'ay be made except to cover the',(,⎕UCS 10),'cost, if any'
  (readme)[1304+⍳41]←', of reproduction and distribution.',(,⎕UCS 10 10),'It i'
  (readme)[1345+⍳55]←'s the best understanding of the Group that no copyright'
  (readme)[1400+⍳46]←(,⎕UCS 10),'and/or proprietary rights pertaining to the c'
  (readme)[1446+⍳43]←'ontributed functions will be',(,⎕UCS 10),'infringed in s'
  (readme)[1489+⍳55]←'o doing.  If this is not so, please inform the Toolkit',(,⎕UCS 10)
  (readme)[1544+⍳41]←'editor at the address noted below.',(,⎕UCS 10 10),'     '
  (readme)[1585+⍳41]←'                          Credit',(,⎕UCS 10 10),'Credit '
  (readme)[1626+⍳55]←'should be given the Toronto Chapter of ACM SIGAPL when',(,⎕UCS 10)
  (readme)[1681+⍳56]←'distributing this workspace.  The source note (.n taglin'
  (readme)[1737+⍳43]←'e), where present',(,⎕UCS 10),'in a function, should be '
  (readme)[1780+⍳46]←'preserved without alteration when separately ',(,⎕UCS 10)
  (readme)[1826+⍳49]←'publishing or distributing any toolkit function.',(,⎕UCS 10)
  (readme)[1875+⍳56]←'This readme file should be distributed along with the wo'
  (readme)[1931+⍳43]←'rkspaces and',(,⎕UCS 10),'Workspace Interchange files (.'
  (readme)[1974+⍳44]←'wsi) when copying or sharing the toolkit.',(,⎕UCS 10 10),'T'
  (readme)[2018+⍳56]←'he Toolkit project was begun in 1983 and has progressed '
  (readme)[2074+⍳43]←'through two versions ',(,⎕UCS 10),'(a manual in 1985 and'
  (readme)[2117+⍳55]←' 1988) and has now progressed to version 2.1, the most',(,⎕UCS 10)
  (readme)[2172+⍳56]←'complete version so far, in machine-readable format. The'
  (readme)[2228+⍳39]←' toolkit was',(,⎕UCS 10),'edited by Richard Levine.',(,⎕UCS 10)
  (readme)[2267+⍳42]←(,⎕UCS 10),'                              Disclaimer',(,⎕UCS 10)
  (readme)[2309+⍳46]←(,⎕UCS 10),'No warranty or liability on the part of the T'
  (readme)[2355+⍳43]←'oronto Chapter of ACM SIGAPL ',(,⎕UCS 10),'for the Toolk'
  (readme)[2398+⍳49]←'it, either for the original distribution, or any',(,⎕UCS 10)
  (readme)[2447+⍳56]←'subsequent distribution by individuals or organizations '
  (readme)[2503+⍳43]←'distributing or',(,⎕UCS 10),'using the Toolkit, is expre'
  (readme)[2546+⍳46]←'ssed or implied by any statement appearing in',(,⎕UCS 10)
  (readme)[2592+⍳41]←'the Toolkit or version thereof.',(,⎕UCS 10 10),'        '
  (readme)[2633+⍳43]←'                 For Further Information',(,⎕UCS 10 10),'F'
  (readme)[2676+⍳56]←'or further information about the Toolkit, including comm'
  (readme)[2732+⍳43]←'ents, questions,',(,⎕UCS 10),'additions, and corrections'
  (readme)[2775+⍳43]←', feel free to contact the Toolkit editor',(,⎕UCS 10),'a'
  (readme)[2818+⍳41]←'t the address below.',(,⎕UCS 10 10),'For further informa'
  (readme)[2859+⍳43]←'tion about the Toronto Chapter of the ACM',(,⎕UCS 10),'A'
  (readme)[2902+⍳56]←'PL SIG, and for information about joining SIGAPL or ACM,'
  (readme)[2958+⍳30]←' write to:',(,⎕UCS 10),'    ',(,⎕UCS 10),'    Toronto AP'
  (readme)[2988+⍳43]←'L Special Interest Group,',(,⎕UCS 10),'    P.O. Box 384,'
  (readme)[3031+⍳43]←' Adelaide Street Station,',(,⎕UCS 10),'    Toronto, Onta'
  (readme)[3074+⍳28]←'rio, Canada.',(,⎕UCS 10),'    M5C 2J5',(,⎕UCS 10 10),'Fo'
  (readme)[3102+⍳56]←'r current phone numbers for the Toolkit editor or any ot'
  (readme)[3158+⍳43]←'her member of',(,⎕UCS 10),'the executive, refer to a cur'
  (readme)[3201+⍳44]←'rent issue of the SIG newsletter, or write',(,⎕UCS 10),'t'
  (readme)[3245+⍳35]←'o the editor at the above address.',(,⎕UCS 10)

toolkitlist←155 15⍴0 ⍝ prolog ≡1
  (,toolkitlist)[⍳55]←'adjust         after          amortize       arabic    '
  (,toolkitlist)[55+⍳52]←'     array          bal            balance        ba'
  (,toolkitlist)[107+⍳51]←'se           beside         boxf           box1    '
  (,toolkitlist)[158+⍳51]←'       bp             browse         catoffun      '
  (,toolkitlist)[209+⍳51]←' cdays          change         checksize      check'
  (,toolkitlist)[260+⍳51]←'subroutinecjulian        comments       condense   '
  (,toolkitlist)[311+⍳51]←'    condense1      contents       contents1      cp'
  (,toolkitlist)[362+⍳51]←'ucon         date           days           ddup    '
  (,toolkitlist)[413+⍳51]←'       deltag         dfh            dimension     '
  (,toolkitlist)[464+⍳51]←' displayfunctiondround         ds             dstat'
  (,toolkitlist)[515+⍳51]←'          duparray       duparray1      easter     '
  (,toolkitlist)[566+⍳51]←'    example        expandaf       expandbe       ex'
  (,toolkitlist)[617+⍳51]←'plain        fagl           fcpucon        fdate   '
  (,toolkitlist)[668+⍳51]←'       fdmy           fgl            fglr          '
  (,toolkitlist)[719+⍳51]←' fi             fibspiral      field          findc'
  (,toolkitlist)[770+⍳51]←'oords     findut         first          fisodate   '
  (,toolkitlist)[821+⍳51]←'    fixuparray     fnlist         frame          ft'
  (,toolkitlist)[872+⍳51]←'ime          funsincat      gettag         getvtag '
  (,toolkitlist)[923+⍳51]←'       global         gradeup        gradeup1      '
  (,toolkitlist)[974+⍳51]←' grafd          hfd            hist           jc   '
  (,toolkitlist)[1025+⍳50]←'          jl             jr             julian    '
  (,toolkitlist)[1075+⍳50]←'     loop           matacross      matdown        '
  (,toolkitlist)[1125+⍳50]←'matrix         mdyoford       moonphase      nl   '
  (,toolkitlist)[1175+⍳50]←'          on             ordofmdy       out       '
  (,toolkitlist)[1225+⍳50]←'     outclose       outheader      outopen        '
  (,toolkitlist)[1275+⍳50]←'outpage        patterng       payday         pick '
  (,toolkitlist)[1325+⍳50]←'          pickn          pnrot          print     '
  (,toolkitlist)[1375+⍳50]←'     prompt         puttag         qstop          '
  (,toolkitlist)[1425+⍳50]←'qtrace         range          reformat       repar'
  (,toolkitlist)[1475+⍳50]←'ray       reparray1      report         reporthead'
  (,toolkitlist)[1525+⍳50]←'er   riota          rnd            rnde           '
  (,toolkitlist)[1575+⍳50]←'roman          scatter        script         searc'
  (,toolkitlist)[1625+⍳50]←'h         shares         signalerror    sixline   '
  (,toolkitlist)[1675+⍳50]←'     sort           sortl          sortlocal      '
  (,toolkitlist)[1725+⍳50]←'split          sr             srn            ss   '
  (,toolkitlist)[1775+⍳50]←'          ssn            stemleaf       stoptrace '
  (,toolkitlist)[1825+⍳50]←'     subtotal       suppress       thru           '
  (,toolkitlist)[1875+⍳50]←'time           timer          timetrace      timin'
  (,toolkitlist)[1925+⍳50]←'g         tower          triangle       unbox     '
  (,toolkitlist)[1975+⍳50]←'     union          ved            vedit          '
  (,toolkitlist)[2025+⍳50]←'veq            vi             vnames         vpis '
  (,toolkitlist)[2075+⍳50]←'          vrepl          vtype          wildcard  '
  (,toolkitlist)[2125+⍳35]←'     xfade          ',(,⎕UCS 8710),'              '
  (,toolkitlist)[2160+⍳23]←(,⎕UCS 8710),'box           ',(,⎕UCS 8710),'centh  '
  (,toolkitlist)[2183+⍳23]←'       ',(,⎕UCS 8710),'centt         ',(,⎕UCS 8710)
  (,toolkitlist)[2206+⍳30]←'db            ',(,⎕UCS 8710),'dc            ',(,⎕UCS 8710)
  (,toolkitlist)[2236+⍳30]←'dlb           ',(,⎕UCS 8710),'dlc           ',(,⎕UCS 8710)
  (,toolkitlist)[2266+⍳30]←'dtb           ',(,⎕UCS 8710),'dtc           ',(,⎕UCS 8710)
  (,toolkitlist)[2296+⍳29]←'if            ',(,⎕UCS 8710),'rowmem        '

⎕PW←10000

]NEXTFILE

-------------------------------------------------------------------------------

Notes by Fred Weigel:

                       The Toronto Toolkit 
                           Release 2.1
                            
This is a version of the Toronto Toolkit Release 2.1 for GNU APL.
g∆cr is changed to ⎕UCS 10, and ⎕PW←10000. ⎕PW is changed
so that long character vectors are correctly displayed. All string
variables have had ⎕UCS 13 changed to ⎕UCS 10 for the Unix
environment.

No other changes have been made. The format is a GNU APL )DUMP file,
which can used with )LOAD or )COPY. As far as I know, the toolkit
would then qualify as a "L1" compatibility level library.

License does not appear (in my opinion) to be GPL compatible, in that
no charge (except for reproduction and distribution costs) may be
made for the material. I do not know if routines may be incorporated
into commercial programs -- get your own legal advice on that matter.

Original "readme" files are reproduced below, reformatted to fit in a
72 character right margin.

readme.txt =============================================================

                  The Toronto ACM SIGAPL Toolkit 
                           Version 2.1
                            1992-05-12

The Toronto Toolkit is a collection of useful ISO Standard APL
utility functions collected by the Toronto Chapter of ACM SIGAPL,
and provided without charge as a service to the computing community.

The functions conform to the 1984 ISO (International Standards
Organization) APL Standard N8485.

The Toronto Chapter of ACM SIGAPL is a group of people interested in
APL, based in Toronto, Canada.

                         Using the Toolkit

The Toolkit consists of APL workspaces for SHARP APL, APL*PLUS, IBM
APL2, and DYALOG APL systems, as well as an ISO Workspace Interchange
format file. Loading the workspace "toolkit" from one of these systems,
then typing "describe", will lead you through a description of the
workspace and its documentation.

                         Distribution Policy

All functions in these workspaces are Copyright (c) 1992 by the author
of the function or by the Toronto Chapter of ACM SIGAPL.  However,
the Toronto Chapter of SIGAPL is making this toolkit available with the
understanding that any or all of the contents may be freely reproduced
and/or used.  No charge may be made except to cover the cost, if any,
of reproduction and distribution.

It is the best understanding of the Group that no copyright and/or
proprietary rights pertaining to the contributed functions will be
infringed in so doing.  If this is not so, please inform the Toolkit
editor at the address noted below.

                               Credit

Credit should be given the Toronto Chapter of ACM SIGAPL when
distributing this workspace.  The source note (.n tagline), where
present in a function, should be preserved without alteration
when separately publishing or distributing any toolkit function.
This readme file should be distributed along with the workspaces and
Workspace Interchange files (.wsi) when copying or sharing the toolkit.

The Toolkit project was begun in 1983 and has progressed through
two versions (a manual in 1985 and 1988) and has now progressed to
version 2.1, the most complete version so far, in machine-readable
format. The toolkit was edited by Richard Levine.

                              Disclaimer

No warranty or liability on the part of the Toronto Chapter of ACM
SIGAPL for the Toolkit, either for the original distribution, or any
subsequent distribution by individuals or organizations distributing or
using the Toolkit, is expressed or implied by any statement appearing
in the Toolkit or version thereof.

                         For Further Information

For further information about the Toolkit, including comments,
questions, additions, and corrections, feel free to contact the
Toolkit editor at the address below.

For further information about the Toronto Chapter of the ACM APL SIG,
and for information about joining SIGAPL or ACM, write to:

    Toronto APL Special Interest Group,
    P.O. Box 384, Adelaide Street Station,
    Toronto, Ontario, Canada.
    M5C 2J5

For current phone numbers for the Toolkit editor or any other member
of the executive, refer to a current issue of the SIG newsletter,
or write to the editor at the above address.

rel21.txt ==============================================================

                  The Toronto ACM SIGAPL Toolkit 
                           Version 2.1
                            1992-06-04

The Toronto Toolkit is a collection of useful ISO Standard APL
utility functions collected by the Toronto Chapter of ACM SIGAPL,
and provided without charge as a service to the computing community.

The functions conform to the 1984 ISO (International Standards
Organization) APL Standard N8485.

The Toronto Chapter of ACM SIGAPL is a group of people interested in
APL, based in Toronto, Canada.

                         Accessing the Toolkit

The Toolkit file (Toolkit.zip) is a compressed file containing several
smaller files, each one being the Toolkit in a different format.  Here
is the procedure to access the Toolkit -- it assumes Toolkit.zip is on
the DOS diskette (device b:) on which it was originally distributed.
(If this is not the case, please make the appropriate changes to
the procedure.)

First of all, it is a good idea to make a new subdirectory
(mkdir xxx) on the hard disk, and change to that directory (chdir
xxx). Then uncompress Toolkit.zip by executing pkunzip (b:pkunzip.exe
b:Toolkit.zip).  After the "unzip" operation is complete, the directory
will contain the Toolkit in files of several formats:

     (.saw)  Sharp PC APL workspace
     (.apl)  IBM PC APL2 (32 bit) workspace
     (.ws )  STSC APL*PLUS II (Version 3) workspace
     (.atf)  APL2 apl transfer format
     (.slt)  STSC source level transfer format
     (.wsi)  WSIS0 interchange transfer format

The size of the workspace is about 500k bytes.

The files in "workspace" format should be accessible via a )LOAD
command from the respective interpreter, although the workspace may
need to be moved to a different directory before APL can access
it.  The files in "transfer" format should be accessible using
vendor-supplied procedures for the respective APL; for example, the
STSC .slt file is input to the vendor-supplied SLT workspace. The
user is expected to know the particular procedures and restrictions
that apply for using these transfer format files.

(Note that these files have not been tested for all combinations of
versions and machines, so unexpected compatibility difficulties not
mentioned here may arise.)

(Note also that a format for Dyalog APL has not been provided in
the original distribution of Version 2.1.  However, this and other
formats may be created and provided by other organizations, and the
Toronto SIG encourages this activity.)

Each workspace contains the complete Toolkit. Loading the workspace
"toolkit" for one of these systems, then typing "describe", will
provide a description of the workspace and its documentation.

                         Distribution Policy

All functions in these workspaces are Copyright (c) 1992 by the author
of the function or by the Toronto Chapter of ACM SIGAPL.  However,
the Toronto Chapter of SIGAPL is making this toolkit available with
the understanding that any or all of the contents may be freely
reproduced and/or used.  No charge should be made except to cover
the cost, if any, of reproduction and distribution.

It is the best understanding of the Group that no copyright and/or
proprietary rights pertaining to the contributed functions will be
infringed in so doing.  If this is not so, please inform the Toolkit
editor at the address noted below.

                               Credit

Credit should be given the Toronto Chapter of ACM SIGAPL when
distributing this workspace.  The source note (.n tagline), where
present in a function, should be preserved without alteration
when separately publishing or distributing any toolkit function.
This readme file should be distributed along with the workspaces and
Workspace Interchange files when copying or sharing the toolkit.

The Toolkit project was begun in 1983 and has progressed through
two versions (a manual in 1985 and 1988) and has now progressed to
version 2.1, the most complete version so far, in machine-readable
format. The toolkit was edited by Richard Levine.

                              Disclaimer

No warranty or liability on the part of the Toronto Chapter of ACM
SIGAPL for the Toolkit, either for the original distribution, or any
subsequent distribution by individuals or organizations distributing or
using the Toolkit, is expressed or implied by any statement appearing
in the Toolkit or version thereof.

                         For Further Information

For further information about the Toolkit, including comments,
questions, additions, and corrections, feel free to contact the
Toolkit editor at the address below.

For further information about the Toronto Chapter of the ACM APL SIG,
and for information about joining SIGAPL or ACM, write to:

    Toronto APL Special Interest Group,
    P.O. Box 384, Adelaide Street Station,
    Toronto, Ontario, Canada.
    M5C 2J5

For current phone numbers for the Toolkit editor or any other member
of the executive, refer to a current issue of the SIG newsletter,
or write to the editor at the above address.

announc.txt ============================================================

Toronto ToolKit - Current Work on Release 3
Richard Levine, Toronto Toolkit Editor
June 8, 1994

The Toronto Toolkit is currently at Release 2.1.  It is a collection of
150 APL "utility" functions developed by the Toronto APL SIG (Special
Interest Group).  It was released as freeware in computer-readable
format in May 1992 and has been widely distributed and favourably
reviewed within the APL community.  It is also included at no charge
with ISI (Sharp) APL (Iverson Software) and APL 68000 (MicroAPL).
Currently the Toolkit comprises about 150K of functions, and about
350K of documentation.

We are now working on Release 3 of the Toolkit.

As Toolkit editor, I am actively soliciting contributions and enhancing
functions in preparation for Release 3 of the Toolkit.  We cannot
give a precise release date because we intend to take whatever time is
required to maintain the Toolkit's committment to and reputation for
reliability, but we intend that when it is released, it will be great!

For Release 3 we intend to strengthn the Toolkit in the following areas:

	(1) Many Toolkit functions enhanced and generalized.
	(2) Significant enhancements to functions in the programming
	    tools category (e.g. reports for x-ref, calling trees, ws
	    changes).
	(3) New toolkit categories such as prompting utilities,
	    workspace "describe" utilities, APL-ASCII transliteration,
	    etc.
	(4) More consistent arguments such as the consistent use of
            "control" values in the left argument, and the removal of
            global arguments in favour of explicit arguments.
	(5) Improved Naming Conventions.
	(6) Use of a simple method for copying (and removing!) Toolkit
            functions and subfunctions.
        (7) More sophisticated "packaging", and support of more APL
            systems.

All this work follows the original Toolkit committment to the
1984 ISO (International Standards Organization) APL Standard N8485.
Incidentally, even thought the Toolkit is written in ISO-standard APL,
it can benefit from non-ISO-standard features of 2nd-gneration APLs.
The Toolkit is based on a core of clearly defined subfunctions that may
be re-defined using 2nd-generation primitives (such as string-search,
character grade-up, cut conjunction for matrix creation, etc.) if so
desired.  Furthermore, the fact of conformity means that the Toolkit
is executable on all APLs, and this has proved an immensely valuable
feature for many users.


"Packaging" of Release 3

One area being worked on is the "packaging" of Release 3.  It is
anticipated that Release 3 will be distributed in several workspace
formats, one workspace for each APL system.  Each workspace will
contain the toolkit functions, and minimal supplementary documentation.
It is currently anticated that we will provide workspaces in the
following formats: Sharp APL (Iverson Software), APL-PLUS PC, APL-PLUS
VERSION II, APL2/PC, Dyalog APL, and APL/68000.  Interchange formats
(WSIS0, APL-ASCII transliteration, and APL2 ATF) will be provided to
help other vendors and users port the toolkit to their systems.

The supplementary documentation will be in a separate directory of
DOS files in APL-ASCII transliteration.  Each workspace will contain
(system- specific) functions to read DOS files, and translate from
ASCII to APL internal format; also included will be ISO-standard
functions to translate from ASCII transliteration to standard APL
symbols.

The anticipated advantages of this method will be to significantly
reduce the size of the active Toolkit workspace, and to make the bulk
of the documentation immediately available using any editor capable
of reading .TXT (standard text) files.


Contributions welcome

If you would like to contribute utilities or ideas for Release 3,
please contact the Toolkit editor at any time.  You may reach him by
phone at 416-781-4198.  However, long-distance phone replies cannot
be handled at this time.

For two-way communication, it is probably more cost-effective to use
e-mail c/o Internet address: richard.levine@canrem.com

Or use post mail c/o:
Toronto APL SIG,
Attention: Toolkit Editor
P.O.Box 384, Adelaide Street Station,
Toronto, Ontario, Canada
M5C 2J5

Take this opportunity to see your ideas incorporated into this very
useful set of APL functions!

sig.txt ================================================================

The Toronto ACM Special Interest Group on APL
MAY, 1994

The Toronto ACM Special Interest Group (SIG) on APL is a professional
organization that is a chapter of the Association for Computing
Machinery (ACM). The Toronto SIG was founded in the early 1980s and
became associated with the ACM in 1992.

The SIG meets once a month from September to May except for
December. We are interested in all `Array Processing Languages'
and present topics of interest to APL users, developers, implementors.

Formally, the scope of the SIG is to pursue "the scientific and
technical aspects of APL as well as the practical and theoretical
approaches to topics of interest to APL users, developers,
implementors, and theoreticians. Topics include the usage, design,
environment, development, education, and application of APL." The
SIG focuses not only on APL but on any 'Array Processing' Language.

Our monthly SIG meetings typically feature a speaker or a workshop.
These provide an opportunity for members to share ideas and learn
about industry developments. Vendors of APL products and services are
periodically invited to give demonstrations at the SIG meetings. Recent
speaker topics have highlighted developments in the Windows environment
for various APL languages, applications of APL and J to business
and graph theory research, performance analysis, APL in education,
and APL based statistical and modelling packages. There are currently
over 60 paid members. In addition, the SIG maintains a mailing list
of many related companies and individuals in the Toronto area.

Our monthly newsletter, called "Gimme Arrays!", is distributed to
members and over 30 APL SIGs worldwide. "Gimme Arrays!" provides a
medium for discussion and keeps members up to date with the activities
of the Toronto and other. The monthly meetings are reviewed in the
newsletter along with other industry related articles and information.
Wealso encourage advertising of relevant products and services.

"The APL Skills Database" is maintained by the SIG to help match
employers seeking APL consultants or staff with SIG members looking
for related employment.

"The Toronto Toolkit" is a freeware library of APL utilities that
are used by APL professionals and companies around the world.

Subcommittees exist from time to time as special opportunities arise.
For example, right now there is a subcommittee to teach the J
language and promote an understanding of its application.

Funds generated from the modest membership fee and advertising are
used to produce and distribute the newsletter, to reimburse speakers'
travel costs, and other special projects such as education seminars.

In August, 1993, the SIG hosted the 1993 international conference on
APL. Over 350 delegates attended from around the world including nine
from the former Soviet Union.

The SIG is establishing relationships with other ACM units and
APL-related industries such as the actuarial, educational, and
financial communities. We welcome participation and are particularly
interested in speakers, articles for the newsletter, or special
projects.

Please consider the Toronto SIG as a partner to your personal or
professional activities! For more information contact The Toronto
ACM SIGAPL at:

  P.O. Box 384, Adelaide Street Post Office, Toronto, Ontario, Canada, M5C 2J5

  Chair - Cameron Linton, crl@ipsalab.tor.soliton.com, phone 416-364-5361
  Secretary and Newsletter Editor - Marc Griffiths, marcg@utcc.utoronto.ca
  Treasurer and Membership - Eric Granz, phone 416-980-7149
  Information Co-ordinator - Richard Procter, rjprocter@ipsalab.tor.soliton.com


⍝ EOF 
