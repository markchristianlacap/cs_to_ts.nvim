# C# to TypeScript interface converter using Lua 

A Neovim helper for converting C# class to TypeScript interface with the ability to import and use as a Lua module.

## Installation and Usage

1. Import the plugin as a Lua module in your Neovim configuration file.
2. Call the function `convert(csharp)` with the selected text as an argument to convert it to a TypeScript interface.

### Sample Configuration using Lazy.nvim

```lua
return {
  'markchristianlacap/cs-to-ts.nvim',
  ft = 'cs',
  keys = {
    {
      '<leader>lc',
      mode = { 'v', 'n' },
      function()
        --get yanked text
        local text = vim.fn.getreg '"'
        -- convert
        local interface = require('cs-to-ts').convert(text)
        if interface then
          --put to vim register
          vim.fn.setreg('"', interface)
        end
      end,
      desc = 'Convert yanked C# to TypeScript interface',
    },
  },
}
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This plugin is licensed under the [MIT License](LICENSE).
