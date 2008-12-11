
class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

protected
  def page_link(page, text, attributes = {})
  	puts url_for("david")
    @template.link_to_remote(text, {:url => url_for(page), :method => :get}.merge(@remote))
  end
end
