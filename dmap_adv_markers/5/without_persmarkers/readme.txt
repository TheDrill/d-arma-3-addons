DMapAdvMarkers v5 
by Drill

////////////////////////////////////////
//  General description

This addon provides enhancements for the ArmA markers system. 
Main advantages are:

  1. Markers type/color are stored between inserting - no need to set it every
     time new marker is placed.
     
  2. Added new "marker" type in form of jugged lines.
  
  3. Ability to assign hotkeys for marker type and color change, hotkey to send
     marker to particular channel (through userconfig).
     
  4. Ability to show/hide channel and creator of existing markers.
  
////////////////////////////////////////
// Installation

The dmap_adv_markers.pbo should be placed in appropriate addons directory.
Userconfig file "config.txt" must be placed in directory:
  "<ArmA installation directory>\userconfig\DMapAdvMarkers"
  
Userconfig is cheat-free because it's handled by the addon as a plain-text,
not executed.

The addon must be activated both on server and on clients.

////////////////////////////////////////
//  Usage description

The addon mimics default ArmA behavior where it's possible.

1. To add jugged-line marker the one should press Ctrl key and left-click by 
   mouse somewhere on the map. That would start the process of placing the 
   jugged-line marker. The next segments of the marker then could be placed 
   by just left-clicks of mouse. The last segment could be removed by pressing
   Backspace key, the whole process could be canceled by pressing Escape key.
   Left/right cursor keys change the color of the marker, Up/down - its 
   thickness. After all needed segments are placed, Enter key must be pressed
   to confirm the marker creation and sending it to the current chat channel.
   
2. The addon provides the possibility to use hotkeys for switching color and
   type of markers (both ordinary and jugged-line markers). The hotkeys are
   assigned through userconfig file:
      "<ArmA installation directory>\userconfig\DMapAdvMarkers\config.txt"
   The description of the config format is provided as comments in file itself.
   The default config is: 
     1. Ctrl-1, Ctrl-2, ..., Ctrl-0 set color of marker.
     
     2. Ctrl-Q, ..., Ctrl-T, Ctrl-A, ..., Ctrl-G, Ctrl-Z, ..., Ctrl-B set type
        of marker.

3. The marker types available in-game and their order could be set through 
   userconfig by command markerslist. The default config enables 16 standard 
   marker types.

4. The colors of marker available in-game and their order could be set through
   userconfig by command colorslist.
   
5. Pressing Alt key on map temporary shows/hides channel of existing markers 
   on the map and/or their creators' nicknames. The actual behavior could be
   changed through "Options" entry in notes list. The behavior then stored in
   user profile namespace.

6. The addon provieds the possibility to user hotkeys for sending the marker
   to a particular chat channel. The actual hotkeys are configurated in 
   user config. Default combinations are:
     1. Ctrl-L - send to vehicle channel
     
     2. Ctrl-; - send to group channel
     
     3. Ctrl-' - send to side channel
     
 
