cd ..

godot --headless --export-release "Windows" ./export/STH.exe
godot --headless --export-release "Android" ./export/STH.apk
godot --headless --export-release "WebFull" ./export/web/index.html
godot --headless --export-release "WebFull" ./deploy/index.html
timeout 5