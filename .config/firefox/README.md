# Make Firefox better with Betterfox
I am tuning, customizing, improving, my Firefox experience with a user.js that starts from [Betterfox](https://github.com/yokoffing/Betterfox) and then is further customized with some changes and my prefs.

## Here's how I use it:
1. Find your active profile in Firefox by going to the profiles page.
   - Type **about:profiles** into the address bar and press the _Enter_ key.
   - Note down the Root Directory
2. Quit Firefox
3. cd into your Root Directory and symlink user.js
   - cd ~/.mozilla/firefox/abcdefg.default-123456
   - ln -s ~/.config/firefox/user.js .
4. Start Firefox
   - make note of any issues and tune your experience by making changes to your user.js as you see fit
5. Enjoy a more streamlined and private Firefox

