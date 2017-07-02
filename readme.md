# Crütech survey server #

A server for surveying campers!

## Installation ##
* if on windows install strawberry perl
* clone this repo: `git clone https://github.com/samgwise/crutech-survey.git`
* `cd crutech-survey`
* Install modules:
  * system perl: `cpanm --sudo --installdeps .` (to install cpanm run: `curl -L https://cpanmin.us | perl - App::cpanminus`)
  * plenv (After setting perl version): `cpanm --installdeps .`

## Run it ##
`./camp-server.pl daemon` <- use this if on windows!
or
`hypnotoad camp-server.pl`

## Make reports ##
To make a csv of campers surveys for Crütech run: `./pack-surveys.pl ct` or for Crusaders run: `pack-surveys.pl cru`

## Surveys ##
The survey page is `/survey`

To view completed surveys restart the server so it can load responses and view the server index (`/`).

Surveys are only viewable after the server has been restarted!
