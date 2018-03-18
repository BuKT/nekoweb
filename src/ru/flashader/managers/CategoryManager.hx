package ru.flashader.managers;

import haxe.ds.StringMap;
import neko.Web;
import ru.flashader.tables.Article;
import ru.flashader.tables.Category;
import sys.db.Manager;

class CategoryManager extends Manager<Category> {
	public function new() {
		super(Category);
	}
	
	public function doAdd():Xml {
		var params:StringMap<String> = Web.getParams();
		var category:Category = new Category();
		category.name = params.get("content");
		category.insert();
		return getShort(category);
	}
	
	public function doRemove(id:Int):Void {
		var category:Category = get(id);
		
		if (category != null) {
			for (art in Article.manager.search($parent == category)) {
				Article.manager.doRemove(art.id);
			}
			category.delete();
		}
	}
	
	public function getList():Xml {
		var toReturn:Xml = Xml.createElement("div");
		toReturn.set("class", "categories");
		for (cat in all()) {
			toReturn.addChild(getShort(cat));
		}
		return toReturn;
	}
	
	private function getShort(cat:Category):Xml {
		return TemplateManager.prepareParagraph(AddingObject.Category, "category", cat.id + "", cat.name, "articles", ParagraphStyle.BigHeader);
	}
}