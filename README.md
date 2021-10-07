# Werewolf

Don't let them be the last alive or they will devour your whole team!

## Description

- Special Traitor role
- Goes on a rampage when they are the last Traitor alive
- The Werewolf gets a damage and health increase when activated, but it gets a speed penalty and can no longer get credits.

## Convars

Add the following to your server.cfg (for dedicated servers) or listenserver.cfg (for peer-to-peer servers):

```cpp
ttt_werewolf_enabled              0                   // Used to enable or disable the role
ttt_werewolf_spawn_weight         1                   // The weight assigned for spawning the role
ttt_werewolf_min_players          0                   // The minimum number of player required to spawn the role
ttt_werewolf_starting_health      100                 // The amount of health the role starts each round with
ttt_werewolf_max_health           100                 // The maximum health of the role
ttt_werewolf_starting_credits     1                   // The player's starting credits
ttt_werewolf_damage_bonus         1.0                 // Damage bonus that the werewolf gets when activated (e.g. 1.0 = 100% more damage)
ttt_werewolf_damage_reduction     0.0                 // Damage reduction that the werewolf gets when activated (e.g. 0.5 = 50% less damage)
ttt_werewolf_announce             1                   // If it announces to all players when the werewolf is activated
ttt_werewolf_full_heal            1                   // If the werewolf is fully healed when activated
ttt_werewolf_heal_bonus           2.0                 // Multiplies the werewolf's max health by this amount on activation
ttt_werewolf_speed_penalty        0.5                 // The speed penalty for the activated werewolf (e.g. 0.5 = 50% less speed)
```

## Special Thanks:
- [Noxx](https://steamcommunity.com/id/noxxflame) and [Malivil](https://steamcommunity.com/id/malivil) for all their work on Custom Roles for TTT
- [Idkperson](https://steamcommunity.com/profiles/76561199045384724) for the idea and getting the role started