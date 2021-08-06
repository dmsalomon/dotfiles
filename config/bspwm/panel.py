#!/usr/bin/env python3

from subprocess import Popen, PIPE, DEVNULL, check_output, run
import errno
import shlex
import os
import os.path
import time
from datetime import datetime
import json
from select import select
import multiprocessing
import threading
import queue
from platform import node
import signal
import sys
import atexit
import requests

environment_vars = [
    "PANEL_WM_NAME",
    "PANEL_HEIGHT",
    "PANEL_FONT_SZ",
    "COLOR_DEFAULT_FG",
    "COLOR_DEFAULT_BG",
    "COLOR_MONITOR_FG",
    "COLOR_MONITOR_BG",
    "COLOR_TITLE_FG",
    "COLOR_TITLE_BG",
    "COLOR_SYS_FG",
    "COLOR_SYS_BG",
    "COLOR_FOCUSED_MONITOR_FG",
    "COLOR_FOCUSED_MONITOR_BG",
    "COLOR_FREE_FG",
    "COLOR_FREE_BG",
    "COLOR_FOCUSED_FREE_FG",
    "COLOR_FOCUSED_FREE_BG",
    "COLOR_OCCUPIED_FG",
    "COLOR_OCCUPIED_BG",
    "COLOR_FOCUSED_OCCUPIED_FG",
    "COLOR_FOCUSED_OCCUPIED_BG",
    "COLOR_URGENT_FG",
    "COLOR_URGENT_BG",
    "COLOR_FOCUSED_URGENT_FG",
    "COLOR_FOCUSED_URGENT_BG",
]
for var in environment_vars:
    globals()[var] = os.getenv(var)
PANEL_FONT_SZ = int(PANEL_FONT_SZ)
PANEL_HEIGHT = int(PANEL_HEIGHT)

msgs = queue.Queue()


class Trayer:
    def __init__(self):
        cmd = f'trayer --edge top --align right --transparent true --SetDockType true --alpha 0 --widthtype request --height {PANEL_HEIGHT-4} --tint {COLOR_DEFAULT_BG.replace("#", "0x")} --expand true'
        args = shlex.split(cmd)
        self.proc = Popen(args, stdout=DEVNULL, stderr=DEVNULL)

        bspwm_root = check_output(shlex.split("xdo id -N Bspwm -n root"))
        bspwm_root = bspwm_root.decode("utf8").split()[0]

        trayid = check_output(shlex.split("xdo id -m -a panel"))
        trayid = trayid.decode("utf8").strip()

        panelid = check_output(shlex.split(f"xdo id -m -a {PANEL_WM_NAME}"))
        panelid = panelid.decode("utf8").strip()

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
            self.bar.stdin.write((line + "\n").encode("utf8"))
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


class Module:
    def __init__(self):
        self.pre = self.post = ""
        self.proc = []

    def start(self, i):
        self.i = i
        self.thread = threading.Thread(target=self.run, args=(), daemon=True)
        self.thread.start()
        return self.thread

    def terminate(self):
        def term(p):
            p.kill()
            p.wait()

        if hasattr(self, "proc"):
            proc = getattr(self, "proc")
            if isinstance(proc, list):
                for p in proc:
                    term(p)
            else:
                term(proc)

    def __del__(self):
        self.terminate()

    def status(self, line):
        entries = []
        if self.pre:
            entries.append(self.pre)
        entries.append(line)
        if self.post:
            entries.append(self.post)
        return "".join(entries)

    def run(self):
        return

    def update(self, line):
        msgs.put((self, line))


class BspwmState(Module):
    def __init__(self):
        super(BspwmState, self).__init__()
        self.pre = "%{A4:bspc desktop -f next.local:}%{A5:bspc desktop -f prev.local:} "
        self.post = "%{A}%{A}"

    def run(self):
        cmd = "bspc subscribe report"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE, stderr=DEVNULL)
        self.proc = proc

        while True:
            wm = []
            line = proc.stdout.readline().decode("utf8").strip()
            line = line[1:]
            details = line.split(":")

            for e in details:
                if not e:
                    continue
                if e[0] in "mM":
                    if e[0] == "m":
                        fg = COLOR_MONITOR_FG
                        bg = COLOR_MONITOR_BG
                if e[0] in "fFoOuU":
                    fg = COLOR_DEFAULT_FG
                    bg = COLOR_DEFAULT_BG
                    ul = bg
                    if e[0] == "f":
                        fg = COLOR_FREE_FG
                        bg = COLOR_FREE_BG
                    elif e[0] == "F":
                        fg = COLOR_FOCUSED_FREE_FG
                        bg = COLOR_FOCUSED_FREE_BG
                    elif e[0] == "o":
                        fg = COLOR_OCCUPIED_FG
                        bg = COLOR_OCCUPIED_BG
                    elif e[0] == "O":
                        fg = COLOR_FOCUSED_OCCUPIED_FG
                        bg = COLOR_FOCUSED_OCCUPIED_BG
                    elif e[0] == "u":
                        fg = COLOR_URGENT_FG
                        bg = COLOR_URGENT_BG
                    elif e[0] == "U":
                        fg = COLOR_FOCUSED_URGENT_FG
                        bg = COLOR_FOCUSED_URGENT_BG
                    name = e[1:]
                    wm.append("%{F" + fg + "}%{B" + bg + "}%{U" + ul + "}")
                    wm.append(
                        "%{+u}%{A:bspc desktop -f "
                        + name
                        + ":}"
                        + name
                        + "%{A}%{B-}%{F-}%{-u} "
                    )
            line = "".join(wm)
            self.update(line)


class Clock(Module):
    def __init__(self):
        super(Clock, self).__init__()
        self.pre = "%{F" + COLOR_SYS_FG + "}%{b" + COLOR_SYS_BG + "} "
        self.post = "%{B-}%{F-}"

    def run(self):
        while True:
            self.update(time.strftime(" %a, %b %-d at %I:%M %p"))
            now = datetime.now()
            snooze = 60 - now.second - now.microsecond / 1e6
            if snooze > 0:
                time.sleep(snooze)


class Battery(Module):
    def __init__(self):
        super(Battery, self).__init__()
        self.post = " "

    def run(self):
        dir = "/sys/class/power_supply/BAT0/"
        status_path = os.path.join(dir, "status")
        capacity_path = os.path.join(dir, "capacity")
        batteries = ""
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
                icon = batteries[capacity // 10]
            elif status == "Charging":
                icon = ""
            elif status == "Full":
                icon = ""

            if capacity < 15:
                icon = "%{F#ff0000}" + icon + "%{F-}"
            elif capacity < 25:
                icon = "%{F#ffff00}" + icon + "%{F-}"

            self.update(f"{icon}{capacity}%")

            proc = Popen(args, stdout=PIPE, stderr=PIPE)
            self.proc = proc
            proc.wait()


class Brightness(Module):
    def __init__(self):
        super(Brightness, self).__init__()
        self.pre = "%{A4:light -A 5:}%{A5:light -U 5:} "
        self.post = "%%{A}%{A} "

    def run(self):
        dir = "/sys/class/backlight/intel_backlight"
        if not os.path.isdir(dir):
            return

        with open(os.path.join(dir, "max_brightness")) as fh:
            max = int(fh.read())

        path = os.path.join(dir, "brightness")
        cmd = f'inotifywait -t {2*60} "{path}"'
        args = shlex.split(cmd)

        while True:
            with open(path) as fh:
                cur = int(fh.read())
            b = 100 * cur // max
            self.update(str(b))

            proc = Popen(args, stdout=DEVNULL, stderr=DEVNULL)
            self.proc = proc
            proc.wait()


class Media(Module):
    def __init__(self):
        super(Media, self).__init__()
        self.pre = "%{A:mediactl pp:}%{A3:mediactl next:}"
        self.post = "%{A}%{A}"

    def run(self):
        cmd = (
            "playerctl -p playerctld metadata -f '{{status}} {{artist}} - {{title}}' -F"
        )
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE, stderr=DEVNULL)
        self.proc = proc

        while True:
            line = (
                proc.stdout.readline()
                .decode("utf8")
                .strip()
                .replace("Playing", "")
                .replace("Paused", "")
                .replace("Stopped", "")
            )
            self.update(line)


class PublicIP(Module):
    def __init__(self):
        super(PublicIP, self).__init__()
        self.pre = "%{R}  "
        self.post = " %{F-}%{B-} "

    def run(self):
        cmd = "ip -4 -o monitor link address"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE, stderr=PIPE)
        self.proc = proc

        def await_internet():
            while os.system("ping -q -c1 1.1.1.1 >/dev/null 2>&1") != 0:
                time.sleep(3)

        while True:
            await_internet()
            resp = requests.get("https://ip.me")
            if not resp.ok:
                time.sleep(2 * 60)
                continue

            ip = resp.text.strip()
            self.update(ip)

            time.sleep(1.5)
            rl, _, _ = select([proc.stdout.fileno()], [], [], 2 * 60 * 60)
            if proc.stdout.fileno() in rl:
                _ = proc.stdout.read1()


class IFace(Module):
    def run(self):
        hostname = node()
        exc = ["lo", "docker", "virbr", "vboxnet", "veth", "br"]
        if hostname == "tini":
            exc.append("eno1")

        cmd = "ip -4 -o monitor link address"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE, stderr=PIPE)
        self.proc = proc

        while True:
            ip_json = check_output(("ip", "-j", "addr")).decode("utf8")
            j = json.loads(ip_json)

            filtered = filter(
                lambda i: not any(map(lambda x: i["ifname"].startswith(x), exc)), j
            )
            ifaces = []

            for iface in filtered:
                ifname = iface["ifname"]
                state = iface["operstate"].lower()
                addr = filter(lambda a: a["family"] == "inet", iface["addr_info"])
                addr = ", ".join(map(lambda a: a["local"], addr))
                ifaces.append((ifname, state, addr))

            entries = []
            for i, (ifname, state, addr) in enumerate(ifaces):
                if state not in ("up", "down"):
                    state = ""
                ssid = ""
                icon = ""
                if ifname.startswith("w"):
                    ssid = (
                        check_output(("iwgetid", "--raw", ifname))
                        .decode("utf8")
                        .strip()
                    )
                    icon = ""
                elif ifname.startswith("e"):
                    icon = ""
                elif ifname.startswith("tun"):
                    icon = ""
                if icon:
                    icon = f"{icon} "
                if state:
                    state = f" {state}"
                if addr:
                    addr = f" {addr}"
                if ssid:
                    ssid = f" {ssid}"
                entry = "".join(
                    (
                        icon,
                        ifname,
                        state,
                        addr,
                        ssid,
                    )
                )
                entries.append(entry)
            line = " %{R} ".join(entries) + " %{F-}%{B-}"
            self.update(line)

            rl, _, _ = select([proc.stdout.fileno()], [], [], 3 * 60)
            if proc.stdout.fileno() in rl:
                _ = proc.stdout.read1()


class Volume(Module):
    def __init__(self):
        super(Volume, self).__init__()
        self.pre = "%{A:mediactl toggle:}%{A3:patoggle:}"
        self.post = "%{A}%{A}"

    def run(self):
        last = ""
        proc = Popen(("pulsemon"), stdout=PIPE)
        self.proc = proc

        while True:
            line = proc.stdout.readline().decode("utf8").strip()
            if line == last:
                continue
            last = line
            card, vol, mute = line.split()

            if "JDS_Labs_Element" in card:
                card = ""
            else:
                card = ""

            if mute == "muted":
                mute = ""
            else:
                mute = ""

            self.update(f"{mute} {vol} {card}")


class TrayOffset(Module):
    def __init__(self):
        super(TrayOffset, self).__init__()
        self.pre = "%{O"
        self.post = "} "

    def run(self):
        os.system("xdo id -m -a panel >/dev/null 2>&1")

        cmd = "xprop -name panel -f WM_SIZE_HINTS 32i ' $5\n' -spy WM_NORMAL_HINTS"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE)
        self.proc = proc

        while True:
            line = proc.stdout.readline().decode("utf8").strip()
            line = line.removeprefix("WM_NORMAL_HINTS(WM_SIZE_HINTS) ")
            self.update(line)


class XTitle(Module):
    def __init__(self):
        super(XTitle, self).__init__()
        self.pre = "%{F" + COLOR_TITLE_FG + "}%{B" + COLOR_TITLE_BG + "} "
        self.post = " %{B-}%{F-}"

    def run(self):
        cmd = "xtitle -sf '%s\n'"
        args = shlex.split(cmd)
        proc = Popen(args, stdout=PIPE)
        self.proc = proc

        while True:
            line = proc.stdout.readline().decode("utf8").strip()
            self.update(line)


line_format = [
    "%{l}",
    BspwmState(),
    Battery(),
    Brightness(),
    "%{A4:mediactl +5:}%{A5:mediactl -5:}",
    Volume(),
    " ",
    Media(),
    "%{A}%{A}",
    "%{c}",
    XTitle(),
    "%{r}",
    PublicIP(),
    IFace(),
    Clock(),
    TrayOffset(),
]
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
        m, line = msgs.get()

        status_line[m.i] = m.status(line)
        line = "".join(status_line)
        bar.update(line)


def cleanup(sig, *args):
    tray.terminate()
    bar.terminate()
    for mod in modules:
        mod.terminate()
    sys.exit(128 + sig)


for sig in (signal.SIGTERM, signal.SIGINT):
    signal.signal(sig, cleanup)

try:
    main()
    cleanup()
except KeyboardInterrupt:
    cleanup()
