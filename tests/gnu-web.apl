#!/usr/local/bin/apl --script --

0 0⍴⍎')COPY 5 HTML.apl'

⍝ This is an APL CGI script that demonstrates the use of APL for CGI scripting
⍝ It outputs an HTML page like GNU APL's homepage at www.gnu.org.
⍝

⍝ Variable name conventions:
⍝
⍝ Variables starting with x, e.g. xB, are strings (simple vectors of
⍝ characters), i.e. 1≡ ≡xB and 1≡''⍴⍴⍴xB
⍝
⍝ Variables starting with y are vectors of character strings,
⍝ i.e. 2≡ ≡yB and 1≡''⍴⍴⍴yB
⍝
⍝ Certain characters in function names have the following meaning:
⍝
⍝ T - start tag
⍝ E - end tag
⍝ X - attributes

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

      ⍝ Disable coloured output and avoid APL line wrapping
      ⍝
      ]COLOR OFF
      ⎕PW←1000

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝
⍝ Document variables. Set them to '' so that they are always defined.
⍝ Override them in the document section (after )SAVE) as needed.
⍝
xTITLE←'<please-set-xTITLE>'
xDESCRIPTION←'<please-set-xDESCRIPTION>'

yBODY←0⍴'<please-set-yBODY>'

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ The content of the HTML page
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Return xHTTP_GNU or xHTTP_JSA
⍝ depending on the CGI variable SERVER_NAME
⍝
∇xZ←Home;xS
 xS←⊃(⎕⎕ENV 'SERVER_NAME')[;⎕IO + 1]
 xZ←"192.168.0.110/apl"    ⍝ Jürgen's home ?
 →(S≡'192.168.0.110')/0    ⍝ yes, this script was called by apache
 →(S≡'')/0                 ⍝ yes, this script called directly
 xZ←xHTTP_GNU,'/apl'       ⍝ no
∇

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ set xTITLE and xDESCRIPTION that go into the HEAD section of the page
⍝
xTITLE←'GNU APL'
xDESCRIPTION←'Welcome to GNU APL'

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ some URIs used in the BODY
⍝
xHTTP_GNU←"http://www.gnu.org/"
xHTTP_JSA←"http://192.168.0.110/apl/"
xFTP_GNU←"ftp://ftp.gnu.org"
xFTP_APL←xFTP_GNU,"/gnu/apl"
xCYGWIN←"www.cygwin.org"
xMIRRORS←'http://www.gnu.org/prep/ftp.html'
xGNU_PIC←HTML∆__src xHTTP_GNU, "graphics/gnu-head-sm.jpg"

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ some file names used in the BODY
⍝
xAPL_VERSION←'apl-1.5'
xTARFILE←xAPL_VERSION,  '.tar.gz'
xRPMFILE←xAPL_VERSION,  '-0.i386.rpm'
xSRPMFILE←xAPL_VERSION, '-0.src.rpm'
xDEBFILE←xAPL_VERSION,  '-1_i386.deb'
xSDEBFILE←xAPL_VERSION, '-1.debian.tar.gz'
xAPL_TAR←xFTP_GNU, '/', xTARFILE
xMAIL_GNU←'gnu@gnu.org'
xMAIL_WEB←'bug-apl@gnu.org'
xMAIL_APL←'bug-apl@gnu.org'
xMAIL_APL_ARCHIVE←'http://lists.gnu.org/archive/html/bug-apl/'
xMAIL_APL_SUBSCRIBE←'https://lists.gnu.org/mailman/listinfo/bug-apl'
xSVN_APL←'https://savannah.gnu.org/svn/?group=apl'

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ some features of GNU APL
⍝
yFEATURES←           ⊂ 'nested arrays and related functions'
yFEATURES←yFEATURES, ⊂ 'complex numbers, and'
yFEATURES←yFEATURES, ⊂ 'a shared variable interface'
yFEATURES←HTML∆Ul yFEATURES

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Installation instructios
⍝
∇yZ←INSTALL;I1;I2;I3;I4
I1←      'Visit one of the ', xMIRRORS HTML∆A 'GNU mirrors'
I1←  I1, ' and download the tar file <B>', xTARFILE,'</B> in directory'
I1←⊂ I1, ' <B>apl</B>.'
I2←⊂     'Unpack the tar file: <B>tar xzf ', xTARFILE, '</B>'
I3←⊂     'Change to the newly created directory: <B>cd ', xAPL_VERSION, '</B>'
I4←      'Read (and follow) the instructions in files <B>INSTALL</B>'
I4←⊂ I4, ' and <B>README-*</B>'
yZ←⊃ HTML∆Ol I1, I2, I3, I4
∇

      ⍝ ⎕INP acts like a HERE document in bash. The monadic form ⎕INP B
      ⍝ reads subsequent lines from the input (i.e. the lines below ⎕INP
      ⍝ if ⎕INP is called in a script) until pattern B is seen. The lines
      ⍝ read are then returned as the result of ⎕INP.
      ⍝
      ⍝ The dyadic form A ⎕INP B acts like the monadic form ⎕INP B.
      ⍝ A is either a single string or a nested value of two strings.
      ⍝
      ⍝ Let A1←A2←A if A is a string or else A1←A[1] and A2←A[2] if A is
      ⍝ a nested 2-element vector containing two strings.
      ⍝
      ⍝ Then every pattern A1 expression A2 is replaced by ⍎ expression.
      ⍝
      ⍝ We first give an example of ⎕INP in the style of PHP and another,
      ⍝ more compact, example further down below.
      ⍝
      yBODY← '<?apl' '?>' ⎕INP 'END-OF-⎕INP'   ⍝ php style

<DIV class="c1">
<?apl HTML∆H1[''] xTITLE ?>
<TABLE>
  <TR>
    <TD> <?apl HTML∆Img[xGNU_PIC, (HTML∆_alt 'Astrid'), HTML∆__h_w 122 129] 1 ?>
    <TD style="width:20%">
    <TD><I> Rho, rho, rho of X<BR>
         Always equals 1<BR>
         Rho is dimension, rho rho rank.<BR>
         APL is fun!</I><BR>
         <BR>
         <B>Richard M. Stallman</B>, 1969<BR>
  </TR>
</TABLE>

<BR><BR><BR>
</DIV>
<DIV class="c2">
<B>GNU APL</B> is a free interpreter for the programming language APL.
<BR><BR>
The APL interpreter is an (almost) complete implementation of
<I><B>ISO standard 13751</B></I> aka.
<I><B>Programming Language APL, Extended.</B></I>
<BR>
<BR>
The APL interpreter has implemented:
<?apl ⊃ yFEATURES ?>

In addition, <B>GNU APL</B> can be scripted. For example,
<?apl HTML∆x2y 'APL_demo.html' HTML∆A "<B>this HTML page</B>" ?>
is the output of a CGI script written in APL.
<BR>
<BR>
GNU APL was written and is being maintained by Jürgen Sauermann.
</DIV>
<DIV class="c3">

<?apl HTML∆H2[''] 'Downloading and Installing GNU APL' ?>
GNU APL should be available on every 
<?apl  xMIRRORS HTML∆A 'GNU mirror' ?>
(in directory <B>apl</B>) and at
<?apl  xFTP_APL HTML∆A xFTP_GNU ?>.

<?apl HTML∆H4[''] 'Normal Installation of GNU APL' ?>
The normal (and fully supported) way to install GNU APL is this:

<?apl ⊃ INSTALL ?>

<?apl HTML∆H4[''] 'GNU APL for WINDOWs' ?>

GNU APL compiles under CYGWIN, (see
<?apl  ('http://',xCYGWIN) HTML∆A xCYGWIN ?>),
provided that the necessary libraries are installed. A 32-bit <B>apl.exe</B>
that may run under CYGWIN lives in the download area. Use at your own risk and
see <B>README-5-WINDOWS</B> for further information.

<?apl HTML∆H4[''] 'Subversion (SVN) repository for GNU APL' ?>

You can also check out the latest version of GNU APL from its subversion
repository on Savannah:
<BR>
<BR>
<B>svn co http://svn.savannah.gnu.org/svn/apl/trunk</B>.
<BR>
<BR>
Here is <?apl HTML∆x2y xSVN_APL HTML∆A "<EM>more information</EM>" ?>
about using Subversion with GNU APL.

<?apl HTML∆H4[''] 'RPMs for GNU APL' ?>

For RPM based GNU/Linux distributions we have created source and binary RPMs.
Look for files <B><?apl xRPMFILE ?></B> (binary RPM for i386) or 
<B><?apl xSRPMFILE ?></B> (source RPM). If you encounter a problem with these
RPMs, then please report it, but with a solution, since the maintainer of
GNU APL may use a GNU/Linux distribution with a different package manager.

<?apl HTML∆H4[''] 'Debian packages for GNU APL' ?>

For Debian based GNU/Linux distributions we have created source and binary 
packages for Debian. Look for files <B><?apl xDEBFILE ?></B> (binary Debian
package for i386) or <B><?apl xSDEBFILE ?></B> (Debian source package).
If you encounter a problem with these packages, then please report it,
but with a solution, since the maintainer of GNU APL may use a GNU/Linux
distribution with a different package manager.

<?apl HTML∆H4[''] 'GNU APL Binary' ?>

If you just want to quickly give GNU APL a try, and if you are very lucky
then you may be able to start the compiled
GNU APL binary <B>apl</B> in the directory <B>apl</B> rather than 
installing the entire packet . The binary MAY run on a 32-bit i686 Ubuntu.
Chances are, however, that it does NOT work, Please DO NOT report any
problems if the binary does not run on your machine. Instead use the standard
installation method above.
<BR><BR>
<B>Note:</B> The program <B>APnnn</B> (a support program for shared variables)
is not provided in binary form, so you should start the <B>apl</B> binary with
command line option --noSV. Note as well that the binary <B>apl</B> will not
be updated with every GNU APL release. Therefore it will contain errors that
have been corrected already.
</DIV>
<DIV class="c4">
<?apl HTML∆H2[''] 'Reporting Bugs' ?>

GNU APL is made up of more than 75,000 lines of C++ code. In a code of that
size, programming mistakes are inevitable. Even though mistakes are hardly
avoidable, they can be <B>corrected</B> once they are found. In order to
improve the quality of GNU APL, we would like to encourage you to report
errors that you find in GNU APL to
<?apl HTML∆x2y ("mailto:", xMAIL_APL) HTML∆A "<EM>", xMAIL_APL, "</EM>" ?>.
<BR><BR>
The emails that we like the most are those that include a small example of
 how to reproduce the fault. You can see all previous postings to this mailing
list at 
<?apl HTML∆x2y xMAIL_APL_ARCHIVE HTML∆A "<B>", xMAIL_APL_ARCHIVE,"</B>" ?>
or subscribe to it at 
<?apl HTML∆x2y xMAIL_APL_SUBSCRIBE HTML∆A "<B>", xMAIL_APL_SUBSCRIBE,"</B>" ?>
</DIV>
<DIV class="c5">
<?apl HTML∆H2[''] 'Documentation' ?>
We have an <?apl HTML∆x2y 'apl.html' HTML∆A "<B>info manual</B>" ?> for GNU APL.

We are also looking for <B>free</B> documentation on APL in general
(volunteers welcome) that can be published here. A "Quick start" document
for APL is planned but the work has not started yet.
<BR><BR>
The C++ source files for GNU APL are Doxygen documented. You can generate
this documentation by running <B>make DOXY</B> in the top level directory
of the GNU APL package.
</DIV>
<DIV class="c6">
<?apl HTML∆H2[''] 'GNU APL Community' ?>
There is a growing group of people that are using GNU APL and that have made
their own developments related to APL available to the public.
We have created a
<?apl  'Community.html' HTML∆A '<b>GNU APL Community Web page</b>' ?>
that collects <B>links</B> to those developments to avoid that they get lost.
<BR><BR>
In addition, we maintain a 
<?apl  'Bits_and_Pieces/' HTML∆A '<b>Bits-and-Pieces</b>' ?> directory
where we collect <B>files</B> that contain APL code sniplets, GNU APL
workspaces, and other files that were contributed by the GNU APL Community.
The Bits-and-Pieces directory is the right place for contributions for which
the creation of an own hosting account would be an overkill.

</DIV>

END-OF-⎕INP


      ⍝ the text above used an 'escape style' similar to PHP
      ⍝ (using <?apl ... ?> instead of <?php ... ?>). This style also
      ⍝ resembles the tagging of HTML.
      ⍝
      ⍝ By calling ⎕INP with different left arguments you can use your
      ⍝ preferred style, for example the more compact { ... } style
      ⍝ as shown in the following example:
      ⍝
      yBODY←yBODY, (,¨'{}') ⎕INP 'END-OF-⎕INP'   ⍝ more compact style
<DIV class="c7">
Return to {HTML∆x2y "http://www.gnu.org/home.html" HTML∆A "GNU's home page"}.
<P>

Please send FSF & GNU inquiries & questions to

{HTML∆x2y ("mailto:", xMAIL_GNU) HTML∆A "<EM>", xMAIL_GNU, "</EM>"}.
There are also
{HTML∆x2y "http://www.gnu.org/home.html#ContactInfo" HTML∆A "other ways to contact"}
the FSF.
<P>
Please send comments on these web pages to
{HTML∆x2y ("mailto:", xMAIL_WEB) HTML∆A "<EM>", xMAIL_WEB, "</EM>"}.
send other questions to
{HTML∆x2y ("mailto:", xMAIL_GNU) HTML∆A "<EM>", xMAIL_GNU, "</EM>"}.
<P>
Copyright (C) 2014 Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA  02110,  USA
<P>
Verbatim copying and distribution of this entire article is
permitted in any medium, provided this notice is preserved.<P>
</DIV>
END-OF-⎕INP

      HTML∆emit HTML∆Document

      '<!--'
      )VARS

      )FNS

      )SI
      '-->'
      )OFF

      )WSID APL_CGI
      )DUMP

    
