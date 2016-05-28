(function ($) {
  $.module = function (module, selector) {
    var name = btoa(module).replace(/\W|\=/g,"")
    var el = selector.split(/\s+/).map(function (sub_selector) {
      return sub_selector.replace(/^([\.#])(.*)/g, function (_, f, s) {
        return f + name + "_" + s
      })
    }).join(" ")
    return $(el)
  }
})(jQuery)
