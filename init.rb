%w[config app]
.each do |folder|
    require_relative "#{folder}/init.rb"
end


#text = SeoAssistant::OutAPI::TextMapper.new(JSON.parse(SeoAssistant::App.config.GOOGLE_CREDS), SeoAssistant::App.config.UNSPLASH_ACCESS_KEY).process("狗是最好的朋友")
#puts text.keywords[0].url
#puts SeoAssistant::Repository::For.entity(text)
#SeoAssistant::Database::TextOrm.create(text.to_attr_hash)
#puts text.to_attr_hash

#Ruby 是一種物件導向、命令式、函數式、動態的通用程式語言。在20世紀90年代中期由日本電腦科學家松本行弘（Matz）設計並開發。遵守BSD授權條款和Ruby License[10][註 1]。它的靈感與特性來自於Perl、Smalltalk、Eiffel、Ada以及Lisp語言。由Ruby語言本身還發展出了JRuby（Java平台）、IronRuby（.NET平台）等其他平台的Ruby語言替代品。"
