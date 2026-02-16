{
  services.swaync = {
		enable = true;
		
		settings = {
			positionX = "right";
			positionY = "top";
			layer = "overlay";
			control-center-layer = "top";
			layer-shell = true;
			cssPriority = "user";
			control-center-margin-top = 10;
			control-center-margin-bottom = 10;
			control-center-margin-right = 10;
			control-center-margin-left = 10;
			notification-2fa-action = true;
			notification-inline-replies = false;
			notification-window-width = 400;
			keyboard-shortcuts = true;
			image-visibility = "always";
			transition-time = 200;
			hide-on-clear = true;
			hide-on-action = true;
			script-fail-notify = true;
			
			widgets = [
				"title"
				"dnd"
				"mpris"
				"notifications"
			];
			
			widget-config = {
				title = {
					text = "Уведомления";
					clear-all-button = true;
					button-text = "Очистить все";
				};
				dnd = {
					text = "Не беспокоить";
				};
				mpris = {
					image-size = 96;
					image-radius = 12;
				};
			};
		};
		style = ''
      scale {
        margin: 0 7px;
      }

      scale trough {
        margin: 0rem 1rem;
        min-height: 8px;
        min-width: 70px;
        border-radius: 12.6px;
      }

      trough slider {
        margin: -10px;
        border-radius: 12.6px;
        box-shadow: 0 0 2px rgba(0, 0, 0, 0.8);
        transition: all 0.2s ease;
      }

      trough slider:hover {
        box-shadow:
          0 0 2px @base02
          0 0 8px @base03
          }

      /* notifications */

      .notification-background {
        box-shadow:
          0 0 8px 0 rgba(0, 0, 0, 0.8),
          inset 0 0 0 1px @base02;
        border-radius: 12.6px;
        margin: 18px;
        padding: 0;
      }

      .notification-background .notification {
        padding: 7px;
        border-radius: 12.6px;
      }

      .notification-background .notification.critical {
        box-shadow: inset 0 0 7px 0 $red;
      }

      .notification .notification-content {
        margin: 7px;
      }

      .notification .notification-content overlay {
        /* icons */
        margin: 4px;
      }

      .notification-content .summary {
      }

      .notification-content .time {
      }

      .notification-content .body {
      }

      .notification > *:last-child > * {
        min-height: 3.4em;
      }

      .notification-background .close-button {
        margin: 7px;
        padding: 2px;
        border-radius: 6.3px;
      }

      .notification .notification-action {
        border-radius: 7px;
        box-shadow: inset 0 0 0 1px @base02;
        margin: 4px;
        padding: 8px;
        font-size: 0.2rem; /* controls the button size not text size*/
      }

      .notification progress,
      .notification trough,
      .notification progressbar {
        border-radius: 12.6px;
        padding: 3px 0;
      }
      /* notification group */

      .notification-group {
        background-color: @base02;
        border-radius: 7px;
        opacity: 0.8
      }

      .notification-group.collapsed {
        background: none;
      }
      .notification-group.expanded {
        background: none;
      }

      .notification-group.collapsed .notification-row {
        background: none;
      }
      .notification-group.expanded .notification-row {
        background: none;
      }

      /* control center */

      .control-center {
        box-shadow:
          0 0 8px 0 rgba(0, 0, 0, 0.8),
          inset 0 0 0 1px @base01;
        border-radius: 12.6px;
        padding: 14px;
        background: none;
        background-color: @base00;
        opacity: 0.9;
      }

      .control-center .notification-background {
        border-radius: 7px;
        box-shadow: inset 0 0 0 1px @base02;
        margin: 4px 10px;
      }

      .control-center .notification-background .notification {
        border-radius: 7px;
        background-color: transparent;
      }

      .control-center .notification-background .notification.low {
        opacity: 0.95
      }

      .control-center .widget-title > label {
        font-size: 1.3em;
      }

      .control-center .widget-title button {
        border-radius: 7px;
        box-shadow: inset 0 0 0 1px @base02;
        padding: 8px;
      }

      .control-center .notification-group {
        margin-top: 10px;
      }

      scrollbar slider {
        margin: -3px;
        opacity: 0.8;
      }

      scrollbar trough {
        margin: 2px 0;
      }
      '';
	};
}
