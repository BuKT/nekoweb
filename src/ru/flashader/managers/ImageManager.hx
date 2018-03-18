package ru.flashader.managers;

import haxe.ds.StringMap;
import neko.Web;
import ru.flashader.tables.Image;
import ru.flashader.tables.Paragraph;
import sys.db.Manager;

class ImageManager extends Manager<Image> {

	public function new() {
		super(Image);
	}
	
	public function doAdd(parentId:String):Xml {
		var params:StringMap<String> = Web.getParams();
		var image:Image = new Image();
		image.name = params.get("name");
		image.src = params.get("src");
		image.pid = Std.parseInt(parentId);
		image.insert();
		return getShort(image);
	}
	
	public function doRemove(id:Int):Void {
		var image:Image = get(id);
		if (image != null) { image.delete(); }
	}
	
	public function getList(parent:Paragraph):List<Xml> {
		var toReturn:List<Xml> = new List<Xml>();
		for (image in search($parent == parent)) {
			toReturn.add(getShort(image));
		}
		return toReturn;
	}
	
	private function getShort(image:Image):Xml {
		return TemplateManager.prepareImage("image", image.id + "", image.name, image.src);
	}
}