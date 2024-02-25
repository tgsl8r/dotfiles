-- spec.lua
-- Contains the global plugin spec table and a function for adding plugin specifications to it
LAZY_SPEC = {}

function spec(plugin)
  table.insert(LAZY_SPEC, { import = plugin })
end
