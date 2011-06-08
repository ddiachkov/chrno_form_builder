# encoding: utf-8
module ChrnoFormBuilder
  # Расширения для ActionView
  module Helpers
    extend ActiveSupport::Autoload

    autoload :HtmlBuilder,      "chrno_form_builder/helpers/html_builder"
    autoload :ErrorHelper,      "chrno_form_builder/helpers/error_helper"
    autoload :BlueprintHelper,  "chrno_form_builder/helpers/blueprint_helper"
    autoload :NestedFormHelper, "chrno_form_builder/helpers/nested_form_helper"
  end
end