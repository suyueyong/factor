! Copyright (C) 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors arrays combinators html.elements io io.streams.string
kernel math memoize namespaces peg peg.ebnf prettyprint
sequences sequences.deep strings xml.entities vectors splitting
xmode.code2html ;
IN: farkup

SYMBOL: relative-link-prefix
SYMBOL: disable-images?
SYMBOL: link-no-follow?

TUPLE: heading1 obj ;
TUPLE: heading2 obj ;
TUPLE: heading3 obj ;
TUPLE: heading4 obj ;
TUPLE: strong obj ;
TUPLE: emphasis obj ;
TUPLE: superscript obj ;
TUPLE: subscript obj ;
TUPLE: inline-code obj ;
TUPLE: paragraph obj ;
TUPLE: list-item obj ;
TUPLE: list obj ;
TUPLE: table obj ;
TUPLE: table-row obj ;
TUPLE: link href text ;
TUPLE: image href text ;
TUPLE: code mode string ;

EBNF: farkup
nl               = ("\r\n" | "\r" | "\n") => [[ drop "\n" ]]
2nl              = nl nl

heading1      = "=" (!("=" | nl).)+ "="
    => [[ second >string heading1 boa ]]

heading2      = "==" (!("=" | nl).)+ "=="
    => [[ second >string heading2 boa ]]

heading3      = "===" (!("=" | nl).)+ "==="
    => [[ second >string heading3 boa ]]

heading4      = "====" (!("=" | nl).)+ "===="
    => [[ second >string heading4 boa ]]

strong        = "*" (!("*" | nl).)+ "*"
    => [[ second >string strong boa ]]

emphasis      = "_" (!("_" | nl).)+ "_"
    => [[ second >string emphasis boa ]]

superscript   = "^" (!("^" | nl).)+ "^"
    => [[ second >string superscript boa ]]

subscript     = "~" (!("~" | nl).)+ "~"
    => [[ second >string subscript boa ]]

inline-code   = "%" (!("%" | nl).)+ "%"
    => [[ second >string inline-code boa ]]

escaped-char  = "\" .                => [[ second ]]

image-link       = "[[image:" (!("|") .)+  "|" (!("]]").)+ "]]"
                    => [[ [ second >string ] [ fourth >string ] bi image boa ]]
                  | "[[image:" (!("]").)+ "]]"
                    => [[ second >string f image boa ]]

simple-link      = "[[" (!("|]" | "]]") .)+ "]]"
    => [[ second >string dup link boa ]]

labelled-link    = "[[" (!("|") .)+ "|" (!("]]").)+ "]]"
    => [[ [ second >string ] [ fourth >string ] bi link boa ]]

link             = image-link | labelled-link | simple-link

heading          = heading4 | heading3 | heading2 | heading1

inline-tag       = strong | emphasis | superscript | subscript | inline-code
                   | link | escaped-char

inline-delimiter = '*' | '_' | '^' | '~' | '%' | '\' | '['

table-column     = (list | (!(nl | inline-delimiter | '|').)+ | inline-tag | inline-delimiter  ) '|'
    => [[ first ]]
table-row        = "|" (table-column)+
    => [[ second table-row boa ]]
table            =  ((table-row nl => [[ first ]] )+ table-row? | table-row)
    => [[ table boa ]]

paragraph-item = ( table | (!(nl | code | heading | inline-delimiter | table ).) | inline-tag | inline-delimiter)+
paragraph = ((paragraph-item nl => [[ first ]])+ nl+ => [[ first ]]
             | (paragraph-item nl)+ paragraph-item?
             | paragraph-item)
    => [[ paragraph boa ]]
                
list-item      = '-' ((!(inline-delimiter | nl).)+ | inline-tag)*
    => [[ second list-item boa ]]
list = ((list-item nl)+ list-item? | list-item)
    => [[ list boa ]]

code       =  '[' (!('{' | nl | '[').)+ '{' (!("}]").)+ "}]"
    => [[ [ second >string ] [ fourth >string ] bi code boa ]]

stand-alone      = (code | heading | list | table | paragraph | nl)*
;EBNF



: invalid-url "javascript:alert('Invalid URL in farkup');" ;

: check-url ( href -- href' )
    {
        { [ dup empty? ] [ drop invalid-url ] }
        { [ dup [ 127 > ] contains? ] [ drop invalid-url ] }
        { [ dup first "/\\" member? ] [ drop invalid-url ] }
        { [ CHAR: : over member? ] [
            dup { "http://" "https://" "ftp://" } [ head? ] with contains?
            [ drop invalid-url ] unless
        ] }
        [ relative-link-prefix get prepend ]
    } cond ;

: escape-link ( href text -- href-esc text-esc )
    >r check-url escape-quoted-string r> escape-string ;

: write-link ( text href -- )
    escape-link
    "<a" write
    " href=\"" write write "\"" write
    link-no-follow? get [ " nofollow=\"true\"" write ] when
    ">" write write "</a>" write ;

: write-image-link ( href text -- )
    disable-images? get [
        2drop "<strong>Images are not allowed</strong>" write
    ] [
        escape-link
        >r "<img src=\"" write write "\"" write r>
        dup empty? [ drop ] [ " alt=\"" write write "\"" write ] if
        "/>" write
    ] if ;

: render-code ( string mode -- string' )
    >r string-lines r>
    [
        <pre>
            htmlize-lines
        </pre>
    ] with-string-writer write ;

GENERIC: write-farkup ( obj -- )
: <foo.> ( string -- ) <foo> write ;
: </foo.> ( string -- ) </foo> write ;
: in-tag. ( obj quot string -- ) [ <foo.> call ] keep </foo.> ; inline
M: heading1 write-farkup ( obj -- ) [ obj>> write-farkup ] "h1" in-tag. ;
M: heading2 write-farkup ( obj -- ) [ obj>> write-farkup ] "h2" in-tag. ;
M: heading3 write-farkup ( obj -- ) [ obj>> write-farkup ] "h3" in-tag. ;
M: heading4 write-farkup ( obj -- ) [ obj>> write-farkup ] "h4" in-tag. ;
M: strong write-farkup ( obj -- ) [ obj>> write-farkup ] "strong" in-tag. ;
M: emphasis write-farkup ( obj -- ) [ obj>> write-farkup ] "em" in-tag. ;
M: superscript write-farkup ( obj -- ) [ obj>> write-farkup ] "sup" in-tag. ;
M: subscript write-farkup ( obj -- ) [ obj>> write-farkup ] "sub" in-tag. ;
M: inline-code write-farkup ( obj -- ) [ obj>> write-farkup ] "code" in-tag. ;
M: list-item write-farkup ( obj -- ) [ obj>> write-farkup ] "li" in-tag. ;
M: list write-farkup ( obj -- ) [ obj>> write-farkup ] "ul" in-tag. ;
M: paragraph write-farkup ( obj -- ) [ obj>> write-farkup ] "p" in-tag. ;
M: link write-farkup ( obj -- ) [ text>> ] [ href>> ] bi write-link ;
M: image write-farkup ( obj -- ) [ href>> ] [ text>> ] bi write-image-link ;
M: code write-farkup ( obj -- ) [ string>> ] [ mode>> ] bi render-code ;
M: table-row write-farkup ( obj -- )
    obj>> [ [ [ write-farkup ] "td" in-tag. ] each ] "tr" in-tag. ;
M: table write-farkup ( obj -- ) [ obj>> write-farkup ] "table" in-tag. ;
M: fixnum write-farkup ( obj -- ) write1 ;
M: string write-farkup ( obj -- ) write ;
M: vector write-farkup ( obj -- ) [ write-farkup ] each ;
M: f write-farkup ( obj -- ) drop ;

: convert-farkup ( string -- string' )
    farkup [ write-farkup ] with-string-writer ;