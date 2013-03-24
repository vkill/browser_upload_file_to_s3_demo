# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#upload input:file").on 'change', (event) ->
    $this = $(this)
    file = $this[0].files[0]
    $.ajax
      type: 'post'
      url: '/s3_files'
      dataType: 'json'
      data:
        s3_file:
          name: file.name
          size: file.size
          content_type: file.type
      success: (data) ->
        console.log data.s3_upload_url
        form = $("#upload")
        $this.data('s3-upload-url', data.s3_upload_url)
        $this.data('s3-upload-method', data.s3_upload_method)
        $this.data('s3-upload-content-type', data.s3_upload_content_type)
        form.data('id', data.id)
      error: (xhr, status, err) ->
        console.log 'error'
        console.log xhr.responseText
        alert 'get upload url failed'

  $("#upload").on 'submit', (event) ->
    event.preventDefault()
    $this = $(this)
    file_input = $($this.find("input:file"))
    file = file_input[0].files[0]
    $.ajax
      type: file_input.data('s3-upload-method')
      url: file_input.data('s3-upload-url')
      dataType: 'xml'
      processData: false
      data: file
      headers:
        'Content-Type': file_input.data('s3-upload-content-type')
        'Content-Disposition': "attachment; filename="+file.name
      success: (data, status, xhr) ->
        console.log 'success'
        console.log xhr.status
        $this.attr('action', "/s3_files/"+$this.data('id')+"/uploaded")
        $this.off 'submit'
        $this.submit()
        $this.each -> @reset()
      error: (xhr, status, err) ->
        console.log 'error'
        console.log xhr.responseText
        alert 'upload failed'

