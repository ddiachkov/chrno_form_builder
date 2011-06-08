# encoding: utf-8
module ChrnoFormBuilder
  module Helpers
    ##
    # Поддержка вложенных форм.
    #
    module NestedFormHelper
      extend ActiveSupport::Concern

      included do
        alias_method_chain :form_for, :blueprints_support
      end

      ##
      #  Добавляем к формам автоматический вывод шаблонов.
      #  @see BlueprintHelper#render_blueprints
      #
      def form_for_with_blueprints_support( record, options = {}, &proc )
        form_for_without_blueprints_support( record, options, &proc ).safe_concat render_blueprints
      end

      ##
      # Возвращает ссылку создающую новую вложенную форму.
      #
      # @param [String] object_name название родительской модели
      # @param [String] association название вложенной модели
      # @param args аргументы передаются в стандартный хелпер link_to
      # @param block блок передаётся в стандартный хелпер link_to
      #
      # @return [String] ссылка
      #
      def link_to_create( object_name, association, *args, &block )
        association = association.to_s.singularize

        options = args.extract_options!
        options.symbolize_keys!

        options[ :class ] ||= ""

        # Всегда добавляем класс create-nested-model
        unless options[ :class ].include? "create-nested-model"
          options[ :class ] += " create-nested-model"
          options[ :class ].strip!
        end

        # data-атрибуты:
        #   * association - имя родительской модели
        #   * blueprint   - название шаблона
        #   * placeholder - jQuery селектор, куда будет присоединена новая форма
        options[ :data ] ||= {}
        options[ :data ].merge! association: object_name, blueprint: "#{association}-blueprint"
        options[ :data ][ :placeholder ] = options.delete :placeholder if options[ :placeholder ]

        options[ :rel ] ||= "nofollow"

        args << "javascript:void(0)" if args.length == 1 and not block_given?
        args << options

        # Запрашиваем шаблон и генерируем ссылку
        require_blueprint( association )
        link_to( *args, &block )
      end

      ##
      # Возвращает ссылку удаляющую вложенную форму.
      #
      # @param [String] object_name название удаляемой формы
      # @param args аргументы передаются в стандартный хелпер link_to
      # @param block блок передаётся в стандартный хелпер link_to
      #
      # @return [String] ссылка
      #
      def link_to_destroy( object_name, *args, &block )
        options = args.extract_options!
        options.symbolize_keys!

        options[ :class ] ||= ""

        unless options[ :class ].include? "destroy-nested-model"
          options[ :class ] += " destroy-nested-model"
          options[ :class ].strip!
        end

        # data-атрибуты:
        #   * association - имя удаляемой модели
        options[ :data ] ||= {}
        options[ :data ].merge! association: object_name

        options[ :rel ] ||= "nofollow"

        args << "javascript:void(0)" if args.length == 1 and not block_given?
        args << options

        # Создаём скрытое поле и ссылку
        hidden_field( object_name, :_destroy ) + link_to( *args, &block )
      end
    end
  end
end