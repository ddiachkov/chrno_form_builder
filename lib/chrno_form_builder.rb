# encoding: utf-8
module ChrnoFormBuilder
  extend ActiveSupport::Autoload

  autoload :FormBuilder, "chrno_form_builder/form_builder"
  autoload :Helpers,     "chrno_form_builder/helpers"
  autoload :Version,     "chrno_form_builder/version"

  class Engine < Rails::Engine
    initializer "chrno_form_builder.initialize", :before => :disable_dependency_loading do |app|
      # Загружаем расширения
      ActiveSupport.on_load( :action_view ) do
        Rails.logger.debug "--> load chrno_form_builder"

        include ChrnoFormBuilder::Helpers::HtmlBuilder
        include ChrnoFormBuilder::Helpers::ErrorHelper
        include ChrnoFormBuilder::Helpers::BlueprintHelper
        include ChrnoFormBuilder::Helpers::NestedFormHelper
      end

      # Загружаем form builder
      ActiveSupport.on_load( :after_initialize ) do
        ActionView::Base.default_form_builder = ChrnoFormBuilder::FormBuilder
      end
    end
  end
end