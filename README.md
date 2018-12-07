# S&S_SeoAssistant
Application that allows users know keyword in any article and offer them pictures of each keyword.

## Overview
SeoAssistant can take the Chinese article pasted by user and analysize by using Google Cloud Natural Language API, which will come out "Entities" as the keyword of article.

Then, SeoAssistant will use Google Translaton API to translate keywords from Chinese to English in order to search the picture online.

Finally, SeoAssistant will pull the link of pictures which are online and have no copyright to anyone from Unsplash API.

We hope this application can help some content designer more easier to understand other article and generate attractive picture to make a report or article.

Here are the links of APIs we use:
[Unsplash Developers,](https://unsplash.com/developers)
[Cloud Natural Langrage,](https://cloud.google.com/natural-language/docs/quickstart-client-libraries#client-libraries-usage-ruby)
[Cloud Translation](https://cloud.google.com/translate/docs/quickstart-client-libraries)

## Usability goals
* Analysize the article and generate the keywords
* Translate the keywords
* Search pictures with keywords
* Display keywords and pictures in disigned layout.
SeoAssistant::OutAPI::TextMapper
          .new(JSON.parse(SeoAssistant::Api.config.GOOGLE_CREDS), SeoAssistant::Api.config.UNSPLASH_ACCESS_KEY)
          .process(input[:decode_text])

## Usage:

**Service**
Check API alive => GET /
Add Text => POST /api/v1/answer/{text}
Show information of Text => GET /api/v1/answer/{text}
List Texts => GET /api/v1/answer?article={base64 json array of texts}

text = SeoAssistant::Repository::Texts.find_text("狗是最好的朋友")
text = SeoAssistant::Repository::For.klass(SeoAssistant::Entity::Text).find_text("狗是最好的朋友")
text = SeoAssistant::Database::TextOrm.all
text = SeoAssistant::OutAPI::TextMapper.new(JSON.parse(SeoAssistant::Api.config.GOOGLE_CREDS), SeoAssistant::Api.config.UNSPLASH_ACCESS_KEY).process("狗是最好的朋友")
**Installation**
```
$ bundle install
```

**Create databes**
```
$ rake db:wipe
$ rake db:migrate
or
$ RACK_ENV=test rake db:migrate
```

**Google path setting**
```
$ export GOOGLE_APPLICATION_CREDENTIALS="config/google_credential.json"
```


**Search a picture with keyword**
```ruby
search_pic = SeoAssistant::OutAPI::Unsplash
  .new(SeoAssistant::App.config.UNSPLASH_ACCESS_KEY), "dog")
puts search_pic.process['results'][0]['urls']['raw'] #string
```
> <dog_picture_first_url>

**Translate to English**
```ruby
translate_word = SeoAssistant::OutAPI::Translate.new("狗,貓,公車")
puts translate_word.process #string
```
> "Dog, cat, bus"

**Analyze text**
```ruby
text = "Google, headquartered in Mountain View, unveiled the new Android phone at the Consumer Electronic Show./
            Sundar Pichai said in his keynote that users love their new Android phones."
analyze_text = SeoAssistant::OutAPI::Analyze
  .new(JSON.parse(SeoAssistant::App.config.GOOGLE_CREDS, text)
puts analyze_text.process.keyword #array
puts analyze_text.process.type #array
puts analyze_text.process.importance #array
```
> Google   users   phone   Android   Sundar Pichai   Mountain View   Consumer Electronic Show   phones   keynote

> ORGANIZATION   PERSON   CONSUMER_GOOD   CONSUMER_GOOD   PERSON   LOCATION   EVENT   CONSUMER_GOOD   OTHER

> 0.22637900710105896   0.191544771194458   0.18347220122814178   0.09827315807342529   0.09172182530164719   0.07637178152799606   0.05269023776054382   0.052234947681427   0.027312073856592


**Overall usage**
```ruby
text = SeoAssistant::OutAPI::TextMapper
  .new(JSON.parse(SeoAssistant::App.config.GOOGLE_CREDS), SeoAssistant::App.config.UNSPLASH_ACCESS_KEY)
  .process("狗是最好的朋友")
puts text.text #array
puts text.keywords[0].url #string of many url link join with '\n'
```
> "狗是最好的朋友"
> <dog_picture_random_url>

```ruby
many_url = text.keywords[0].url.split('\n')

many_url.map do |url|
    a=gets.chomp.to_s
    if a == "ok"
        puts url
    end
end
```