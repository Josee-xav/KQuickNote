I added automatic sliding to the next note

made scrollbar work how it should.



# KQuickNote

Simple yet powerful note-taking widget for KDE Plasma 6. Create and manage your notes with Markdown support, auto-save feature, and quick access from system tray.

> **Note**: Currently only supports KDE Plasma 6. Plasma 5 version may be available in the future.

## ✨ Features

- 📝 Quick and easy note-taking
- 🎨 Seamless integration with KDE Plasma
- 📱 Modern and clean user interface
- ✅ Markdown support for rich text formatting
- 💾 Automatic saving
- 🔍 Easy access from system tray
- 🌙 Follows system theme (light/dark mode)

## 📸 Screenshots

Looks a lil different.......  i honestly cba uploading images and then linking it

## 🚀 Installation

### From KDE Store
Coming soon!
<!-- 1. Right-click on your desktop
2. Select "Add or Manage Widgets"
3. Click "Get New Widgets"
4. Search for "KQuickNote"
5. Click "Install" -->

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/se7uh/kquicknote.git

# Enter the directory
cd kquicknote

# Install to your local Plasma widgets directory
mkdir -p ~/.local/share/plasma/plasmoids/com.se7uh.kquicknote
cp -r * ~/.local/share/plasma/plasmoids/com.se7uh.kquicknote/
```

After installation, add the widget to your desktop:
1. Right-click on your desktop or panel
2. Select "Add or Manage Widgets"
3. Search for "KQuickNote"
4. Click and drag to your desktop or panel

You might need to restart Plasma to see the widget:
```bash
plasmashell --replace &
```

## 🎮 Usage

1. Click the KQuickNote icon in your system tray
2. Start typing your notes
3. Use Markdown for formatting:
   - `# Heading 1`
   - `## Heading 2`
   - `**Bold**` or `*Italic*`
   - `- List items`
   - `1. Numbered lists`
   - `[Links](http://example.com)`
   - `` `Code` ``

## ⚙️ Configuration

Right-click on the widget and select "Configure KQuickNote" to access settings:
- Shortcut keys

## 🛠️ Development

### Requirements
- KDE Plasma 6.0 or higher

### Testing the Widget
```bash
# Install to your local Plasma widgets directory
mkdir -p ~/.local/share/plasma/plasmoids/com.se7uh.kquicknote
cp -r * ~/.local/share/plasma/plasmoids/com.se7uh.kquicknote/

# Test the widget in a window
plasmawindowed com.se7uh.kquicknote
```

## 🤝 Contributing

Contributions are welcome! Feel free to:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💖 Support

If you find KQuickNote useful, please consider:
- Giving it a star on GitHub ⭐
- Sharing it with others
- [Reporting issues](https://github.com/se7uh/kquicknote/issues)
- Contributing to the code

## 🙏 Acknowledgments

- KDE Community for the amazing Plasma desktop
- Contributors and users of KQuickNote
