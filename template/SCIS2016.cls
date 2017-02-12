\def\sci@fileversion{2.03}
\def\sci@filedate{2016/01/08}
\def\@journal{Sci China Inf Sci}
\def\@issn{1674-733X}
\def\@copyright{\copyright~Science China Press and Springer-Verlag Berlin Heidelberg 2016}
\def\@website{info.scichina.com~~~~link.springer.com}

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{SCIS}[\sci@filedate, \sci@fileversion]

\LoadClass[twoside]{article}
%% math packages
\RequirePackage{amsmath,amsthm,amsfonts,amssymb,bm,upgreek,multicol,mathrsfs,pifont,amscd,latexsym,geometry,color,fancyhdr}
%% graphics packages
\RequirePackage{graphicx,picins}
%% other packages
\RequirePackage{algorithm,algorithmic,tabularx,url,float,booktabs}
%% check pdfTeX mode
\RequirePackage{ifpdf}
\RequirePackage{fancyhdr,lastpage}
\RequirePackage[citebordercolor={1 1 1},linkbordercolor={1 1 1},menubordercolor={1 1 1},pagebordercolor={1 1 1},urlbordercolor={1 1 1}]{hyperref}
\RequirePackage{breakurl}
\urlstyle{same}%定义url字体和正文相同
%-------------------------- Page layout ------------------------------
\textwidth=160truemm
\textheight=226truemm
\topmargin=0pt
\headsep=6truemm
\oddsidemargin=0pt
\evensidemargin=0pt
\parindent=0pt
\footskip=0mm
\renewcommand{\baselinestretch}{1.0}
\renewcommand{\arraystretch}{1.2}
\newcommand{\sanhao}{\fontsize{18pt}{\baselineskip}\selectfont}
\newcommand{\xiaosanhao}{\fontsize{15pt}{2\baselineskip}\selectfont}
\newcommand{\xiaosihao}{\fontsize{12pt}{\baselineskip}\selectfont}
\newcommand{\wuhao}{\fontsize{10pt}{\baselineskip}\selectfont}
\newcommand{\bahao}{\fontsize{8pt}{\baselineskip}\selectfont}
\newcommand{\qihao}{\fontsize{7pt}{\baselineskip}\selectfont}
\newcommand{\jiuhao}{\fontsize{9pt}{0.8\baselineskip}\selectfont}
\newcommand{\shihao}{\fontsize{6pt}{0.8\baselineskip}\selectfont}
\def\letter{LETTER}
\def\editornote{Editor's Note}
\def\highlight{HIGHLIGHT}
\def\supplementary{Supplementary File}
\def\blank{ }
\def\lastpage{\pageref{LastPage}}
\def\firstpage{\pageref{FirstPage}}
%-------------------- Article Information ----------------------------
\def\ArticleType#1#2{
    \def\article{#1}
    \ifx\article\editornote
        \begin{picture}(0,0)
            {#2}
        \end{picture}
    \else
        \begin{picture}(0,0)
            \rm
            \put(0,-13){\makebox[160truemm][l]{\bf {\sanhao\raisebox{2pt}{.}}~#1~{\sanhao\raisebox{1.5pt}{.}}}}
            {#2}
        \end{picture}
    \fi
}
\let\@Year\@empty \def\Year#1{\def\@Year{#1}}
\let\@Month\@empty \def\Month#1{\def\@Month{#1}}
\let\@Vol\@empty \def\Vol#1{\def\@Vol{#1}}
\let\@No\@empty \def\No#1{\def\@No{#1}}
\let\@AuthorMark\@empty \def\AuthorMark#1{\def\@AuthorMark{#1}}
\let\@AuthorCitation\@empty \def\AuthorCitation#1{\def\@AuthorCitation{#1}}
\let\@BeginPage\@empty \def\BeginPage#1{\def\@BeginPage{#1}}
\let\@EndPage\@empty \def\EndPage#1{\def\@EndPage{#1}}
\let\@DOI\@empty \def\DOI#1{\def\@DOI{#1}}
\let\@ArtNo\@empty \def\ArtNo#1{\def\@ArtNo{#1}}
\let\@ReceiveDate\@empty \def\ReceiveDate#1{\def\@ReceiveDate{#1}}
\let\@AcceptDate\@empty \def\AcceptDate#1{\def\@AcceptDate{#1}}
\let\@OnlineDate\@empty \def\OnlineDate#1{\def\@OnlineDate{#1}}
%\let\@Correspondingauthor\@empty \def\Correspondingauthor#1{\def\@Correspondingauthor{#1}}
\let\@abstract\@empty \renewcommand\abstract[1]{\def\@abstract{#1}}
\let\@keywords\@empty \def\keywords#1{\def\@keywords{#1}}

%-------------------------- Title ------------------------------------
\let\@title\@empty 
\renewcommand\title[3][]{
  \renewcommand{\baselinestretch}{0.9}
  \baselineskip 9pt
  \vspace{-9mm}
  \begin{picture}(0,0)
    {\rm
    \put(165,5){\xiaosanhao \bf SCIENCE CHINA}
    \put(167,-10){\xiaosanhao Information Sciences}
    \put(0,-17){\thicklines\line(1,0){456}}
    %\put(0,-29){\makebox[160truemm][r]{\vbox{\hbox{\footnotesize \@Month~\@Year,~Vol.~\@Vol~~\@ArtNo:1--\@ArtNo:\pageref{LastPage}}}}}
    %\put(0,-40){\makebox[160truemm][r]{\vbox{\hbox{\footnotesize  doi:~\@DOI}}}}
    }
    %\put(0,-678){\makebox[20truemm][l]{\qihao\sf \@copyright}}
    %\put(0,-678){\makebox[160truemm][r]{\qihao\sf \@website}}
  \end{picture}

  \vskip 8true mm
  \def\@title{#2}
  \def\@titlehead{#1}
  \def\@titlecitation{#3}
  \ifx\@titlehead\@empty\def\@titlehead{#2}\fi
  \ifx\@titlecitation\@empty\def\@titlecitation{#2}\fi
}


\let\@author\@empty
\let\@authoremail\@empty
\let\@onlyoneauthor\@empty
\let\@authorcite\@empty
\renewcommand*{\author}[3][]{%
  \ifx\@author\@empty
    \def\@author{#2\@authornote{#1}{#3}}
    \let\@authortemp\@author
  \else
    \let\@author\@authortemp
    \def\@onlyoneauthor{No}
    \expandafter\def\expandafter\@author\expandafter
      {\@author~{\&}~#2\@authornote{#1}{#3}}
    \expandafter\def\expandafter\@authortemp\expandafter
      {\@authortemp,~#2\@authornote{#1}{#3}}
  \fi
  
  \ifx\@AuthorCitation\@empty
    \ifx\@authorcite\@empty \def\@authorcite{#2}
    \else \expandafter\def\expandafter\@authorcite\expandafter{\@authorcite, #2}
    \fi
  \fi
  
  \ifx\@AuthorMark\@empty
    \def\@AuthorMark{#2}
  \fi
    
  \ifx#3\@empty
  \else
      \ifx\@authoremail\@empty \def\@authoremail{#3}
      \else \expandafter\def\expandafter\@authoremail\expandafter{\@authoremail,~#3}
      \fi
  \fi
}

\def\@authornote#1#2{%
  \def\SCAE@author@address{#1}%
  \def\SCAE@author@footnote{#2}%
  
  \ifx\SCAE@author@address\@empty
  \else \textsuperscript{#1}\hspace{-1.2mm}
  \fi
  
  \ifx\SCAE@author@footnote\@empty
  \else
    \ifx\@onlyoneauthor\@empty
    \else \textsuperscript{\raisebox{-2pt}[0mm][0mm]{*}}%
    \fi
  \fi
}


\def\@address{}
\newcommand*{\address}[2][]{%
  \ifx \@address\@empty
    \def\@address{\@addressline{#1}{#2}}
  \else
    \expandafter\def\expandafter\@address\expandafter
      {\@address;\tabularnewline\@addressline{#1}{#2}}
  \fi}
\def\@addressline#1#2{\@addresscr\hb@xt@1ex{\textsuperscript{\rm#1}\hss}#2}
\def\@addresscr{\def\\{\tabularnewline\@addresscr\hbox to1ex{}\ignorespaces}}

\def\@foundation{}
\newcommand*{\foundation}[1]{
  \def\SCAE@foundation{#1}
  \ifx\SCAE@foundation\@empty
  \else  
    \def\@foundation{\footnotetext{#1}}
  \fi
}


\renewcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\fnsymbol{footnote}}
    \let\footnote\thanks
    \def\@makefnmark{\hbox{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\noindent\@textsuperscript{\normalfont\@thefnmark}##1}%
    \@maketitle
    \thispagestyle{empty}\@thanks
    \long\def\@makefntext##1{\noindent##1}%
    \@foundation
  \endgroup
  \renewcommand\thefootnote{\arabic{footnote}}
  \setcounter{footnote}{0}
  
  \setlength{\textwidth}{16cm}
  \setlength{\textheight}{23.6cm}
  \ifx\article\letter \renewcommand{\baselinestretch}{1.0}
  \else 
    \ifx\article\highlight \renewcommand{\baselinestretch}{1.0}
    \else \renewcommand{\baselinestretch}{1.1}
    \fi
  \fi
  \baselineskip 12pt
  \parindent=10.8pt
  \wuhao
  \vspace{5mm}
}

\long\def\@makefntext#1{\parindent 12pt \indent\hbox{\hss{\@thefnmark)\ }}#1}
\def\@makefnmark{\hbox\textsuperscript{\@thefnmark)}}


\def\@maketitle{
  \noindent
  \vskip 16mm
  \begin{center}\LARGE\bfseries \@title \end{center}
  
  \ifx\article\editornote
  \else
      \vskip 0.5 true cm
      \renewcommand{\baselinestretch}{1.1}
      \baselineskip 12pt
      \begin{center}\xiaosihao{\rm
          \begin{tabular}{@{}c@{}}
          \@author
          \ifx\@onlyoneauthor\@empty
            \setcounter{footnote}{-1}
            \footnote{Email:~\@authoremail}
          \else
            \ifx\article\letter
                \setcounter{footnote}{-1}
                \footnote{*{\thinspace}Corresponding author (email:~\@authoremail)\protect\\The authors declare that they have no conflict of interest.}
            \else
                \ifx\article\highlight
                    \setcounter{footnote}{-1}
                    \footnote{*{\thinspace}Corresponding author (email:~\@authoremail)\protect\\The authors declare that they have no conflict of interest.}
                \else
                    \setcounter{footnote}{-1}
                    \footnote{*{\thinspace}Corresponding author (email:~\@authoremail)}
                \fi
            \fi
          \fi
          \end{tabular}
      }\end{center}
      
      \vskip 0.1 true cm
      \renewcommand{\baselinestretch}{0.9}
      \baselineskip 9pt
      \begin{center}\bahao{\it
          \begin{tabular}[t]{@{}c@{}}
            \@address
          \end{tabular}
      }\end{center}
      
      \ifx\article\supplementary
      \else
          \vspace{-2mm}
          \begin{center}\bahao{
              \ifx\@OnlineDate\@empty{Received \@ReceiveDate; accepted \@AcceptDate}
              \else{Received \@ReceiveDate; accepted \@AcceptDate; published online \@OnlineDate}
              \fi
          }\end{center}
      \fi
      
      \ifx\article\letter
      \else
        \ifx\article\highlight
        \else
            \ifx\article\supplementary
            \else
              \renewcommand{\baselinestretch}{0.95}
              \baselineskip 12pt
              \vspace{2mm}\hspace{6.3mm}
              \begin{tabular}{p{0.88\textwidth}}\hline\\\end{tabular}
              \vspace{-4mm}
              \begin{center}\parbox{14.5cm}{
                \bahao\noindent\textbf{Abstract}\quad\ignorespaces\@abstract}
              \end{center}
              \vspace{-0.6mm}
              \begin{center}\parbox{14.5cm}{
                \bahao\noindent\textbf{Keywords}\quad\ignorespaces\@keywords}
              \end{center}
            \fi
        \fi
      \fi
      
      \ifx\article\supplementary
      \else
          \renewcommand{\baselinestretch}{1.2}{
          \ifx\@AuthorCitation\@empty \def\@AuthorCitation{\@authorcite} \fi
          \hspace{6.3mm}
          \scriptsize
          \begin{tabular}{p{0.88\textwidth}}
            \hline\\
            \vspace{-5mm}
            {\bf Citation}\quad~ \@AuthorCitation. \@titlecitation. \@journal, \@Year, \@Vol(\@No): 
            \makeatletter\@ArtNo, doi: \@DOI\makeatother\vspace{1mm}\\
            \hline
          \end{tabular}}
      \fi
  \fi
  
}


%----------------------- Running heads ---------------------------------
\def\ps@myheadings{\global\let\@oddfoot\@empty\global\let\@evenfoot\@empty
    \def\@evenhead{\vbox{\hbox to \textwidth{
        \qihao
        \thepage
        \rm\hbox to 0.01cm{} \hfill{
            \ifx \@onlyoneauthor\@empty 
                \@AuthorMark\emph{\ \ \ \@journal}
            \else
                \@AuthorMark\emph{,~et al.\ \ \ \@journal}
            \fi
            %{\ \ \ \@Month~\@Year~Vol.~\@Vol~\@ArtNo:\thepage}
        }\hfill
    }}}
    
    \def\@oddhead{\vbox{\hbox to \textwidth{
        \qihao\rm\hbox to 0.01cm{} \hfill{
            \ifx \@onlyoneauthor\@empty 
                \@AuthorMark\emph{\ \ \ \@journal}
            \else
                \@AuthorMark\emph{,~et al.\ \ \ \@journal}
            \fi
            %{\ \ \ \@Month~\@Year~Vol.~\@Vol~\@ArtNo:\thepage}
        }\hfill
        \thepage
    }}}

    \let\@oddfoot\@empty  \let\@evenfoot\@empty
}
\pagestyle{myheadings}


%---------------------- Acknowledgements -------------------------------
\let\@Acknowledgements\@empty \def\Acknowledgements#1{\def\@Acknowledgements{#1}}
%\newcommand*\Acknowledgements[1]{%
%    \vskip 3mm
%    {\jiuhao\noindent\textbf{Acknowledgements}\quad{#1}}
%}

%\newcommand\InterestConflict{
%    \ifx\@onlyoneauthor\@empty
%    \else
%    \vskip 3mm
%    {\jiuhao\noindent\textbf{Conflict of interest}\quad
%    {The authors declare that they have no conflict of interest.}}
%    \fi
%}

\let\@Supplements\@empty \def\Supplements#1{\def\@Supplements{#1}}
%\newcommand*\Supplements[1]{%
%    \vskip 3mm
%    {\jiuhao\noindent\textbf{Supporting information}\quad{#1
%    The supporting information is available online at \url{info.scichina.com} and \url{link.springer.com}.
%    The supporting materials are published as submitted, without typesetting or editing.
%    The responsibility for scientific accuracy and content remains entirely with the authors.}}
%}

%-------------------------- Sections ----------------------------------
\renewcommand\section{
    \@startsection{section}{1}{\z@}%
    {-4.5ex \@plus -1ex \@minus -.2ex}%
    {2.5ex \@plus.1ex}%
    {\normalfont\xiaosihao\bfseries}}

\renewcommand\subsection{
    \@startsection{subsection}{2}{\z@}%
    {-2ex\@plus -2ex \@minus -.1ex}%
    {2ex \@plus .2ex}%
    {\normalfont\normalsize\bfseries}}

\renewcommand\subsubsection[1]{
    \@startsection{subsubsection}{3}{\z@}%
    {-3ex\@plus -1ex \@minus -.1ex}%
    {1ex \@plus .1ex}%
    {\normalfont\normalsize}{\it#1}}

\newcommand\deareditor{
    {\normalfont\normalsize\bfseries\noindent Dear editor,\par}
}

\newcommand\lettersection[1]{{\it #1}. }
\columnsep 0.7cm  %两栏之间的距离

\let\oldappendix\appendix
\renewenvironment{appendix}{
    \oldappendix
    \setcounter{section}{0}
    \def\thesection{Appendix \Alph{section}}
    \renewcommand{\theequation}{\Alph{section}\arabic{equation}}
    \renewcommand{\thefigure}{\Alph{section}\arabic{figure}}
    \renewcommand{\thetable}{\Alph{section}\arabic{table}}
    \renewcommand{\thealgorithm}{\Alph{section}\arabic{algorithm}}
    \renewcommand{\section}{
        \setcounter{equation}{0}
        \setcounter{table}{0}
        \setcounter{figure}{0}
        \setcounter{algorithm}{0}
        \@startsection{section}{1}{\z@}%
        {-4.5ex \@plus -1ex \@minus -.2ex}%
        {1ex \@plus .2ex}%
        {\normalfont\normalsize\bfseries}
    }
    \footnotesize
}

%-------------------------- Bibliography ------------------------------
\usepackage{cite}%使多个参文中间用--连接
\def\@biblabel#1{#1~}
\renewenvironment{thebibliography}[1]{
    \ifx\@Acknowledgements\@empty\else
    \vskip 3mm
    {\jiuhao\noindent\textbf{Acknowledgements}\quad{\@Acknowledgements}}
    \fi
    
    \ifx\article\highlight\else
    \ifx\article\letter\else
    \ifx\article\editornote\else
    \ifx\article\supplementary\else
    \ifx\@onlyoneauthor\@empty\else
    \vskip 3mm
    {\jiuhao\noindent\textbf{Conflict of interest}\quad
    {The authors declare that they have no conflict of interest.}}
    \fi\fi\fi\fi\fi
    
    \ifx\@Supplements\@empty\else
        \vskip 3mm
        {\jiuhao\noindent\textbf{Supporting information}\quad{
        \ifx\@Supplements\blank\else{\@Supplements~ }\fi
        The supporting information is available online at \url{info.scichina.com} and \url{link.springer.com}.
        The supporting materials are published as submitted, without typesetting or editing.
        The responsibility for scientific accuracy and content remains entirely with the authors.}}
    \fi
    
    \section*{\normalsize\refname
        \@mkboth{\jiuhao\refname}{\jiuhao\refname}}%
    \vspace{-3mm}
    \list{\@biblabel{\@arabic\c@enumiv}}{
        \settowidth\labelwidth{\@biblabel{#1}}%
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \@openbib@code
        \usecounter{enumiv}%
        \let\p@enumiv\@empty
        \renewcommand\theenumiv{\@arabic\c@enumiv}
    }
    \itemsep 0ex \parskip 0ex
    \footnotesize\sloppy
}
\renewcommand{\UrlFont}{\selectfont} %使用\url{}使参文中的url自动断行



%-------------------------- Figures and tables ------------------------

\setlength{\floatsep}{12pt plus 2pt minus 2pt}%页面顶部/底部的浮动对象间的垂直距离, 缺省为12pt plus 2pt minus 2pt
\setlength{\textfloatsep}{12pt plus 2pt minus 2pt}%页顶部/底部的浮动对象与文本间垂直距离, 缺省20pt plus 2pt minus 4pt
\setlength{\intextsep}{12pt plus 2pt minus 2pt}%页中浮动对象与上下方文本间垂直距离, 缺省12pt plus 2pt minus 2pt
\setlength{\belowrulesep}{0pt}%横线和其下文字的间距
\setlength{\aboverulesep}{0pt}%横线和其上文字的间距
\setlength{\doublerulesep}{0.4pt}
\newcommand\Times{\fontfamily{ptm}\selectfont}
\newcommand{\picsize}{\fontsize{8pt}{0.4\baselineskip}\selectfont}
\usepackage[bf,footnotesize,labelsep=quad]{caption}
\usepackage[labelfont={rm,md,up}]{subfig}
\captionsetup[subfloat]{labelformat=simple,captionskip=0pt}
\captionsetup[table]{aboveskip=1mm}
\captionsetup[figure]{aboveskip=3mm}
\captionsetup[algorithm]{font=footnotesize}
\renewcommand{\thesubfigure}{{\picsize\Times(\alph{subfigure})}} %这两行定义子图在正文引用时的label形式
\renewcommand{\thesubtable}{{\picsize(\alph{subtable})}} %子表label的字体仍和正文相同

%----------------------- Math ---------------------------------
\def\leq{\leqslant}
\def\geq{\geqslant}
\def\le{\leqslant}
\def\ge{\geqslant}
\abovedisplayskip=11pt plus 0pt minus 6pt 
\belowdisplayskip=11pt plus 0pt minus 6pt 
\newcommand{\set}[1]{\ensuremath{\left\{ #1 \right\}}}%
\newcommand{\Set}[2]{\ensuremath{\left\{ #1 \left| \right. #2 \right\}}}%
\newcommand{\abs}[1]{\ensuremath{\left| #1 \right|}}%
\newcommand{\map}[3]{\ensuremath{#1 : #2 \rightarrow #3}}%
\newcommand{\C}[1]{\ensuremath{\mathcal{#1}}}%
\newcommand{\restrict}[2]{\ensuremath{#1 \left|_{#2}\right.}}%
\newcommand{\NN}{\mathbb{N}^0}
\newcommand{\PN}{\mathbb{N}}
\newcommand{\syn}{\mathbf{S}}
\newcommand{\Syn}{\mathbf{M}}
\allowdisplaybreaks
\setlength{\arraycolsep}{2.0pt}

%--------------------------------- Theorems ---------------------------------
\def\proof{\noindent{\it Proof.}\quad}
\def\th#1{\noindent{\bf #1}\quad}%The common style. 通用形式
\renewcommand{\qedsymbol}{}
\newtheoremstyle{newdefinition}%
    {2pt}% Space above
    {2pt}% Space below
    {\normalfont}% Body font
    {}% Indent amount
    {\bfseries}% Theorem head font
    {.}% Punctuation after theorem head
    {10pt plus 1pt minus 1pt}% Space after theorem head
    {}% Theorem head spec (can be left empty, meaning `normal')
\theoremstyle{newdefinition}%
\newtheorem{assumption}{Assumption}
\newtheorem{corollary}{Corollary}
\newtheorem{definition}{Definition}
\newtheorem{example}{Example}
\newtheorem{lemma}{Lemma}
\newtheorem{problem}{Problem}
\newtheorem{proposition}{Proposition}
\newtheorem{remark}{Remark}
\newtheorem{theorem}{Theorem}

\iffalse
\makeatletter
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt\@xiipt
   \abovedisplayskip 9\p@ \@plus4\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip  \abovedisplayskip
   \let\@listi\@listI}
\makeatother
\fi

%--------------------------------- list ---------------------------------
\renewenvironment{itemize}{
\begin{list}{$\bullet$}{
\labelwidth=4em
\labelsep=0.5em
\leftmargin=0em
\rightmargin=0em
\parsep=\parskip
\itemsep=0em
\topsep=0em
\itemindent=2.1em
}
}{\end{list}}


\endinput

