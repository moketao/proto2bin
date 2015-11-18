package
{
	import com.bulkLoader.BulkLoader;
	import com.bulkLoader.BulkProgressEvent;
	import com.netease.protobuf.Message;
	import com.netease.protobuf.WireType;
	import com.netease.protobuf.WriteUtils;
	import com.netease.protobuf.WritingBuffer;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_INT32;
	import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_STRING;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import parser.Script;
	
	import proto.PlayerInfo2;
	
	public class Proto2bin extends Sprite
	{

		private var loader:BulkLoader;
		public function Proto2bin()
		{
			Script.init(this, "class global{}");
			loader = new BulkLoader("main");
			loader.add("E:/swordweb/trunk/clientLibs/proto2bin/proto/out/proto/PlayerInfo.as");
			loader.addEventListener(BulkProgressEvent.COMPLETE,onOK);
			loader.start();
		}
		
		protected function onOK(e:BulkProgressEvent):void
		{
			var txt:String = loader.getText("E:/swordweb/trunk/clientLibs/proto2bin/proto/out/proto/PlayerInfo.as");
			txt = fix(txt);
			Script.LoadFromString(txt);
			var playerinfo:*=Script.New("PlayerInfo");
			playerinfo.id = 999;
			playerinfo.email = "123@abc.com";
			playerinfo.name = "f55";
			
			//写入
			var b:ByteArray = write(playerinfo);
			trace("写入后 , b.bytesAvailable:",b.bytesAvailable);
			
			//读出
			var playerInfo2:PlayerInfo2 = new PlayerInfo2();
			playerInfo2.mergeFrom(b);
			trace(playerInfo2.name);	//f55
			trace(playerInfo2.id);		//999
			trace(playerInfo2.email);	//123@abc.com
		}
		
		private var w:WritingBuffer = new WritingBuffer();
		private function write(playerinfo:*):ByteArray
		{
			w.clear();
			var b:ByteArray = new ByteArray();
			playerinfo.writeToBuffer(w);
			w.toNormal(b);
			b.position = 0;
			return b;
		}
		
		/*针对protobuf的修改*/
		private function fix(code:String):String
		{
			var reg:* = [FieldDescriptor$TYPE_INT32,FieldDescriptor$TYPE_STRING,Message,WireType,WriteUtils,WritingBuffer];
			var tmp:String = "import com.netease.protobuf.Message;\n";
			tmp += "import com.netease.protobuf.WireType;\n";
			tmp += "import com.netease.protobuf.WriteUtils;\n";
			tmp += "import com.netease.protobuf.WritingBuffer;\n";
			tmp += "import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_INT32;\n";
			tmp += "import com.netease.protobuf.fieldDescriptors.FieldDescriptor$TYPE_STRING;\n";
			tmp += "\n";
			code=code.replace("import com.netease.protobuf.*;","");
			code=code.replace("import com.netease.protobuf.fieldDescriptors.*;",tmp);
			code=code.replace(/use namespace com.netease.protobuf.used_by_generated_code;/g,"");
			code=code.replace(/override public final function/g,"function");
			code=code.replace(/override com.netease.protobuf.used_by_generated_code final function/g,"function");
			code=code.replace(/com.netease.protobuf.used_by_generated_code /g,"");
			code=code.replace(/dynamic /g,"");
			code=code.replace(/final /g,"");
			code=code.replace(/static /g,"");
			code=code.replace(/const /g,"var ");
			code=code.replace(/override /g,"var ");
			code=code.replace("for (var fieldKey:* in this) {","if(false){");
			code=code.replace(/super.writeUnknown(output, fieldKey);/g,";");
			code=code.replace(/extends com.netease.protobuf.Message/,"extends Message");
			code=code.replace(/output:com.netease.protobuf.WritingBuffer/g,"output:WritingBuffer");
			code=code.replace(/input:flash.utils.IDataInput/g,"input:IDataInput");
			code=code.replace(/com.netease.protobuf.WireType\./g,"WireType.");
			code=code.replace(/com.netease.protobuf.WriteUtils\./g,"WriteUtils.");
			code=code.replace(/com.netease.protobuf.ReadUtils\./g,"ReadUtils.");
			return code;
		}
	}
}