package ru.flashader.tables;
	import ru.flashader.managers.UserManager;
	import sys.db.Object;
	import sys.db.Types.SDateTime;
	import sys.db.Types.SId;

	class User extends Object {
		public var id:SId;
		public var name:String;
		public var passwd:String;
		public var cookie:Null<String>;
		public var validFor:Null<SDateTime>;
		public static var manager:UserManager = new UserManager();
	}