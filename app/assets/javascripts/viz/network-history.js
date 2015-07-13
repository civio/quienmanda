/**
* Action History for Network Graph 
* (based on https://stackoverflow.com/questions/5617447/apply-undo-redo-on-elements-that-can-dragable-drag-and-drop)
*/

// We define $j instead of $ to avoid conflict with annotorious.js 
// (see https://learn.jquery.com/using-jquery-core/avoid-conflicts-other-libraries/)
$j = jQuery.noConflict();

function NetworkHistory( undoBtn, redoBtn ) {

  var self = this;

  this.done = this.reverted = [];
  this.undoBtn = $j(undoBtn);
  this.redoBtn = $j(redoBtn);
  this.undoBtnDisabled = this.redoBtnDisabled = true;
  
  this.add = function(item) {
    self.done.push(item);

    // delete anything forward
    self.reverted = [];

    // enable undo btn
    if (this.undoBtnDisabled) {
      this.undoBtnDisabled = false;
      this.undoBtn.removeClass('disabled');
    }
  };

  this.undo = function() {
    var item = self.done.pop();

    if (item) {
      self.reverted.push(item);
    }

    // enable redo btn
    if (this.redoBtnDisabled) {
      this.redoBtnDisabled = false;
      this.redoBtn.removeClass('disabled');
    }

    // disable undo btn if has no more actions in done array
    if (self.done.length === 0) {
      this.undoBtnDisabled = true;
      this.undoBtn.addClass('disabled');
    }

    return item;
  };

  this.redo = function() {
    var item = self.reverted.pop();

    if (item) {
      self.done.push(item);
    }

    // enable undo btn
    if (this.undoBtnDisabled) {
      this.undoBtnDisabled = false;
      this.undoBtn.removeClass('disabled');
    }

    // disable redo btn if has no more actions in reverted array
    if (self.reverted.length === 0) {
      this.redoBtnDisabled = true;
      this.redoBtn.addClass('disabled');
    }

    return item;
  };

  this.getDone = function() {
    return self.done;
  };
}