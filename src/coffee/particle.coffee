class Particle
  @FRICTION = 0.9
  constructor:(elem)->
    @elem = elem
    @transform =
      x: 0
      y: 0
      rotation: 0
    @offset = 
      top: window.getOffset(@elem).top
      left: window.getOffset(@elem).left
    @velocity = 
      x:0
      y:0

  tick:(blast)->
    previousStateX = @transform.x
    previousStateY = @transform.y
    previousRotation = @transform.rotation
    if @velocity.x > Particle.FRICTION then @velocity.x -= Particle.FRICTION else if @velocity.x < -Particle.FRICTION then @velocity.x += Particle.FRICTION else @velocity.x = 0
    if @velocity.y > Particle.FRICTION then @velocity.y -= Particle.FRICTION else if @velocity.y < -Particle.FRICTION then @velocity.y += Particle.FRICTION else @velocity.y = 0

    if blast?
      distX = @x() - blast.x
      distY = @y() - blast.y
      distanceWithBlast = Math.sqrt(distX*distX+distY*distY)
      force = 1500/distanceWithBlast
      rad = Math.asin(distY/distanceWithBlast)
      forceY = Math.sin(rad)*force
      forceX = Math.cos(rad)*force * if distX < 0 then -1 else 1
      @velocity.x =+ forceX
      @velocity.y =+ forceY
    
    @transform.x = @transform.x + @velocity.x
    @transform.y = @transform.y + @velocity.y
    @transform.rotation = @transform.x*-10
    @setTransform() if (previousStateX != @transform.x or previousStateY != @transform.y or previousRotation != @transform.rotation) and ((@transform.x > 1 or @transform.x < -1) or (@transform.y > 1 or @transform.y < -1)) 

  setTransform: ->
    transform = "translate(#{@transform.x}px, #{@transform.y}px) rotate(#{@transform.rotation}deg)"
    @elem.style['MozTransform']    = transform
    @elem.style['WebkitTransform'] = transform
    @elem.style['MsTransform']     = transform
    @elem.style['transform']     = transform
    @elem.style['zIndex'] = 9999

  y:->
    @offset.top+@transform.y

  x:->
    @offset.left+@transform.x

this.Particle = Particle