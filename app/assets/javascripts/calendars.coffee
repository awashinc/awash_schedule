ready = ->
  moment.locale('ko')
  start_date = document.getElementById("calendar_start_date")
  start_date_dialog = new mdDateTimePicker.default(
    type: 'date',
    future: moment().add(1, 'years'),
    trigger: start_date,
    orientation: 'PORTRAIT'
  )

  start_date.addEventListener "click", ->
    start_date_dialog.toggle()
  start_date.addEventListener "onOk", (e) ->
    this.value = start_date_dialog.time.format('YYYY-MM-DD')

  end_date = document.getElementById("calendar_end_date")
  end_date_dialog = new mdDateTimePicker.default(
    type: 'date',
    future: moment().add(1, 'years'),
    trigger: end_date,
  )

  end_date.addEventListener "click", ->
    end_date_dialog.toggle()
  end_date.addEventListener "onOk", (e) ->
    this.value = end_date_dialog.time.format('YYYY-MM-DD')


$(document).on 'turbolinks:load', ready
