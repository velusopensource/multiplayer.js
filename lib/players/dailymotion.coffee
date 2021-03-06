#
#	@author Félix Girault <felix.girault@gmail.com>
#	@license FreeBSD License (http://opensource.org/licenses/BSD-2-Clause)
#

Player = require( 'player' )



class Dailymotion extends Player

	UNSTARTED: -1
	ENDED: 0
	PLAYING: 1
	PAUSED: 2



	_queue = { }

	constructor: ( id, options ) ->
		super( id, options )

		player = document.createElement( 'div' )
		player.setAttribute( 'id', @domId )
		@container.appendChild( player )

		if !window.onDailymotionPlayerReady
			window.onDailymotionPlayerReady = ( id ) ->
				for domId, callback of _queue
					if id is domId
						callback( domId )
						delete _queue[ domId ]

		_queue[ @domId ] = ( id ) =>
			@player = document.getElementById( id )
			@dfd.resolve( this )

		swfobject.embedSWF(
			"http://www.dailymotion.com/swf/#{@id}?enableApi=1&playerapiid=#{@domId}",
			@domId,
			options.width
			options.height
			options.version
			options.swfUrl
			options.flashVars
			options.params
			options.attributes
		)



	load: ( id ) ->
		@player.loadVideo( id )

	clear: ( ) ->
		@player.clearVideo( )



	play: ( ) ->
		@player.playVideo( )

	isPlaying: ( ) ->
		@player.getPlayerState( ) is @PLAYING

	pause: ( ) ->
		@player.pauseVideo( )

	isPaused: ( ) ->
		@player.getPlayerState( ) is @PAUSED

	stop: ( ) ->
		@player.stopVideo( )

	isStopped: ( ) ->
		@player.getPlayerState( ) in [ @UNSTARTED, @ENDED ]



	duration: ( ) ->
		@player.getDuration( )

	currentTime: ( ) ->
		@player.getCurrentTime( )

	seek: ( seconds ) ->
		@player.seekTo( seconds )



	volume: ( ) ->
		@player.getVolume( )

	setVolume: ( volume ) ->
		@player.setVolume( volume )

	mute: ( ) ->
		@player.mute( )

	unMute: ( ) ->
		@player.unMute( )

	isMuted: ( ) ->
		@player.isMuted( )



	on: ( event, callback ) ->
		@player.addEventListener( event, callback )



module.exports = Dailymotion
