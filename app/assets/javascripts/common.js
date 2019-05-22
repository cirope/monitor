+function () {
  window.State = {
    // Registra la variación en el contenido de los formularios
    unsavedData: false,
    // Texto con la advertencia de que hay datos sin guardar
    unsavedDataWarning: undefined
  }

  var _onBeforeUnload = function (event) {
    if (State.unsavedData) {
      if (event) event.returnValue = State.unsavedDataWarning

      return State.unsavedDataWarning
    }
  }

  if (window.addEventListener)
    window.addEventListener('beforeunload', _onBeforeUnload)
  else
    window.onbeforeunload = _onBeforeUnload

  $(document).on('change', 'form [data-observe-changes]', function () {
    State.unsavedData = true
  })

  $(document).on('click', 'input[type=submit]', function () {
    // Siempre que clickiemos el submit deberíamos permitir la "salida"
    State.unsavedData = false
  })
}()
