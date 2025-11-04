{
  ...
}:

{
  programs.mangohud = {
    enable = true;
    settings = {
      full = true;
      vertical = true;

      gpu_temp = true;
      gpu_junction_temp = true;
      gpu_core_clock = true;
      gpu_mem_temp = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_power_limit = true;

      ram = true;
      vram = true;
      toggle_hud = "Shift_R+F12";
    };
  };
}
