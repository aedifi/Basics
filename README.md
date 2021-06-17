### Basics for Aedificium
[Lua](https://lua.org) plugin for [Cuberite](https://cuberite.org) which provides basic commands and permissions needed to run a simple server.
<br>
Based off the [cuberite/core](https://github.com/cuberite/Core) plugin by [Mathias](https://github.com/mathiascode) and others.

### Visitor commands
By default server configuration, these commands are granted to visitors.
| Usage | Permission(s) | Description |
| ------- | ---------- | ----------- |
| `/chunks` | `basics.chunks` | Lists any chunks in memory. |
| `/commands [page] [string]` | `basics.help` | Lists permissible commands. |
| `/distance <distance>` | `basics.distance` | Sets your render distance. `distance` = `min - max` for client. |
| `/lag` | `basics.lag` | Calculates the average t/s. |
| `/players` | `basics.players` | Lists players who are connected. |
| `/plugins` | `basics.plugins` | Lists configured plugins. |
| `/ranks` | `basics.ranks` | Lists configured ranks. |
| `/memory` | `basics.memory` | Calculates the amount of memory being used. |
| `/motd` | `basics.motd` | Displays the message of the day. |
| `/nearby` | `basics.nearby` | Lists players who are nearby. |
| `/worlds` | `basics.worlds` | Lists configured worlds. |
| `/whisper <player> <message> (or) /reply <message>` | `basics.whisper` | Directly messages somebody. |
| `/seed [world]` | `basics.seed` | Displays the world's seed. |
| `/spawn [world]` | `basics.spawn` | Takes you to any world's spawn. |

### Architect commands
By default server configuration, these commands are granted to architects.
| Usage | Permission(s) | Description |
| ------- | ---------- | ----------- |
| `/clear [player]` | `basics.clear` `basics.clear.others` | Clears a player's inventory. |
| `/get <item> [amount] [data] [datatag]` | `basics.get` | Gets an item for you with optional data. |
| `/goto <player> (or) /goto <x> <y> <z>` | Takes you to any player or coordinates. |
| `/mode <creative \| spectator> [player]` | `basics.mode` | Changes a player's gamemode. |
| `/summon <entity> [x] [y] [z]` | `basics.summon` | Summons an entity. |
| `/time <day \| night \| value> [world]` | `basics.time` | Changes the world's time. |
| `/weather <sunny \| rainy \| stormy> [seconds] [world]` | `basics.weather` | Changes the world's weather. |

### Moderator commands
By default server configuration, these commands are granted to moderators.
| Usage | Permission(s) | Description |
| ------- | ---------- | ----------- |
| `/ban <player> [reason]` | `basics.ban` | Bans a player. |
| `/discretion <watching \| ignoring>` | `baiscs.discretion` | Changes if you're watching everybody's commands. |
| `/kick <player> [reason]` | `basics.kick` | Kicks a player. |
| `/pardon <player> [reason]` | `basics.pardon` | Pardons a player. |
| `/regen <x> <z>` | `basics.regen` | Regenerates a specific chunk. |
| `/reload` | `basics.reload` | Reloads all plugins. |
| `/save` | `basics.save` | Saves all worlds to disk. |
| `/spy <commands \| stop>` | `basics.spy` | Spies on the commands of players. |
| `/unload` | `basics.unload` | Unloads chunks with no players in them. |

### Administrator commands
By default server configuration, these commands are granted to administrators.
| Usage | Permission(s) | Description |
| ------- | ---------- | ----------- |
| `/assign <player> [rank]` | `basics.assign` | Displays or assigns a player's rank. |