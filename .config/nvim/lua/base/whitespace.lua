-- Whitespace highlights
local opt = vim.opt
-- Enable the list mode to show special characters.
opt.list = true
-- Define the characters to use for specific whitespace types
opt.listchars = {
  -- Tabs shown as a double arrow followed by a dot.
  tab = '»·',
  -- Leading spaces shown as a middle dot.
  lead = '·',
  -- Trailing spaces shown as a bullet point.
  trail = '•',
  -- End of line marker.
  eol = '↵',
  -- Non-breaking space marker.
  nbsp = '␣',
  -- Non-breaking space marker.
  multispace = '␣␣',
}
