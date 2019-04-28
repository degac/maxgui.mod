Rem
		Common function to ProxyGadget
		v. 1.0
End Rem
Import brl.max2d
Import maxgui.maxgui

Function MakeLight:Object(src:Object)
		Local r:Int,g:Int,b:Int,argb:Int,a:Int,c:Int
		Local x:Int,y:Int,tipo:Int=0,pm:TPixmap
		Local tmp_img:TImage,pix:TPixmap,ics:Ticonstrip


		If TPixmap(src)	
			pix=TPixmap(src)
			tmp_img=CreateImage(pix.WIDTH,pix.HEIGHT)
			pm=pix
			tipo=0
		End If
		If ticonstrip(src)
			ics=Ticonstrip(src)
			tmp_img=CreateImage(ics.pixmap.WIDTH,ics.pixmap.HEIGHT)
			pm=ics.pixmap
			tipo=1
		End If
		
		Local kk:Int=64,hh:Int=pm.HEIGHT,ww:Int=pm.WIDTH

		Local RED:Int[ww,hh]
		Local green:Int[ww,hh]
		Local blue:Int[ww,hh]
		Local alpha:Int[ww,hh]
		Local pm2:TPixmap=LockImage(tmp_img)
		
		DebugLog "Tipo: "+tipo+" Size: "+pm.WIDTH+" x "+pm.HEIGHT
		For y=0 Until pm.HEIGHT
		For x=0 Until pm.WIDTH
			argb=ReadPixel(pm,x,y)
			a=argb Shr 24 & $ff
			r = (argb Shr 16) & $ff
			g = (argb Shr 8) & $ff
			b = argb & $ff
			RED[x,y]=r
			green[x,y]=g
			blue[x,y]=b
			alpha[x,y]=a
		Next
		Next

		Local pixcol:Int
		For y=0 Until pm.HEIGHT
		For x=0 Until pm.WIDTH
			r=RED[x,y]+kk
			g=green[x,y]+kk
			b=blue[x,y]+kk
			a=alpha[x,y]
			
			CheckLimit(r)
			CheckLimit(g)
			CheckLimit(b)
			
			pixcol:Int=(a Shl 24)|(r Shl 16)|(g Shl 8)|(b)
			WritePixel(pm2,x,y,pixcol)

		Next
		Next

	'	light=pm2
	'	light_iconstrip=LoadIconStrip(pm2)
		If tipo=0	Return pm2
		If tipo=1 Return LoadIconStrip(pm2)


		Function CheckLimit(value:Int Var)
				If value<0 value=0
				If value>255 value=255
				Return 
		End Function


End Function


Function MakeGrey:Object(src:Object)
		Local r:Int,g:Int,b:Int,argb:Int,a:Int,c:Int
		Local x:Int,y:Int,tipo:Int=0
		Local tmp_grey:TImage,pix:TPixmap,ics:Ticonstrip
		Local pm:TPixmap

		If TPixmap(src)	
			pix=TPixmap(src)
			tmp_grey=CreateImage(pix.WIDTH,pix.HEIGHT)
			pm=pix
			tipo=0
		End If
		If ticonstrip(src)
			ics=Ticonstrip(src)
			tmp_grey=CreateImage(ics.pixmap.WIDTH,ics.pixmap.HEIGHT)
			pm=ics.pixmap
			tipo=1
		End If
		
		Local pm2:TPixmap=LockImage(tmp_grey)
			
		For y=0 Until pm.HEIGHT
		For x=0 Until pm.WIDTH
	
		argb=ReadPixel(pm,x,y)
			
			a=argb Shr 24 & $ff
			r = (argb Shr 16) & $ff
			g = (argb Shr 8) & $ff
			b = argb & $ff

			c=(r+g+b)/3
			
			Local pixcol:Int=(a Shl 24)|(c Shl 16)|(c Shl 8)|(c)
			WritePixel(pm2,x,y,pixcol)
		Next
		Next
		
		If tipo=0	Return pm2
		If tipo=1 Return LoadIconStrip(pm2)

	
	End Function
	
