return {
  name = "compile",
  builder = function(params)
    return {
      cmd = "meson compile --verbose -C $BUILD_DIR " .. params.target,
      components = {
        {
          "dependencies",
          task_names = {
            {
              "configure",
              param_values = { build_type = params.build_type, quit_on_exit = "success" }, -- FICTITIOUS
            }
          }
        }
      }
    }
  end,
  params = {
    build_type = {
      type = "enum",
      choices = {
        "release",
        "debug"
      },
      default = "release",
    },
    target = {
      type = "enum",
      choices = {
        "my_target_1",
        "my_target_2",
        "my_target_3"
      },
      default = "my_target_1",
    }
  }
}
