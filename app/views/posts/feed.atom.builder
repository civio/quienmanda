atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated

  @posts.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.title item.title
      entry.content item.lead, :type => 'html'
      entry.author do |author|
        author.name(item.author.name)
      end
    end
  end
end
