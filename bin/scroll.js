$(document).ready(function(){

	function expandElement(elem) {
       elem.removeClass("haveInnerContent");
        elem.append("<div />");
        var elemsDiv = elem.find("div");
        elemsDiv.load("/" + elem.attr("innerContent") + "/" + elem.attr("baseID"), null, checkWindow);
	}

    function checkWindow() {
        processNewElements();
        var elem = $(".haveInnerContent").first();
        if (!elem || !elem.length) { return; }
        if(elem.offset().top < window.innerHeight + window.pageYOffset) {
			expandElement(elem);
		}
    }
    $(window).scroll(function() {checkWindow();});
    checkWindow();

    var clickLock = false;
	var currentParagraph;	

    function processNewElements() {
        $("a[cheatLink]").each(function(index, value) {
			var currentObject = $(this);
			if (currentObject.hasClass("clickHandled")) { return; }
			currentObject.addClass("clickHandled");
			switch (currentObject.attr("cheatLink")) {
				case "add":
					currentObject.click(currentObject, processAddClick);
					break;
				case "remove":
					currentObject.click(currentObject, processRemoveClick);
					break;
			}
		});
	}

	function ajaxAddingHandler(data) {
        if (currentParagraph) { currentParagraph.find("div").first().find("div").first().append(data); }
		currentParagraph = undefined;
        $(".overlay").remove();
        clickLock = false;
        checkWindow();
	}

	function formSubmitHandler(e) {
        e.preventDefault();
        e.stopPropagation();
        $.post(e.data.attr("action"), e.data.serialize(), ajaxAddingHandler);
	}

	function overlayLoadHandler() {
        var form = $("form[action]");
        var submitButton = $("input[type=submit]");
        submitButton.click(form, formSubmitHandler);
	}

	function processAddClick(event) {
        if (clickLock) { return; }
		clickLock = true;
        currentParagraph = event.data.parent();
        var url = "/formFor" + event.data.attr("typeOf") + "/" + event.data.attr("after");
        $("body").append("<div class='overlay'/>");
        $(".overlay").load(url, overlayLoadHandler);
	}

	function removeProcessingHandler() {
		if (currentParagraph) { currentParagraph.remove(); }
		currentParagraph = undefined;
		clickLock = false;
		checkWindow();
	}

	function processRemoveClick(event) {
        if (clickLock) { return; }
		currentParagraph = event.data.parent();
        var url = "/delete/" + event.data.attr("typeOf") + "/" + event.data.attr("ownID");
        $.post(url, null, removeProcessingHandler);
	}
});
