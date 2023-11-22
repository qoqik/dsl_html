class HtmlDsl

  attr_accessor :result, :arguments

  def initialize(&block)
    @result = ""
    @indentation = 0
    @arguments = {}
    instance_eval(&block)
  end

  def parsing(arguments = {})
    @arguments = arguments
  end

  def content(value)
    @result += "\n" + " " * @indentation
    @result += value.to_s
  end

  def p (*args, &block)
    method_missing("p", *args, &block)
  end

  def method_missing(name, *args, &block)
    tag = name.to_s
    @result += "\n" + " " * @indentation + "<#{tag}"
    if block_given?
      parsing(args[0] || {})
      @arguments.each_pair { |key, value| @result += " #{key}=\"#{value}\"" }
      @result += ">"
      @indentation += 2
      instance_eval(&block)
      @indentation -= 2
    end
    @result += "\n" + " " * @indentation
    @result += "</#{tag}>"
  end

end

html = HtmlDsl.new do
  html do
    head do
      title do
        content "My Website"
      end
    end
    body class: "main" do
      h1 id: "heading", class: "title" do
        content "Welcome!"
      end
      p do
        content "Website using HTML DSL."
      end
    end
  end
end
puts html.result