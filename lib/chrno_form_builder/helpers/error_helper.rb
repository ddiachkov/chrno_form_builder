# encoding: utf-8
module ChrnoFormBuilder
  module Helpers
    ##
    # Обработка ошибок.
    #
    module ErrorHelper
      ##
      # Метод отображает ошибки для заданной записи.
      #
      # @param [ActiveModel] record модель, для которой необходимо отобразить ошибки
      # @return [String] список ошибок в HTML
      #
      def render_errors_for( record )
        # Ошибок нет, выходим
        return nil unless record.errors.any?

        build_html do |b|
          b.ul( class: "errors" ) {
             record.errors.full_messages.each { |msg| b.li { b << msg }}
          }
        end
      end
    end
  end
end