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

## Usage:

**Service**

| Service                  | Verb | Route                                                |
| :----------------------: | :---:| :--------------------------------------------------: |
| Check API alive          | GET  | /                                                    |
| Add Text                 | POST | /api/v1/answer/{text}                                |
| Show information of Text | GET  | /api/v1/answer/{text}                                |
| List Texts               | GET  | /api/v1/answer?article={base64 json array of texts}  |

| :------------ |:---------------:| -----:|

**Installation**
```
$ bundle install -- without production
```

**Create databes**
```
$ rake db:wipe
$ rake db:migrate
or
$ RACK_ENV=test rake db:migrate
```

**Test API alive**
```
$ http https://sands-seoassistant-api.herokuapp.com/
```