
2016-2-26

* google for							     :google:
  
** TODO modify load-path variable
** TODO emacs built-in packages
** TODO how packages are initialized at the start up of emacs
** TODO the start process of emacs, files loaded and path searched, variables set?
* summarize emacs nots						      :notes:
** learned @20160227
*** C-x 5 create frames
*** C-x 2 split horizontal, C-x 3 split vertical
*** C-x RET f coding
***  Episode 1:

  1. emacas --font "Monaco 20"
  2. C-h i to learn inside the emacs. mEmacs to open the Emacs Manual.
  3. in the info page, search for game, will open Game list.
  4. M-x <game-name> will open game.
  5. C-x k to kill the game window.

***   Episode 2: Customize Emacs

  1. hide menu bar: M-x customize, Environment, Frames, Menu Bar, toggle, state, 1(for future sessions).
     this will add (menu-bar-mode nil) into .emacs file.
  2. hide tool bar:  same with menubar. this will add (tool-bar-mode nil) into .emacs file.
  3. blink cursor mode: Customize Group: Frames, Subgroup: Cursor.
  4. Faces and Themes: 
     Change Faces: Environment : Faces : Basic Faces:Default, make some changes and save the state for future session.
     Change Themes:M-x customize-themes check the themes and save the settings. Note: you should untoggle the foreground and background in Basic Faces:Default area.
  	     		    	 
*** Episode 3: Install Packages and Extensions.

  1. show all packages: M-x packages.
  2. add package site: M-x customize group    
** extra
 1. uppercase and lowercase.
** todos
 1. collect mature .emacs from others.
 2. line number.
 3. quick switch between files and windows.
 4. auto complete.
 5. copy paste cut system clipboard.
 6. tags and project explorer.
 7. auto indent.
 8. code navigation.
 9. autoload file changes.
** notes
   
    
