class Explosion
  constructor:(confirmation = true)->
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
        @dropBomb(@touchEvent) if @touchMoveCount < 3
        @touchMoveCount = 0
      )
    @explosifyNodes  @body.childNodes
    @chars = for char in document.getElementsByTagName('particle')
      new Particle(char,@body)
    @tick()
    if confirmation?
      confirmation = document.createElement("div")
      confirmation.innerHTML = "<span style='font-weight:bold;'>fontBomb loaded!</span> Click anywhere to destroy this website."
      confirmation.style['position'] = 'absolute'
      confirmation.style['bottom'] = '0px'
      confirmation.style['width'] = '100%'
      confirmation.style['padding'] = '20px'
      confirmation.style['background'] = '#e8e8e8'
      confirmation.style['text-align'] = 'center'
      confirmation.style['font-size']  = '14px'
      confirmation.style['font-family'] = 'verdana'
      confirmation.style['color'] = '#000'
      @body.appendChild confirmation
    

  explosifyNodes:(nodes)->
    for node in nodes
      @explosifyNode(node)
  
  explosifyNode:(node)->
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