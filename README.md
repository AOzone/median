# Median

Middleware + front end for Åzone Terminal, built with [Are.na](https://www.are.na) and [Ezel](http://ezeljs.com/)

http://azone.guggenheim.org

Median connects Åzone's Kernal API (built by Hugo Liu), the Are.na API, a Wordpress.com blog and a local database to facilitate transactions, display market data, and connect relevant news to various futures.

## Organization

Median keeps with the conventions established in the [Ezel](http://ezeljs.com/) docs. Routes are stored in the `apps` folder, front-end components are in the `components` folder, and any "static" data, or files that describe relationships between two data sources (e.g. connecting "Futures" to their respective Are.na channels) are stored in `maps`.

## Getting Started

(Note: Without having a kernal secret and an Are.na API token filled out in an .env file, you will be unable to make transactions through your local server. This is purely for educational purposes.)

* `brew install mongo`
* `brew install nvm`
* `nvm install 0.12`
* `nvm alias default 0.12`
* Fork, clone, cd
* `npm install`
* `make assets`
* `npm run dev`

## Credits
Huge, huge thanks to @craigspaeth at Artsy for making [Ezel.js](http://ezeljs.com/), the best isomorphic javascript boilerplate around.
