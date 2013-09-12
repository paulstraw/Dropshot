$.fn.dropShot = (opts) ->
  settings = $.extend({
    placeholder: 'Browse'
  }, opts)

  isMobile = !!navigator.userAgent.match /Mobile|webOS/i
  fileApiSupported = window.File && window.FileReader && window.FileList && window.Blob

  return this.each ->
    inp = $(this)
    return if inp.hasClass('snapified') || inp[0].tagName != 'INPUT'
    inp.addClass('snapified')

    setupDragHandlers = ->
      trigger.on 'dragenter', ->
        setTimeout ->
          wrapper.addClass 'dragging'
        , 0

      # this is stupid, but seems to be necessary for the drop event to fire (at least in chrome)
      wrapper.on 'dragover', (e) ->
        e.preventDefault()

      wrapper.on 'dragenter', ->
        wrapper.addClass 'dragging'

      wrapper.on 'dragleave', (e) ->
        return if $(e.target).is 'button'

        wrapper.removeClass 'dragging'

      wrapper.on 'drop', (e) ->
        e.preventDefault()
        e.stopPropagation()

        wrapper.removeClass 'dragging'

        console.log 'drop', e

        handleFileChange(e.originalEvent.dataTransfer.files[0])

        return false

    setTriggerText = ->
      return if fileApiSupported
      trigger.text(if inp.val() then inp.val().substr(val.lastIndexOf('\\') + 1) else settings.placeholder)

    handleFileChange = (file) ->
      if fileApiSupported
        reader = new FileReader

        reader.onload = do (file) ->
          return unless file.type.indexOf('image/') == 0
          console.log file

          (evt) ->
            newImgData = evt.target.result

            # if wrapper.find('img').length
            #   wrapper.find('img').attr('src', newImgData)
            # else
            #   wrapper.prepend("""<img src="#{newImgData}">""")
            wrapper.css('background-image', "url(#{newImgData})")
            wrapper.removeClass('empty')

        reader.readAsDataURL(file)
      else # fallback for bad browsers
        wrapper.css('background-image', 'none')
        setTriggerText()

    # hide the native file input
    inp.css
      display: 'none'

    # some global setup stuff
    inp.wrap '<div class="dropshot-container">'
    wrapper = inp.parent()

    wrapper.append """<button class="dropshot-trigger">#{settings.placeholder}</button>"""

    trigger = wrapper.find '.dropshot-trigger'

    # mark as empty if there's not already an image
    unless inp.data('current-path')
      wrapper.addClass('empty')

    # initialize trigger text for bad browsers
    setTriggerText() unless fileApiSupported

    setupDragHandlers()

    trigger.on 'click', (e) ->
      e.preventDefault()

      inp.trigger('click')

    inp.on 'change', ->
      handleFileChange(inp[0].files[0])

    #######################
    return
    #disabled in markup?
    disabled = sel.prop('disabled')
    if disabled
      wrapper.addClass 'disabled'

    updateTriggerText = ->
      trigger.text sel.find(':selected').text()

    sel.on 'enable', ->
      sel.prop 'disabled', false
      wrapper.removeClass 'disabled'
      disabled = false
      copyOptionsToList()

    sel.on 'disable', ->
      sel.prop 'disabled', true
      wrapper.addClass 'disabled'
      disabled = true

    sel.on 'update', ->
      wrapper.find('.options').empty()

    #######################