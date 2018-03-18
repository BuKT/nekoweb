package ru.flashader;
	import haxe.web.Dispatch;
	import neko.Lib;
	import neko.Web;
	import ru.flashader.managers.TemplateManager;
	import ru.flashader.managers.UserManager;
	import ru.flashader.tables.Article;
	import ru.flashader.tables.Category;
	import ru.flashader.tables.Image;
	import ru.flashader.tables.Paragraph;
	import ru.flashader.tables.User;

	class Api {
		
		public function new() { }
		
		public function doDefault():Void {
			doCategories();
		}
		
		public function doLogin(name:String, passwd:String):Void {
			User.manager.tryLogin(name, passwd);
		}
		
		public function doCategories():Void {
			showXML(TemplateManager.getHtml(Category.manager.getList()));
		}
		
		public function doArticles(category:Category):Void {
			showXML(category.toXml());
		}
		
		public function doParagraphs(article:Article):Void {
			showXML(article.toXml());
		}
		
		public function doImages(paragraph:Paragraph):Void {
			showXML(paragraph.toXml());
		}
		
		public function doAndrew():Void {
			Web.setReturnCode(301);
			Web.setHeader("Location", "http://financepo8aa.1gb.ru");
		}
		
		/*
		* Cheat zone
		*/
		
		public function doFormForimages(parentID:String):Void {
			if (!UserManager.cookieValid) { throw 'Bad Request'; }
			showXML(TemplateManager.getImageAddingForm(parentID));
		}
		
		public function doFormForparagraphs(parentID:String):Void {
			if (!UserManager.cookieValid) { throw 'Bad Request'; }
			showXML(TemplateManager.getParagraphAddingForm(parentID));
		}
		
		public function doFormForarticles(parentID:String):Void {
			if (!UserManager.cookieValid) { throw 'Bad Request'; }
			showXML(TemplateManager.getArticleAddingForm(parentID));
		}
		
		public function doFormForcategories():Void {
			if (!UserManager.cookieValid) { throw 'Bad Request'; }
			showXML(TemplateManager.getCategoryAddingForm());
		}
		
		public function doAdd(type:AddingObject, ?parentId:String):Void {
			if (!UserManager.cookieValid) { throw 'Bad Request'; }
			switch(type) {
				case AddingObject.Image:
					showXML(Image.manager.doAdd(parentId));
				case AddingObject.Paragraph:
					showXML(Paragraph.manager.doAdd(parentId));
				case AddingObject.Article:
					showXML(Article.manager.doAdd(parentId));
				case AddingObject.Category:
					showXML(Category.manager.doAdd());
				default:
					throw 'Bad request';
			}
		}
		
		public function doDelete(type:AddingObject, id:Int):Void {
			if (!UserManager.cookieValid) { throw 'Bad Request'; }
			switch(type) {
				case AddingObject.Image:
					Image.manager.doRemove(id);
				case AddingObject.Paragraph:
					Paragraph.manager.doRemove(id);
				case AddingObject.Article:
					Article.manager.doRemove(id);
				case AddingObject.Category:
					Category.manager.doRemove(id);
				default:
					throw 'Bad request';
			}
		}
		
		
		static function main()  {
			if (!BaseConnector.isInited) {
				BaseConnector.init();
			}
			try {
				User.manager.checkCookie();
				Dispatch.run(Web.getURI(), null, new Api());
			} catch (e:Dynamic) {
				Web.setReturnCode(400);
				Lib.print('Bad request');
			}
			Web.flush();
		}
		
		static function showXML(source:Xml):Void {
			Lib.print(source.toString());
		}
	}