{
  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
    global = {
      check_for_updates_on_startup = false;
      show_in_menu_bar = false;
      show_profile_name_in_menu_bar = false;
    };
    profiles = [
      {
        name = "default";
        selected = true;
        complex_modifications.rules = [
          {
            description = "Capslock to HYPER";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers.optional = [ "any" ];
                };
                to = [
                  {
                    key_code = "left_command";
                    modifiers = [
                      "left_control"
                      "left_option"
                    ];
                  }
                ];
                to_if_alone = [ { key_code = "escape"; } ];
              }
            ];
          }
        ];
      }
    ];
  };
}
