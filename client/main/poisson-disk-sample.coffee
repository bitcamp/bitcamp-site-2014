#poisson-disk-sample
#https://github.com/jeffrey-hearn/poisson-disk-sample
#MIT License


window.PoissonDiskSampler = class PoissonDiskSampler
  constructor: (width, height, minDistance, sampleFrequency, start) ->
    @width           = width
    @height          = height
    @minDistance     = minDistance
    @sampleFrequency = sampleFrequency
    @reset()
    @queueToAll start if start

  reset: ->
    @grid            = new Grid @width, @height, @minDistance
    @outputList      = new Array()
    @processingQueue = new RandomQueue()

  sampleUntilSolution: ->
    continue while @sample()
    @outputList

  sample: ->
    if 0 is @outputList.length
      @queueToAll @grid.randomPoint()
      return true
    processPoint = @processingQueue.pop()
    return false unless processPoint?
    i = 0
    while i < @sampleFrequency
      samplePoint = @grid.randomPointAround(processPoint)
      @queueToAll samplePoint unless @grid.inNeighborhood(samplePoint)
      i++
    true

  queueToAll: (point) ->
    valid = @grid.addPointToGrid(point, @grid.pixelsToGridCoords(point))
    return unless valid
    @processingQueue.push point
    @outputList.push point


class Grid
  constructor: (width, height, minDistance) ->
    @width = width
    @height = height
    @minDistance = minDistance
    @cellSize = @minDistance / Math.SQRT2

    @pointSize = 2
    @cellsWide = Math.ceil(@width / @cellSize)
    @cellsHigh = Math.ceil(@height / @cellSize)

    @grid = []
    x = 0
    while x < @cellsWide
      @grid[x] = []
      y = 0
      while y < @cellsHigh
        @grid[x][y] = null
        y++
      x++

  pixelsToGridCoords: (point) ->
    gridX = Math.floor(point.x / @cellSize)
    gridY = Math.floor(point.y / @cellSize)
    x: gridX
    y: gridY

  addPointToGrid: (pointCoords, gridCoords) ->
    return false if gridCoords.x < 0 or gridCoords.x > @grid.length - 1
    return false if gridCoords.y < 0 or gridCoords.y > @grid[gridCoords.x].length - 1
    @grid[gridCoords.x][gridCoords.y] = pointCoords
    true

  randomPoint: ->
    x: getRandomArbitrary(0, @width)
    y: getRandomArbitrary(0, @height)

  randomPointAround: (point) ->
    r1 = Math.random()
    r2 = Math.random()
    radius = @minDistance * (r1 + 1)
    angle = 2 * Math.PI * r2
    x: point.x + radius * Math.cos(angle)
    y: point.y + radius * Math.sin(angle)

  inNeighborhood: (point) ->
    gridPoint = @pixelsToGridCoords(point)
    cellsAroundPoint = @cellsAroundPoint(point)
    i = 0
    while i < cellsAroundPoint.length
      if cellsAroundPoint[i]?
        if @calcDistance(cellsAroundPoint[i], point) < @minDistance
          return true
      i++
    false

  cellsAroundPoint: (point) ->
    gridCoords = @pixelsToGridCoords(point)
    neighbors = new Array()
    x = -2
    while x < 3
      targetX = gridCoords.x + x
      targetX = 0  if targetX < 0
      targetX = @grid.length - 1  if targetX > @grid.length - 1
      y = -2
      while y < 3
        targetY = gridCoords.y + y
        targetY = 0  if targetY < 0
        targetY = @grid[targetX].length - 1  if targetY > @grid[targetX].length - 1
        neighbors.push @grid[targetX][targetY]
        y++
      x++
    neighbors

  calcDistance: (pointInCell, point) ->
    x = (point.x - pointInCell.x) * (point.x - pointInCell.x)
    y = (point.y - pointInCell.y) * (point.y - pointInCell.y)
    Math.sqrt x + y


class RandomQueue
  constructor: (a) ->
    @queue = a or new Array()

  push: (element) ->
    @queue.push element

  pop: ->
    randomIndex = getRandomInt(0, @queue.length)
    while @queue[randomIndex] is `undefined`
      empty = true
      i = 0
      while i < @queue.length
        empty = false  if @queue[i] isnt `undefined`
        i++
      return null if empty
      randomIndex = getRandomInt(0, @queue.length)
    element = @queue[randomIndex]
    @queue.remove randomIndex
    element


getRandomArbitrary = (min, max) ->
  Math.random() * (max - min) + min
getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


Array::remove = (from, to) ->
  rest = @slice((to or from) + 1 or @length)
  @length = (if from < 0 then @length + from else from)
  @push.apply this, rest

