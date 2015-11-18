package com.mkt
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FileUtil
	{
		public static function File2ByteArray(f:File):ByteArray
		{
			var b:ByteArray = new ByteArray();
			var s:FileStream = new FileStream();
			s.open(f,FileMode.READ);
			s.readBytes(b);
			b.position = 0;
			return b;
		}
		public static function File2String(f:File):String
		{
			var b:ByteArray = new ByteArray();
			var s:FileStream = new FileStream();
			s.open(f,FileMode.READ);
			var str:String = s.readUTFBytes(s.bytesAvailable);
			return str;
		}
		
		static public function saveByKey(key:String,content:String):void
		{
			var tmp:* = SOManager.get(key);
			if(tmp){
				save(tmp,content);
			}
		}
		
		private static function save(path:String, content:String):void
		{
			var f:File = new File(path);
			if(!f.exists){
				f.createDirectory();
			}
			var s:FileStream = new FileStream();
			s.open(f,FileMode.WRITE);
			s.writeUTFBytes(content);
			s.close();
		}
	}
}