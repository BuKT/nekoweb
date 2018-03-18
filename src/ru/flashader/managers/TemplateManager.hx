package ru.flashader.managers;
import haxe.Log;
import ru.flashader.AddingObject;
import ru.flashader.ParagraphStyle;

class TemplateManager {
	
	private static var pageTitle:String = 'Пояснительная записка к курсовому проекту по дисциплине Web-программирование';
	private static var metaTemplate:String = '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><meta name="language" content="ru" />';
	private static var styleTemplate:String = '<link rel="stylesheet" type="text/css" href="/css/main.css" />';
	private static var scriptTemplate:String = '<script type="text/javascript" src="/jquery.js"></script><script type="text/javascript" src="/scroll.js"></script>';
	
	public static function getHtml(mainContent:Xml):Xml {
		var toReturn:Xml = Xml.createElement("html");
		toReturn.addChild(getHead(mainContent));
		toReturn.addChild(getBody(mainContent));
		return toReturn;
	}
	
	static function getHead(mainContent:Xml):Xml {
		var toReturn:Xml = Xml.createElement("head");
		var title:Xml = Xml.createElement("title");
		title.addChild(Xml.createPCData(pageTitle));
		toReturn.addChild(title);
		toReturn.addChild(Xml.parse(metaTemplate));
		toReturn.addChild(Xml.parse(styleTemplate));
		toReturn.addChild(Xml.parse(scriptTemplate));
		return toReturn;
	}
	
	static function getBody(mainContent:Xml):Xml {
		var toReturn:Xml = Xml.createElement("body");
		var content:Xml = Xml.createElement("div");
		content.set("id", "content");
		
		if (UserManager.cookieValid) {
			toReturn.addChild(createCheatAddLink("categories", ""));
		}
		content.addChild(mainContent);
		toReturn.addChild(content);
		return toReturn;
	}
	
	static public function prepareImage(ownClass:String, id:String, content:String, src:String):Xml {
		var paragraph:Xml = Xml.createElement("center");
		var contentHolder:Xml = Xml.createElement("img");
		contentHolder.set("src", src);
		paragraph.set("class", ownClass);
		paragraph.set("baseID", id);
		contentHolder.addChild(Xml.createPCData(content));
		paragraph.addChild(contentHolder);
		return paragraph;
	}
	
	static public function prepareParagraph(addingObject:AddingObject, ownClass:String, id:String, content:String, ?contentClass:String, ?style:ParagraphStyle):Xml {
		var paragraph:Xml = Xml.createElement("div");
		var contentHolderName:String;
		switch(style) {
			case ParagraphStyle.BigHeader:
				contentHolderName = "h2";
			case ParagraphStyle.SimpleHeader:
				contentHolderName = "h3";
			default:
				contentHolderName = "p";
		}
		paragraph.set("class", ownClass);
		paragraph.set("baseID", id);
		if (contentClass != null && contentClass.length > 0) {
			paragraph.set("innerContent", contentClass);
			paragraph.set("class", paragraph.get("class") + " haveInnerContent");
			if (UserManager.cookieValid) {
				paragraph.addChild(createCheatAddLink(contentClass, id));
			}
		}
		if (UserManager.cookieValid) {
			paragraph.addChild(createCheatRemoveLink(addingObject, id));
		}
		var contentHolder:Xml = Xml.createElement(contentHolderName);
		contentHolder.addChild(Xml.createPCData(content));
		paragraph.addChild(contentHolder);
		return paragraph;
	}
	
	static function createCheatAddLink(contentClass:String, id:String):Xml {
		var cheat:Xml = Xml.createElement("a");
		cheat.addChild(Xml.createPCData("Add"));
		cheat.set("cheatLink", "add");
		cheat.set("typeOf", contentClass);
		cheat.set("after", id);
		cheat.set("class", "underline");
		cheat.set("style", "float: right;");
		return cheat;
	}
	
	static function createCheatRemoveLink(addingObject:AddingObject, id:String):Xml {
		var cheat:Xml = Xml.createElement("a");
		cheat.addChild(Xml.createPCData("Del"));
		cheat.set("cheatLink", "remove");
		cheat.set("typeOf", addingObject.getName());
		cheat.set("ownID", id);
		cheat.set("class", "underline");
		cheat.set("style", "float: right;");
		return cheat;
	}
	
	public static function getCategoryAddingForm():Xml {
		var form:Xml = Xml.createElement("form");
		form.set("action", "/add/" + AddingObject.Category);
		form.addChild(createArea());
		form.addChild(createButton());
		return form;
	}
	
	public static function getArticleAddingForm(parentId:String):Xml {
		var form:Xml = Xml.createElement("form");
		form.set("action", "/add/" + AddingObject.Article + "/" + parentId);
		form.addChild(createArea());
		form.addChild(createButton());
		return form;
	}
	
	public static function getParagraphAddingForm(parentId:String):Xml {
		var form:Xml = Xml.createElement("form");
		form.set("action", "/add/" + AddingObject.Paragraph + "/" + parentId);
		var div:Xml = Xml.createElement("div");
		div.addChild(addCheckbox("style", "bold"));
		div.addChild(addCheckbox("style", "italic"));
		div.addChild(addCheckbox("style", "underline"));
		form.addChild(div);
		form.addChild(createArea());
		form.addChild(createButton());
		return form;
	}
	
	public static function getImageAddingForm(parentId:String):Xml {
		var form:Xml = Xml.createElement("form");
		form.set("action", "/add/" + AddingObject.Image + "/" + parentId);
		var div:Xml = Xml.createElement("div");
		form.addChild(div);
		form.addChild(createField("src"));
		form.addChild(createField("name"));
		form.addChild(createButton());
		return form;
	}
	
	static function createButton():Xml {
		var button:Xml = Xml.createElement("input");
		button.set("name", "Submit");
		button.set("type", "submit");
		button.set("value", "Submit");
		var div:Xml = Xml.createElement("div");
		div.addChild(button);
		return div;
	}
	
	static function createArea():Xml {
		var textArea:Xml = Xml.createElement("textArea");
		textArea.set("name", "content");
		textArea.set("rows", "5");
		textArea.set("cols", "50");
		textArea.addChild(Xml.createPCData("Enter content"));
		return textArea;
	}
	
	static function createField(value:String):Xml {
		var textArea:Xml = Xml.createElement("textArea");
		textArea.set("name", value);
		textArea.set("size", "50");
		textArea.set("type", "text");
		textArea.addChild(Xml.createPCData("Enter " + value));
		return textArea;
	}
	
	static function addCheckbox(name:String, value:String):Xml {
		var checkBox:Xml = Xml.createElement("input");
		checkBox.set("type", "checkbox");
		checkBox.set("name", "is" + value);
		checkBox.set("value", "true");
		checkBox.addChild(Xml.createPCData(value));
		return checkBox;
	}
}