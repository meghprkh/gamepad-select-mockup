private enum ValaGtk.State {
  CHOSE_PLAYER,
  CHOSE_GAMEPAD,
}

[GtkTemplate (ui = "/org/gnome/ValaGtk/app.ui")]
public class ValaGtk.Application : Gtk.Window {
  [GtkChild]
	private Gtk.ListBox list_box1;
  [GtkChild]
	private Gtk.ListBox list_box2;
  [GtkChild]
	private Gtk.Stack stack;
  [GtkChild]
	private Gtk.Label label;

  public string[] gamepads;
  public int[] associations;

  private State state = State.CHOSE_PLAYER;
  private int active_player = -1;

  public Application (string[] gamepad_c, int[] association_c) {
    gamepads = gamepad_c;
    associations = association_c;

    this.destroy.connect(() => {
      print(@"\n\nAssociations : $(associations.length)\n");
      for (var i = 0; i < associations.length; i++) {
        print(@"Player $(i+1) - $(associations[i])\n");
      }
    });

    foreach (var gamepad in gamepads) {
      list_box2.add(new Gtk.Label(gamepad));
    }

    for (var i = 0; i < associations.length; i++) {
      var button = new Gtk.Button.with_label(get_player_string(i));
      var i_copy = i;
      button.clicked.connect(() => change_state(State.CHOSE_GAMEPAD, i_copy));
      list_box1.add(button);
    }
  }

  private string get_player_string (int player) {
    return @"Player $(player+1) - $(gamepads[associations[player]])";
  }

  [GtkCallback]
  private void on_back_button_clicked () {
    if (state == State.CHOSE_GAMEPAD) change_state(State.CHOSE_PLAYER);
    else this.close();
  }

  private void change_state (State to, int player = -1) {
    if (to == state) return;
    switch (to) {
    case State.CHOSE_PLAYER:
      var associate_to = list_box2.get_selected_row().get_index();
      print(@"Row changed $active_player - $associate_to!\n");
      int other = -1;
      for (var i = 0; i < associations.length; i++) {
        if (associations[i] == associate_to) { other = i; break; }
      }
      if (other != -1) associations[other] = associations[active_player];
      associations[active_player] = associate_to;
      ((Gtk.Button) list_box1.get_row_at_index(active_player).get_child()).label = get_player_string(active_player);
      ((Gtk.Button) list_box1.get_row_at_index(other).get_child()).label = get_player_string(other);
      stack.transition_type = Gtk.StackTransitionType.SLIDE_RIGHT;
      label.label = "Select a player.";
      stack.set_visible_child(list_box1);
      break;
    case State.CHOSE_GAMEPAD:
      label.label = "Select your gamepad device.\n You can also press a button on your gamepad to select it.";
      list_box2.select_row(list_box2.get_row_at_index(associations[player]));
      stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT;
      stack.set_visible_child(list_box2);
      break;
    }
    state = to;
    active_player = player;
  }
}
