$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'maruku'

markdown_string = <<-EOF
# Header

## Second header

### Third header



EOF

doc = Maruku.new(markdown_string)
puts doc.to_html