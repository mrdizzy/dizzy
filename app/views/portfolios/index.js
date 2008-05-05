<% @companies.each do |company| %>
	<p><%= link_to_remote company.name, :url =>{ :action => "show_ajax", :id => company.id } %></p>
<% end %>

<%= link_to_remote "&laquo; Previous", { :url => portfolios_path(:page => @company_pages.current.previous), :method => :get } if @company_pages.current.previous %>

<%= link_to_remote "Next &raquo;", { :url => portfolios_path(:page => @company_pages.current.next), :method => :get } if @company_pages.current.next %>