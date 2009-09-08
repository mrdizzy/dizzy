require 'digest/md5'
require 'net/http'
require 'captcha_view'
ActiveRecord::Base.send(:include, TextCaptcha)
ActionView::Base.default_form_builder = CaptchaFormBuilder

