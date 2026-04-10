\NeedsTeXFormat{LaTeX2e}
\LoadClass[10.5pt,a4paper,oneside,UTF8]{ctexbook}
\usepackage{graphicx}
\usepackage{geometry}
\usepackage[dvipsnames]{xcolor}
\usepackage[many]{tcolorbox}
\usepackage{siunitx}
\usepackage{enumerate}
\usepackage{enumitem}
\usepackage{annotate-equations}
\usepackage{fancyhdr}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage[explicit]{titlesec}
\usepackage{adjustbox}
\usepackage[fixed]{fontawesome5}
\usetikzlibrary{fadings}
\usepackage{fontspec}
\usepackage{dashrule}

\usepackage{esint}

\setcounter{secnumdepth}{3}
\renewcommand{\thesubsection}{\Alph{subsection}}
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsubsection}{\arabic{subsubsection}}

\pagestyle{plain}
\geometry{
    a4paper,
    top=25.4mm, bottom=25.4mm,
    left=20mm, right=20mm,
    headheight=2.17cm,
    headsep=4mm,
    footskip=12mm
  }
\lfoot{}

\setlength{\parskip}{0.5em}
\linespread{1.3}

%列表间距设置
\setenumerate{itemsep=0.2em,partopsep=0pt,parsep=0pt,topsep=0pt}
\setitemize{itemsep=0.2em,partopsep=0pt,parsep=0pt,topsep=0pt}

\titleformat{\part}
{}
{}
{20pt}
{\thispagestyle{empty}
\begin{tikzpicture}[remember picture,overlay]
        \fill[sidecolor] (current page.north west) rectangle (current page.south east);
        \node[diamond,fill=black,text=white,font=\Huge\sffamily\bfseries] at ([shift={(5cm,-5cm)}]current page.north west) {第~\adjustbox{scale=3,valign=m}{\arabic{part}}~篇};
        \node[right,font=\Huge\sffamily\bfseries] at ([shift={(2.5cm,-12cm)}]current page.north west) {\scalebox{2}{#1}};
    \end{tikzpicture}}
\makeatother

\newcommand{\silentpart}[1]{%
  \addcontentsline{toc}{part}{#1}%
}

\titleformat{\chapter}{\Huge\bfseries\filcenter}{}{1em}{
\begin{tikzpicture}[remember picture, overlay, inner sep=0pt]
    %\fill[white,path fading=east](current page.north east) rectangle ++(-0.5\paperwidth,-.2\paperheight);
    \fill[sidecolor,path fading=east](current page.north west) rectangle ++(\paperwidth,-.14\paperheight);
    \fill[maincolor,rounded corners] ([shift={(-.2cm,-1.1cm)}]current page.north west) rectangle ++(7cm,-1.8cm);
    \node[right,text=white,font=\sffamily] at ([shift={(2cm,-2cm)}]current page.north west) {第 \scalebox{2}{\thechapter} 章};
    \node[right,font=\sffamily] at ([shift={(8cm,-2.3cm)}]current page.north west) {#1};
\end{tikzpicture}
}

\titlespacing{\chapter}{0pt}{0pt}{10pt}
\titlespacing{name=\chapter, numberless}{0pt}{0pt}{0pt}

\titleformat{name=\chapter, numberless}{\Huge\bfseries\filcenter}{}{1em}{
\begin{tikzpicture}[remember picture, overlay, inner sep=0pt]
    %\fill[white,path fading=east](current page.north east) rectangle ++(-0.5\paperwidth,-.2\paperheight);
    \fill[sidecolor,path fading=east](current page.north west) rectangle ++(\paperwidth,-.15\paperheight);
    %\fill[maincolor,rounded corners] ([shift={(-.2cm,-1.1cm)}]current page.north west) rectangle ++(6cm,-1.8cm);
    \node[right,font=\sffamily] at ([shift={(2.4cm,-2.5cm)}]current page.north west) {#1};
\end{tikzpicture}
}

\titleformat{\section}{\LARGE\bfseries}{}{0pt}{
\noindent
\begin{tikzpicture}
    \fill[maincolor] (0.7,0) rectangle (16.2,1);
    %\fill[lightgray] (-0.65,0.25) rectangle (0.25,1.15);
    \fill[black] (-0.5,0) rectangle (0.5,1);
    %\draw[white,ultra thick] (-0.7,0.2) rectangle (0.3,1.2);
    \node[color=white,font=\sffamily] at (0,0.5) {\thesection};
    \node[right,color=white,font=\sffamily] at (0.8,0.5) {#1};
\end{tikzpicture}
%\vspace{-1.5em}
}
\titlespacing{\section}{-0.2em}{0pt}{0em}

\titleformat{name=\section, numberless}{\LARGE\bfseries}{}{0pt}{
\centering #1
}

\titlespacing{name=\section, numberless}{0pt}{0pt}{0.5em}

\titleformat{\subsection}{\Large\bfseries}{}{0pt}{
\noindent
\begin{tikzpicture}
    \fill[maincolor!40,rounded corners] (-0.5,0) rectangle (0.5,0.8);
    \fill[maincolor!40] (-0.5,0) rectangle (0.5,0.4);
    \draw[maincolor!40,ultra thick] (-0.5,0) -- (16.2,0);
    \node[color=black,font=\sffamily] at (-0.0,0.4) {\thesubsection};
    \node[right,font=\sffamily] at (0.7,0.4) {#1};
\end{tikzpicture}
%\vspace{-1.5em}
}
\titlespacing{\subsection}{-0.2em}{1em}{0em}

\titleformat{\subsubsection}{\large\bfseries}{}{0pt}{
\noindent
\begin{tikzpicture}
    \fill[sidecolor, rounded corners](0,-0.25) rectangle (0.5,0.25);
    \node[color=white,font=\sffamily] at (0.25,0) {\thesubsubsection};
    \node[right,font=\sffamily] (text) at (0.75,0) {#1};
    \draw[color=sidecolor!80,ultra thick] (text.south west) -- (text.south east);
\end{tikzpicture}
\vspace{-0.2em}
}
\titlespacing{\subsubsection}{0pt}{0.5em}{0pt}

\newcounter{example_counter}[chapter]

\newenvironment{example}[1]
{\begin{tcolorbox}[colback=maincolor!10,colframe=maincolor!80,fonttitle=\bfseries,title=\textbf{例\arabic{example_counter}：#1},breakable]}
{\end{tcolorbox} \stepcounter{example_counter}}

\newenvironment{formula}
{\begin{tcolorbox}[colback=maincolor!10,colframe=maincolor!80,boxrule=0pt,borderline={1pt}{0pt}{maincolor!80, dashed,fit to width=true}] \centering}
{\end{tcolorbox}}

%\newcommand{\note}[1]{\par\noindent\textcolor{ForestGreen!50!black}{\lefthand}\quad {#1} \par}
\newcommand{\note}[1]{\par\noindent\textcolor{ForestGreen!50!black}{\faHandPointRight}\quad {\fangsong #1} \par}

\newcommand{\warn}[1]{\par\noindent\textcolor{red!50!black}{\faHighlighter}\quad {\fangsong #1} \par}
