(function() {
  var Bomb, Explosion, Particle, targetTime, vendor, w, _i, _len, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  w = window;

  _ref = ['ms', 'moz', 'webkit', 'o'];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    vendor = _ref[_i];
    if (w.requestAnimationFrame) break;
    w.requestAnimationFrame = w["" + vendor + "RequestAnimationFrame"];
    w.cancelAnimationFrame = w["" + vendor + "CancelAnimationFrame"] || w["" + vendor + "CancelRequestAnimationFrame"];
  }

  targetTime = 0;

  w.requestAnimationFrame || (w.requestAnimationFrame = function(callback) {
    var currentTime;
    targetTime = Math.max(targetTime + 16, currentTime = +(new Date));
    return w.setTimeout((function() {
      return callback(+(new Date));
    }), targetTime - currentTime);
  });

  w.cancelAnimationFrame || (w.cancelAnimationFrame = function(id) {
    return clearTimeout(id);
  });

  w.findClickPos = function(e) {
    var posx, posy;
    posx = 0;
    posy = 0;
    if (!e) e = window.event;
    if (e.pageX || e.pageY) {
      posx = e.pageX;
      posy = e.pageY;
    } else if (e.clientX || e.clientY) {
      posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
      posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
    }
    return {
      x: posx,
      y: posy
    };
  };

  w.getOffset = function(el) {
    var body, _x, _y;
    body = document.getElementsByTagName("body")[0];
    _x = 0;
    _y = 0;
    while (el && !isNaN(el.offsetLeft) && !isNaN(el.offsetTop)) {
      _x += el.offsetLeft - el.scrollLeft;
      _y += el.offsetTop - el.scrollTop;
      el = el.offsetParent;
    }
    return {
      top: _y + body.scrollTop,
      left: _x + body.scrollLeft
    };
  };

  Particle = (function() {

    Particle.FRICTION = 0.9;

    function Particle(elem) {
      this.elem = elem;
      this.transform = {
        x: 0,
        y: 0,
        rotation: 0
      };
      this.offset = {
        top: window.getOffset(this.elem).top,
        left: window.getOffset(this.elem).left
      };
      this.velocity = {
        x: 0,
        y: 0
      };
    }

    Particle.prototype.tick = function(blast) {
      var distX, distXS, distY, distYS, distanceWithBlast, force, forceX, forceY, previousRotation, previousStateX, previousStateY, rad;
      previousStateX = this.transform.x;
      previousStateY = this.transform.y;
      previousRotation = this.transform.rotation;
      if (this.velocity.x > Particle.FRICTION) {
        this.velocity.x -= Particle.FRICTION;
      } else if (this.velocity.x < -Particle.FRICTION) {
        this.velocity.x += Particle.FRICTION;
      } else {
        this.velocity.x = 0;
      }
      if (this.velocity.y > Particle.FRICTION) {
        this.velocity.y -= Particle.FRICTION;
      } else if (this.velocity.y < -Particle.FRICTION) {
        this.velocity.y += Particle.FRICTION;
      } else {
        this.velocity.y = 0;
      }
      if (blast != null) {
        distX = this.x() - blast.x;
        distY = this.y() - blast.y;
        distXS = distX * distX;
        distYS = distY * distY;
        distanceWithBlast = distXS + distYS;
        force = 100000 / distanceWithBlast;
        rad = Math.asin(distYS / distanceWithBlast);
        forceY = Math.sin(rad) * force * (distY < 0 ? -1 : 1);
        forceX = Math.cos(rad) * force * (distX < 0 ? -1 : 1);
        this.velocity.x = +forceX;
        this.velocity.y = +forceY;
      }
      this.transform.x = this.transform.x + this.velocity.x;
      this.transform.y = this.transform.y + this.velocity.y;
      this.transform.rotation = this.transform.x * -1;
      if ((Math.abs(previousStateX - this.transform.x) > 1 || Math.abs(previousStateY - this.transform.y) > 1 || Math.abs(previousRotation - this.transform.rotation) > 1) && ((this.transform.x > 1 || this.transform.x < -1) || (this.transform.y > 1 || this.transform.y < -1))) {
        return this.setTransform();
      }
    };

    Particle.prototype.setTransform = function() {
      var transform;
      transform = "translate(" + this.transform.x + "px, " + this.transform.y + "px) rotate(" + this.transform.rotation + "deg)";
      this.elem.style['MozTransform'] = transform;
      this.elem.style['WebkitTransform'] = transform;
      this.elem.style['MsTransform'] = transform;
      this.elem.style['transform'] = transform;
      return this.elem.style['zIndex'] = 9999;
    };

    Particle.prototype.y = function() {
      return this.offset.top + this.transform.y;
    };

    Particle.prototype.x = function() {
      return this.offset.left + this.transform.x;
    };

    return Particle;

  })();

  this.Particle = Particle;

  Bomb = (function() {

    Bomb.SIZE = 50;

    function Bomb(x, y) {
      this.countDown = __bind(this.countDown, this);
      this.drop = __bind(this.drop, this);      this.pos = {
        x: x,
        y: y
      };
      this.body = document.getElementsByTagName("body")[0];
      this.state = 'planted';
      this.count = 3;
      this.drop();
    }

    Bomb.prototype.drop = function() {
      this.bomb = document.createElement("div");
      this.bomb.innerHTML = this.count;
      this.body.appendChild(this.bomb);
      this.bomb.style['zIndex'] = "9999";
      this.bomb.style['fontFamily'] = "verdana";
      this.bomb.style['width'] = "" + Bomb.SIZE + "px";
      this.bomb.style['height'] = "" + Bomb.SIZE + "px";
      this.bomb.style['display'] = 'block';
      this.bomb.style['borderRadius'] = "" + Bomb.SIZE + "px";
      this.bomb.style['WebkitBorderRadius'] = "" + Bomb.SIZE + "px";
      this.bomb.style['MozBorderRadius'] = "" + Bomb.SIZE + "px";
      this.bomb.style['fontSize'] = '18px';
      this.bomb.style['color'] = '#fff';
      this.bomb.style['lineHeight'] = "" + Bomb.SIZE + "px";
      this.bomb.style['background'] = '#000';
      this.bomb.style['position'] = 'absolute';
      this.bomb.style['top'] = "" + (this.pos.y - Bomb.SIZE / 2) + "px";
      this.bomb.style['left'] = "" + (this.pos.x - Bomb.SIZE / 2) + "px";
      this.bomb.style['textAlign'] = "center";
      this.bomb.style['WebkitUserSelect'] = 'none';
      this.bomb.style['font-weight'] = 700;
      return setTimeout(this.countDown, 1000);
    };

    Bomb.prototype.countDown = function() {
      this.state = 'ticking';
      this.count--;
      this.bomb.innerHTML = this.count;
      if (this.count > 0) {
        return setTimeout(this.countDown, 1000);
      } else {
        return this.explose();
      }
    };

    Bomb.prototype.explose = function() {
      this.bomb.innerHTML = '';
      return this.state = 'explose';
    };

    Bomb.prototype.exploded = function() {
      this.state = 'exploded';
      this.bomb.innerHTML = '';
      this.bomb.style['fontSize'] = '12px';
      return this.bomb.style['opacity'] = 0.05;
    };

    return Bomb;

  })();

  this.Bomb = Bomb;

  Explosion = (function() {

    function Explosion(confirmation) {
      var char, _ref2,
        _this = this;
      if (confirmation == null) confirmation = true;
      this.tick = __bind(this.tick, this);
      this.dropBomb = __bind(this.dropBomb, this);
      this.bombs = [];
      this.body = document.getElementsByTagName("body")[0];
      if ((_ref2 = this.body) != null) {
        _ref2.onclick = function(event) {
          return _this.dropBomb(event);
        };
      }
      this.body.addEventListener("touchstart", function(event) {
        return _this.touchEvent = event;
      });
      this.body.addEventListener("touchmove", function(event) {
        _this.touchMoveCount || (_this.touchMoveCount = 0);
        return _this.touchMoveCount++;
      });
      this.body.addEventListener("touchend", function(event) {
        if (_this.touchMoveCount < 3) _this.dropBomb(_this.touchEvent);
        return _this.touchMoveCount = 0;
      });
      this.explosifyNodes(this.body.childNodes);
      this.chars = (function() {
        var _j, _len2, _ref3, _results;
        _ref3 = document.getElementsByTagName('particle');
        _results = [];
        for (_j = 0, _len2 = _ref3.length; _j < _len2; _j++) {
          char = _ref3[_j];
          _results.push(new Particle(char, this.body));
        }
        return _results;
      }).call(this);
      this.tick();
      if (confirmation != null) {
        confirmation = document.createElement("div");
        confirmation.innerHTML = "<span style='font-weight:bold;'>fontBomb loaded!</span> Click anywhere to destroy this website.";
        confirmation.style['position'] = 'absolute';
        confirmation.style['bottom'] = '0px';
        confirmation.style['width'] = '100%';
        confirmation.style['padding'] = '20px';
        confirmation.style['background'] = '#e8e8e8';
        confirmation.style['text-align'] = 'center';
        confirmation.style['font-size'] = '14px';
        confirmation.style['font-family'] = 'verdana';
        confirmation.style['color'] = '#000';
        this.body.appendChild(confirmation);
      }
    }

    Explosion.prototype.explosifyNodes = function(nodes) {
      var node, _j, _len2, _results;
      _results = [];
      for (_j = 0, _len2 = nodes.length; _j < _len2; _j++) {
        node = nodes[_j];
        _results.push(this.explosifyNode(node));
      }
      return _results;
    };

    Explosion.prototype.explosifyNode = function(node) {
      var newNode;
      switch (node.nodeType) {
        case 1:
          return this.explosifyNodes(node.childNodes);
        case 3:
          if (!/^\s*$/.test(node.nodeValue)) {
            if (node.parentNode.childNodes.length === 1) {
              return node.parentNode.innerHTML = this.explosifyText(node.nodeValue);
            } else {
              newNode = document.createElement("particles");
              newNode.innerHTML = this.explosifyText(node.nodeValue);
              return node.parentNode.replaceChild(newNode, node);
            }
          }
      }
    };

    Explosion.prototype.explosifyText = function(string) {
      var char, chars, index;
      chars = (function() {
        var _len2, _ref2, _results;
        _ref2 = string.split('');
        _results = [];
        for (index = 0, _len2 = _ref2.length; index < _len2; index++) {
          char = _ref2[index];
          if (!/^\s*$/.test(char)) {
            _results.push("<particle style='display:inline-block;'>" + char + "</particle>");
          } else {
            _results.push('&nbsp;');
          }
        }
        return _results;
      })();
      chars = chars.join('');
      chars = (function() {
        var _len2, _ref2, _results;
        _ref2 = chars.split('&nbsp;');
        _results = [];
        for (index = 0, _len2 = _ref2.length; index < _len2; index++) {
          char = _ref2[index];
          if (!/^\s*$/.test(char)) {
            _results.push("<word style='white-space:nowrap'>" + char + "</word>");
          } else {
            _results.push(char);
          }
        }
        return _results;
      })();
      return chars.join(' ');
    };

    Explosion.prototype.dropBomb = function(event) {
      var pos;
      pos = window.findClickPos(event);
      return this.bombs.push(new Bomb(pos.x, pos.y));
    };

    Explosion.prototype.tick = function() {
      var bomb, char, _j, _k, _l, _len2, _len3, _len4, _ref2, _ref3, _ref4;
      _ref2 = this.bombs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        bomb = _ref2[_j];
        if (bomb.state === 'explose') {
          bomb.exploded();
          this.blast = bomb.pos;
        }
      }
      if (this.blast != null) {
        _ref3 = this.chars;
        for (_k = 0, _len3 = _ref3.length; _k < _len3; _k++) {
          char = _ref3[_k];
          char.tick(this.blast);
        }
        this.blast = null;
      } else {
        _ref4 = this.chars;
        for (_l = 0, _len4 = _ref4.length; _l < _len4; _l++) {
          char = _ref4[_l];
          char.tick();
        }
      }
      return requestAnimationFrame(this.tick);
    };

    return Explosion;

  })();

  new Explosion();

}).call(this);
