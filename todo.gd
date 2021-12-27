Stream overlay extreme

3 separate applications
- Twitch manager # Hi Mr Stream - Lil'Oni
- Godot plugin # f*ck. - TheYagich
- Stream overlay

Twitch Manager:
	- Responsible for interfacing with Twitch.
		- Having a server for events like subscriptions, redemptions, follows, etc
		- The ability to setup a stream
			- Setting the name of the stream and any tags, etc.
			- Control which channel points are active
				- If we aren't using Godot, don't activate those redemptions
			- Have things saved as profiles
				- We can switch between godot/game dev/minecraft easily
				- keep track of last used name, notification, tags, redemptions
			- !today command setting thing
	- Responsible for other application connections and distributing data
		- When we get a Twitch event, it will send out to any listeners
		- We will have a websocket where overlay/plugin are able to connect
			- They will identify themselves and we will have a status icon
				showing their connection
			- Any events will be sent through this socket to the listeners
		- We will have a check and status for ngrok being active
	- Responsible for hosting the HTTP server for the overlay
		- Just a single endpoint that OBS is able to use as a media source
			- I think we just need to serve the HTML file for the overlay
	- Responsible for setting up a chat client
		- Takes and manages commands
		- Forward any chat messages to the listening services
	- UI
		- Status of plugin|ngrok|overlay
		- Profiles tabs to switch between different profiles
			- stream info for the day
				- notification
				- title
				- tags
				- !today
			- command setup
				- list of commands
					- title
					- is admin
					- is streamer
					- type (static|code execution)
					- tags
			- point redemption setup
				- list of redemptions (Look at API for creating redemptions)
					- title 
					- description
					- points
					- picture (scale as required)

Godot Plugin:
	- Responsible for responding to everything related to Godot
		- Color change
		- inverting
		- commenting
		- ridiculousness
			- This will now be by keystroke not time
	- Output chat messages to console


Stream overlay:
	- Responsible for the border of the stream
		- Be able to have color changed :D :D
		- Once this is merged, camera will go through too https://github.com/godotengine/godot/pull/49763
			- Have fun camera position type things
	- Responsible for the BRB and Starting Soon screens
		- This will integrate with the Stream deck for fun button pressing times
	- Responsible for cool scene transitions and effects
	- Responsible for alerts and outputing them
		- Followers are announced as "New follow!"
		- Subscribers are announced as "<username> subscribed!"
			- Gift subs?
			- Amount of times subbed? subbed for x months
		- Certain channel redemptions get their own alerts
	- Responsible for showing status icons of things
		- like ridiculous typing
	- Other fun things I have yet to think about :D
	- React to bits|butts
		- bright flashy things to stimulate happy glands

