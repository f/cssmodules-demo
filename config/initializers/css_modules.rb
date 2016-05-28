require 'css_parser'

class CSSModules
  RE_GLOBAL = /^\:g(lobal)?\s+/
  RE_MODULE = /^\:module\((.*?)\)\s+(.*)/

  RE_ID_SELECTOR = /^#/
  RE_CLASS_SELECTOR = /^\./

  def rebuild_selector(name, selector)
    if selector =~ RE_ID_SELECTOR
      "##{name}_#{selector.gsub(RE_ID_SELECTOR, "")}"
    elsif selector =~ RE_CLASS_SELECTOR
      ".#{name}_#{selector.gsub(RE_CLASS_SELECTOR, "")}"
    else
      ".#{name} #{selector}"
    end
  end

  def parse_selector(name, selector)
    if selector =~ RE_GLOBAL
      selector.gsub(RE_GLOBAL, "")
    elsif selector =~ RE_MODULE
      selector.gsub(RE_MODULE) do
        rebuild_selector(encode_module_name($1), $2)
      end
    else
      selector.split(/\s+/).map do |sub_selector|
        rebuild_selector(name, sub_selector)
      end.join(" ")
    end
  end

  def encode_module_name(name)
    Base64.encode64(name).gsub(/\W/, "")
  end

  def call(input)
    parser = CssParser::Parser.new
    parser.add_block! input[:data]

    rules = []
    parser.each_selector do |selector, body|
      name = encode_module_name File.basename(input[:name])
      rules.append "#{parse_selector(name, selector)} {\n  #{body.gsub(/\;\s+/, ";\n  ")} }\n"
    end
    {data: rules.join("\n")}
  end
end

Sprockets.register_postprocessor 'text/css', CSSModules.new
