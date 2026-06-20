{ config, pkgs, ... }:

let
  serverDir = "/var/lib/minecraft/hbm_1.7.10";
  rconPassword = "AHAHAHAH_SOSAL?!";
  authProxyPort = 8901;
  containerWhitelist = "/var/lib/nixos-containers/minecraft-server${serverDir}/whitelist.json";

  # Whitelist helper: fetches UUID from a specific auth provider and writes
  # it directly to whitelist.json, then reloads via mcrcon.
  # Usage: mc-wl [--ely|--mojang] <NickName>
  mcWlScript = pkgs.writeScript "mc-wl" ''
    #!${pkgs.python3}/bin/python3
    import sys, json, urllib.request, subprocess

    WHITELIST = "${containerWhitelist}"
    RCON_PASS = "${rconPassword}"

    ELY_URL    = "https://account.ely.by/api/authlib-injector/api/profiles/minecraft"
    MOJANG_URL = "https://api.mojang.com/profiles/minecraft"

    def fmt_uuid(u):
        return f"{u[:8]}-{u[8:12]}-{u[12:16]}-{u[16:20]}-{u[20:]}"

    def lookup(url, nick):
        try:
            req = urllib.request.Request(
                url, data=json.dumps([nick]).encode(),
                headers={"Content-Type": "application/json"}, method="POST")
            r = urllib.request.urlopen(req, timeout=5)
            data = json.loads(r.read())
            if data:
                return data[0]["id"], data[0]["name"]
        except Exception:
            pass
        return None, None

    provider, nick = "auto", None
    for arg in sys.argv[1:]:
        if arg == "--ely":    provider = "ely"
        elif arg == "--mojang": provider = "mojang"
        else: nick = arg

    if not nick:
        print("Usage: mc-wl [--ely|--mojang] <NickName>")
        sys.exit(1)

    uid = name = found_on = None

    if provider in ("ely", "auto"):
        uid, name = lookup(ELY_URL, nick)
        if uid: found_on = "Ely.by"

    if not uid and provider in ("mojang", "auto"):
        uid, name = lookup(MOJANG_URL, nick)
        if uid: found_on = "Mojang"

    if not uid:
        src = "Ely.by or Mojang" if provider == "auto" else provider
        print(f"Not found on {src}: {nick}")
        sys.exit(1)

    formatted = fmt_uuid(uid)

    with open(WHITELIST) as f:
        wl = json.load(f)

    if any(e["uuid"] == formatted for e in wl):
        print(f"{name} already whitelisted ({found_on}, {formatted})")
        sys.exit(0)

    wl.append({"uuid": formatted, "name": name})
    with open(WHITELIST, "w") as f:
        json.dump(wl, f, indent=2)

    print(f"Added {name}  [{found_on}]  {formatted}")

    subprocess.run([
        "nixos-container", "run", "minecraft-server", "--",
        "mcrcon", "-H", "127.0.0.1", "-P", "25575", "-p", RCON_PASS,
        "whitelist reload"
    ], capture_output=True)
    print("Whitelist reloaded.")
  '';

  # Dual-auth proxy: tries Ely.by first, falls back to Mojang.
  # Implements the minimal Yggdrasil session API that authlib-injector needs.
  dualAuthProxy = pkgs.writeText "mc-dual-auth-proxy.py" ''
    #!/usr/bin/env python3
    import http.server, urllib.request, urllib.error, json

    PORT = ${toString authProxyPort}
    ELY_BASE       = "https://account.ely.by/api/authlib-injector"
    MOJANG_SESSION = "https://sessionserver.mojang.com"
    MOJANG_API     = "https://api.mojang.com"

    class Handler(http.server.BaseHTTPRequestHandler):

        # ── GET ────────────────────────────────────────────────────────────

        def do_GET(self):
            if self.path in ("/", ""):
                self._proxy_get(ELY_BASE + "/")
            elif self.path.startswith("/sessionserver/session/minecraft/hasJoined"):
                self._dual_has_joined()
            elif self.path.startswith("/sessionserver/"):
                self._proxy_get(ELY_BASE + self.path)
            elif self.path.startswith("/api/"):
                self._proxy_get(ELY_BASE + self.path)
            else:
                self.send_response(404); self.end_headers()

        # ── POST ───────────────────────────────────────────────────────────

        def do_POST(self):
            # /whitelist add uses POST /api/profiles/minecraft to resolve name→UUID.
            # We merge results from both providers so both Ely.by and Mojang
            # players can be added to the whitelist with a simple command.
            if self.path == "/api/profiles/minecraft":
                self._dual_profiles()
            else:
                body = self._read_body()
                self._proxy_post(ELY_BASE + self.path, body)

        # ── Auth helpers ───────────────────────────────────────────────────

        def _dual_has_joined(self):
            # 1. Try Ely.by
            status, body, ct = self._get(ELY_BASE + self.path)
            if status == 200:
                return self._respond(200, body, ct)
            # 2. Fall back to Mojang
            status, body, ct = self._get(MOJANG_SESSION + self.path)
            if status == 200:
                return self._respond(200, body, ct)
            # Both failed → auth denied
            self.send_response(204); self.end_headers()

        def _dual_profiles(self):
            # Query both providers, merge by lowercased name (Ely.by wins on conflict)
            body = self._read_body()
            ely    = self._post_json(ELY_BASE + "/api/profiles/minecraft", body) or []
            mojang = self._post_json(MOJANG_API + "/profiles/minecraft",   body) or []
            merged = {p["name"].lower(): p for p in mojang}
            merged.update({p["name"].lower(): p for p in ely})
            result = json.dumps(list(merged.values())).encode()
            self._respond(200, result, "application/json")

        # ── Low-level helpers ──────────────────────────────────────────────

        def _read_body(self):
            length = int(self.headers.get("Content-Length", 0))
            return self.rfile.read(length) if length else b""

        def _get(self, url):
            try:
                r = urllib.request.urlopen(url, timeout=5)
                return r.status, r.read(), r.headers.get("Content-Type", "application/json")
            except urllib.error.HTTPError as e:
                return e.code, b"", "application/json"
            except Exception:
                return 503, b"", "application/json"

        def _proxy_get(self, url):
            status, body, ct = self._get(url)
            self._respond(status, body, ct)

        def _post_json(self, url, body):
            try:
                req = urllib.request.Request(url, data=body,
                      headers={"Content-Type": "application/json"}, method="POST")
                r = urllib.request.urlopen(req, timeout=5)
                return json.loads(r.read())
            except Exception:
                return None

        def _proxy_post(self, url, body):
            result = self._post_json(url, body)
            data = json.dumps(result or []).encode()
            self._respond(200, data, "application/json")

        def _respond(self, status, body, ct):
            self.send_response(status)
            self.send_header("Content-Type", ct)
            self.end_headers()
            self.wfile.write(body)

        def log_message(self, fmt, *args):
            print(f"[mc-auth] {self.address_string()} {fmt % args}", flush=True)

    http.server.HTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
  '';
in
{
  # Fish aliases + functions — only meaningful when this module is imported
  programs.fish.shellAliases = {
    mc-console = "sudo nixos-container run minecraft-server -- mcrcon -p '${rconPassword}' -t";
    mc-log     = "TERM=xterm-256color sudo nixos-container run minecraft-server -- journalctl -u minecraft-server -f -n 100";
  };

  # mc-wl NickName          — auto (Ely.by first, Mojang fallback)
  # mc-wl --ely NickName    — force Ely.by UUID
  # mc-wl --mojang NickName — force Mojang UUID
  #
  # Bypasses the proxy and writes UUID directly to whitelist.json,
  # then reloads whitelist via mcrcon — so the chosen provider wins.
  programs.fish.interactiveShellInit = ''
    function mc-wl
      sudo ${mcWlScript} $argv
    end
  '';

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 24454 ];
  };

  containers.minecraft-server = {
    autoStart = true;

    forwardPorts = [
      { protocol = "tcp"; hostPort = 25565; containerPort = 25565; }
      { protocol = "udp"; hostPort = 24454; containerPort = 24454; }
    ];

    config = { config, pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

      environment.systemPackages = [ pkgs.mcrcon ];

      users.users.minecraft = {
        isSystemUser = true;
        group = "minecraft";
        home = "/var/lib/minecraft";
        createHome = true;
      };
      users.groups.minecraft = {};

      networking.firewall = {
        allowedTCPPorts = [ 25565 ];
        allowedUDPPorts = [ 24454 ];
      };

      systemd.services.mc-auth-proxy = {
        description = "Minecraft dual-auth proxy (Ely.by → Mojang fallback)";
        wantedBy = [ "multi-user.target" ];
        before = [ "minecraft-server.service" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.python3}/bin/python3 ${dualAuthProxy}";
          Restart = "on-failure";
          RestartSec = "3s";
        };
      };

      systemd.services.minecraft-server = {
        description = "Minecraft HBM Server (Forge 1.7.10)";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "mc-auth-proxy.service" ];
        requires = [ "mc-auth-proxy.service" ];

        serviceConfig = {
          Type = "simple";
          User = "minecraft";
          Group = "minecraft";
          WorkingDirectory = serverDir;

          ExecStart = ''
            ${pkgs.zulu8}/bin/java \
              -Xms8G -Xmx10G \
              -XX:+UseG1GC \
              -XX:MaxGCPauseMillis=50 \
              -javaagent:authlib-injector.jar=http://localhost:${toString authProxyPort} \
              -jar forge-1.7.10-universal.jar nogui
          '';

          Restart = "always";
          TimeoutStopSec = "60";
        };
      };

      systemd.services.minecraft-backup = {
        description = "Minecraft World Backup";
        serviceConfig = {
          Type = "oneshot";
          User = "minecraft";
          Group = "minecraft";
        };
        script = ''
          BACKUP_DIR="${serverDir}/backups"
          mkdir -p "$BACKUP_DIR"
          DATE=$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)
          echo "Starting backup..."
          ${pkgs.gnutar}/bin/tar -czf "$BACKUP_DIR/world_$DATE.tar.gz" -C "${serverDir}" world
          echo "Backup created: world_$DATE.tar.gz"
          ${pkgs.findutils}/bin/find "$BACKUP_DIR" -name "world_*.tar.gz" -mtime +7 -delete
          echo "Old backups cleaned up."
        '';
      };

      systemd.timers.minecraft-backup = {
        description = "Timer for Minecraft World Backup";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "04:00:00";
          Persistent = true;
        };
      };
    };
  };
}
