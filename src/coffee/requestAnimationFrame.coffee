w = window
for vendor in ['ms', 'moz', 'webkit', 'o']
    break if w.requestAnimationFrame
    w.requestAnimationFrame = w["#vendorRequestAnimationFrame"]
    w.cancelAnimationFrame = (w["#vendorCancelAnimationFrame"] or
                              w["#vendorCancelRequestAnimationFrame"])

targetTime = 0
w.requestAnimationFrame or= (callback) ->
    targetTime = Math.max targetTime + 16, currentTime = +new Date
    w.setTimeout (-> callback +new Date), targetTime - currentTime

w.cancelAnimationFrame or= (id) -> clearTimeout id

w.findClickPos = (e)-> 
  posx = 0
  posy = 0
  if (!e) then e = window.event
  if (e.pageX || e.pageY)
    posx = e.pageX
    posy = e.pageY
  else if (e.clientX || e.clientY)
    posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
    posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
  x:posx,y:posy

w.getOffset = (el)->
  body = document.getElementsByTagName("body")[0]
  _x = 0
  _y = 0
  while el and !isNaN(el.offsetLeft) and !isNaN(el.offsetTop) 
      _x += el.offsetLeft - el.scrollLeft
      _y += el.offsetTop - el.scrollTop
      el = el.offsetParent
   top: _y + body.scrollTop, left: _x + body.scrollLeft