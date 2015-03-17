let opf_head = 
"<?xml version='1.0' encoding='utf-8'?>
<package xmlns=\"http://www.idpf.org/2007/opf\"
            xmlns:dc=\"http://purl.org/dc/elements/1.1/\"
            unique-identifier=\"bookid\" version=\"2.0\">
  <metadata>
    <dc:title>Le Culte de l'Archange</dc:title>
    <dc:creator>Victor Nicollet</dc:creator>
    <dc:identifier
id=\"bookid\">urn:http//nicollet.net/book-1</dc:identifier>
    <dc:language>en-US</dc:language>
    <meta name=\"cover\" content=\"cover-image\" />
  </metadata>
  <manifest>
    <item id=\"ncx\" href=\"toc.ncx\" media-type=\"application/x-dtbncx+xml\"/>
    <item id=\"cover\" href=\"title.htm\" media-type=\"application/xhtml+xml\"/>
    <item id=\"map\" href=\"map.htm\" media-type=\"application/xhtml+xml\"/>"

let opf_mid = 
"    <item id=\"cover-image\" href=\"cover.png\" media-type=\"image/png\"/>
    <item id=\"map-image\" href=\"map.png\" media-type=\"image/png\"/>
    <item id=\"css\" href=\"main.css\" media-type=\"text/css\"/>
  </manifest>
  <spine toc=\"ncx\">
    <itemref idref=\"cover\" linear=\"no\"/>
    <itemref idref=\"map\" linear=\"no\"/>
"

let opf_foot = "  
    </spine>
  <guide>
    <reference href=\"title.htm\" type=\"cover\" title=\"Le Culte de l'Archange\"/>
  </guide>
</package>"


let ncx_head = 
"<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE ncx PUBLIC \"-//NISO//DTD ncx 2005-1//EN\"
                 \"http://www.daisy.org/z3986/2005/ncx-2005-1.dtd\">
<ncx xmlns=\"http://www.daisy.org/z3986/2005/ncx/\" version=\"2005-1\">
  <head>
    <meta name=\"dtb:uid\"
content=\"urn:http//nicollet.net/book-1\"/>
    <meta name=\"dtb:depth\" content=\"1\"/>
    <meta name=\"dtb:totalPageCount\" content=\"0\"/>
    <meta name=\"dtb:maxPageNumber\" content=\"0\"/>
  </head>
  <docTitle>
    <text>Le Culte de l'Archange</text>
  </docTitle>
  <navMap>
    <navPoint id=\"title\" playOrder=\"0\">
      <navLabel>
        <text>Couverture</text>
      </navLabel>
      <content src=\"title.htm\"/>
    </navPoint>
    <navPoint id=\"map\" playOrder=\"1\">
      <navLabel>
        <text>Carte d'Athanor</text>
      </navLabel>
      <content src=\"map.htm\"/>
    </navPoint>"

let ncx_item (path,title) = 
  let n = int_of_string (String.sub path 0 2) in
  Printf.sprintf "<navPoint id=\"chapter-%s\" playOrder=\"%d\">
      <navLabel>
        <text>%d. %s</text>
      </navLabel>
      <content src=\"%s.htm\"/>
    </navPoint>"
    path (2 + n) n title path

let ncx_foot = "  
   </navMap>
</ncx>"

let head chap = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">
  <head>
    <meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml; charset=utf-8\" />
    <title>" ^ chap ^ "</title>
    <link rel=\"stylesheet\" href=\"main.css\" type=\"text/css\" />
  </head>
  <body>
  <h1> "^ chap ^ "</h1>"

let foot = "  </body>
</html>" 


class toEpub = object

  val buffer = Buffer.create 1024

  method start_chapter title =
    Buffer.add_string buffer (head title) 
  method start_emphasis =
    Buffer.add_string buffer "<em>"
  method end_emphasis = 
    Buffer.add_string buffer "</em>"
  method start_small = 
    Buffer.add_string buffer "<small>"
  method end_small = 
    Buffer.add_string buffer "</small>"
  method start_strong = 
    Buffer.add_string buffer "<strong>"
  method end_strong = 
    Buffer.add_string buffer "</strong>"
  method line_break = 
    Buffer.add_string buffer "<br/>"
  method end_paragraph = 
    Buffer.add_string buffer "</p>" 
  method start_paragraph = 
    Buffer.add_string buffer "<p class=\"t\">"
  method non_letter c = 
    let () = match c with 
      | '?' | '!' | ':' -> Buffer.add_string buffer "&nbsp;"
      | _ -> () 
    in
    match c with
    | '\'' -> Buffer.add_string buffer "&rsquo;" 
    | _ -> Buffer.add_char buffer c
  method start_quote = 
    Buffer.add_string buffer " &laquo;&nbsp;"
  method start_dialog = 
    Buffer.add_string buffer "<p class=\"ds\">&laquo;&nbsp;"
  method next_tirade = 
    Buffer.add_string buffer "</p><p class=\"d\">&mdash;&nbsp;"
  method emdash = 
    Buffer.add_string buffer "&mdash;"
  method end_dialog = 
    Buffer.add_string buffer "&nbsp;&raquo;</p>"
  method end_quote = 
    Buffer.add_string buffer "&nbsp;&raquo; "

  method word word = 
    Buffer.add_string buffer word

  method contents = 
    Buffer.contents buffer ^ foot

end

