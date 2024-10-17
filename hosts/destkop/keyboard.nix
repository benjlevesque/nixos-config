{ ... }: {
  # Enable keyboard remapping daemon
  services.keyd = {
    enable = true;
    keyboards = {
      default = {

        # Steelseries keyboard
        ids = [ "04b4:0101" ];
        settings = {
          main = {
            # This maps the capslock key to the "Super" key, to open Gnome search
            capslock = "leftmeta";
          };
        };
      };
    };
  };
}
