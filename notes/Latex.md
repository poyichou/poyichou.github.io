### Notes-Latex  

#### Installation  
```bash
# contains most TeX Live packages
sudo pacman -S texlive-most
# contains packages providing character sets and features for non-English languages
sudo pacman -S texlive-lang
```
#### To use chinese  
```latex
\usepackage{CJKutf8} % add
...
\begin{document}
\begin{CJK}{UTF8}{bsmi} % add
...
\end{CJK} % add
\end{document} 
```
#### Problem:  
```latex
% Description:
%   It happens when compiling with pdflatex while using \tableofcontents
%   with sections containing chinese characters.
%   error message: Package inputenc Error: Unicode char \u 8: XXX not set up for use with LaTeX
%   note: you may have to compile the .tex file twice after applying this solution
...
\clearpage % add
\end{CJK}
```

