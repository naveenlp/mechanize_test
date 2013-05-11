require 'rubygems'
require 'mechanize'

agent = Mechanize.new

page = agent.get("http://www.google.com/")

google_form = page.form(‘f’)
google_form.q = ‘mechanize’
page = agent.submit(google_form, google_form.buttons.first)