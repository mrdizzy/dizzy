module ActionController
	module RecordIdentifier

		def dom_id(record, prefix = nil) 
		  if record_id = record.id
			  "#{dom_class(record, prefix)}#{JOIN}#{record_id}"
		  else
		  "#{NEW}#{JOIN}#{dom_class(record, prefix)}#{JOIN}#{record.object_id}"
		  end
		end
	end
end