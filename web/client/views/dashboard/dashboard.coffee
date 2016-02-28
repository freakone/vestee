AutoForm.hooks
  add:
    onSuccess: (operation, result, template) ->
      sAlert.success 'New device added'
    onError: (operation, error, template) ->
      sAlert.error 'Device adding error'
