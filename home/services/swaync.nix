{
	services.swaync = {
		enable = true;
		
		# Конфигурация интерфейса (JSON)
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
			
			# Структура виджетов в панели
			widgets = [
				"title"
				"dnd"
				"mpris"          # Управление музыкой
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
			@define-color bg #1e1e2e;
			@define-color text #cdd6f4;
			@define-color surface #313244;
			@define-color overlay #45475a;
			@define-color blue #89b4fa;
			@define-color red #f38ba8;
			@define-color green #a6e3a1;
			@define-color yellow #f9e2af;
			@define-color mauve #cba6f7;
			
			.notification-row {
				background-color: @surface;
				border-radius: 20px;
				border: 2px solid @overlay;
				margin: 10px;
				padding: 10px;
			}

			.notification {
				background-color: @surface;
				border-radius: 20px;
			}
			
			.title {
				color: @blue;
				font-size: 1.2rem;
				font-weight: bold;
			}

			.app-name {
				color: @mauve;
			}

			.body {
				color: @text;
				font-size: 1rem;
			}

			.control-center {
				background-color: @bg;
				border-radius: 20px;
				border: 2px solid @blue;
			}
			
			.control-center .notification-row {
				background-color: transparent;
				border: none;
			}

			.control-center-dnd {
				background-color: @surface;
				border-radius: 15px;
				margin: 10px;
			}
			
			.control-center-dnd:hover {
				background-color: @overlay;
			}

			.control-center .widget-title {
				color: @text;
				font-size: 1.1rem;
				padding: 10px;
				margin-bottom: 5px;
			}
			
			.control-center .widget-title > button {
				background-color: @surface;
				color: @red;
				border-radius: 12px;
			}
			
			.control-center .widget-title > button:hover {
				background-color: @red;
				color: @bg;
			}

			/* Стили для плеера Mpris */
			.widget-mpris {
					background-color: @surface;
					padding: 15px;
					border-radius: 15px;
					margin: 10px;
			}
			.widget-mpris .title {
					color: @green;
					font-size: 1.1em;
			}
			.widget-mpris .artist {
					color: @yellow;
					font-size: 0.9em;
			}
			.widget-mpris button {
					color: @blue;
			}
			.widget-mpris button:hover {
					color: @mauve;
			}
		'';
	};
}
