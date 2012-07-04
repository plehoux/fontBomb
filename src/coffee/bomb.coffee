class Bomb
  @SIZE = 50
  constructor:(x,y)->
    @pos = 
      x:x 
      y:y
    @body  = document.getElementsByTagName("body")[0]
    @state = 'planted'
    @count = 3
    @drop()

  drop:=>
    @bomb = document.createElement("div")
    @bomb.innerHTML = @count
    @body.appendChild(@bomb)
    @bomb.style['zIndex'] = "9999"
    @bomb.style['fontFamily'] = "verdana"
    @bomb.style['width'] = "#{Bomb.SIZE}px"
    @bomb.style['height'] = "#{Bomb.SIZE}px"
    @bomb.style['display'] = 'block'
    @bomb.style['borderRadius'] = "#{Bomb.SIZE}px"
    @bomb.style['WebkitBorderRadius'] = "#{Bomb.SIZE}px"
    @bomb.style['MozBorderRadius'] = "#{Bomb.SIZE}px"
    @bomb.style['fontSize'] = '18px'
    @bomb.style['color'] = '#fff'
    @bomb.style['lineHeight'] = "#{Bomb.SIZE}px"
    @bomb.style['background'] = '#000'
    @bomb.style['position'] = 'absolute'
    @bomb.style['top'] = "#{@pos.y-Bomb.SIZE/2}px"
    @bomb.style['left'] = "#{@pos.x-Bomb.SIZE/2}px"
    @bomb.style['textAlign'] = "center"
    @bomb.style['WebkitUserSelect'] = 'none'
    @bomb.style['font-weight'] = 700
    setTimeout(@countDown,1000)

  countDown:=>
    @state = 'ticking'
    @count--
    @bomb.innerHTML = @count
    if @count > 0 then setTimeout(@countDown,1000) else @explose()

  explose:->
    @bomb.innerHTML = ''
    @state = 'explose'

  exploded:->
    @state = 'exploded'
    @bomb.innerHTML = ''
    @bomb.style['fontSize'] = '12px'
    @bomb.style['opacity'] = 0.05

this.Bomb = Bomb