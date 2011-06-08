(function($) {
  // Создание вложенной модели
  $(".create-nested-model").live ("click", function () {
    // Формируем модель из шаблона
    var new_model = $("#" + $(this).data ("blueprint")).tmpl ({
        association : $(this).data ("association")
      , id          : new Date ().getTime ()
    });

    // Вычисляем плейсхолдер (по умолчанию добавляем модель сразу после ссылки)
    var placeholder = $($(this).data ("placeholder") || $(this).parent ());

    // Добавляем модель на страницу и отправляем событие форме
    new_model.hide ().appendTo (placeholder).closest ("form").trigger ("nested:modelAdded");
    new_model.slideDown ();
  });

  // Удаление вложенной модели
  $(".destroy-nested-model").live ("click", function () {
    // Получаем модель по её имени
    var model = $(".nested-model[data-model='" + $(this).data ("association") + "']");

    // Проставляем флаг удаления и отправляем событие форме
    model.find("input[name$='[_destroy]']")
      .val ("1")
      .closest ("form").trigger ("nested:modelRemoved");

    // Скрываем модель
    model.slideUp ("fast");
  });
}) (jQuery);