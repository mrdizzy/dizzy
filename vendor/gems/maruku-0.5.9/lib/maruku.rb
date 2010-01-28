require 'rexml/document'

module MaRuKu

	module In
		module Markdown
			module SpanLevelParser; end
			module BlockLevelParser; end
		end
		# more to come?
	end

	module Out
		# Functions for exporting to MarkDown.
		module Markdown; end
		# Functions for exporting to HTML.
		module HTML; end
		# Functions for exporting to Latex
		module Latex; end
	end
		
	# These are strings utilities.
	module Strings; end

	module Helpers; end

	module Errors; end
		
	class MDElement
		include REXML
		include MaRuKu
		include Out::Markdown
		include Out::HTML
		include Out::Latex
		include Strings
		include Helpers
		include Errors
	end
		
	class MDDocument < MDElement
		include In::Markdown
		include In::Markdown::SpanLevelParser
		include In::Markdown::BlockLevelParser
	end
end

# This is the public interface
class Maruku < MaRuKu::MDDocument; end

# Structures definition
require 'maruku/structures'
require 'maruku/structures_inspect'

require 'maruku/defaults'

# Less typings
require 'maruku/helpers'

# Code for parsing whole Markdown documents
require 'maruku/input/parse_doc'

# Ugly things kept in a closet
require 'maruku/string_utils'
require 'maruku/input/linesource'
require 'maruku/input/type_detection'

# A class for reading and sanitizing inline HTML
require 'maruku/input/html_helper'

# Code for parsing Markdown block-level elements
require 'maruku/input/parse_block'

# Code for parsing Markdown span-level elements
require 'maruku/input/charsource'
require 'maruku/input/parse_span_better'
require 'maruku/input/rubypants'

require 'maruku/input/extensions'

require 'maruku/attributes'

require 'maruku/structures_iterators'

require 'maruku/errors_management'

# Code for creating a table of contents
require 'maruku/toc'

# Version and URL
require 'maruku/version'

# Exporting to html
require 'maruku/output/to_html'

# class Maruku is the global interface
require 'maruku/maruku'
