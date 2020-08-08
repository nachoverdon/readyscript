##############################

Program written by aquila

E-Mail: lowb1rd-aquila@web.de
ICQ: 241113067

##############################


===========================================================================================================================


######## D E U T S C H #######


1.) Installation
- STEAMID in admins.txt in dem Scriptordner eintragen
- Starte das Script und trage die LAN-IP (wenn Router) bzw. WAN-IP (wenn kein Router) unter Optionen -> Script ein.
- Öffne den Port 6563 UDP

2.) Wie benutze ich das Script?
Wichtig ist es das der Port offen ist, ansonsten wird es nicht funktionieren. Um es zu benutzen müsst ihr einfach
nur die readyscript.exe starten, IP-Adresse und RCON-Passwort eintragen und anschließend starten. Dann sollte es auch
schon problemlos funktionieren ;).

3.) Script-Erweiterungen
- Transparenz des Fensters, lässt sich im Traymenu aktivieren.
- Skins, sprich Farbe des Fensters lässt sich verändern.
- Lädt gewünschte Settings, je nachdem wenn sie 2on2 spielen, lädt er die 2on2.cfg im Ordner configs. Sie können die Settings auch
mit einer anderen überspeichern, achten sie aber darauf, das sie den gleichen Aufbau wie die momentanen haben, sprich kein RCON o.ä.
davor. Die Settings die momentan vorhanden sind, sind die ESL-Settings (Stand: ~ Februar 2008)
- Verschlüsselt das RCON und speichert RCON + IP.
- Overtimefunktion möglich.
- IRC Suche möglich. Dazu muss beim Script unter Optionen -> Script -> Ein hacken bei "Enable irc search" sein. Suchen kann prinzipiell jeder.
Man startet den ircbot mit 'irc Text'. Wichtig ist, das im Text 1on1, 2on2,... oder 5on5 vorkommt, damit das Script weiss, in welchen Channel es muss.
Der Text wird solange geschrieben, bis ein Gegner gefunden wurde. Anschließend kann man mit dem User, der dich angeqeryt hat, chatten. Das geht
dann ebenfalls mit 'irc text'. Um ihm die IP und das pw zu senden, müsst ihr einfach nur 'irc ip pw' schreiben, dann empfängt er die Ip und das Pw des
momentanen Servers. Schließen kannn man den bot mit 'irc close'. Fals der User, der euch angequeryt hat, nicht mehr antwortet oder wie auch immer, könnt
ihr die IRC suche mit 'irc next' weiterführen. Zusätzlich erscheinen auf dem Server alle Nachrichten die ihr lossendet, damit ihr einen Überblick habt.

4.) Befehle
Folgende Befehle können auf dem Server genutzt werden:

-Für Alle:
ready/rdy
notready/notrdy
info
time
-Für Admins:
setup xonx mrxx (z. B. setup 2on2 mr12)
warmup
stop script
resume script
restart match (Start die Halbzeit nochmal neu, die momentan gespielt wird.)


Bei Fragen oder Anregungen, meine Kontaktiermöglichkeiten stehen ganz oben im Dokument.


===========================================================================================================================


####### E N G L I S H #######


1.) Installation
- put in STEAMID in admins.txt in the scriptfolder
- Put in your LAN-IP in lanip.txt (LAN-IP for example: 192.168.2.101)
- OPEN Port 6563 UDP

2.) How to use the Script?
First it's important to open the Port, otherwise it won't work. To use the script you need only run the readyscript.exe.
Then put in the IP and the Port and in the other Input the RCON-Password. Then press run readyscript and you can begin
with your war :D.

3.) Script-Addons
- Transparency of the window, u can activate it in the Traymenu.
- Skins, so you can change the color of the window.
- It can load Settings, so if you play a 2on2 and wrote setup 2on2 mr12, it will load the 2on2.cfg in the configs folder of your Scriptdir.
You can change the settings of course, too. But also make sure, that you have the same structure like these at the moment, so not RCON or anything
else before the commands. The settings at the moment are the ESL-Settings (~Februar, 2008).
- Crypts the RCON and saves IP + RCON.
- Overtime function.
- IRC search possible. For this open the script options, Traymenu -> Options -> Script. Make a tick at 'Enable irc search'. You can run it with 
'irc text' on the server. It's important that in the text is 1on1, 2on2,... or 5on5, because the script needs to know, in which channel it should connect.
The text will send the message to the channel until someone opend a query. The messages will shown on the server. You can answer with 'irc text'. If
you want to send him the ip and the pw, you only need to write 'irc ip pw' and he will receive the ip and the pw of the current server. The command 
'irc close' will close the irc. If someone opens a query and don't answer anymore you just need to type 'irc next' and it will writing again the message
in the channel until someone opens a query again. Every message is shown on the server, so you have a good overview.


4.) Commands
The following Commands can be used on the Server:
-For all:
ready/rdy
notready/notrdy
info
time
-For Admins:
setup xonx mrxx (for example, setup 2on2 mr12)
warmup
stop script
resume script
restart match (Restarts the halftime which is playing at the moment. So if you write restart match in 2nd half, it will restart the 2nd one.)


If you have any questions, you can contact me. Take a look to the top of the file.


===========================================================================================================================


© 2008 aquila