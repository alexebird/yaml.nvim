local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  return nil
end

local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local document = require("yaml_nvim.document")
local pair = require("yaml_nvim.pair")

local function entry_maker(node)
  local parsed = pair.parse(node)
  return {
    value = parsed.errorformat,
    ordinal = parsed.line,
    display = parsed.human,
  }
end

local function yaml_picker(opts)
  opts = opts or {}
  local results = {}
  for _, key in pairs(document.all_keys()) do
    if not document.is_value_a_block(key) then
      table.insert(results, key)
    end
  end

  pickers.new(
    opts, {
      prompt_title = "YAML Telescope",
      finder = finders.new_table({results = results, entry_maker = entry_maker}),
      previewer = previewers.vim_buffer_cat.new(opts),
      sorter = sorters.get_fuzzy_file(opts),
    }
  ):find()
end

return telescope.register_extension({exports = {yaml = yaml_picker}})
