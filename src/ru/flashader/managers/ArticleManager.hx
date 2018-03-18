package ru.flashader.managers;

import haxe.ds.StringMap;
import neko.Web;
import ru.flashader.tables.Article;
import ru.flashader.tables.Category;
import ru.flashader.tables.Paragraph;
import sys.db.Manager;

class ArticleManager extends Manager<Article> {
	public function new() {
		super(Article);
	}
	
	public function doAdd(parentId:String):Xml {
		var params:StringMap<String> = Web.getParams();
		var article:Article = new Article();
		article.name = params.get("content");
		article.cid = Std.parseInt(parentId);
		article.insert();
		return getShort(article);
	}
	
	public function doRemove(id:Int):Void {
		var article:Article = get(id);
		if (article != null) {
			for (par in Paragraph.manager.search($parent == article)) {
				Paragraph.manager.doRemove(par.id);
			}
			article.delete();
		}
	}
	
	public function getList(parent:Category):List<Xml> {
		var toReturn:List<Xml> = new List<Xml>();
		for (art in search($parent == parent)) {
			toReturn.add(getShort(art));
		}
		return toReturn;
	}
	
	private function getShort(art:Article):Xml {
		return TemplateManager.prepareParagraph(AddingObject.Article, "article", art.id + "", art.name, "paragraphs", ParagraphStyle.SimpleHeader);
	}
}