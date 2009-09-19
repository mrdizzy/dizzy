ActiveRecord::Base.send(:include, HasBinary)
ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, MigrationsBinary)
ActionController::Base.send(:include, RenderBinary)