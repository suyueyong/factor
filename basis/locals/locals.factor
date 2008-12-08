! Copyright (C) 2007, 2008 Slava Pestov, Eduardo Cavazos.
! See http://factorcode.org/license.txt for BSD license.
USING: lexer locals.parser locals.types macros memoize parser
sequences vocabs vocabs.loader words kernel ;
IN: locals

: :> scan <local> <def> parsed ; parsing

: [| parse-lambda parsed-lambda ; parsing

: [let
    "|" expect "|" parse-bindings
    \ ] (parse-lambda) <let> parsed-lambda ; parsing

: [let*
    "|" expect "|" parse-bindings*
    \ ] (parse-lambda) <let*> parsed-lambda ; parsing

: [wlet
    "|" expect "|" parse-wbindings
    \ ] (parse-lambda) <wlet> parsed-lambda ; parsing

: :: (::) define ; parsing

: M:: (M::) define ; parsing

: MACRO:: (::) define-macro ; parsing

: MEMO:: (::) define-memoized ; parsing

{
    "locals.macros"
    "locals.fry"
} [ require ] each

"prettyprint" vocab [
    "locals.definitions" require
    "locals.prettyprint" require
] when
