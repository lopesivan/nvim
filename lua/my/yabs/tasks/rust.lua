local app = require("my.neovim_dev").app
local file_exists = require("yabs.conditions").file_exists

local function get_package_name()
  local cargo_toml = io.open("Cargo.toml", "r")
  if not cargo_toml then
    return nil
  end
  local name
  for line in cargo_toml:lines() do
    name = line:match('^name%s*=%s*"(.-)"')
    if name then
      break
    end
  end
  cargo_toml:close()
  return name
end

local function run_cargo(args)
  vim.notify(
    "cargo " .. table.concat(args, " "),
    vim.log.levels.INFO,
    { title = "cargo" }
  )
  vim.defer_fn(function()
    app("cargo", args)
  end, 1000) -- ms
end

return {
  ["cargo build"] = {
    command = function()
      run_cargo({ "build" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo build --release"] = {
    command = function()
      run_cargo({ "build", "--release" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo run"] = {
    command = function()
      run_cargo({ "run" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo run --release"] = {
    command = function()
      run_cargo({ "run", "--release" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo check"] = {
    command = function()
      run_cargo({ "check" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo clippy"] = {
    command = function()
      run_cargo({ "clippy" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo test"] = {
    command = function()
      run_cargo({ "test" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo clean"] = {
    command = function()
      run_cargo({ "clean" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo fmt"] = {
    command = function()
      run_cargo({ "fmt" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo doc --open"] = {
    command = function()
      run_cargo({ "doc", "--open" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo update"] = {
    command = function()
      run_cargo({ "update" })
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo fix"] = {
    command = function()
      local name = get_package_name()
      if name then
        run_cargo({ "fix", "--bin", name, "-p", name })
      else
        run_cargo({ "fix" })
      end
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
  ["cargo fix --allow-dirty"] = {
    command = function()
      local name = get_package_name()
      if name then
        run_cargo({ "fix", "--bin", name, "-p", name, "--allow-dirty" })
      else
        run_cargo({ "fix", "--allow-dirty" })
      end
    end,
    condition = file_exists("Cargo.toml"),
    type = "lua",
  },
}
