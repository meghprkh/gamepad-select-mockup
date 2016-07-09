int main (string[] args) {
  Gtk.init (ref args);
  var app = new ValaGtk.Application ({"Logitech gamepad", "RetroPad", "PS4", "Keyboard"}, {1, 0, 2, 3});
  app.destroy.connect(Gtk.main_quit);
  app.show_all ();
  Gtk.main ();
  return 0;
}
