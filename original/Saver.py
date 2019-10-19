import objc,json,types

from AppKit import *
from ScreenSaver import ScreenSaverView
from random import randint, randrange, random, uniform, choice, seed
from math import sin, pi, sqrt, pow
from time import sleep

configs = [{
    "speed":    "uniform(0.2, 1.0)",
    "numrows":  "randint(20,300)",
    "keepdir":  "[uniform(0, 0.9), uniform(0, 0.9), uniform(0, 0.9)]*2",
    "reset":    "choice(['random', 'center', 'wrap'])",
    "resetmax": "randint(6000,10000)",
    "colorinc": "uniform(80.0/self.numrows, 200.0/self.numrows)",
    "colors": """choice([{'type':'smooth'}])""",
},{
    "speed":    "uniform(0.01, 0.1)",
    "numrows":  "randint(15,50)",
    "keepdir":  "[uniform(0, 0.9), uniform(0, 0.9), uniform(0, 0.9)]*2",
    "reset":    "choice(['random', 'center', 'wrap'])",
    "resetmax": "randint(3000,6000)",
    "colorinc": "uniform(20.0/self.numrows, 100.0/self.numrows)",
    "colors": """choice([
                 {'type':'eval', 'eval':'((self.r + self.colorinc)%100,0,0)'},
                 {'type':'eval', 'eval':'[randint(0,100)]*3'},
                 {'type':'eval', 'eval':'[randint(0,100), randint(0,100), randint(0,100)]'},
                 {'type':'list', 'list':[(0.1,0.1,0.1), (1,1,1), (0.1,0.1,0.1), (0.5,0.5,0.5), (0.1,0.1,0.1), (1,0,0), (0.1,0.1,0.1), (0.5,0.5,0.5)]},
                 ])""",
},{
    "speed":    "uniform(0.2, 1.0)",
    "numrows":  "randint(20,500)",
    "keepdir":  "[uniform(0, 0.9), uniform(0, 0.9), uniform(0, 0.9)]*2",
    "reset":    "choice(['random', 'center', 'wrap'])",
    "resetmax": "max(2000, self.numrows*20)",
    "colorinc": "uniform(1.0/self.numrows, 100.0/self.numrows)",
    "colors": """choice([
                 {'type':'random'},
                 {'type':'smoothlist', 'list':[(0,0,0), (1,0,0), (0,0,0), (1,1,0), (0,0,0), (1,0,0), (0,0,0), (0,0,1)]},
                 {'type':'smoothlist', 'list':[(0,0,0), (.5,.5,1), (0,0,1), (0,0,0), (.5,.5,.5)]},
                 {'type':'smoothlist', 'list':[(0,0,0), (0,0,1), (0.5,0.5,1), (1,0,0), (1,1,0), (1,0,0), (0.5,0.5,1), (0,0,1)]},
                 {'type':'smoothlist', 'list':[(0,0,0), (.5,.5,.5), (0,0,0), (1,0,0), (0,0,0), (0.5,0.5,0.5)]},
                 ])""",
}]

class Saver (ScreenSaverView):

    def initWithFrame_isPreview_(self, frame, isPrev):
        self = ScreenSaverView.initWithFrame_isPreview_(self,frame,isPrev)
        self.width  = frame.size.width
        self.height = frame.size.height
        self.animState = "anim"
        self.initConfig()
        return self

    def initConfig(self):
        self.seed  = int(random()*10000)
        seed(self.seed)
        self.resetmax = 2000
        self.resetcounter = 0
        self.speed = 1
        config = choice(configs)

        for ck in ["numrows", "colorinc", "keepdir", "reset", "colors", "speed", "resetmax"]:
            setattr(self, ck, eval(config[ck]))

        self.colorindex = 0
        self.colorfade  = 100
        self.thiscolor  = [0.0,0.0,0.0]
        self.nextcolor  = [0.0,0.0,0.0]
        self.resetcolor = [0.0,0.0,0.0]

        self.lastPos = randint(0,5)
        self.numrows = min(self.numrows, self.height/2)
        self.sizey = self.height/self.numrows
        print("height %d numrows %d sizey %f" % (self.height, self.numrows, self.sizey))
        self.sizex = sin(pi/3)*self.sizey

        self.steps = int(sqrt(sqrt(self.numrows))-1)+1
        self.steps = int(pow(2,self.steps)-1)
        self.steps *= self.steps
        self.steps = max(1, int(self.speed*self.steps))
        self.steps = max(1, int(self.speed*self.numrows/10))

        self.nx = int(self.width/self.sizex)
        self.ny = int(self.height/self.sizey)

        self.cx = int(self.nx/2)
        self.cy = int(self.ny/2)

        self.x = self.cx
        self.y = self.cy

        self.r = self.resetcolor[0]
        self.g = self.resetcolor[1]
        self.b = self.resetcolor[2]

        print "config={"
        for k in ["reset", "colorinc", "colors", "numrows", "keepdir", "speed", "resetmax"]:
            print "'%s': %s," % (k, ""+json.dumps(getattr(self, k)))
        print "}"
        return self

    def drawCube(self, xi, yi, c, skip=1):

        h = self.sizey
        w = self.sizex
        s = h/2

        x = xi*w
        y = yi*h

        if xi%2==1:
            y-=h/2

        if (skip != 0):
            NSColor.colorWithCalibratedRed_green_blue_alpha_(c[0], c[1], c[2], 1.0).set() # top
            path = NSBezierPath.bezierPath()
            path.moveToPoint_(NSPoint(x  ,y))
            path.lineToPoint_(NSPoint(x+w,y+s))
            path.lineToPoint_(NSPoint(x  ,y+h))
            path.lineToPoint_(NSPoint(x-w,y+s))
            path.fill()

        if skip != 1:
            NSColor.colorWithCalibratedRed_green_blue_alpha_(c[0]*0.6, c[1]*0.6, c[2]*0.6, 1.0).set() # left
            path = NSBezierPath.bezierPath()
            path.moveToPoint_(NSPoint(x    ,y))
            path.lineToPoint_(NSPoint(x-w  ,y+s))
            path.lineToPoint_(NSPoint(x-w  ,y-s))
            path.lineToPoint_(NSPoint(x    ,y-h))
            path.fill()

        if skip != 2:
            NSColor.colorWithCalibratedRed_green_blue_alpha_(c[0]*0.25, c[1]*0.25, c[2]*0.25, 1.0).set() # right
            path = NSBezierPath.bezierPath()
            path.moveToPoint_(NSPoint(x    ,y))
            path.lineToPoint_(NSPoint(x+w  ,y+s))
            path.lineToPoint_(NSPoint(x+w  ,y-s))
            path.lineToPoint_(NSPoint(x    ,y-h))
            path.fill()

    def nextColor(self, nextPos):
        if self.colors['type'] == "smooth":
            self.smoothColor(nextPos)
        elif self.colors['type'] == "random":
            self.colorfade += self.colorinc
            if self.colorfade >= 100:
                self.colorfade -= 100
                self.thiscolor = self.nextcolor
                self.nextcolor = [random(), random(), random()]
            self.r = self.thiscolor[0] * (100-self.colorfade) + self.colorfade * self.nextcolor[0]
            self.g = self.thiscolor[1] * (100-self.colorfade) + self.colorfade * self.nextcolor[1]
            self.b = self.thiscolor[2] * (100-self.colorfade) + self.colorfade * self.nextcolor[2]
        elif self.colors['type'] == "eval":
            (self.r, self.g, self.b) = eval(self.colors['eval'])
        elif self.colors['type'] == "list":
            self.colorindex = (self.colorindex + 1) % len(self.colors['list'])
            self.r = self.colors['list'][self.colorindex][0]*100
            self.g = self.colors['list'][self.colorindex][1]*100
            self.b = self.colors['list'][self.colorindex][2]*100
        elif self.colors['type'] == "smoothlist":
            self.colorfade += self.colorinc
            if self.colorfade > 100:
                self.colorfade -= 100
                self.colorindex = (self.colorindex + 1) % len(self.colors['list'])
            nextindex = (self.colorindex + 1) % len(self.colors['list'])
            self.r = self.colors['list'][self.colorindex][0] * (100-self.colorfade) + self.colorfade * self.colors['list'][nextindex][0]
            self.g = self.colors['list'][self.colorindex][1] * (100-self.colorfade) + self.colorfade * self.colors['list'][nextindex][1]
            self.b = self.colors['list'][self.colorindex][2] * (100-self.colorfade) + self.colorfade * self.colors['list'][nextindex][2]

    def smoothColor(self, nextPos):
        ci = self.colorinc
        if nextPos == 0:
            if self.b < 100-ci:
                self.b = (self.b+ci)%100
            else:
                self.b = 100
        if nextPos == 1:
            if self.r < 100-ci:
                self.r = (self.r+ci)%100
            else:
                self.r = 100
        if nextPos == 2:
            if self.g < 100-ci:
                self.g = (self.g+ci)%100
            else:
                self.g = 100
        if nextPos == 3:
            if self.b >= ci:
                self.b = (self.b+100-ci)%100
            else:
                self.b = 0
        if nextPos == 4:
            if self.r >= ci:
                self.r = (self.r+100-ci)%100
            else:
                self.r = 0
        if nextPos == 5:
            if self.g >= ci:
                self.g = (self.g+100-ci)%100
            else:
                self.g = 0

    def nextCube(self):
        skip = -1
        if type(self.keepdir) == types.ListType:
            if random() < self.keepdir[self.lastPos]:
                nextPos = self.lastPos
            else:
                nextPos = randint(0,5)
        elif random() < self.keepdir:
            nextPos = self.lastPos
        else:
            nextPos = randint(0,5)
        self.lastPos = nextPos
        if nextPos == 0:
            self.y += 1
        if nextPos == 1:
            if (self.x%2)==1:
                self.y -= 1
            self.x += 1
        if nextPos == 2:
            if (self.x%2)==1:
                self.y -= 1
            self.x -= 1
        if nextPos == 3:
            self.y -= 1
            skip = 0
        if nextPos == 4:
            if (self.x%2)==0:
                self.y += 1
            self.x -= 1
            skip = 2
        if nextPos == 5:
            if (self.x%2)==0:
                self.y += 1
            self.x += 1
            skip = 1

        self.nextColor(nextPos)

        if self.x < 1 or self.y < 2 or self.x > self.nx-1 or self.y > self.ny-1:
            if self.reset == "center":
                self.x = self.cx
                self.y = self.cy
            elif self.reset == "random":
                self.x = randint(0,self.nx-1)
                self.y = randint(0,self.ny-1)
            elif self.reset == "wrap":
                if self.x < 1: self.x = self.nx-1
                elif self.x > self.nx-1: self.x = 1
                if self.y < 2: self.y = self.ny-1
                elif self.y > self.ny-1: self.y = 2
            self.r = self.resetcolor[0]
            self.g = self.resetcolor[1]
            self.b = self.resetcolor[2]
            self.lastPos = randint(0,5)

        self.drawCube(self.x, self.y, [self.r/100.0, self.g/100.0, self.b/100.0], skip)

    def clear(self, color=[0,0,0,1]):
        NSColor.colorWithCalibratedRed_green_blue_alpha_(color[0], color[1], color[2], color[3]).set()
        NSBezierPath.fillRect_(NSRect(NSPoint(0,0),NSSize(self.width,self.height)))

    def fadeOut(self):
        if self.fadeState >= 100:
            self.clear()
            self.initConfig()
            self.animState = "anim"
        else:
            self.clear([0,0,0,0.02])
            self.fadeState += 1

    def animateOneFrame(self):
        if self.animState == "fade":
            self.fadeOut()
        else:
            self.resetcounter += 1
            if self.resetcounter > self.resetmax:
                self.animState = "fade"
                self.fadeState = 0
            for i in range(self.steps):
                self.nextCube()

objc.removeAutoreleasePool()
