if CKEDITOR?
  CKEDITOR.editorConfig = (config) ->
    config.height = '500'
    config.allowedContent = true

    config.language = 'es'
    config.scayt_sLang = 'es_ES'
    config.scayt_autoStartup = true

    config.toolbar_Pure = [
      { name: 'document',    items: [ 'Source','-','Save','Preview','-','Templates' ] },
      { name: 'clipboard',   items: [ 'Undo','Redo' ] },
      { name: 'editing',     items: [ 'Find','Replace','-','SpellChecker', 'Scayt' ] },
      { name: 'tools',       items: [ 'Maximize', 'ShowBlocks' ] }
      '/',
      { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
      { name: 'paragraph',   items: [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyBlock' ] },
      { name: 'insert',      items: [ 'Link','Unlink','Anchor', 'Image','Table','HorizontalRule','SpecialChar' ] },
      '/',
      { name: 'styles',      items: [ 'Styles','Format','Font','FontSize' ] },
      { name: 'colors',      items: [ 'TextColor','BGColor' ] },
    ]
    config.toolbar = 'Pure'
    config.toolbarCanCollapse = true
    config.toolbarStartupExpanded = false

    config.stylesSet = [
      { name: 'Ladillo', element: 'h2', styles: { } }
    ]
    true

if CKEDITOR?
  CKEDITOR.on "dialogDefinition", (ev) ->
    ev.data.definition.getContents("target").get("linkTargetType")["default"] = "_blank"  if ev.data.name is "link"
