package ru.flashader.managers;

import haxe.ds.StringMap;
import neko.Web;
import ru.flashader.tables.Article;
import ru.flashader.tables.Image;
import ru.flashader.tables.Paragraph;
import sys.db.Manager;

class ParagraphManager extends Manager<Paragraph> {
	public function new() {
		super(Paragraph);
	}
	
	public function doAdd(parentId:String):Xml {
		var params:StringMap<String> = Web.getParams();
		var paragraph:Paragraph = new Paragraph();
		paragraph.content = params.get("content");
		
		if (params.get("isbold") != null) {
			paragraph.style.set(ParagraphStyle.Bold);
		}
		if (params.get("isitalic") != null) {
			paragraph.style.set(ParagraphStyle.Italic);
		}
		if (params.get("isunderline") != null) {
			paragraph.style.set(ParagraphStyle.Underline);
		}
		paragraph.aid = Std.parseInt(parentId);
		paragraph.insert();
		
		return getShort(paragraph);
	}
	
	public function doRemove(id:Int):Void {
		var paragraph:Paragraph = get(id);
		if (paragraph != null) {
			for (im in Image.manager.search($parent == paragraph)) {
				Image.manager.doRemove(im.id);
			}
			paragraph.delete();
		}
	}
	
	public function getList(parent:Article):List<Xml> {
		var toReturn:List<Xml> = new List<Xml>();
		for (paragraph in search($parent == parent)) {
			toReturn.add(getShort(paragraph));
		}
		return toReturn;
	}
	
	private function getShort(paragraph:Paragraph):Xml {
		var ownClass:String = "paragraph";
		if (paragraph.style.has(ParagraphStyle.Bold)) { ownClass += " bold"; }
		if (paragraph.style.has(ParagraphStyle.Italic)) { ownClass += " italic"; }
		if (paragraph.style.has(ParagraphStyle.Underline)) { ownClass += " underline"; }
		
		return TemplateManager.prepareParagraph(AddingObject.Paragraph, ownClass, paragraph.id + "", paragraph.content, "images");
	}
}