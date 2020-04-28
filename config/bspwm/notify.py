#!/usr/bin/env python3

from gi.repository import GLib
import gi

gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl

manager = Playerctl.PlayerManager()

def notify(player):
    metadata = player.props.metadata
    keys = metadata.keys()

    artist = None
    if 'xesam:artist' in keys:
        artist = metadata['xesam:artist'][0]

    title = None
    if 'xesam:title' in keys:
        title = metadata['xesam:title']

    status = player.props.status

    if artist:
        print(f'{status} {artist} - {title}', flush=True)
    elif title:
        print(f'{status} {title}', flush=True)
    else:
        print(flush=True)

def on_play(player, status, manager):
    notify(player)

def on_metadata(player, metadata, manager):
    notify(player)

def init_player(name):
    player = Playerctl.Player.new_from_name(name)
    player.connect('playback-status::playing', on_play, manager)
    player.connect('playback-status::paused', on_play, manager)
    player.connect('playback-status::stopped', on_play, manager)
    player.connect('metadata', on_metadata, manager)
    manager.manage_player(player)
    if name.name == 'playerctld':
        notify(player)

def on_name_appeared(manager, name):
    init_player(name)

manager.connect('name-appeared', on_name_appeared)

for name in manager.props.player_names:
    init_player(name)

main = GLib.MainLoop()
main.run()
