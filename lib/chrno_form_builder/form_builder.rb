# encoding: utf-8
module ChrnoFormBuilder
  ##
  # Кастомный form builder.
  #
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Обёртка над {ErrorHelper#render_errors_for}
    def errors
      @template.render_errors_for @object
    end

    ##
    # Создание вложенной формы.
    #
    def fields_for( record_name, record_object = nil, fields_options = {}, &block )
      # Если не указан блок, то рендерим паршиал с именем модели
      # (можно переопределить, используя параметр :partial)
      unless block_given?
        partial = fields_options[ :partial ] || record_name.to_s.singularize
        block = Proc.new { |builder| @template.render partial, :f => builder }
      end

      super( record_name, record_object, fields_options, &block )
    end

    # Обёртка над {NestedFormsHelper#link_to_create}
    def link_to_create( association, *args, &block )
      @template.link_to_create( object_name, association, *args, &block )
    end

    # Обёртка над {NestedFormsHelper#link_to_destroy}
    def link_to_destroy( *args, &block )
      @template.link_to_destroy( object_name, *args, &block )
    end

    private

    def fields_for_with_nested_attributes( association_name, association, options, block )
      # Сохраняем шаблоны для вложенных форм
      if reflection = object.class.reflect_on_association( association_name.to_sym )
        @template.blueprint( association_name.to_s.singularize, model: reflection.klass, as: association_name, &block )
      end
      super
    end

    def fields_for_nested_model( name, object, options, block )
      # has_many?
      unless name.end_with? "_attributes]"
        # Оборачиваем в div с названием модели
        "<div class=\"nested-model\" data-model=\"#{name}\">#{super}</div>".html_safe
      else
        super
      end
    end
  end
end