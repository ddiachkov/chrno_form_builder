# encoding: utf-8
module ChrnoFormBuilder
  module Helpers
    ##
    # Поддержка шаблонов.
    #
    module BlueprintHelper
      extend ActiveSupport::Concern

      included do
        define_method( :_blueprints ) { @blueprints ||= Hash.new }
        define_method( :_required_blueprints ) { @_required_blueprints ||= Set.new }
      end

      ##
      # Класс для хранения и вывода шаблонов.
      # @private
      #
      class Blueprint
        # Название шаблона
        attr_accessor :name
        # Флаг: вызывался ли метод {#render}?
        attr_accessor :rendered

        ##
        # @param [ActionView::Base] template контекст
        # @param [#to_s] name название шаблона
        #
        # @param [Hash] options параметры
        #   @options options [Class]  :model класс модели (для вложенных форм)
        #   @options options [String] :as   название модели
        #
        # @yieldparam block тело шаблона
        # @raise [ArgumentError] если не задан блок
        #
        def initialize( template, name, options = {}, &block )
          raise ArgumentError, "block expected" unless block_given?
          @template = template
          @name, @options, @proc = name.to_s, options, block
          @rendered = false
        end

        ##
        # Выводит шаблон формате jQuery-tmpl.
        #
        # @example
        #   blueprint#render # => '<script id="...-blueprint" type="text/x-jquery-tmpl">...content...</script>'
        #
        # @return [String] HTML шаблона
        #
        def render
          @rendered = true

          # <script id="...-blueprint" type="text/x-jquery-tmpl">
          output = @template.content_tag :script, id: "#{@name}-blueprint", type: "text/x-jquery-tmpl"  do
            # Если задана модель, то генерируем вложенную форму
            if @options[ :model ]
              model_klass = @options[ :model ]
              model_name  = @options[ :as ] || ActiveModel::Naming.param_key( model_klass )

              # Формируем шаблон для имени (в качестве маркеров используются .:: и ::.)
              name_template = ".::association::.[#{model_name}_attributes][new_.::id::.]"

              # <div class="nested-model" data-model="...">
              @template.content_tag :div, class: "nested-model", data: { model: name_template } do
                @template.fields_for( name_template, model_klass.new, &@proc )
              end
            else
              # Если модеь не задана, то используем обычный capture без параметров для блока
              @template.capture( &@proc )
            end
          end

          # Рельсы режут в ID символы ${}, поэтому приходиться так извращаться
          output.gsub( ".::", "${" ).gsub( "::.", "}" )
        end
      end

      ##
      # Создаёт или возвращает новый шаблон.
      #
      # jQuery-like API: если задан блок, то метод создаёт новый шаблон, иначе -- возвращает
      # ранее созданный.
      #
      # @param [#to_s] name имя шаблона
      # @param [Hash] options набор параметров (см. {Blueprint#initialize})
      # @param [Proc] block тело шаблона
      #
      # @raise [ArgumentError] если не задано
      # @raise [ArgumentError] если запрошен несуществующий шаблон
      #
      # @return [Blueprint]
      #
      def blueprint( name, options = {}, &block )
        raise ArgumentError, "name can't be blank" if name.blank?

        if block_given?
          _blueprints[ name ] = Blueprint.new( self, name, options, &block )
        else
          raise ArgumentError, "blueprint #{name} doesn't exists" unless _blueprints[ name ]
          _blueprints[ name ]
        end
      end

      ##
      # @return [Array] список зарегистрированных шаблонов
      #
      def blueprints
        _blueprints.values
      end

      ##
      # Запрашивает заданный шаблон для вывода на страницу.
      #
      # @note Запрашивать один и тот же шаблон можно многократно, на страницу
      #       он будет выведен только единожды.
      #
      # @see #required_blueprints, #render_blueprints
      #
      # @param [#to_s] name название шаблона
      #
      def require_blueprint( name )
        _required_blueprints << name.to_s
      end

      ##
      # @return [Array] список запрошенных шаблонов
      #
      def required_blueprints
        blueprints.select { |b| _required_blueprints.include? b.name }
      end

      ##
      # Выводит на страницу запрошенные шаблоны.
      #
      # @note Метод можно вызывать многократно, шаблоны всегда будут выведены в
      #       одном экземпляре.
      #
      # @see #require_blueprint
      #
      # @return [String] HTML шаблонов
      #
      def render_blueprints
        required_blueprints.reject( &:rendered ).map( &:render ).join
      end
    end
  end
end