
Type TCanvas Extends TListener

	Const IMAGES_FOLDER:String = "images"

	Field name:String

	Field canvas:TGadget
	
	Field preloader:TPreloader
	
	Method Create:TListener(context:TApplication)
		Super.Create(context)

	?Win32
		SetGraphicsDriver(D3D9Max2DDriver())
	?MacOs
		SetGraphicsDriver(GLMax2DDriver())
	?
		canvas = CreateCanvas(0, context.propertiesBar.height, context.window.ClientWidth(),  ..
							context.window.ClientHeight() - context.propertiesBar.height, context.window)
		canvas.SetLayout(EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED)
		
		preloader = TPreloader(New TPreloader.Create(Self))
		
		CreateTimer(15)
		context.AddListener(Self)
		
		Return Self
	End Method
	
	Method Init()
		preloader.Init()
	End Method
	
	Method AddImage()
		Local path:String = RequestFile("Select Image", "Image Files:png,jpg")
		
		If (path <> Null) Then
			Local image:TImage = LoadImage(path)
			
			If (image <> Null) Then
				Local preloaderImage:TPreloaderImage = TPreloaderImage(New TPreloaderImage.Create(Self))
				preloaderImage.SetImage(image)
				preloaderImage.filename = path
				preloader.AddImage(preloaderImage)
			End If
		End If
	End Method
	
	Method AddProgBar()
		preloader.AddProgBar(TPreloaderProgBar(New TPreloaderProgBar.Create(Self)))
	End Method
	
	Method AddText()
		preloader.AddText(TPreloaderText(New TPreloaderText.Create(Self)))
	End Method
	
	Method Save()
		Local filePath:String = name
		Local oldFlxp:ZipReader
	
		If (Not name) Then
			filePath = RequestFile("Save As...", "Preloader Files:flxp", True)
			If (Not filePath) Return
		Else
			oldFlxp = New ZipReader
			oldFlxp.OpenZip(filePath)
		End If
		
		Local images:TMap = New TMap
		
		If (oldFlxp) Then
			Local file:SZipFileEntry
			
			For Local i:Int = 0 To oldFlxp.getFileCount() - 1
				file = oldFlxp.getFileInfo(i)
				images.Insert(file.zipFileName, oldFlxp.ExtractFile(file.zipFileName))
			Next
			
			oldFlxp.CloseZip()
		End If
		
		Local flxp:ZipWriter = New ZipWriter
		flxp.OpenZip(filePath, APPEND_STATUS_CREATE)
		
		Local info:String
		
		info:+z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.MajorVersion + ":"
		info:+z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.MinorVersion + ":"
		info:+z_blide_bgd3e99f15_f89d_4905_b08a_e0aed2f388bc.Revision + ";"
		
		info:+preloader.width + ":"
		info:+preloader.height + ":"
		info:+preloader.minDisplayTime + ":"
		info:+preloader.color.ToString() + ";"
		
		For Local obj:TPreloaderImage = EachIn preloader.objects
			Local filename:String = IMAGES_FOLDER + "/" + StripDir(obj.filename)
		
			If (Not images.Contains(filename)) Then
				images.Insert(filename, ReadStream(obj.filename))
			End If
			
			obj.filename = filename
		Next
		
		For Local obj:TPreloaderObject = EachIn preloader.objects
			If (TPreloaderImage(obj)) Then
				info:+"image:"
				
			ElseIf(TPreloaderProgBar(obj)) Then
				info:+"progbar:"
				
			ElseIf(TPreloaderText(obj))
				info:+"text:"
			End If
		
			info:+obj.x + ":"
			info:+obj.y + ":"
			info:+obj.width + ":"
			info:+obj.height + ":"
			
			If (TPreloaderImage(obj)) Then
				flxp.AddStream(TStream(images.ValueForKey(TPreloaderImage(obj).filename)), TPreloaderImage(obj).filename)
			
				info:+TPreloaderImage(obj).filename + ":"
				info:+TPreloaderImage(obj).fromAlpha + ":"
				info:+TPreloaderImage(obj).toAlpha + ":"
				info:+TPreloaderImage(obj).blendMode
				
			ElseIf(TPreloaderProgBar(obj)) Then
				info:+TPreloaderProgBar(obj).color.ToString()
				
			ElseIf(TPreloaderText(obj))
				info:+TPreloaderText(obj).size + ":"
				info:+TPreloaderText(obj).text + ":"
				info:+TPreloaderText(obj).color.ToString()
			End If
			
			info:+","
		Next
		
		info = info[..(info.Length - 1)]
		
		Local infoStream:TStream = CreateBankStream(CreateBank(info.Length))
		infoStream.WriteString(info)
		
		flxp.AddStream(infoStream, "info")
		
		flxp.CloseZip()
		name = filePath
	End Method
	
	Method Open()
		Local filePath:String = RequestFile("Select Preloader...", "Preloader Files:flxp")
		If (Not filePath) Return
		Load(filePath)
	End Method
	
	Method Load(filePath:String)
		Reset()
		
		Local flxp:ZipReader = New ZipReader
		flxp.OpenZip(filePath)
		
		Local info:String[] = flxp.ExtractFile("info").ReadLine().Split(";")
		
		Local data:String[] = info[1].Split(":")
		
		preloader.width = Int(data[0])
		preloader.height = Int(data[1])
		preloader.minDisplayTime = Int(data[2])
		preloader.color.Set(Int(data[3]))
		
		Local objects:String[] = info[2].Split(",")
		
		Local tmpObj:TPreloaderObject
		
		For Local obj:String = EachIn objects
			data = obj.Split(":")
			
			Select data[0]
				Case "image"
					tmpObj = New TPreloaderImage
					TPreloaderImage(tmpObj).filename = data[5]
					TPreloaderImage(tmpObj).src = LoadImage(flxp.ExtractFile(data[5]))
					TPreloaderImage(tmpObj).fromAlpha = Int(data[6])
					TPreloaderImage(tmpObj).toAlpha = Int(data[7])
					TPreloaderImage(tmpObj).blendMode = Int(data[8])
				Case "progbar"
					tmpObj = New TPreloaderProgBar
					tmpObj.color.Set(Int(data[5]))
				Case "text"
					tmpObj = New TPreloaderText
					TPreloaderText(tmpObj).SetSize(Int(data[5]))
					TPreloaderText(tmpObj).text = data[6]
					tmpObj.color.Set(Int(data[7]))
			End Select
			
			tmpObj.x = Int(data[1])
			tmpObj.y = Int(data[2])
			tmpObj.width = Int(data[3])
			tmpObj.height = Int(data[4])
			
			preloader.objects.AddLast(tmpObj)
		Next
		
		flxp.CloseZip()
		preloader.DeselectAll()
		name = filePath
	End Method
	
	Method Reset()
		preloader.Reset()
		name = Null
		preloader.DeselectAll()
	End Method
	
	Method OnEvent(event:Int, src:TGadget)
		Select event
			Case EVENT_TIMERTICK
				preloader.Update()
				RedrawGadget(canvas)
				
			Case EVENT_GADGETPAINT
				SetGraphics (CanvasGraphics(canvas))
				SetClsColor(127, 127, 127)
				SetViewport(0, 0, canvas.width, canvas.height)
				SetBlend(ALPHABLEND)
				SetOrigin(0, 0)
				SetAlpha(1)
				SetColor(255, 255, 255)
								
				Cls
				preloader.Draw()
				Flip
				
			Case EVENT_MOUSEDOWN
				If (src = canvas And EventData() = MOUSE_LEFT) Then
					preloader.Click(EventX(), EventY())
				End If
		End Select
	End Method

End Type
