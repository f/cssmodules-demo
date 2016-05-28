module CssModulesHelper
  class Styler
    def initialize(component)
      @component = encode_module_name(component)
    end
    def encode_module_name(name)
      Base64.encode64(name).gsub(/\W/, "")
    end
    def style(name)
      [@component, name].join("_")
    end
  end

  def style_for(component, name)
    Styler.new(component.to_s).style(name.to_s)
  end

  def component(name, &block)
    block.call(Styler.new(name.to_s))
  end
end
