package ru.flashader.tables;
	import ru.flashader.managers.CategoryManager;
	import ru.flashader.tables.Article;
	import sys.db.Object;
	import sys.db.Types.SId;

	class Category extends Object {
		public var id:SId;
		public var name:String;
		public static var manager:CategoryManager = new CategoryManager();
		
		public function toXml():Xml {
			var toReturn:Xml = Xml.createElement("div");
			toReturn.set("class", "category");
			for (art in Article.manager.getList(this)) {
				toReturn.addChild(art);
			}
			toReturn.set("name", name);
			return toReturn;
		}
	}