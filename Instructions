# How to Recreate My Customized Linux Desktop

This guide provides step-by-step instructions for setting up my customized Openbox-based Linux desktop using my GitHub dotfiles.

## 1. Clone the Repository
First, download my dotfiles to your home directory:
```bash
git clone https://github.com/Mrfutterwacks/dotfiles.git ~/dotfiles
```

## 2. Backup Your Existing Configuration (IMPORTANT)
Before making changes, back up your current configuration:
```bash
mkdir -p ~/config_backup
cp -r ~/.config/openbox ~/config_backup/
cp -r ~/.config/conky ~/config_backup/
cp ~/.xinitrc ~/.bashrc ~/.profile ~/config_backup/
```

## 3. Install Required Software
### Arch Linux
```bash
sudo pacman -S openbox conky python3 git feh picom polybar rofi
```
If using AUR, install additional dependencies:
```bash
yay -S glava
```

### Debian/Ubuntu
```bash
sudo apt update && sudo apt install openbox conky python3 git feh picom polybar rofi
```

### Fedora
```bash
sudo dnf install openbox conky python3 git feh picom polybar rofi
```

### openSUSE
```bash
sudo zypper install openbox conky python3 git feh picom polybar rofi
```

### Generic (for other Linux distros)
Use your package manager to install the required software. Examples:
- **Alpine:** `apk add openbox conky python3 git feh picom polybar rofi`
- **Gentoo:** `emerge --ask x11-wm/openbox app-admin/conky dev-lang/python git feh x11-misc/picom x11-misc/polybar x11-misc/rofi`

## 4. Deploy Configuration Files
Copy configuration files to their appropriate locations:
```bash
cp -r ~/dotfiles/.config/* ~/.config/
cp ~/dotfiles/.xinitrc ~/dotfiles/.bashrc ~/dotfiles/.profile ~/
```

## 5. Enable Openbox Autostart
Make sure Openbox starts correctly with the necessary configurations:
```bash
echo "exec openbox-session" > ~/.xinitrc
```

## 6. Configure and Start Conky
If Conky is not running automatically, start it manually:
```bash
conky -c ~/.config/conky/conky.conf &
```
To make Conky start on login, add it to Openbox autostart:
```bash
echo "conky -c ~/.config/conky/conky.conf &" >> ~/.config/openbox/autostart
```

## 7. Set Up Wallpaper and Visual Elements
Set wallpaper using `feh`:
```bash
feh --bg-scale ~/dotfiles/wallpapers/my_wallpaper.png
```
Enable Picom for transparency and effects:
```bash
picom --config ~/.config/picom/picom.conf &
```

## 8. Start and Configure Polybar (Optional)
If using Polybar for a status bar, start it:
```bash
polybar mybar &
```
To autostart, add it to Openbox autostart:
```bash
echo "polybar mybar &" >> ~/.config/openbox/autostart
```

## 9. Final Steps and Reboot
After completing these steps, reboot your system to apply changes:
```bash
reboot
```

---

### Additional Notes:
- If something doesn't load correctly, check the logs:
  ```bash
  journalctl -xe | grep openbox
  ```
- Modify settings in `~/.config/openbox/rc.xml` for keybindings and window behaviors.
- Conky settings are in `~/.config/conky/conky.conf`.
- For more tweaks, check my `dotfiles` repository and customize as needed.

By following this guide, you should be able to replicate my exact desktop setup. Enjoy!

