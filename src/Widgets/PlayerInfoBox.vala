/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Justin Lahman <justinlahmanCS@gmail.com>
 */
namespace Eksanos.Widgets {
	internal class PlayerInfoBox : Gtk.Box {
		private Gtk.Label player_name_label;
		private Gtk.Label player_score_label;

		public PlayerInfoBox (string player_name, int spacing) {
			orientation = Gtk.Orientation.VERTICAL;
			get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
			get_style_context ().add_class (Granite.STYLE_CLASS_ROUNDED);


			player_name_label = new Gtk.Label (player_name);
			player_name_label.margin = 4;
			player_score_label = new Gtk.Label ("Matches Won: 0");
			player_score_label.margin = 4;

			pack_start (player_name_label, false, false, 12);
			pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
			pack_start (player_score_label, false, false, 2);

			set_spacing(spacing);
		}

		public void update_score_label (int score) {
			player_score_label.set_label ("Matches Won: " + score.to_string());
		}

		public string get_player_name () {
			return player_name_label.get_label ();
		}

		public void update_player_name (string player_name) {
			player_name_label.set_label (player_name);
		}

		public void disable () {
			set_sensitive (false);
		}

		public void enable () {
			set_sensitive (true);
		}
	}
}
