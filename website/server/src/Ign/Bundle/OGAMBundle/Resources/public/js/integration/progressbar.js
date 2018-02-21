/**
 * WebAppers Progress Bar, version 0.2 (c) 2007 Ray Cheung
 * 
 * WebAppers Progress Bar is freely distributable under the terms of an Creative
 * Commons license. For details, see the WebAppers web site:
 * http://wwww.Webappers.com/
 * 
 */

var initial = -120;
var imageWidth = 240;
var eachPercent = (imageWidth / 2) / 100;
var label = "";

/**
 * Set the text.
 * 
 * @param id
 * @param percent
 * @return
 */
function setText(id, percent) {
	document.getElementById(id + 'percentText').innerHTML = percent + "%";
}

/**
 * Display the progress bar.
 * 
 * @param id
 * @param percentage
 * @param imgpath the image path
 * @param label the label
 * @return
 */
function display(id, label, percentage, imgpath) {
	var percentageWidth = eachPercent * percentage;
	var actualWidth = initial + percentageWidth;
	document.write('<span style="display:block;" id="' + id + 'percentLabel">' + label + '</span> ' +
			' <img id="' + id + 
			'"src= "'+imgpath+ 'percentImage.png"' + 
			' alt= "' + percentage + '%" '+ 
			' class= "percentImage" ' + 
			' style="background-position: ' + actualWidth + 'px 0pt; width:120px; height:10px"/>' +
			' <span id="' + id + 'percentText">' + percentage + '%</span>');
	
}

/**
 * Set the label.
 * 
 * @param id
 * @param percent
 * @return
 */
function setLabel(id, label) {
	document.getElementById(id+'percentLabel').innerHTML = label;
}

/**
 * Empty the progress bar.
 * 
 * @param id
 * @return
 */
function emptyProgress(id) {
	var newProgress = initial + 'px';
	document.getElementById(id).style.backgroundPosition = newProgress + ' 0';
	setText(id, '0');
}

/**
 * Get the current value of the progress.
 * 
 * @param id
 * @return
 */
function getProgress(id) {
	var nowWidth = document.getElementById(id).style.backgroundPosition.split("px");
	return (Math.floor(100 + (nowWidth[0] / eachPercent)) + '%');

}

/**
 * Set the progress value.
 * 
 * @param id
 * @param percentage
 * @return
 */
function setProgress(id, percentage) {
	percentage = Math.round(percentage); 
	var percentageWidth = eachPercent * percentage;
	var newProgress = eval(initial) + eval(percentageWidth) + 'px';
	document.getElementById(id).style.backgroundPosition = newProgress + ' 0';
	setText(id, percentage);
}

/**
 * Add some value to the progress.
 * 
 * @param id
 * @param percentage
 * @return
 */
function plus(id, percentage) {
	var nowWidth = document.getElementById(id).style.backgroundPosition.split("px");
	var nowPercent = Math.floor(100 + (nowWidth[0] / eachPercent)) + eval(percentage);
	var percentageWidth = eachPercent * percentage;
	var actualWidth = eval(nowWidth[0]) + eval(percentageWidth);
	var newProgress = actualWidth + 'px';
	if (actualWidth >= 0 && percentage < 100) {
		var newProgress = 1 + 'px';
		document.getElementById(id).style.backgroundPosition = newProgress + ' 0';
		setText(id, 100);
	} else {
		document.getElementById(id).style.backgroundPosition = newProgress + ' 0';
		setText(id, nowPercent);
	}
}

/**
 * Decrease some value from the progress.
 * 
 * @param id
 * @param percentage
 * @return
 */
function minus(id, percentage) {
	var nowWidth = document.getElementById(id).style.backgroundPosition.split("px");
	var nowPercent = Math.floor(100 + (nowWidth[0] / eachPercent)) - eval(percentage);
	var percentageWidth = eachPercent * percentage;
	var actualWidth = eval(nowWidth[0]) - eval(percentageWidth);
	var newProgress = actualWidth + 'px';
	if (actualWidth <= -120) {
		var newProgress = -120 + 'px';
		document.getElementById(id).style.backgroundPosition = newProgress + ' 0';
		setText(id, 0);
	} else {
		document.getElementById(id).style.backgroundPosition = newProgress + ' 0';
		setText(id, nowPercent);
	}
}

/**
 * Fill the progress bar.
 * 
 * @param id
 * @param endPercent
 * @return
 */
function fillProgress(id, endPercent) {
	var nowWidth = document.getElementById(id).style.backgroundPosition.split("px");
	startPercent = Math.ceil(100 + (nowWidth[0] / eachPercent)) + 1;
	var actualWidth = initial + (eachPercent * endPercent);	
	if (startPercent <= endPercent && nowWidth[0] <= actualWidth) {
		plus(id, '1');
		setText(id, startPercent);
		setTimeout("fillProgress('" + id + "'," + endPercent + ")", 10);
	}
}