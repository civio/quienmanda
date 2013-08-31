require 'spec_helper'

describe Post do
  context 'when parsing a post content' do
    before do
      @public_person = create(:public_person, name: "Big shot", slug: "big-shot")
      @public_organization = create(:public_organization, name: "Big company", slug: "big-company")

      @extractors = [
        { regex: /^\/people\/(.*)$/, method: ->(slug) { Entity.find_by_slug(slug) } },
        { regex: /^\/organizations\/(.*)$/, method: ->(slug) { Entity.find_by_slug(slug) } }
      ]
    end

    it 'standard links are ignored' do
      content = 'Hello <a href="http://world.com">world</a>'
      post = create(:public_post, content: content)
      references = post.extract_references('quienmanda.es', @extractors)
      references.should == []
    end

    it 'returns list of referenced people' do
      content = 'He is a <a href="http://quienmanda.es/people/big-shot">big shot</a>'
      post = create(:public_post, content: content)
      references = post.extract_references('quienmanda.es', @extractors)
      references.size.should == 1
      references.first.should == @public_person
    end

    it 'returns list of referenced people in subdomains too' do
      content = 'He is a <a href="http://www.quienmanda.es/people/big-shot">big shot</a>'
      post = create(:public_post, content: content)
      references = post.extract_references('quienmanda.es', @extractors)
      references.size.should == 1
      references.first.should == @public_person
    end

    it 'can handle both people and organizations' do
      content = 'He is a <a href="http://www.quienmanda.es/people/big-shot">big shot</a> '+
                'at a <a href="http://www.quienmanda.es/organizations/big-company">big company</a>.'
      post = create(:public_post, content: content)
      references = post.extract_references('quienmanda.es', @extractors)
      references.size.should == 2
      references.first.should == @public_person
      references.last.should == @public_organization
    end
  end
end
