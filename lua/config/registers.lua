-- lua/config/registers.lua
-- Clear registers a-z, 0-9, and special registers
local function clear_user_registers()

  -- Clear all registers a-z
  for c = string.byte("a"), string.byte("z") do
    vim.fn.setreg(string.char(c), "")
  end

  -- Clear the unnamed register
  vim.fn.setreg('"', "")  -- unnamed register

  -- Clear system clipboard registers
  vim.fn.setreg("*", "")  -- selection buffer
  vim.fn.setreg("+", "")  -- clipboard

  -- Clear other special registers
  vim.fn.setreg("0", "")  -- yank history register
  for i = 1, 9 do
    vim.fn.setreg(tostring(i), "")  -- 1-9 registers
  end
  vim.fn.setreg(":", "")  -- last command-line command register
  vim.fn.setreg("%", "")  -- current file name register

  -- Notify user that registers have been cleared
  print("All registers cleared!")
end

-- Create the ClearRegisters command to run manually
vim.api.nvim_create_user_command("ClearRegisters", clear_user_registers, {})

