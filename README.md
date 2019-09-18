# vrp_scoreboard

A VRP scoreboard converted from the esx_scoreboard with is based of the original Stadus_Scoreboard resource.

Here is a preview as an admin
![Preview image](https://i.imgur.com/K5KnTvf.png)
Her is a preview as a player
![Preview image](https://i.imgur.com/VkQe5Nv.png)


To install the resource, just download it and put it in your resouce folder.
It is important that is called "vrp_scoreboard" or else it won't show up when you press the open button
## Feautures

- Light on performance
- See all players ping, and colored depending on the ping
- The script allows for some configuration. Though there is no config file.
  - You can change who is allowed to see the Jobs and ID's by changing the permission in server.lua
    in the playerspawn event(as seen in the example above).
  - You can add your own groups to the groups table in server.lua. Remember to change the title. It is the title that will
    be shown in the scoreboard.
  - Remember that if you change the groups table, then you have to change the if statements in client.lua to make the job counters work
  - To open the scoreboard you have to have the permission which is inside the vrp_scoreboard:askperm event in server.lua
- Controller friendly! Dpad up or Home button to open the scoreboard by default.
  This can be changed in client.lua if you wish

## Getting uptime to work

Properly install the [uptime](https://forum.fivem.net/t/release-show-uptime-in-server-list/162956) thing by Hawaii. If you don't want it then you can remove its code.

## Credits

- Stadus, original resource
- LifeGoal, design
- Hawaii, Wrote the esx resource

## License

Copyright 2018 Stadus

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
