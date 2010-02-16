begin  
  require 'deadweight'  
rescue LoadError   
end  
begin
  require 'deadweight'
rescue LoadError
end

desc "run Deadweight (requires script/server)"  
task :deadweight do  
  dw = Deadweight.new  
  dw.stylesheets = ['/stylesheets/main.css', '/stylesheets/markdown.css', '/stylesheets/printer.css', '/stylesheets/syntax_highlighting.css']   
  dw.pages = ['/ruby_on_rails/cheatsheets/active-record-validation-errors', '/ruby_on_rails/cheatsheets/rails-migrations', '/ruby_on_rails/contents/exception-handling-services', '/', '/portfolios', '/ruby_on_rails/cheatsheets', '/ruby_on_rails/latest']   
  puts dw.run   
end  