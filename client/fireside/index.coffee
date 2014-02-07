socket = io.connect "50.22.11.232:13891"

randomN = (min, max) ->
  Math.random() * (max - min) + min

randomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min


angular.module('bitcampApp')
  .controller 'FiresideCtrl', ($scope, $http, $resource) ->

    blocksI = 0
    blocksT = 2400

    socket.on 'connect', ->
      socket.on '/api/fireside/blocks', (blocks) ->

    Blocks = $resource '/api/fireside/blocks', {},
      get:
        method: 'GET'
        isArray: true

    do blocksF = ->
      $http.get('/api/fireside/blocks')

        .success (blocks) ->
          $bs = $ '.inner-block'
          (b for b in blocks when b.on).map (b) ->
            do ($b = $bs.eq b.i) ->
              setTimeout ->
                $b.removeClass $b.data 'dimclass'
                $b.addClass    $b.data 'colorclass'
                setTimeout ->
                  $b.removeClass $b.data 'colorclass'
                  $b.addClass    $b.data 'dimclass'
                , (randomN 1, blocksT)
              , (randomN 1, blocksT)

        .error (err) ->
          null

    blocksI = setInterval blocksF, blocksT
