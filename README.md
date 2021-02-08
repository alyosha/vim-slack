## vim-slack
minimal vim slack client

## Usage
- `Fwd` => forward currently yanked text to a conversation of your choosing
- `Send` => send a new message to a conversation of your choosing
- `Check` => check last 50 messages in a conversation of your choosing

Planned functionality includes some updates around message viewing (reply, etc.)
and mapping of internal Slack user ID to username for readability when viewing
messages.

## Setup
You'll need to create a new bot for your Slack workspace to use the plugin.

First hop on over to https://api.slack.com and create a new app. Then navigate
to the Oauth & Permissions tab and add the following scopes:

**BOT TOKEN SCOPES**
- `channels:read`
- `groups:read`
- `im:read`
- `mpim:read`

**USER TOKEN SCOPES**
- `channels:history`
- `chat:write`

Then copy the two tokens at the top of this page and assign them to the
following env variables, respectively:

- `SLACK_USER_TOKEN` =>  `OAuth Access Token`
- `SLACK_BOT_TOKEN` =>  `Bot User OAuth Access Token`

Finally, please set your Slack user ID in the `SLACK_USER_ID` env variable.
You can find your ID by opening your profile in Slack and clicking `More`.

## Contributions
Suggestions/contributions always welcome.

## Installation
Using your preferred plugin manager or if all else fails:

`git clone https://github.com/alyosha/vim-slack ~/.vim/bundle/vim-slack`

## Screenshots
![send example](images/send-example.png)
![forward yanked example](images/fwd-yanked-example.png)

