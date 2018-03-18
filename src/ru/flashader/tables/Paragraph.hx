package ru.flashader.tables;
	import ru.flashader.managers.ParagraphManager;
	import ru.flashader.tables.Article;
	import sys.db.Object;
	import sys.db.Types.SFlags;
	import sys.db.Types.SId;
	import sys.db.Types.SInt;
	
	class Paragraph extends Object {
		public var id:SId;
		public var aid:SInt;
		public var content:String;
		public var style:SFlags<ParagraphStyle> = new SFlags<ParagraphStyle>();
		@:relation(aid) public var parent:Article;
		public static var manager:ParagraphManager = new ParagraphManager();
		
		public function toXml():Xml {
			var toReturn:Xml = Xml.createElement("div");
			toReturn.set("class", "article");
			for (par in Image.manager.getList(this)) {
				toReturn.addChild(par);
			}
			return toReturn;
		}
	}