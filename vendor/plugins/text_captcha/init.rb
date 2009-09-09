require 'net/http'
ActiveRecord::Base.send(:include, TextCaptcha)
ActionView::Base.default_form_builder = CaptchaFormBuilder

