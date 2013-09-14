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
      # trigger.on 'dragenter', ->
      #   setTimeout ->
      #     wrapper.addClass 'dragging'
      #   , 0

      # this is stupid, but seems to be necessary for the drop event to fire (at least in chrome)
      # wrapper.on 'dragover', (e) ->
      #   e.preventDefault()

      # wrapper.on 'dragenter', ->
      #   wrapper.addClass 'dragging'

      # wrapper.on 'dragleave', (e) ->
      #   return if $(e.target).is 'button'

      #   wrapper.removeClass 'dragging'

      # wrapper.on 'drop', (e) ->
      #   e.preventDefault()
      #   e.stopPropagation()

      #   wrapper.removeClass 'dragging'

      #   handleFileChange(e.originalEvent.dataTransfer.files[0])

      #   return false

    setFilenameText = (newVal) ->
      actualVal = newVal || if inp.val() then inp.val().substr(val.lastIndexOf('\\') + 1) else settings.placeholder

      wrapper.addClass('filename').attr('data-filename', actualVal)

    handleFileChange = (file) ->
      if fileApiSupported
        imagey = /^image\/(png|jpg|jpeg|gif|svg(\+xml)?)$/.test file.type

        if imagey
          reader = new FileReader

          reader.onload = do (file) ->
            wrapper.removeClass('empty filename')

            return (evt) ->
              newImgData = evt.target.result

              wrapper.css('background-image', "url(#{newImgData})")

          reader.readAsDataURL(file)
        else
          wrapper.css('background-image', 'none')
          setFilenameText(file.name)
      else # fallback for bad browsers
        wrapper.css('background-image', 'none')
        setFilenameText()

    # hide the native file input
    inp.css
      opacity: 0
      display: 'block'
      width: '100%'
      height: '100%'
      position: 'absolute'
      top: 0
      left: 0
      background: '#f00'

    # some global setup stuff
    inp.wrap '<div class="dropshot-container">'
    wrapper = inp.parent()

    wrapper.append """<button class="dropshot-trigger">#{settings.placeholder}</button>"""

    trigger = wrapper.find '.dropshot-trigger'

    # mark as empty if there's not already an image
    unless inp.data('current-path')
      wrapper.addClass('empty')

    # initialize filename/thumbnail
    existing = inp.data('existing-file-url')
    if existing
      if fileApiSupported
        existingIsImage = /\.(png|jpg|jpeg|gif|svg\+xml)$/.test existing

        if existingIsImage
          wrapper.removeClass('empty').css('background-image', "url(#{existing})")
        else
          setFilenameText(existing)
      else
        setFilenameText(existing)




    # setFilenameText() unless fileApiSupported

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