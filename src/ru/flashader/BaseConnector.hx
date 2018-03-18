package ru.flashader;
import haxe.crypto.Md5;
import ru.flashader.tables.Article;
import ru.flashader.tables.Category;
import ru.flashader.tables.Image;
import ru.flashader.tables.Paragraph;
import ru.flashader.tables.User;
import sys.db.Connection;
import sys.db.Manager;
import sys.db.Sqlite;
import sys.db.TableCreate;


	class BaseConnector {
		private var cnx:Connection;
		public static var isInited:Bool;
		public static var instance:BaseConnector;
		
		public function new() {
			cnx = Sqlite.open("./sitebase.db");
			Manager.cnx = cnx;
			Manager.initialize();
			if (!TableCreate.exists(User.manager)) {
				TableCreate.create(User.manager);
				var user:User = new User();
				user.name = "bukt";
				user.passwd = Md5.encode("0123" + "BeMyGuest!");
				user.insert();
			}
			if (!TableCreate.exists(Category.manager)) {
				TableCreate.create(Category.manager);
			}
			if (!TableCreate.exists(Article.manager)) {
				TableCreate.create(Article.manager);
			}
			if (!TableCreate.exists(Paragraph.manager)) {
				TableCreate.create(Paragraph.manager);
			}
			if (!TableCreate.exists(Image.manager)) {
				TableCreate.create(Image.manager);
			}
		}
		
		public static function init() {
			instance = new BaseConnector();
			isInited = true;
		}
	}