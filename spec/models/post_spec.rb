require 'spec_helper'

describe Post do
  # extract_references is a private method called before_save, but we want to test it
  context 'when parsing a post content' do
    before do
      @public_person = create(:public_person, name: "Big shot", slug: "big-shot")
      @public_organization = create(:public_organization, name: "Big company", slug: "big-company")

      @extractors = [
        { prefix: '/people', method: ->(slug) { Entity.find_by_slug(slug) } },
        { prefix: '/orgs', method: ->(slug) { Entity.find_by_slug(slug) } }
      ]
    end

    it 'standard links are ignored' do
      content = 'Hello <a href="http://world.com">world</a>'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.should == []
      post.content.should == content
    end

    it 'does not break if an invalid url is found' do
      content = 'Hello <a href="crap:foobár">world</a>'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.should == []
    end

    it 'does not choke on anchors' do
      content = 'Hello <a id="anchor" name="anchor"></a>'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.should == []
    end

    it 'returns list of referenced people' do
      content = 'He is a <a href="http://qm.es/people/big-shot">big shot</a>'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.size.should == 1
      references.first.should == @public_person
    end

    it 'returns list of referenced people in subdomains too' do
      content = 'He is a <a href="http://www.qm.es/people/big-shot">big shot</a>'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.size.should == 1
      references.first.should == @public_person
    end

    it 'can handle both people and orgs' do
      content = 'He is a <a href="http://www.qm.es/people/big-shot">big shot</a> '+
                'at a <a href="http://www.qm.es/orgs/big-company">big company</a>.'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.size.should == 2
      references.first.should == @public_person
      references.last.should == @public_organization
    end

    it 'adds a blank target to links' do
      content = 'He is a <a href="http://www.qm.es/people/big-shot">big shot</a> '+
                'at a <a href="http://www.qm.es/orgs/big-company">big company</a>.'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)

      post.content.should ==  'He is a <a href="http://www.qm.es/people/big-shot" target="_blank">' + 
        'big shot</a> at a <a href="http://www.qm.es/orgs/big-company" target="_blank">big company</a>.'
    end

    it 'marks references to non existent entities' do
      content = 'He is just a <a href="http://qm.es/people/random-guy">random guy</a>'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.size.should == 0
      post.content.should == 'He is just a <a href="http://qm.es/people/random-guy" class="broken-link">random guy</a>'
    end

    it 'marks links that reference things we know nothing about' do
      content = 'He is just <a href="http://qm.es/stuff/weird">weird</a>'
      post = create(:public_post, content: content)
      references = post.send(:extract_references, 'qm.es', @extractors)
      references.size.should == 0
      post.content.should == 'He is just <a href="http://qm.es/stuff/weird" class="unknown-link">weird</a>'
    end
  end
end
