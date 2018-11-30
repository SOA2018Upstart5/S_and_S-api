module Views
    # View for a single project entity
  class Keyword
    def initialize(keyword, index = nil)
      @keyword = keyword
      @index = index
    end

    def keyword_word()
      @keyword.word
    end

    def keyword_eng_word()
      @keyword.eng_word
    end

    def keyword_type()
      @keyword.type
    end

    def keyword_importance()
      num = (@keyword.importance * 100).to_i
      "#{num} %"
    end

    def keyword_url(num)
      many_url = @keyword.url.split('\n')
      many_url[num % (many_url.length)]
    end

    def keyword_url_num()
      @keyword.url.split('\n').length
    end

    def keyword_all_url()
      @keyword.url
    end
  end
end