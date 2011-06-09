# Описание
Расширенный form builder для Rails.

Добавляет следующие возможности:

- Поддержка шаблонов на основе jQuery.tmpl

Пример:

    <%= blueprint "my-template" do %>
      <div id="${id} class="content">${content}</div>
    <% end %>
    ...
    <%= require_blueprint "my-template" %>
    ...
    <%= render_blueprints %>
      #=>
        <script id="my-template-blueprint" type="text/x-jquery-tmpl">
          <div id="${id} class="content">${content}</div>
        </script>

- Простейший вывод ошибок для форм

Пример:

    <%= f.errors >

- Хелпер для конструирования HTML на основе Builder::XmlMarkup (удобно использовать внутри других хелперов)

Пример:

    build_html do |b|
       b.div( id: "foo" ) {
         b.span {
            b << "bar"
         }
       }
     end

- Улучшенная поддержка вложенных форм

Пример:

    <div id="fields">
      <%= f.fields_for :nested_attribute do |n| >
        <%= n.text_field :foo %>
        <%= n.link_to_destroy "Delete"
      <% end %>
    </div>

    <%= f.link_to_create :nested_attribute, "New attribute", placeholder: "#fields"