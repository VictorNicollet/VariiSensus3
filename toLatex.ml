type t = Draft | Final | Pdf

let head_draft = "\\documentclass[10pt,twocolumn]{article}

\\usepackage[utf8]{inputenc}
\\usepackage[frenchb]{babel}

\\usepackage[T1]{fontenc}

\\usepackage[left=1cm,right=1cm,top=1.4cm,bottom=1.4cm]{geometry}
\\setlength{\\parindent}{0in}
\\setlength{\\parskip}{0.5cm}

\\begin{document}

\\begin{flushright}
  \\huge{Les enfants de la Brume}\\\\
  \\large{Victor Nicollet}
\\end{flushright}"

let head_pdf = "\\documentclass[10pt,openany]{book}

\\usepackage[papersize={5in,8in},margin=0.75in]{geometry}

\\usepackage[utf8]{inputenc}
\\usepackage[frenchb]{babel}

\\usepackage{lmodern}
\\usepackage[T1]{fontenc}

\\usepackage{setspace}
\\doublespace

\\usepackage{graphicx}
\\usepackage{changepage}

\\setlength{\\parindent}{0in}
\\setlength{\\parskip}{0.4cm}

\\begin{document}

\\pagestyle{empty}

\\changepage{2in}{3in}{-0.75in}{-0.75in}{0in}{-0.75in}{0in}{0in}{0in}
\\includegraphics[width=5in]{cover.eps}

\\clearpage

\\changepage{-2in}{-3in}{0.75in}{0.75in}{0in}{0.75in}{0in}{0in}{0in}

\\begin{flushright}

  \\verb+ +

  \\vfill
  \\huge{Le Culte de l'Archange}\\\\
  \\large{Victor Nicollet}

  \\vfill

\\end{flushright}

\\clearpage

\\changepage{0in}{1in}{-0.5in}{-0.5in}{0in}{0in}{0in}{0in}{0in}
\\includegraphics[width=4.5in]{map.eps}

\\clearpage
\\changepage{0in}{-1in}{0.5in}{0.5in}{0in}{0in}{0in}{0in}{0in}
"

let head_final = "\\documentclass[10pt,openleft,twoside]{book}

\\usepackage[papersize={5in,8in},margin={0.6in,0.75in}]{geometry}

\\setlength{\\oddsidemargin}{-1in}
\\setlength{\\evensidemargin}{-1in}
\\addtolength{\\oddsidemargin}{0.6in}
\\addtolength{\\evensidemargin}{0.6in}

\\addtolength{\\oddsidemargin}{0.2in}
\\addtolength{\\evensidemargin}{-0.2in}

\\usepackage[utf8]{inputenc}

\\usepackage{titlesec}
\\usepackage{color}
\\definecolor{gray}{rgb}{0.5,0.5,0.5}
\\titleformat{\\chapter}[hang]{\\LARGE\\bfseries}{\\textcolor{gray}{\\thechapter\\ · }}{0pt}{\\LARGE\\bfseries\\sc}
\\titlespacing{\\chapter}{0pt}{-30pt}{40pt}

\\usepackage[frenchb]{babel}

\\usepackage{lmodern}
\\usepackage[T1]{fontenc}

\\author{Victor Nicollet}

\\usepackage{setspace}
\\onehalfspace

\\usepackage{graphicx}
\\usepackage{changepage}

\\setlength{\\parindent}{0in}
\\setlength{\\parskip}{0.4cm}

\\begin{document}

\\sloppy

\\pagestyle{plain}

\\thispagestyle{empty}
\\verb+ + 
\\clearpage

\\thispagestyle{empty}
\\verb+ + 
\\clearpage

\\thispagestyle{empty}

\\begin{flushright}

  \\verb+ +

  \\vfill
  \\huge{Le Culte de l'Archange}\\\\
  \\large{Victor Nicollet}

  \\vfill

  {}

  \\vfill

\\end{flushright}

\\clearpage

\\thispagestyle{empty}

\\begin{center}
\\includegraphics[width=3.9in]{map-left.eps}
\\end{center}

\\clearpage

\\thispagestyle{empty}

\\begin{center}
\\includegraphics[width=3.9in]{map-right.eps}
\\end{center}
"

let head = function
  | Pdf   -> head_pdf
  | Draft -> head_draft
  | Final -> head_final

let fin = "
\\cleardoublepage
\\thispagestyle{empty}
\\section*{Le mot de l'auteur}
\\singlespace
\\vfill
{\\small
J'espère que vous avez pris beaucoup de plaisir à lire ce roman ! Pour vous tenir au courant de la sortie des volumes suivants, rendez-vous sur :

\\verb+http://nicollet.net/le-culte-de-l-archange+}

\\begin{flushright}
Victor Nicollet
\\end{flushright}

\\vfill

\\begin{center}

{\\tiny
  \\textcircled{c} 2013 Victor Nicollet\\\\
}

\\end{center}
\\end{document}\n"

class toLatex what = object

  val final = (what <> Draft)

  val buffer = 
    let buffer = Buffer.create 1024 in
    Buffer.add_string buffer (head what) ;
    buffer 

  method start_chapter title =
    let nbsp = Str.regexp (Str.quote "&#160;") in
    Buffer.add_string buffer (if final then "\\chapter{" else "\\section{") ;
    Buffer.add_string buffer (Str.global_replace nbsp "~" title);
    Buffer.add_string buffer "}\\thispagestyle{empty} %%%%%%%%%%%%%%%%%%%%\n\n"

  method start_emphasis =
    Buffer.add_string buffer "\\textit{"
  method end_emphasis = 
    Buffer.add_string buffer "}"
  method start_small = 
    Buffer.add_string buffer "{\\small "
  method end_small = 
    Buffer.add_string buffer "}"
  method start_strong = 
    Buffer.add_string buffer "\\textbf{ "
  method end_strong = 
    Buffer.add_string buffer "}"
  method line_break = 
    Buffer.add_string buffer "\\\\\n"
  method end_paragraph = 
    Buffer.add_string buffer "\n\n" 
  method start_paragraph = 
    Buffer.add_string buffer ""
  method non_letter c = 
    Buffer.add_char buffer c
  method start_quote = 
    Buffer.add_string buffer " «~"
  method start_dialog =  
    Buffer.add_string buffer " «~"
  method next_tirade = 
    Buffer.add_string buffer "\\\\\n---\\ "
  method emdash = 
    Buffer.add_string buffer "---"
  method end_dialog = 
    Buffer.add_string buffer "~»\n\n"
  method end_quote = 
    Buffer.add_string buffer "~» "
  method word word = 
    Buffer.add_string buffer word

  method contents = 
    Buffer.contents buffer ^ "\n" ^ (if final then fin else "\end{document}")

end

