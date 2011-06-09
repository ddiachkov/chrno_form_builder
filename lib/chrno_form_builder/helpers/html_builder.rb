# encoding: utf-8
require "active_support/builder"

module ChrnoFormBuilder
  module Helpers
    ##
    # Builds HTML.
    #
    module HtmlBuilder
      ##
      # Метод для удобного создания HTML разметки.
      # Использует стандартный Builder::XmlMarkup.
      #
      # @example
      #   build_html do |b|
      #     b.div( id: "foo" ) {
      #       b.span {
      #          b << "bar"
      #       }
      #     }
      #   end
      #
      # @yieldparam [Builder::XmlMarkup]
      # @return [String] HTML разметка
      #
      def build_html( &block )
        raise ArgumentError, "block expected" unless block_given?

        result_html = ""
        yield Builder::XmlMarkup.new( :target => result_html )
        result_html.html_safe
      end
    end
  end
end