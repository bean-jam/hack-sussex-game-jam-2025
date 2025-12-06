# hack-sussex-game-jam-2025

## How to clone repository

Either get the GitHub Desktop app and follow the steps to clone the repository or use the terminal:

- Change directory to the folder you want

`cd path/to/location/you/want/the-repo`

- Clone the repo:

`git clone https://github.com/bean-jam/hack-sussex-game-jam-2025.git`

## Workflow for the team

Create a new branch for the feature you are going to add. For example, feature/player.

If you are working in an existing branch, use the Branch tab at top menu of the GitHub Desktop app and update from main.
This ensure's you're working on the most recent, up to date version.

Then you can work on your feature and then commit and push your changes to GitHub and start a Pull Request.


## Layout

In the game node, everything is made out of scenes. Make your own scene and 
edit within the scene. For example, player.tscn gets edited in it's own 
environment, tested in a test environment, and then it gets imported into 
the world node when it is ready. This will hopefully reduce conflicts where we are making changes in independent files.
