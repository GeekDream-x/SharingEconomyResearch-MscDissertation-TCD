### [v2.3.0] - 2018-01-16
#### Added
- Added module for administering AMT HITs within breadboard
- Import and export experiments from the browser
- Supports translating experiment content in multiple languages
- Improved performance: now defaults to a polling for client updates
- Player client is now responsive and mobile friendly
- Improved security

#### Changed
- UI updates including a new taskbar and tabs that show changed / saved state
- Players dialog now lists players by ID and formats player data in JSON format 
- Style, Client Html and Client Graph dialogs have been moved to tabs of a Customize dialog
- Parameters inputs now enforce selected type, min, and max values
- Breadboard now supports JDK 7/8/9

#### Fixed
- Fixed an issue where the bandwidth test fails when AMT workers join a game
- Fixed an issue where player timers may be inaccurate if their computer's clock differs from the server
- Fixed an issue where a.remove(Vertex player) and a.remove(String playerId) behavior was inconsistent

### [v2.2.4] - 2017-04-14 
#### Added 
- Added LICENSE file to download
- If a 'password' parameter is provided it is checked against client login

#### Changed
- Changed "Allow repeat play?" options in AMT dialog to be more clear 

#### Fixed 
- Resolved 'Not a valid Play application' error with Windows breadboard.bat batch file
- Edge properties are restored in Admin Graph view on browser refresh
- Running experiment instance is highlighted based on id, not name
- OnLeaveStep no longer throws an exception when stopping a game with players
in the graph

### [v2.2.3] - 2016-04-01
#### First public release!
#### Added 
- Now can launch on Windows PCs using breadboard.bat 
- Settings can now be modified using the application-prod.conf file 

### [v2.2.2] - 2016-03-09
#### Fixed 
- Fixed custom PlayerActions with regards to checkboxes

### [v2.2.1] - 2016-03-01
#### Added
- The wattsStrogatz graph algorithm implementing the Watts-Strogatz small world algorithm
- A edge.randV() function that returns a random vertex attached to the edge
- Settings can now be set using an application-prod.conf file in the root of the breadboard directory

#### Changed
- Removed the confusing 'Extend HIT' and 'Assign Qualification' buttons from the AMT Assignments dialog
- Updated the README

#### Fixed 
- Fixed support for checkboxes and radio buttons as input options for custom player choices

### [v2.2.0] - 2015-12-02
#### Added 
- A Client Graph dialog that allows users to modify the players' graph view without modifying source code
- Now hashing and salting admin passwords with BCrypt
- breadboard with an empty Users table prompts user to add first user 

#### Fixed 
- Added proper syntax highlighting to the Client HTML dialog

### [v2.1.0] - 2015-11-05
#### Added 
- A Client HTML dialog that allows users to modify the players' client view without modifying source code

#### Changed
- The admin graph function name from 'graph' to 'Graph' to match javascript conventions
- Moved TimersCtrl to its own client-timer.js file
 
### [v2.0.0] - 2015-10-29
#### Added
- The initial release version of breadboard v2

### A note on version numbers:
The version number will be incremented based on the following system, given a version number vX.Y.Z (e.g. v2.1.0): when
X (major) is incremented it means a new codebase that is not backward compatible with other major versions, when Y 
(minor) is incremented it means new features have been added that may require database evolutions but are compatible 
with databases created with software with the same major version number, and when Z (patch) is incremented it means
 that bugs with the features of the minor version have been fixed.
