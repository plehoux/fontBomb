class Particle
  constructor:(elem)->
    @elem                 = elem
    @style                = elem.style
    @elem.style['zIndex'] = 9999
    @transformX           = 0
    @transformY           = 0
    @transformRotation    = 0
    @offsetTop  = window.getOffset(@elem).top
    @offsetLeft = window.getOffset(@elem).left
    @velocityX  = 0
    @velocityY  = 0

  tick:(blast)->
    previousStateX = @transformX
    previousStateY = @transformY
    previousRotation = @transformRotation
    if @velocityX > 1.5 then @velocityX -= 1.5 else if @velocityX < -1.5 then @velocityX += 1.5 else @velocityX = 0
    if @velocityY > 1.5 then @velocityY -= 1.5 else if @velocityY < -1.5 then @velocityY += 1.5 else @velocityY = 0
    if blast?
      distX  = @offsetLeft + @transformX - blast.x
      distY  = @offsetTop + @transformY - blast.y
      distXS = distX * distX
      distYS = distY * distY
      distanceWithBlast = distXS+distYS
      force  = 100000/distanceWithBlast
      force  = 50 if force > 50
      rad    = Math.asin distYS/distanceWithBlast 
      forceY = Math.sin(rad)*force * if distY < 0 then -1 else 1
      forceX = Math.cos(rad)*force * if distX < 0 then -1 else 1
      @velocityX =+ forceX
      @velocityY =+ forceY
    @transformX = @transformX + @velocityX
    @transformY = @transformY + @velocityY
    @transformRotation = @transformX*-1
    
    if (Math.abs(previousStateX - @transformX) > 1 or Math.abs(previousStateY - @transformY) > 1 or Math.abs(previousRotation - @transformRotation) > 1) and ((@transformX > 1 or @transformX < -1) or (@transformY > 1 or @transformY < -1)) 
      transform = "translate(#{@transformX}px, #{@transformY}px) rotate(#{@transformRotation}deg)"
      @style['MozTransform']    = transform
      @style['OTransform']      = transform
      @style['WebkitTransform'] = transform
      @style['msTransform']     = transform
      @style['transform']       = transform

this.Particle = Particle