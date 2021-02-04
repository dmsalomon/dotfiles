#!/usr/bin/env python3

from subprocess import Popen, PIPE, DEVNULL, check_output, run
import errno
import shlex
import os
import os.path
import time
import json
from select import select
import multiprocessing
from platform import node
import signal
import sys
import atexit

environment_vars = [
    'PANEL_WM_NAME',
    'PANEL_HEIGHT',
    'PANEL_FONT_SZ',
    'COLOR_DEFAULT_FG',
    'COLOR_DEFAULT_BG',
    'COLOR_MONITOR_FG',
    'COLOR_MONITOR_BG',
    'COLOR_TITLE_FG',
    'COLOR_TITLE_BG',
    'COLOR_SYS_FG',
    'COLOR_SYS_BG',
    'COLOR_FOCUSED_MONITOR_FG',
    'COLOR_FOCUSED_MONITOR_BG',
    'COLOR_FREE_FG',
    'COLOR_FREE_BG',
    'COLOR_FOCUSED_FREE_FG',
    'COLOR_FOCUSED_FREE_BG',
    'COLOR_OCCUPIED_FG',
    'COLOR_OCCUPIED_BG',
    'COLOR_FOCUSED_OCCUPIED_FG',
    'COLOR_FOCUSED_OCCUPIED_BG',
    'COLOR_URGENT_FG',
    'COLOR_URGENT_BG',
    'COLOR_FOCUSED_URGENT_FG',
    'COLOR_FOCUSED_URGENT_BG',
]
for var in environment_vars:
    globals()[var] = os.getenv(var)
PANEL_FONT_SZ = int(PANEL_FONT_SZ)
PANEL_HEIGHT = int(PANEL_HEIGHT)

class ProcManager:
    def __init__(self):
        self.pids = []
        self.rx, self.tx = multiprocessing.Pipe()
        self.proc = multiprocessing.Process(target=self.run)
        self.proc.start()

    def run(self):
        while True:
            pid = self.rx.recv()
            if not pid:
                for pid in self.pids:
                    try:
                        os.kill(pid, signal.SIGTERM)
                    except:
                        pass
                return

            self.pids.append(pid)

    def register(self, pid):
        if isinstance(pid, Popen):
            pid = pid.pid
        self.tx.send(pid)

    def terminate(self):
        self.tx.send(0)

    def __del__(self):
        self.terminate()

class Trayer:
    def __init__(self):
        cmd = f'trayer --edge top --align right --transparent true --SetDockType true --alpha 0 --widthtype request --height {PANEL_HEIGHT-4} --tint {COLOR_DEFAULT_BG.replace("#", "0x")} --expand true'
        args = shlex.split(cmd)
        self.proc = Popen(args, stdout=DEVNULL, stderr=DEVNULL)

        bspwm_root = check_output(shlex.split("xdo id -N Bspwm -n root"))
        bspwm_root = bspwm_root.decode('utf8').split()[0]

        trayid = check_output(shlex.split("xdo id -m -a panel"))
        trayid = trayid.decode('utf8').strip()

        panelid = check_output(shlex.split(f"xdo id -m -a {PANEL_WM_NAME}"))
        panelid = panelid.decode('utf8').strip()

        os.system(f"xdo above -t {bspwm_root} {trayid}")
        os.system(f"xdo above -t {bspwm_root} {panelid}")

    def terminate(self):
        if not self.proc.poll():
            self.proc.kill()
            self.proc.wait()

    def __del__(self):
        self.terminate()

class Lemonbar:
    def __init__(self):
        cmd = f'lemonbar -a 32 -u 2 -n {PANEL_WM_NAME} -g x{PANEL_HEIGHT} -f "Ubuntu Mono:size={PANEL_FONT_SZ}" -f "Symbols Nerd Font:size={PANEL_FONT_SZ}" -f "JoyPixels:size={PANEL_FONT_SZ-2}" -F {COLOR_DEFAULT_FG} -B {COLOR_DEFAULT_BG}'
        args = shlex.split(cmd)
        self.bar = Popen(args, stdin=PIPE, stdout=PIPE, stderr=PIPE)

        def sh_exec(inp):
            while True:
                cmd = inp.readline()
                os.system(cmd)

        self.sh = multiprocessing.Process(target=sh_exec, args=(self.bar.stdout,))
        self.sh.start()

    def update(self, line):
        if self.bar.poll() is not None:
            self.bar.wait()
            cleanup(0)

        try:
            self.bar.stdin.write((line+'\n').encode('utf8'))
            self.bar.stdin.flush()
        except IOError as e:
            if e.errno in (errno.EPIPE, errno.EINVAL):
                self.terminate()
            else:
                raise

    def terminate(self):
        if not self.bar.poll():
            self.bar.kill()
            self.sh.terminate()
            self.bar.wait()

    def __del__(self):
        self.terminate()

# crtitial ordering, bar must be launched first
bar = Lemonbar()
tray = Trayer()
PM = ProcManager()

class Module:
    def __init__(self):
        self.pre = self.post = ""

    def start(self, i):
        self.i = i
        self.rx, self.tx = multiprocessing.Pipe()
        self.process = multiprocessing.Process(target=self.run, args=(self.tx,))
        self.process.start()
        return self.rx

    def terminate(self):
        if self.process.is_alive():
            self.process.terminate()

    def __del__(self):
        self.terminate()

    def status(self):
        entry = self.rx.recv()
        if self.pre:
            entry = f'{self.pre}{entry}'
        if self.post:
            entry = f'{entry}{self.post}'
        return entry

class BspwmState(Module):
    def run(self, out):
        cmd = "bspc subscribe report"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE, stderr=DEVNULL)
        PM.register(proc)

        while True:
            wm = ["%{A4:bspc desktop -f next.local:}%{A5:bspc desktop -f prev.local:} "]
            line = proc.stdout.readline().decode('utf8').strip()
            line = line[1:]
            details = line.split(':')

            for e in details:
                if e[0] in 'mM':
                    if e[0] == 'm':
                        fg = COLOR_MONITOR_FG
                        bg = COLOR_MONITOR_BG
                if e[0] in "fFoOuU":
                    fg = COLOR_DEFAULT_FG
                    bg = COLOR_DEFAULT_BG
                    ul = bg
                    if e[0] == 'f':
                        fg = COLOR_FREE_FG
                        bg = COLOR_FREE_BG
                    elif e[0] == 'F':
                        fg = COLOR_FOCUSED_FREE_FG
                        bg = COLOR_FOCUSED_FREE_BG
                    elif e[0] == 'o':
                        fg = COLOR_OCCUPIED_FG
                        bg = COLOR_OCCUPIED_BG
                    elif e[0] == 'O':
                        fg = COLOR_FOCUSED_OCCUPIED_FG
                        bg = COLOR_FOCUSED_OCCUPIED_BG
                    elif e[0] == 'u':
                        fg = COLOR_URGENT_FG
                        bg = COLOR_URGENT_BG
                    elif e[0] == 'U':
                        fg = COLOR_FOCUSED_URGENT_FG
                        bg = COLOR_FOCUSED_URGENT_BG
                    name = e[1:]
                    wm.append('%{F' + fg + '}%{B' + bg + '}%{U' + ul + '}')
                    wm.append('%{+u}%{A:bspc desktop -f ' + name + ':}' + name + '%{A}%{B-}%{F-}%{-u} ')
            wm.append('%{A}%{A}')
            line = "".join(wm)
            out.send(line)

class Clock(Module):
    def __init__(self):
        super(Clock, self).__init__()
        self.pre = '%{F'+COLOR_SYS_FG+'}%{b'+COLOR_SYS_BG+'} '
        self.post = '%{B-}%{F-}'

    def run(self, out):
        while True:
            out.send(time.strftime(' %a, %b %-d at %I:%M %p'))
            time.sleep(60)

class Battery(Module):
    def __init__(self):
        super(Battery, self).__init__()
        self.post = ' '

    def run(self, out):
        dir = '/sys/class/power_supply/BAT0/'
        status_path = os.path.join(dir, "status")
        capacity_path = os.path.join(dir, "capacity")
        batteries = ''
        if not os.path.isdir(dir):
            return

        cmd = f'inotifywait -t {2*60} "{status_path}" "{capacity_path}"'
        args = shlex.split(cmd)

        while True:
            with open(status_path) as fh:
                status = fh.read().strip()

            with open(capacity_path) as fh:
                capacity = int(fh.read())

            icon = ""
            if status == "Discharging":
                icon = batteries[capacity//10]
            elif status == "Charging":
                icon = ''
            elif status == "Full":
                icon = ''

            if capacity < 15:
                icon = '%{F#ff0000}' + icon + '%{F-}'
            elif capacity < 25:
                icon = '%{F#ffff00}' + icon + '%{F-}'

            out.send(f'{icon}{capacity}%')

            proc = Popen(args, stdout=PIPE, stderr=PIPE)
            proc.wait()

class Brightness(Module):
    def __init__(self):
        super(Brightness, self).__init__()
        self.pre = '%{A4:light -A 5:}%{A5:light -U 5:} '
        self.post = '%%{A}%{A} '

    def run(self, out):
        dir='/sys/class/backlight/intel_backlight'
        if not os.path.isdir(dir):
            return

        with open(os.path.join(dir, 'max_brightness')) as fh:
            max = int(fh.read())

        path = os.path.join(dir, 'brightness')
        cmd = f'inotifywait -t {2*60} "{path}"'
        args = shlex.split(cmd)

        while True:
            with open(path) as fh:
                cur = int(fh.read())
            b = 100 * cur // max
            out.send(str(b))

            proc = Popen(args, stdout=DEVNULL, stderr=DEVNULL)
            proc.wait()

class Media(Module):
    def __init__(self):
        super(Media, self).__init__()
        self.pre = '%{A:mediactl pp:}%{A3:mediactl next:}'
        self.post = '%{A}%{A}'

    def run(self, out):
        cmd = "playerctl -p playerctld metadata -f '{{status}} {{artist}} - {{title}}' -F"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE, stderr=DEVNULL)
        PM.register(proc)

        while True:
            line = proc.stdout.readline().decode('utf8')    \
                .strip()                                    \
                .replace('Playing', '')                    \
                .replace('Paused', '')                     \
                .replace('Stopped', '')
            out.send(line)

class IFace(Module):
    def run(self, out):
        hostname = node()
        exc = ["lo", "docker", "virbr", "vboxnet", "veth", "br"]
        if hostname == "tini":
            exc.append('eno1')

        cmd = "ip -4 -o monitor link address"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE, stderr=PIPE)
        PM.register(proc)

        while True:
            ip_json = check_output(('ip', '-j', 'addr')).decode('utf8')
            j = json.loads(ip_json)

            filtered = filter(lambda i: not any(map(lambda x: i['ifname'].startswith(x), exc)), j)
            ifaces = []

            for iface in filtered:
                ifname = iface['ifname']
                state = iface['operstate'].lower()
                addr = filter(lambda a: a['family'] == 'inet', iface['addr_info'])
                addr = ", ".join(map(lambda a: a['local'], addr))
                ifaces.append((ifname, state, addr))

            entries = []
            for i, (ifname, state, addr) in enumerate(ifaces):
                if state not in ('up', 'down'):
                    state = ""
                ssid = ""
                entry = []
                if ifname.startswith("w"):
                    ssid = check_output(('iwgetid', '--raw', ifname)).decode('utf8').strip()
                    icon = ''
                elif ifname.startswith("e"):
                    icon = ''
                elif ifname.startswith("tun"):
                    icon = ''
                if icon: icon = f'{icon} '
                if state: state = f' {state}'
                if addr: addr = f' {addr}'
                if ssid: ssid = f' {ssid}'
                entry.append(f'{icon}{ifname}{state}{addr}{ssid}')
                entries.append("".join(entry))
            # entries.append('%{F-}%{B-}')
            line = " %{R} ".join(entries) + " %{F-}%{B-}"
            out.send(line)

            # ifaces = map(lambda t: " ".join(t), ifaces)
            # line = " ".join(ifaces)
            # out.send(line)

            rl, _, _ = select([proc.stdout.fileno()], [], [], 3*60)
            if proc.stdout.fileno() in rl:
                _ = proc.stdout.read1()

class Volume(Module):
    def __init__(self):
        super(Volume, self).__init__()
        self.pre = '%{A:mediactl toggle:}%{A3:patoggle:}'
        self.post = '%{A}%{A}'

    def run(self, out):
        last = ""
        proc = Popen(('pulsemon'), stdout=PIPE)
        PM.register(proc)

        while True:
            line = proc.stdout.readline().decode('utf8').strip()
            if line == last:
                continue
            last = line
            card, vol, mute = line.split()

            if 'JDS_Labs_Element' in card:
                card = ''
            else:
                card = ''

            if mute == "muted":
                mute = ''
            else:
                mute = ''

            out.send(f'{mute} {vol} {card}')

class TrayOffset(Module):
    def __init__(self):
        super(TrayOffset, self).__init__()
        self.pre = "%{O"
        self.post = "} "

    def run(self, out):
        os.system("xdo id -m -a panel >/dev/null 2>&1")

        cmd = "xprop -name panel -f WM_SIZE_HINTS 32i ' $5\n' -spy WM_NORMAL_HINTS"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE)
        PM.register(proc)

        while True:
            line = proc.stdout.readline().decode('utf8').strip()
            line = line.removeprefix('WM_NORMAL_HINTS(WM_SIZE_HINTS) ')
            out.send(line)

class XTitle(Module):
    def __init__(self):
        super(XTitle, self).__init__()
        self.pre = '%{F'+COLOR_TITLE_FG+'}%{B' +COLOR_TITLE_BG+'} '
        self.post = ' %{B-}%{F-}'

    def run(self, out):
        cmd = "xtitle -sf '%s\n'"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE)
        PM.register(proc)

        while True:
            line = proc.stdout.readline().decode('utf8').strip()
            out.send(line)

line_format = ["%{l}", BspwmState(), Battery(), Brightness(), '%{A4:mediactl +5:}%{A5:mediactl -5:}', Volume(), " ", Media(), '%{A}%{A}', "%{c}", XTitle(), "%{r}", IFace(), Clock(), TrayOffset()]
modules = []
status_line = [None] * len(line_format)

for i, mod in enumerate(line_format):
    if isinstance(mod, str):
        status_line[i] = mod
    else:
        status_line[i] = ""
        modules.append(mod)
        mod.start(i)

def main():
    i = 0
    while True:
        rlist = [m.rx.fileno() for m in modules]
        rl, _, _ = select(rlist, [], [])

        if len(rl) == 0:
            continue

        for m in modules:
            if m.rx.fileno() in rl:
                status_line[m.i] = m.status()

        line = "".join(status_line)
        bar.update(line)

def cleanup(sig, *args):
    tray.terminate()
    bar.terminate()
    for mod in modules:
        mod.terminate()
    PM.terminate()
    sys.exit(128 + sig)

atexit.register(cleanup, 0)

for sig in (signal.SIGTERM, signal.SIGINT):
    signal.signal(sig, cleanup)

try:
    main()
except KeyboardInterrupt:
    pass
