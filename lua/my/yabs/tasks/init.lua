local function merge_tables(...)
  local result = {}

  for _, tbl in ipairs({ ... }) do
    for key, value in pairs(tbl) do
      result[key] = value
    end
  end

  return result
end

return merge_tables(
  require("my.yabs.tasks.autogen"),
  -- require("my.yabs.tasks.make"),
  -- require("my.yabs.tasks.gradle"),
  -- require("my.yabs.tasks.maven"),
  -- require("my.yabs.tasks.android"),
  require("my.yabs.tasks.dotenv"),
  require("my.yabs.tasks.rust"),
  require("my.yabs.tasks.typescript")
)
