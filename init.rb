%w[config app]
.each do |folder|
    require_relative "#{folder}/init.rb"
end


#text = SeoAssistant::OutAPI::TextMapper.new(JSON.parse(SeoAssistant::App.config.GOOGLE_CREDS), SeoAssistant::App.config.UNSPLASH_ACCESS_KEY).process("狗是最好的朋友")
#puts text.keywords[0].url
#puts SeoAssistant::Repository::For.entity(text)
#SeoAssistant::Database::TextOrm.create(text.to_attr_hash)
#puts text.to_attr_hash
