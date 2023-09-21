#!/usr/bin/env node

const fs = require( 'fs' )
const commander = require( 'commander' )
const puppeteer = require( 'puppeteer' )

const chromiumBin = '/usr/bin/chromium-browser'

commander
	.option( '-f, --file <s>', 'input html file path' )
	.option( '-u, --url <s>', 'input html url path' )
	.option( '-o, --output <s>', 'output file path', 'output.pdf' )
	.option( '--format <s>', 'output format type [A4, letter, or so]', 'letter' )
	.option( '--scale <n>', 'output scale factor [> 0]', 1 )
	.option( '--media <s>', 'emulate media type [screen, media]', 'screen' )
	.option( '--landscape', 'this document will be landscaped' )
	.option( '--printBackground', 'print background images' )
	.option( '--displayHeaderFooter', 'display header and footer' )
	.option( '-c, --chromium <s>', 'executable chromium path', chromiumBin )
	.parse( process.argv )

if ( ! commander.opts().file && ! commander.opts().url ) {
	commander.opts().help( )
}

let url
if ( commander.opts().url ) {
	url = commander.opts().url
}
else {
	const body = fs.readFileSync( commander.opts().file )
	if ( ! body ) {
		commander.opts().help( )
	}
	url = 'data:text/html;,' + encodeURIComponent( body )
}

( async ( ) => {
  console.log("Generating resume PDF. Please wait...")
	const browser = await puppeteer.launch( {
		executablePath: commander.opts().chromium,
    headless: "new",
		args: [
			'--no-sandbox',
      '--start-fullscreen'
		],
    defaultViewport: {
      width: 1920,
      height: 1080
    }
	} )
	const page = await browser.newPage( )
	await page.emulateMediaType( commander.opts().media )
	await page.goto( url, {
		waitUntil: 'networkidle2'
	} )
	await page.pdf( {
		path: commander.opts().output,
		scale: parseFloat(commander.opts().scale),
		displayHeaderFooter: commander.opts().displayHeaderFooter,
		format: commander.opts().format,
		printBackground: commander.opts().printBackground,
		landscape: commander.opts().landscape,
    preferCSSPageSize: true
	} )
	await browser.close( )
} )( )
