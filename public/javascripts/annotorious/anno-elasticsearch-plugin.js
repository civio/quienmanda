/**
 * A simple storage connector plugin to the ElasticSearch REST interface.
 *
 * Note: the plugin requires jQuery to be linked into the host page.
 *
 * THIS PLUGIN IS FOR DEMO PURPOSES ONLY - DON'T USE IN A PRODUCTION
 * ENVIRONMENT.
 */
annotorious.plugin.ElasticSearch = function(opt_config_options) {
  /** @private **/
  this._STORE_URI = opt_config_options['base_url'];

  /** @private **/
  this._annotations = [];
  
  /** @private **/
  this._loadIndicators = [];
}

annotorious.plugin.ElasticSearch.prototype.initPlugin = function(anno) {  
  var self = this;
  anno.addHandler('onAnnotationCreated', function(annotation) {
    self._create(annotation);
  });

  anno.addHandler('onAnnotationUpdated', function(annotation) {
    self._update(annotation);
  });

  anno.addHandler('onAnnotationRemoved', function(annotation) {
    self._delete(annotation);
  });
  
  self._loadAnnotations(anno);
}

annotorious.plugin.ElasticSearch.prototype.onInitAnnotator = function(annotator) {
  var spinner = this._newLoadIndicator();
  annotator.element.appendChild(spinner);
  this._loadIndicators.push(spinner);
}

annotorious.plugin.ElasticSearch.prototype._newLoadIndicator = function() { 
  var outerDIV = document.createElement('div');
  outerDIV.className = 'annotorious-es-plugin-load-outer';
  
  var innerDIV = document.createElement('div');
  innerDIV.className = 'annotorious-es-plugin-load-inner';
  
  outerDIV.appendChild(innerDIV);
  return outerDIV;
}

/**
 * @private
 */
annotorious.plugin.ElasticSearch.prototype._showError = function(error) {
  // TODO proper error handling
  window.alert('ERROR');
  console.log(error);
}

/**
 * @private
 */
annotorious.plugin.ElasticSearch.prototype._loadAnnotations = function(anno) {
  // TODO need to restrict search to the URL of the annotated
  var self = this;
  jQuery.getJSON(this._STORE_URI + '_search?query=*:*&size=1000', function(data) {
    try {
      jQuery.each(data.hits.hits, function(idx, hit) {
        var annotation = hit['_source'];
        annotation.id = hit['_id'];
        
        if (jQuery.inArray(annotation.id, self._annotations) < 0) {
          self._annotations.push(annotation.id);
          if (!annotation.shape && annotation.shapes[0].geometry)
            anno.addAnnotation(annotation);
        }
      });
    } catch (e) {
      self._showError(e);
    }
    
    // Remove all load indicators
    jQuery.each(self._loadIndicators, function(idx, spinner) {
      jQuery(spinner).remove();
    });
  });
}

/**
 * @private
 */
annotorious.plugin.ElasticSearch.prototype._create = function(annotation) {
  var self = this;
  jQuery.post(this._STORE_URI + 'annotation/',  JSON.stringify(annotation), function(response) {
    // TODO error handling if response status != 201 (CREATED)
    var id = response['_id'];
    annotation.id = id;
  });
}

/**
 * @private
 */
annotorious.plugin.ElasticSearch.prototype._update = function(annotation) {
  var self = this;
  jQuery.ajax({
    url: this._STORE_URI + 'annotation/' + annotation.id,
    type: 'PUT',
    data: JSON.stringify(annotation)
  }); 
}

/**
 * @private
 */
annotorious.plugin.ElasticSearch.prototype._delete = function(annotation) {
  jQuery.ajax({
    url: this._STORE_URI + 'annotation/' + annotation.id,
    type: 'DELETE'
  });
}
