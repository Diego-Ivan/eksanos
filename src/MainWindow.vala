/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Justin Lahman <justinlahmanCS@gmail.com>
 */
namespace Eksanos {
	public class MainWindow : Hdy.ApplicationWindow {
		private Controllers.Game game_controller;
		private MainMenu main_menu;
		private Hdy.HeaderBar header_bar;
		private Hdy.Deck deck;
		private Gtk.Button nav_button;

		public MainWindow (Eksanos.Application eksanos_app) {
			Object (
				application: eksanos_app,
				title: "Eksanos",
				default_height: 640,
				default_width: 360,
				resizable: false
			);
		}

		construct {
			Hdy.init ();
			var global_grid = new Gtk.Grid ();
			global_grid.orientation = Gtk.Orientation.VERTICAL;

			nav_button = new Gtk.Button.with_label ("Menu");
			nav_button.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);
			nav_button.set_visible (false);
			nav_button.set_can_focus (false);

			game_controller = new Controllers.Game (this);
			main_menu = new MainMenu ();

			game_controller.get_game_screen ().quit_game_requested.connect (on_quit_game_requested);
			game_controller.get_game_screen ().back_to_main_menu_requested.connect (() => {
				deck.set_visible_child (main_menu.get_menu_screen ());
				nav_button.set_visible (false);
			});

			setup_header_bar ();
			setup_deck ();
			setup_connections ();

			global_grid.add (header_bar);
			global_grid.add (deck);
			add (global_grid);
		}

		private void setup_header_bar () {
			header_bar = new Hdy.HeaderBar (){
				hexpand = true,
				has_subtitle = false,
				show_close_button = true,
				title = "Eksanos"
			};

			var title = new Gtk.Label ("Eksanos");
			title.get_style_context ().add_class(Granite.STYLE_CLASS_ACCENT);
			title.get_style_context ().add_class(Granite.STYLE_CLASS_H3_LABEL);

			header_bar.set_custom_title (title);

			header_bar.pack_start (nav_button);
		}

		private void setup_deck () {
			deck = new Hdy.Deck ();
			deck.set_transition_type (Hdy.DeckTransitionType.UNDER);
			deck.add (main_menu.get_menu_screen ());
			deck.add (game_controller.get_game_screen ());
			deck.set_visible_child (main_menu.get_menu_screen ());
		}

		private void setup_connections () {
			main_menu.start_game_requested.connect ((player_one_name, player_two_name, single_player_mode, color_name) => {
				game_controller.generate_new_game (player_one_name, player_two_name, single_player_mode, color_name);
				deck.set_visible_child (game_controller.get_game_screen ());
				nav_button.set_visible (true);
			});

			nav_button.clicked.connect (() => {
				deck.set_visible_child (main_menu.get_menu_screen ());
				nav_button.set_visible (false);
			});
		}

		private void on_quit_game_requested () {
			application.quit ();
		}
	}
}
