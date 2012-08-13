class Explosion
  constructor:()->
    return if window.FONTBOMB_LOADED
    window.FONTBOMB_LOADED = true
    confirmation = true unless window.FONTBOMB_HIDE_CONFIRMATION
    @bombs = []
    @body          = document.getElementsByTagName("body")[0]
    @body?.onclick = (event)=>@dropBomb(event)
    @body.addEventListener("touchstart", (event)=>
        @touchEvent = event
      )
    @body.addEventListener("touchmove", (event)=>
        @touchMoveCount ||= 0
        @touchMoveCount++
      )
    @body.addEventListener("touchend", (event)=>
        @dropBomb(@touchEvent) if @touchMoveCount < 2
        @touchMoveCount = 0
      )
    @explosifyNodes  @body.childNodes
    @chars = for char in document.getElementsByTagName('particle')
      new Particle(char,@body)
    @tick()
    if confirmation?
      style = document.createElement('style')
      style.innerHTML = """
div#fontBombConfirmation {
  position: absolute;
  top: -200px;
  left: 0px;
  right: 0px;
  bottom: none;
  width: 100%;
  padding: 18px;
  margin: 0px;
  background: #e8e8e8;
  text-align: center;
  font-size: 14px;
  line-height: 14px;
  font-family: verdana, sans-serif;
  color: #000;
  -webkit-transition: all 1s ease-in-out;
  -moz-transition: all 1s ease-in-out;
  -o-transition: all 1s ease-in-out;
  -ms-transition: all 1s ease-in-out;
  transition: all 1s ease-in-out;
  -webkit-box-shadow: 0px 3px 3px rgba(0,0,0,0.20);
  -moz-box-shadow: 0px 3px 3px rgba(0,0,0,0.20);
  box-shadow: 0px 3px 3px rgba(0,0,0,0.20);
  z-index: 100000002;
}
div#fontBombConfirmation span,div#fontBombConfirmation a {
  color: #fe3a1a;
}
div#fontBombConfirmation.show {
  top:0px;
  display:block;
}
"""
      document.head.appendChild style
      @confirmation = document.createElement("div")
      @confirmation.id = 'fontBombConfirmation'
      @confirmation.innerHTML = "<span style='font-weight:bold;'>fontBomb loaded!</span> Click anywhere to destroy #{document.title.substring(0,50)}"
      @body.appendChild @confirmation
      setTimeout(=>
        @confirmation.className = 'show'
      ,10)
      setTimeout(=>
        @confirmation.className = ''
        setTimeout(=>
          @confirmation.innerHTML = "If you think fontBomb is a blast, follow me on twitter <a href='http://www.twitter.com/plehoux'>@plehoux</a> for my next experiment!"
          @confirmation.className = 'show'
          setTimeout(=>
            @confirmation.className = ''
          ,20000)
        ,5000)
      ,5000)

  explosifyNodes:(nodes)->
    for node in nodes
      @explosifyNode(node)
  
  explosifyNode:(node)->
    for name in ['script','style','iframe','canvas','video','audio','textarea','embed','object','select','area','map','input']
      return if node.nodeName.toLowerCase() == name
    switch node.nodeType
      when 1 then @explosifyNodes(node.childNodes)
      when 3
        unless /^\s*$/.test(node.nodeValue)
          if node.parentNode.childNodes.length == 1
            node.parentNode.innerHTML = @explosifyText(node.nodeValue)
          else
            newNode           = document.createElement("particles")
            newNode.innerHTML = @explosifyText(node.nodeValue)
            node.parentNode.replaceChild newNode, node

  explosifyText:(string)->
    chars = for char, index in string.split ''
      unless /^\s*$/.test(char) then "<particle style='display:inline-block;'>#{char}</particle>" else '&nbsp;'
    chars = chars.join('')
    chars = for char, index in chars.split '&nbsp;'
      unless /^\s*$/.test(char) then "<word style='white-space:nowrap'>#{char}</word>" else char
    chars.join(' ')
  
  dropBomb:(event)=>
    pos = window.findClickPos(event)
    @bombs.push new Bomb(pos.x,pos.y)
    if window.FONTBOMB_PREVENT_DEFAULT
      event.preventDefault()

  tick:=>
    for bomb in @bombs
      if bomb.state == 'explose'
        bomb.exploded()
        @blast = bomb.pos
    
    if @blast?
      char.tick(@blast) for char in @chars
      @blast = null 
    else
      char.tick() for char in @chars
    requestAnimationFrame @tick

new Explosion()