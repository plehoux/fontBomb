class Explosion
  constructor:->
    @bombs = []
    @body          = document.getElementsByTagName("body")[0]
    @body?.onclick = (event)=>@dropBomb(event)
    @body.addEventListener("touchend", @dropBomb, false);
    @explosifyNodes  @body.childNodes
    @chars = for char in document.getElementsByTagName('particle')
      new Particle(char,@body)
    @tick()
    

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