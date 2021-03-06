require 'vanilla/renderers/base'

require 'rubygems'
# from http://www.deveiate.org/projects/BlueCloth
gem 'BlueCloth'
require 'bluecloth'

module Vanilla::Renderers
  class Markdown < Base
    def process_text(snip, content, args)
      BlueCloth.new(content).to_html
    end
  end
end