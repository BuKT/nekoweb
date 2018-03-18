package ru.flashader.tables;

import ru.flashader.managers.ImageManager;
import sys.db.Object;
import sys.db.Types.SId;
import sys.db.Types.SInt;

class Image extends Object {
	public var id:SId;
	public var pid:SInt;
	public var name:String;
	public var src:String;
	@:relation(pid) public var parent:Paragraph;
	public static var manager:ImageManager = new ImageManager();
}