module.exports = {
  config: {
    fontSize: 10,
    fontFamily: "Noto Sans Mono, Menlo, DejaVu Sans Mono, Lucida Console, monospace",
    cursorBlink: false,
    copyOnSelect: true,
    quickEdit: true,
    defaultSSHApp: false,
    showHamburgerMenu: false,

/* Theme */
    cursorColor: "#4fb4d8",
    borderColor: "#3b3d45",
    foregroundColor: "#cbcdd2",
    backgroundColor: "#18181b",
    colors: {
      "black": "#3b3d45",
      "red": "#eb3d54",
      "green": "#78bd65",
      "yellow": "#e5cd52",
      "blue": "#4fb4d8",
      "magenta": "#c46eb1",
      "cyan": "#85e0c9",
      "white": "white",
      "lightBlack": "#525560",
      "lightRed": "#f1223e",
      "lightGreen": "#6cc653",
      "lightYellow": "#edcd2c",
      "lightBlue": "#21acde",
      "lightMagenta": "#ce64b7",
      "lightCyan": "#63e9c7",
      "lightWhite": "white",
    },

/* Plugin Configurations */
    // [[https://www.npmjs.com/package/hyper-opacity][hyper-opacity]]
    opacity: {
      focus: 1,
      blur: 0.96,
    },

    // [[https://www.npmjs.com/package/hyperterm-summon][hyperterm-summon]]
    summon: {
      "hotkey": "Ctrl+'",
    },
  },

  plugins: ["hyper-opacity", "hyperterm-summon",],

  localPlugins: [],

  keymaps: {
    "window:devtools": "cmd+alt+o"
  }
};
