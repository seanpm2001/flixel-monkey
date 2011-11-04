Strict

Import flxcamera
Import flxgame

Import plugin.timemanager

Class FlxG	

	Global LIBRARY_NAME:String = "Monkey flixel"
	
	Global LIBRARY_MAJOR_VERSION:Int = 1
	
	Global LIBRARY_MINOR_VERSION:Int = 0
	
	Global RED:Color = New Color($FFFF0012)
	
	Global GREEN:Color = New Color($FF00F225)
	
	Global BLUE:Color = New Color($FF0090E9)
	
	Global PINK:Color = New Color($FFF01EFF)
	
	Global WHITE:Color = New Color($FFFFFFFF)
	
	Global BLACK:Color = New Color($FF000000)
	
	Global width:Int
	
	Global height:Int
			
	Global cameras:Stack<FlxCamera>
	
	Global camera:FlxCamera
	
	Global plugins:Stack<FlxBasic>
	
	Global elapsed:Int
	
	Global visualDebug:Bool
	
	Global framerate:Int
	
Private
	Global _game:FlxGame
	
	Global _bgColor:Color = FlxG.BLACK

Public	
	Function Init:Void(game:FlxGame, width:Int, height:Int, zoom:Float)
		FlxG._game = game
		FlxG.width = width
		FlxG.height = height
		
		FlxCamera.defaultZoom = zoom
		FlxG.cameras = New Stack<FlxCamera>()		
		
		plugins = New Stack<FlxBasic>
		AddPlugin(New TimerManager())	
	End Function
	
	Function GetRandom:FlxBasic(objects:FlxBasic[], startIndex:Int = 0, length:Int = 0)
		Return Null
	End Function
	
	Function AddCamera:FlxCamera(newCamera:FlxCamera)
		FlxG.cameras.Push(newCamera)
		Return newCamera
	End Function
	
	Function RemoveCamera:Void(camera:FlxCamera, destroy:Bool = True)
		FlxG.cameras.RemoveEach(camera)
		If (destroy) camera.Destroy()
	End Function
	
	Function ResetCameras:Void(newCamera:FlxCamera = Null)
		Local cam:FlxCamera
		Local cams:Stack<FlxCamera> = FlxG.cameras
		Local i:Int = 0
		Local l:Int = cams.Length()
		
		While(i < l)
			cam = cams.Get(i)
			cam.Destroy()
			i+=1
		Wend
		
		cams.Clear()
		If (newCamera = Null) newCamera = New FlxCamera(0, 0, FlxG.width, FlxG.height)
		
		FlxG.camera = FlxG.AddCamera(newCamera)	
	End Function
	
	Function Reset:Void()
		FlxG.elapsed = 0	
	End Function	
	
	Function BgColor:Color()
		If (FlxG.camera = Null) Return FlxG._bgColor	
		Return FlxG.camera.bgColor
	End Function
	
	Function BgColor:Void(color:Color)
		Local i:Int = 0
		Local l:Int = FlxG.cameras.Length()
		
		While(i < l)
			cameras.Get(i).bgColor = color
			i+=1
		Wend
		
		FlxG._bgColor = color
	End Function
	
	Function AddPlugin:FlxBasic(plugin:FlxBasic)
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			If (pluginList.Get(i).ToString() = plugin.ToString()) Then
				Return plugin	
			End If
			
			i+=1
		Wend
		
		pluginList.Push(plugin)
		Return plugin
	End Function
	
	Function GetPlugin:FlxBasic(creator:FlxClassCreator)
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local plugin:FlxBasic
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (creator.InstanceOf(plugin)) Return plugin
			
			i+=1
		Wend
		
		Return Null	
	End Function
	
	Function RemovePlugin:FlxBasic(plugin:FlxBasic)
		plugins.RemoveEach(plugin)
		Return plugin
	End Function
	
	Function RemovePluginType:Bool(creator:FlxClassCreator)
		Local results:Bool = False
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = pluginList.Length() - 1	
		
		While(i >= 0)
			If (creator.InstanceOf(pluginList.Get(i))) Then
				pluginList.Remove(i)
				results = True	
			End If
			
			i-=1
		Wend
	
		Return results
	End Function
	
	Function UpdateCameras:Void()
		Local cam:FlxCamera
		Local cams:Stack<FlxCamera> = FlxG.cameras
		Local i:Int = 0
		Local l:Int = cams.Length()
		
		While(i < l)
			cam = cams.Get(i)
			If (cam <> Null And cam.exists And cam.active) cam.Update()			
			i+=1
		Wend
	End Function
	
	Function UpdatePlugins:Void()
		Local plugin:FlxBasic
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (plugin.exists And plugin.active) plugin.Update()			
			i+=1
		Wend
	End Function
	
	Function DrawPlugins:Void()
		Local plugin:FlxBasic
		Local pluginList:Stack<FlxBasic> = FlxG.plugins
		Local i:Int = 0
		Local l:Int = pluginList.Length()
		
		While(i < l)
			plugin = pluginList.Get(i)
			If (plugin.exists And plugin.visible) plugin.Draw()			
			i+=1
		Wend
	End Function

End Class
