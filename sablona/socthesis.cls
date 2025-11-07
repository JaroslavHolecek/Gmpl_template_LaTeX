\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sablona/socthesis}[2025/10/29 Class for SOČ and Seminar papers (CZ)]

\LoadClass[12pt, a4paper, oneside]{book}

% --------------------------
% Balíčky
% --------------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[czech]{babel}
\RequirePackage{graphicx}
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{hyperref}
\RequirePackage{csquotes}
\RequirePackage{caption}
\RequirePackage{xstring}
\RequirePackage{ifthen}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{listings}
\RequirePackage{float}
\RequirePackage{xcolor}
\RequirePackage{fancyhdr}
\RequirePackage{datetime}

% --------------------------
% Nastavení listings pro UTF-8
% --------------------------
\lstset{
  inputencoding=utf8,
  extendedchars=true,
  basicstyle=\ttfamily,
  breaklines=true,
  frame=single,
  numbers=left,
  numberstyle=\tiny,
  captionpos=b,
  keywordstyle=\color{blue},
  literate=
    {á}{{\'a}}1 {č}{{\v{c}}}1 {ď}{{\v{d}}}1 {é}{{\'e}}1 {ě}{{\v{e}}}1
    {í}{{\'i}}1 {ň}{{\v{n}}}1 {ó}{{\'o}}1 {ř}{{\v{r}}}1 {š}{{\v{s}}}1
    {ť}{{\v{t}}}1 {ú}{{\'u}}1 {ů}{{\r{u}}}1 {ý}{{\'y}}1 {ž}{{\v{z}}}1
    {Á}{{\'A}}1 {Č}{{\v{C}}}1 {Ď}{{\v{D}}}1 {É}{{\'E}}1 {Ě}{{\v{E}}}1
    {Í}{{\'I}}1 {Ň}{{\v{N}}}1 {Ó}{{\'O}}1 {Ř}{{\v{R}}}1 {Š}{{\v{S}}}1
    {Ť}{{\v{T}}}1 {Ú}{{\'U}}1 {Ů}{{\r{U}}}1 {Ý}{{\'Y}}1 {Ž}{{\v{Z}}}1
}

% --------------------------
% Bibliografie (ČSN ISO 690, numerická)
% --------------------------
\RequirePackage[
  backend=bibtex,
  bibstyle=numeric,
  style=iso-numeric,
  sorting=none,
  date=long,
  dateabbrev=false,
  texencoding=utf8,
  bibencoding=utf8
]{biblatex}

% ==========================================================
%              INTERNÍ MAKRA S @ (bezpečný blok)
% ==========================================================
\makeatletter

% ==========================
% Uživatelská data – OBECNÉ
% ==========================
\newcommand{\titlecz}[1]{\def\@titlecz{#1}}
\newcommand{\titleen}[1]{\def\@titleen{#1}}
\newcommand{\school}[1]{\def\@school{#1}}
\newcommand{\region}[1]{\def\@region{#1}}     % oficiální název kraje
\newcommand{\city}[1]{\def\@city{#1}}         % město (titulní strany)
\newcommand{\yearofwork}[1]{\def\@year{#1}}   % rok
\newcommand{\consultants}[1]{\def\@consultants{#1}} % „Jméno; Jméno; ...“
\newcommand{\consultantsTitle}[1]{\def\@consultantsTitle{#1}} % „Konzultant/Konzultantka/ ...“
\newcommand{\authorsTitle}[1]{\def\@authorsTitle{#1}} % „Autor/Autorka/Autoři ...“

\newcommand{\acknowledgements}[1]{\def\@thanks{#1}}

% anotace & klíčová slova
\newcommand{\abstractcz}[1]{\def\@abstractcz{#1}}
\newcommand{\abstracten}[1]{\def\@abstracten{#1}}
\newcommand{\keywordscz}[1]{\def\@keywordscz{#1}}
\newcommand{\keywordsen}[1]{\def\@keywordsen{#1}}

% typ práce + verze
\newcommand{\worktype}[1]{\def\@worktype{#1}}         % "soc" | "seminar"
\newcommand{\versiontype}[1]{\def\@versiontype{#1}}   % "work" | "final"

% ==========================
% Autoři (více autorů)
% ==========================
\newlength{\sigwidth}
\setlength{\sigwidth}{4cm} % šířka podpisové linky (můžeš upravit)

\newcommand{\authorsClear}{%
  \gdef\@authorsNames{}% pro „Autoři: A, B, C“
  \gdef\@authorsLines{}% jména po řádcích (SOČ 1. titulní strana)
  \gdef\@authorsDecl{} % bloky do prohlášení
}

\newcommand{\addAuthor}[3]{% #1=jméno, #2=město (pište rovnou ve 6. pádu), #3=datum
  % seznam jmen oddělený čárkou
  \ifx\@authorsNames\@empty
    \gdef\@authorsNames{#1}%
  \else
    \g@addto@macro\@authorsNames{, #1}%
  \fi

  % jména po řádcích (pro 1. titulní stranu SOČ)
  \g@addto@macro\@authorsLines{#1\\}%

  % podpisový blok: vlevo "V <město> dne <datum>", vpravo tečkovaná linka a pod ní centrované jméno
  \g@addto@macro\@authorsDecl{%
    \vspace{1cm}%
    \noindent
    \begin{minipage}[t]{0.6\textwidth}%
      V #2 dne #3
    \end{minipage}
    \begin{minipage}[t]{\sigwidth}%
      \dotfill\\[-0.2ex]
      \centering #1
    \end{minipage}\par\medskip
  }%
}


% ==========================
% Obory – číslo -> název
% ==========================
\newcommand{\fieldnum}[1]{\def\@fieldnum{#1}}
\def\@fieldname{Neznámý obor}

\newcommand{\mapSocField}[1]{%
  \IfStrEqCase{#1}{%
    {1}{\def\@fieldname{Matematika a statistika}}%
    {2}{\def\@fieldname{Fyzika}}%
    {3}{\def\@fieldname{Chemie}}%
    {4}{\def\@fieldname{Biologie}}%
    {5}{\def\@fieldname{Geologie a geografie}}%
    {6}{\def\@fieldname{Zdravotnictví}}%
    {7}{\def\@fieldname{Zemědělství, potravinářství, lesní a vodní hospodářství}}%
    {8}{\def\@fieldname{Ochrana a tvorba životního prostředí}}%
    {9}{\def\@fieldname{Strojírenství, hutnictví a doprava}}%
    {10}{\def\@fieldname{Elektrotechnika, elektronika a telekomunikace}}%
    {11}{\def\@fieldname{Stavebnictví, architektura a design interiérů}}%
    {12}{\def\@fieldname{Tvorba učebních pomůcek, didaktická technologie}}%
    {13}{\def\@fieldname{Ekonomika a řízení}}%
    {14}{\def\@fieldname{Pedagogika, psychologie, sociologie a problematika volného času}}%
    {15}{\def\@fieldname{Teorie kultury, umění a umělecké tvorby}}%
    {16}{\def\@fieldname{Historie}}%
    {17}{\def\@fieldname{Filozofie, politologie a ostatní humanitní a společenskovědní obory}}%
    {18}{\def\@fieldname{Informatika}}%
  }[\def\@fieldname{Neznámý obor}]%
}
\newcommand{\mapSemField}[1]{%
  \IfStrEqCase{#1}{%
    {1}{\def\@fieldname{Matematika a statistika}}%
    {2}{\def\@fieldname{Fyzika}}%
    {3}{\def\@fieldname{Chemie}}%
    {4}{\def\@fieldname{Biologie}}%
    {5}{\def\@fieldname{Geologie a geografie}}%
    {6}{\def\@fieldname{Zdravotnictví}}%
    {7}{\def\@fieldname{Zemědělství, potravinářství, lesní a vodní hospodářství}}%
    {8}{\def\@fieldname{Ochrana a tvorba životního prostředí}}%
    {9}{\def\@fieldname{Strojírenství, hutnictví a doprava}}%
    {10}{\def\@fieldname{Elektrotechnika, elektronika a telekomunikace}}%
    {11}{\def\@fieldname{Stavebnictví, architektura a design interiérů}}%
    {12}{\def\@fieldname{Tvorba učebních pomůcek, didaktická technologie}}%
    {13}{\def\@fieldname{Ekonomika a řízení}}%
    {14}{\def\@fieldname{Pedagogika, psychologie, sociologie a problematika volného času}}%
    {15}{\def\@fieldname{Teorie kultury, umění a umělecké tvorby}}%
    {16}{\def\@fieldname{Historie}}%
    {17}{\def\@fieldname{Filozofie, politologie a ostatní humanitní a společenskovědní obory}}%
    {18}{\def\@fieldname{Informatika}}%
  }[\def\@fieldname{Neznámý obor}]%
}
\newcommand{\resolveField}{%
  \ifthenelse{\equal{\@worktype}{seminar}}{\mapSemField{\@fieldnum}}{\mapSocField{\@fieldnum}}%
}

% ==========================
% Seminární práce – doplňkové údaje
% ==========================
\newcommand{\subjectname}[1]{\def\@subject{#1}}
\newcommand{\advisor}[1]{\def\@advisor{#1}}
\newcommand{\classgrade}[1]{\def\@class{#1}}
\newcommand{\submissiondate}[1]{\def\@subdate{#1}}

% ==========================
% Pracovní / finální zápatí
% ==========================

% Definujeme vlastní formát času pro pracovní verzi
\newcommand{\workversiondatetime}{%
  \edef\shifthours{\the\numexpr\time-30\relax}%
  \edef\hours{\the\numexpr\shifthours/60\relax}%
  \edef\minutes{\the\numexpr\time-\hours*60\relax}%
  \number\year-\two@digits{\month}-\two@digits{\day}\ %
  \two@digits{\hours}:\two@digits{\minutes}%
}
% Pomocná funkce pro dvouciferné zobrazení
\def\two@digits#1{\ifnum#1<10 0\fi\the\numexpr#1\relax}

% ==========================================================
%                    TITULNÍ STRANY
% ==========================================================

% --------------------------
% SOČ – 1. strana
% --------------------------
\newcommand{\SocTitlePageOne}{%
  \resolveField
  \pagestyle{empty}

  % horní střed – název soutěže
  \begin{center}
    \vspace*{0pt}
    {\Large \bfseries \MakeUppercase{Středoškolská odborná činnost}}\\[2mm]
    {\bfseries Obor č.~\@fieldnum: \@fieldname}
  \end{center}

  % střed stránky – nápis o verzi + název práce (CZ)
  \vfill
  \begin{center}
    % Nápis o pracovní verzi (pokud je nastaveno)
    \ifthenelse{\equal{\@versiontype}{work}}{%
      {\large \textcolor{red}{\textbf{PRACOVNÍ VERZE – \workversiondatetime}}}\\[5mm]
    }{}
    {\LARGE \bfseries \@titlecz}
  \end{center}
  \vfill

  % spodní část – vlevo autoři + kraj, vpravo město a rok
  \noindent\makebox[\textwidth]{%
    \parbox[b]{0.6\textwidth}{%
      \raggedright
      \@authorsLines
      \@region
    }\hfill
    \parbox[b]{0.35\textwidth}{%
      \raggedleft
      \@city\\
      \@year
    }%
  }
  \newpage
}

% --------------------------
% SOČ – 2. strana
% --------------------------
\newcommand{\SocTitlePageTwo}{%
  \resolveField
  \pagestyle{empty}

  \begin{center}
    \vspace*{0pt}
    {\Large \bfseries \MakeUppercase{Středoškolská odborná činnost}}\\[2mm]
    {\bfseries Obor č.~\@fieldnum: \@fieldname}
  \end{center}

  \vfill
  \begin{center}
    % Nápis o pracovní verzi (pokud je nastaveno)
    \ifthenelse{\equal{\@versiontype}{work}}{%
      {\large \textcolor{red}{\textbf{PRACOVNÍ VERZE – \workversiondatetime}}}\\[5mm]
    }{}
    {\LARGE \bfseries \@titlecz}\\[6pt]
    {\large \bfseries \@titleen}
  \end{center}
  \vfill

  \noindent
  \parbox{0.9\textwidth}{%
    \textbf{\@authorsTitle:} \@authorsNames\\
    \textbf{Škola:} \@school\\
    \textbf{Kraj:} \@region\\
    \textbf{Vedoucí práce:} \@advisor\\
    \ifx\@consultants\@empty\else\textbf{\@consultantsTitle:} \@consultants\\\fi
  }

  \vspace{8mm}
  {\small \@city~\@year}

  \newpage
}

% --------------------------
% SEMINÁRNÍ PRÁCE – titulní strana
% --------------------------
\newcommand{\SemTitlePage}{%
  \resolveField
  \pagestyle{empty}

  \begin{center}
    {\Large \bfseries Seminární práce}\\[2mm]
    {\bfseries v oboru \@fieldnum.\ \@fieldname}
  \end{center}

  \vspace{6mm}
  \begin{center}
    % logo školy – PNG vedle .cls
    \IfFileExists{sablona/logo_skoly.png}{\includegraphics[width=0.35\textwidth]{sablona/logo_skoly.png}}{}
  \end{center}

  \vfill
  \begin{center}
    % Nápis o pracovní verzi (pokud je nastaveno)
    \ifthenelse{\equal{\@versiontype}{work}}{%
      {\large \textcolor{red}{\textbf{PRACOVNÍ VERZE – \workversiondatetime}}}\\[5mm]
    }{}
    {\LARGE \bfseries \@titlecz}\\[4pt]
    {\normalsize v předmětu \@subject}
  \end{center}
  \vfill

  \noindent
  \parbox[b]{0.9\textwidth}{%
    \textbf{\@authorsNames}\\
    \textbf{Třída:} \@class\\
    \textbf{Rok:} \@year\\
    \textbf{Vedoucí práce:} \@advisor\\
    \ifx\@consultants\@empty\else\textbf{\@consultantsTitle:} \@consultants\\\fi
    \textbf{Datum odevzdání:} \@subdate
  }

  \newpage
}

% ==========================================================
%                    POVINNÉ PŘEDSTRÁNKY
% ==========================================================

% Prohlášení – SOČ
\newcommand{\SocDeclaration}{%
  \section*{Prohlášení}
  Prohlašuji, že jsem svou práci SOČ na téma \textit{\@titlecz} vypracoval/a samostatně a použil/a jsem pouze prameny a literaturu uvedené v seznamu bibliografických záznamů.

  Prohlašuji, že tištěná verze a elektronická verze soutěžní práce SOČ jsou shodné. 

  Nemám závažný důvod proti zpřístupňování této práce v souladu se zákonem č.~121/2000~Sb., o právu autorském, o právech souvisejících s právem autorským a o změně některých zákonů (autorský zákon) ve znění pozdějších předpisů. 

  \vspace{2cm}
  \noindent\@authorsDecl
  \newpage
}

% Prohlášení – Seminární práce
\newcommand{\SemDeclaration}{%
  \section*{Prohlášení}
  Prohlašuji, že jsem tuto seminární práci na téma \textit{\@titlecz} vypracoval/a samostatně a uvedl/a jsem všechny použité prameny a literaturu. 

  \vspace{2cm}
  \noindent\@authorsDecl
  \newpage
}

% Poděkování
\newcommand{\ThanksPage}{%
  \section*{Poděkování}
  \@thanks
  \newpage
}

% Anotace & klíčová slova (CZ/EN)
\newcommand{\AbstractsPage}{%
  \section*{Anotace}
  \@abstractcz

  \vspace{3mm}
  \textbf{Klíčová slova}\\
  \@keywordscz

  \vspace{6mm}
  \section*{Annotation}
  \@abstracten

  \vspace{3mm}
  \textbf{Keywords}\\
  \@keywordsen
  \newpage
}

% ==========================================================
%                     HLAVNÍ ROZVRH STRÁNEK
% ==========================================================

% Titulní strany dle typu práce
\renewcommand{\maketitle}{%
  \ifthenelse{\equal{\@worktype}{seminar}}{%
    \SemTitlePage
  }{%
    \SocTitlePageOne
    \SocTitlePageTwo
  }%
}
% Prohlášení dle typu práce
\newcommand{\MakeDeclaration}{%
  \ifthenelse{\equal{\@worktype}{seminar}}{\SemDeclaration}{\SocDeclaration}%
}

\makeatother
