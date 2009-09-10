ActiveRecord::Base.send(:include, TextCaptcha)
ActionView::Helpers::FormBuilder.send(:include, Dizzy::FormBuilder)