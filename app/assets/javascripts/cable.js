/* global ActionCable */
+function () {
  this.App       = this.App || {}
  this.App.cable = ActionCable.createConsumer()
}.call(this)
