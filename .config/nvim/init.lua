
-- ░▀█▀░█▀█░▀█▀░▀█▀░░░░█░░░█░█░█▀█░
-- ░░█░░█░█░░█░░░█░░░░░█░░░█░█░█▀█░
-- ░▀▀▀░▀░▀░▀▀▀░░▀░░▀░░▀▀▀░▀▀▀░▀░▀░


-- Core --
require("user.core.spec")
require("user.core.options")
require("user.core.keymaps")
-- Colourschemes --
-- spec("user.colour.darkplus")
spec("user.colour.alduin")
-- Plugins --
spec("user.plugins.devicons")
spec("user.plugins.treesitter")
spec("user.plugins.mason")
spec("user.plugins.lspconfig")
spec("user.plugins.cmp")
spec("user.plugins.whichkey")
-- Lazy --
require("user.core.lazy")
