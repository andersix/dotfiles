# Firefox user.js

This `user.js` is based on [Betterfox](https://github.com/yokoffing/Betterfox) with personal customizations.

## Usage

1. Find your Firefox profile directory:
   - Type `about:profiles` in Firefox address bar
   - Note the Root Directory (e.g., `~/.mozilla/firefox/abcdefg.default-123456`)

2. Quit Firefox and symlink the file:
   ```bash
   cd ~/.mozilla/firefox/abcdefg.default-123456
   ln -s ~/.config/firefox/user.js .
   ```

3. Restart Firefox

## Updating from Betterfox

Check current version:
```bash
grep "version:" ~/.config/firefox/user.js
```

Update to latest:
```bash
# Download new version
curl -o /tmp/betterfox-new.js https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js

# If you have customizations (line 218+), save them first
tail -n +218 ~/.config/firefox/user.js > /tmp/my-overrides.js

# Replace file
cp /tmp/betterfox-new.js ~/.config/firefox/user.js

# Re-add your overrides (if any) after line 218, then commit
dotfiles add ~/.config/firefox/user.js
dotfiles commit -m "Update Betterfox to version XXX"
```

