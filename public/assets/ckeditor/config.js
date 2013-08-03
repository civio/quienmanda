
CKEDITOR.editorConfig = function(config) {
  config.language = 'en';
  config.allowedContent = true;
  config.height = '450';
  config.toolbar_Pure = [
    {
      name: 'document',
      items: ['Source', '-', 'Save', 'Preview', '-', 'Templates']
    }, {
      name: 'clipboard',
      items: ['Undo', 'Redo']
    }, {
      name: 'editing',
      items: ['Find', 'Replace', '-', 'SpellChecker', 'Scayt']
    }, {
      name: 'tools',
      items: ['Maximize', 'ShowBlocks']
    }, '/', {
      name: 'basicstyles',
      items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat']
    }, {
      name: 'paragraph',
      items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyBlock']
    }, {
      name: 'insert',
      items: ['Link', 'Unlink', 'Anchor', 'Image', 'Table', 'HorizontalRule', 'SpecialChar']
    }, '/', {
      name: 'styles',
      items: ['Styles', 'Format', 'Font', 'FontSize']
    }, {
      name: 'colors',
      items: ['TextColor', 'BGColor']
    }
  ];
  config.toolbar = 'Pure';
  return true;
};
