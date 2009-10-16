class SyntaxHighlighter

   def self.highlight_code(code)


# Class
code = code.gsub(/^\s*(class)\s+([.a-zA-Z0-9_:]+)\s*(<\s*([.a-zA-Z0-9_:]+)?)/, "<class>\\1</class>")

# Module
code =~ /^\s*(module)\s+([.a-zA-Z0-9_:]+)\s*(<\s*([.a-zA-Z0-9_:]+)?)/

# every reserved word, being a value
code = code.gsub(/(nil|true|false|__(FILE|LINE)__|self)/, "<reserved_word_value>\\1</reserved_word_value>")

# everything being a method but having a special function
code =~ /\b(initialize|new|loop|include|require|raise|attr_reader|attr_writer|attr_accessor|attr|catch|throw|private|public|protected)\b/

# Instance variable
code =~ /@[a-zA-Z_]\w*/

# Class variable
code =~ /@@[a-zA-Z_]\w*/

# Constant
code =~ /[A-Z]\w*/

# Symbols
code = code.gsub(/(:(?>[a-zA-Z_]\w*(?>[?!]|=(?![>=]))?|===?|>[>=]?|<[<=]?|<=>|[%&`\/\|]|\*\*?|=?~|[-+]@?|\[\]=?|@@?[a-zA-Z_]\w*))/, "<span class=\"sy\">\\1</span>")

# everything being a reserved word, not a value and needing a ''end'' is a..
code = code.gsub(/\b(def|BEGIN|begin|case|else|elsif|END|end|ensure|for|if|in|rescue|then|unless|until|when|while)\b/, "<span class=\"r\">\\1</span>")

# Comment
code = code.gsub(/(#.*$\n?a)/, "<span class=\"c\">\\1</span>")
end
end