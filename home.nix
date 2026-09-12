{ pkgs, lib, ... }:

let
  terminal = "terminator";
  fileManager = "doublecmd";
  menu = "rofi -show drun";
  browser = "librewolf";

  mainMod = "SUPER";
in
{
  home.username = "gergo";
  home.homeDirectory = "/home/gergo";

  home.stateVersion = "26.05";

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      hl.bind("${mainMod} + Q", hl.dsp.exec_cmd("${terminal}"))
      hl.bind("${mainMod} + C", hl.dsp.window.close())
      hl.bind("${mainMod} + M", hl.dsp.exec_cmd("uwsm stop"))
      hl.bind("${mainMod} + SHIFT + M", hl.dsp.exec_cmd("shutdown now"))
      hl.bind("${mainMod} + E", hl.dsp.exec_cmd("${fileManager}"))
      hl.bind("${mainMod} + V", hl.dsp.window.float())
      hl.bind("${mainMod} + R", hl.dsp.exec_cmd("${menu}"))
      hl.bind("${mainMod} + J", hl.dsp.layout("togglesplit"))
      hl.bind("${mainMod} + L", hl.dsp.exec_cmd("hyprlock"))
      hl.bind("${mainMod} + B", hl.dsp.exec_cmd("${browser}"))
      hl.bind("${mainMod} + N", hl.dsp.exec_cmd("swaync-client -t"))
      hl.bind("${mainMod} + F", hl.dsp.window.fullscreen())
      hl.bind(
        "${mainMod} + SHIFT + C",
        hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy")
      )

      -- Group
      hl.bind("${mainMod} + G", hl.dsp.group.toggle())

      -- Move focus
      hl.bind("${mainMod} + LEFT", hl.dsp.focus({ direction = "l" }))
      hl.bind("${mainMod} + RIGHT", hl.dsp.focus({ direction = "r" }))
      hl.bind("${mainMod} + UP", hl.dsp.focus({ direction = "u" }))
      hl.bind("${mainMod} + DOWN", hl.dsp.focus({ direction = "d" }))

      -- Switch workspaces
      hl.bind("${mainMod} + 1", hl.dsp.focus({ workspace = "1" }))
      hl.bind("${mainMod} + 2", hl.dsp.focus({ workspace = "2" }))
      hl.bind("${mainMod} + 3", hl.dsp.focus({ workspace = "3" }))
      hl.bind("${mainMod} + 4", hl.dsp.focus({ workspace = "4" }))
      hl.bind("${mainMod} + 5", hl.dsp.focus({ workspace = "5" }))
      hl.bind("${mainMod} + 6", hl.dsp.focus({ workspace = "6" }))
      hl.bind("${mainMod} + 7", hl.dsp.focus({ workspace = "7" }))
      hl.bind("${mainMod} + 8", hl.dsp.focus({ workspace = "8" }))
      hl.bind("${mainMod} + 9", hl.dsp.focus({ workspace = "9" }))
      hl.bind("${mainMod} + 0", hl.dsp.focus({ workspace = "10" }))
    
      -- Move active window to a workspace
      hl.bind("${mainMod} + SHIFT + 1",
        hl.dsp.window.move({ workspace = "1" }))
      hl.bind("${mainMod} + SHIFT + 2",
        hl.dsp.window.move({ workspace = "2" }))
      hl.bind("${mainMod} + SHIFT + 3",
        hl.dsp.window.move({ workspace = "3" }))
      hl.bind("${mainMod} + SHIFT + 4",
        hl.dsp.window.move({ workspace = "4" }))
      hl.bind("${mainMod} + SHIFT + 5",
        hl.dsp.window.move({ workspace = "5" }))
      hl.bind("${mainMod} + SHIFT + 6",
        hl.dsp.window.move({ workspace = "6" }))
      hl.bind("${mainMod} + SHIFT + 7",
        hl.dsp.window.move({ workspace = "7" }))
      hl.bind("${mainMod} + SHIFT + 8",
        hl.dsp.window.move({ workspace = "8" }))
      hl.bind("${mainMod} + SHIFT + 9",
        hl.dsp.window.move({ workspace = "9" }))
      hl.bind("${mainMod} + SHIFT + 0",
        hl.dsp.window.move({ workspace = "10" }))

      -- Move/resize windows with mainMod + LMB/RMB and dragging
      hl.bind("${mainMod} + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("${mainMod} + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Volume
      hl.bind(
        "XF86AudioRaiseVolume",
        hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
        { repeating = true }
      )
    
      hl.bind(
        "XF86AudioLowerVolume",
        hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        { repeating = true }
      )
    
      hl.bind(
        "XF86AudioMute",
        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        { repeating = true }
      )
    
      hl.bind(
        "XF86AudioMicMute",
        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
        { repeating = true }
      )
    
      -- Media keys
      hl.bind(
        "XF86AudioNext",
        hl.dsp.exec_cmd("playerctl next"),
        { locked = true }
      )
    
      hl.bind(
        "XF86AudioPause",
        hl.dsp.exec_cmd("playerctl play-pause"),
        { locked = true }
      )
    
      hl.bind(
        "XF86AudioPlay",
        hl.dsp.exec_cmd("playerctl play-pause"),
        { locked = true }
      )
    
      hl.bind(
        "XF86AudioPrev",
        hl.dsp.exec_cmd("playerctl previous"),
        { locked = true }
      )



      -- Ignore maximize requests from apps
      hl.window_rule({
        match = { class = ".*" },
        suppress_event = "maximize",
      })
    
      -- Fix some dragging issues with XWayland
      hl.window_rule({
        name = "fix-xwayland-drags",
        match = {
          class = "^$",
          title = "^$",
          xwayland = true,
          float = true,
          fullscreen = false,
          pin = false,
        },
        no_focus = true,
      })
    
      -- Force Vesktop to open on monitor 1 and workspace 10
      hl.window_rule({
        match = { class = "vesktop" },
        monitor = "1",
        workspace = "10",
        no_initial_focus = true,
      })
    
      -- XWayland
      hl.config({
        xwayland = {
          force_zero_scaling = true,
        },
      })
    '';

    settings = {
      monitor = [
        {
          output = "desc:Samsung Electric Company S24R35A H4TT800193";
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
        }
      
        {
          output = "desc:Acer Technologies V226HQL LY7EE05185QL";
          mode = "1920x1080@60";
          position = "-1920x0";
          scale = 1;
        }
      ];

      config = {
        general = {
          allow_tearing = false;
        };

        dwindle = {
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        input = {
          kb_layout = "hu";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
    
          follow_mouse = 1;
          sensitivity = 0;
    
          touchpad = {
            natural_scroll = false;
          };
        };
      };
    };
  };

  xdg.configFile = {
    "uwsm/env".text = ''
      export XCURSOR_SIZE=24
      export QT_QPA_PLATFORMTHEME=qt5ct
    '';

    "uwsm/env-hyprland".text = ''
      export HYPRCURSOR_SIZE=24
    '';
  };

  xdg.configFile."autostart/vesktop.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Vesktop
    Exec=${pkgs.vesktop}/bin/vesktop
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';

  xdg.configFile."autostart/qbittorrent.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=qBittorrent
    Exec=${pkgs.qbittorrent}/bin/qbittorrent
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';

  systemd.user.services = {

    hyprpolkitagent = {
      Unit = {
        Description = "Hyprland Polkit authentication agent";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe pkgs.hyprpolkitagent;
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };


    waybar = {
      Unit = {
        Description = "Waybar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe pkgs.waybar;
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };


    hyprpaper = {
      Unit = {
        Description = "Hyprpaper";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe pkgs.hyprpaper;
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };


    swaync = {
      Unit = {
        Description = "Sway Notification Center";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe pkgs.swaynotificationcenter;
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };


    cliphist-text = {
      Unit = {
        Description = "Clipboard history text watcher";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart =
          "${lib.getExe' pkgs.wl-clipboard "wl-copy"} --type text --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "on-failure";
        RestartSec = 1;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };


    cliphist-image = {
      Unit = {
        Description = "Clipboard history image watcher";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart =
          "${lib.getExe' pkgs.wl-clipboard "wl-copy"} --type image --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "on-failure";
        RestartSec = 1;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    usbguard-notifier = {
      Unit = {
        Description = "USBGuard notifier";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
    
      Service = {
        ExecStart = lib.getExe pkgs.usbguard-notifier;
        Restart = "on-failure";
        RestartSec = 2;
      };
    
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}
