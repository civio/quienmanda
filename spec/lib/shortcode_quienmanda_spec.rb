require 'spec_helper'

describe Shortcodes::QuienManda do
  it "renders links with text" do
    content = Shortcodes.shortcode('[quienmanda url="http://www.quienmanda.es" text="quienmanda"]')
    content.strip.should == '<a href="http://www.quienmanda.es" target="_blank">quienmanda</a>'
  end

  it "renders links without text" do
    content = Shortcodes.shortcode('[quienmanda url="http://www.quienmanda.es/p/manolito-gafotas"]')
    content.strip.should == '<a href="http://www.quienmanda.es/p/manolito-gafotas" target="_blank">manolito-gafotas</a>'
  end
end
