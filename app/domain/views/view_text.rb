module Views
    # View for a single project entity
  class Text
    def initialize(text, index = nil)
      @text = text
      @index = index
      @keywords = text.keywords.map.with_index { |kw, i| Keyword.new(kw, i) }
    end

    def each
      @keywords.each.with_index do |kw, index|
        yield kw, index
      end
    end

    def entity
      @text
    end

    def text_link
      "/answer/#{text_content}"
    end

    def index_str
      "text[#{@index}]"
    end

    def text_content
      @text.text
    end

    def each_keyword
      @text.keywords.map(&:word).join(', ')
    end

    def keywords_num()
      @text.keywords.map(&:word).length
    end
  end
end
  