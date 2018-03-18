package ru.flashader.managers;

import haxe.crypto.Md5;
import neko.Lib;
import neko.Web;
import ru.flashader.tables.User;
import sys.db.Manager;

class UserManager extends Manager<User> {
	static public var cookieValid:Bool;
	public function new() {
		super(User);
	}
	
	public function tryLogin(name:String, passwd:String):Void {
		var user:User = select($name == name && $passwd == Md5.encode(passwd + "BeMyGuest!"));
		if (user == null) {
			Web.setReturnCode(403);
			Lib.print('Bad request');
			return;
		}
		user.cookie = Md5.encode("JustForYou~" + Date.now().getTime());
		user.validFor = DateTools.delta(Date.now(), (15 * 60 * 60 * 1000));
		user.update();
		Web.setCookie("logon", user.cookie, user.validFor, "flashader.ru", "/");
	}
	
	public function checkCookie() {
		var user:User = select($cookie == Web.getCookies().get("logon"));
		if (user != null && user.validFor != null) {
			cookieValid = (user.validFor.getTime() > Date.now().getTime());
		}
	}
}