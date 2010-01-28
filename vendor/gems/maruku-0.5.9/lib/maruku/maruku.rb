class Maruku
	def initialize(s=nil, meta={})
		super(nil)
		self.attributes.merge! meta
		if s
			parse_doc(s)
		end
	end
end
