goog.provide('ol.control.Scale');
goog.require('ol.control.Control');

ol.control.Scale = function(opt_options) {

        var options = opt_options || {};
		var className = options.className ? options.className : 'ol-scale';
		
		this.innerElement_ = goog.dom.createDom('DIV', className+'-inner','1:');
		var element = goog.dom.createDom('DIV',
      [className, ol.css.CLASS_UNSELECTABLE, ol.css.CLASS_CONTROL],
			this.innerElement_);
			
			
        ol.control.Control.call(this, {
          element: element,
          target: options.target,
		  render:ol.control.Scale.render
        });
		

};
ol.inherits(ol.control.Scale , ol.control.Control);
	  
ol.control.Scale.render = function(mapEvent) {
  var frameState = mapEvent.frameState;
  if (!frameState) {
    this.frameState_ = null;
  } else {
    this.frameState_ = frameState;
  }
  this.updateElement_();
};

/**
 * @see https://groups.google.com/forum/#!msg/ol3-dev/RAJa4locqaM/Tg-JQ9L_YeMJ
*/
ol.control.Scale.prototype.getCurrentScale= function(){
	var view = this.getMap().getView();
	var proj = view.getProjection();
	var resolution =  view.getResolution();
	var dpi =72;// 25.4 / 0.28;
	var mpu = proj.getMetersPerUnit();
	var scale= resolution * mpu * 39.3701 * dpi;
	return scale;
}

ol.control.Scale.prototype.updateElement_=function(){
	
	var scale =this.getCurrentScale();
	if (scale >= 9500 && scale <= 950000) {
	  scale = Math.round(scale / 1000) + "K";
	} else if (scale >= 950000) {
	  scale = Math.round(scale / 1000000) + "M";
	} else {
	  scale = Math.round(scale);
	}
	
	goog.dom.setTextContent(this.innerElement_,'1:'+scale);
};