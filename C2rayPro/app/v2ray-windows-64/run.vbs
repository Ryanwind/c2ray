DIM objShell 
set objShell = wscript.createObject("wscript.shell") 
iReturn = objShell.Run("cmd.exe /C C:\Users\admin\Desktop\storages\C2rayPro\app\v2ray-windows-64\wv2ray.exe -config=C:\Users\admin\Desktop\storages\C2rayPro\config.json", 0, TRUE) 
