package ru.flashader.tables;
	import ru.flashader.managers.ArticleManager;
	import sys.db.Object;
	import sys.db.Types.SId;
	import sys.db.Types.SInt;

	class Article extends Object {
		public var id:SId;
		public var cid:SInt;
		public var name:String;
		@:relation(cid) public var parent:Category;
		public static var manager:ArticleManager = new ArticleManager();
		
		public function toXml():Xml {
			var toReturn:Xml = Xml.createElement("div");
			toReturn.set("class", "article");
			for (par in Paragraph.manager.getList(this)) {
				toReturn.addChild(par);
			}
			toReturn.set("name", name);
			return toReturn;
		}
	}