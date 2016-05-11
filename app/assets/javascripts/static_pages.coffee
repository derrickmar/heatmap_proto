class CellsQuerier1
  constructor: (twod_cells) ->
    @twod_cells = twod_cells
    @oned_cells = []
    for row in @twod_cells
      console.log row
      @oned_cells = @oned_cells.concat(row)
    @last_row_index = @twod_cells.length-1
    @half_length = Math.floor(@twod_cells[0].length/2)

  top: -> @twod_cells[0]
  center: -> @oned_cells
  bottom: -> @twod_cells[@last_row_index]
  left: -> @twod_cells.map (row, index) -> return row[0]
  right: -> @twod_cells.map (row, index) -> return row[1]
  topleft: -> @twod_cells[0][0]
  topright: -> @twod_cells[0][1]
  bottomleft: -> @twod_cells[1][1]
  bottomright: -> @twod_cells[1][2]

class CellsQuerier2
  constructor: (twod_cells) ->
    @twod_cells = twod_cells
    @oned_cells = []
    for row in @twod_cells
      @oned_cells = @oned_cells.concat(row)
    @last_row_index = @twod_cells.length-1
    @half_length = Math.floor(@twod_cells[0].length/2)

  top: -> @twod_cells[0].concat(@twod_cells[1])
  center: -> @oned_cells
  bottom: -> @twod_cells[2].concat(@twod_cells[3])
  left: -> @getColumn(0).concat(@getColumn(1))
  right: -> @getColumn(2).concat(@getColumn(3))
  topleft: -> [@twod_cells[0][0], @twod_cells[0][1], @twod_cells[1][0], @twod_cells[1][1]]
  topright: -> [@twod_cells[0][2], @twod_cells[0][3], @twod_cells[1][2], @twod_cells[1][3]]
  bottomleft: -> [@twod_cells[2][0], @twod_cells[2][1], @twod_cells[3][0], @twod_cells[3][1]]
  bottomright: -> [@twod_cells[2][2], @twod_cells[2][3], @twod_cells[3][2], @twod_cells[3][3]]

  getColumn: (col_index) ->
    @twod_cells.map((row, index) -> return row[col_index])

populate = (width, height, len = 70) ->
  console.log 'populate'
  max = 0
  points = []
  len = len
  while (len--)
    val = Math.floor(Math.random()*100);
    max = Math.max(max, val)
    p =
      x: Math.floor(Math.random()*width),
      y: Math.floor(Math.random()*height),
      value: val
    points.push(p)
  return {max: max, data: points }

class Heatmap
  constructor: ->
    @colors = { 'red': 30, 'yellow': 50, 'green': 100 }
    @mode = "center"
    top_left_hm = h337.create(
      container: document.querySelector('#top-left')
    )
    top_left_hm.setData(populate(300, 100))

    outer_left_hm = h337.create(
      container: document.querySelector('#outer-left')
    )
    outer_left_hm.setData(populate(75, 150, 30))

    center_left_hm = h337.create(
      container: document.querySelector('#center-left')
    )
    center_left_hm.setData(populate(175, 150))

    inner_right_hm = h337.create(
      container: document.querySelector('#inner-right')
    )
    inner_right_hm.setData(populate(100, 150, 30))

    bottom_left_hm = h337.create(
      container: document.querySelector('#bottom-left')
    )
    bottom_left_hm.setData(populate(300, 100))


    top_right_hm = h337.create(
      container: document.querySelector('#top-right')
    )
    top_right_hm.setData(populate(300, 100))

    outer_right_hm = h337.create(
      container: document.querySelector('#outer-right')
    )
    outer_right_hm.setData(populate(60, 150, 30))

    center_right_hm = h337.create(
      container: document.querySelector('#center-right')
    )
    center_right_hm.setData(populate(175, 150))

    inner_left_hm = h337.create(
      container: document.querySelector('#inner-left')
    )
    inner_left_hm.setData(populate(100, 150, 30))

    bottom_right_hm = h337.create(
      container: document.querySelector('#bottom-right')
    )
    bottom_right_hm.setData(populate(300, 100))



    @directions =
      "top": [top_left_hm, top_right_hm]
      "left": [top_left_hm, outer_left_hm, center_left_hm, bottom_left_hm]
      "right": [top_right_hm, outer_right_hm, center_right_hm, bottom_right_hm]
      "bottom": [bottom_left_hm, bottom_right_hm]
      "center": [center_left_hm, center_right_hm]
      "bottom-left": []



    @all_heatmaps = [
      top_left_hm, outer_left_hm, center_left_hm, inner_right_hm, bottom_left_hm,
      top_right_hm, outer_right_hm, center_right_hm, inner_left_hm, bottom_right_hm,
    ]
    @reset()

  activateMode: ->
    console.log 'activateMode', @mode
    heatmaps = @directions[@mode]
    for hm in heatmaps
      hm.setDataMax(50)

  reset: ->
    for hm in @all_heatmaps
      hm.setDataMax(250)

  setMode: (dir) ->
    @mode = dir
    @reset()
    @activateMode()


class Grid
  constructor: (cells_q) ->
    @colors = { 0: 'red', 1: 'yellow', 2: 'green' }
    @cells = cells_q.oned_cells
    @directions =
      "top": cells_q.top()
      "bottom": cells_q.bottom()
      "center": cells_q.center()
      "left": cells_q.left()
      "right": cells_q.right()
      "top-left": cells_q.topleft()
      "top-right": cells_q.topright()
      "bottom-left": cells_q.bottomleft()
      "bottom-right": cells_q.bottomright()

    @mode = "center"
    _this = @
    window.setInterval(_this.activateMode.bind(_this), 7000)

  activateMode: ->
    console.log 'activateMode'
    if @mode == "center"
      @reset()
    else
      selected_cells = @directions[@mode]
      @randomize(selected_cells)

  # Varies selected cells from red and yellow
  randomize: (cells) ->
    console.log 'randomize'
    for cell in cells
      random_num = Math.floor((Math.random() * 2))
      if random_num == 1
        cell.css('background-color', @colors[Math.floor((Math.random() * 2))])

  reset: ->
    for cell in @cells
      cell.css('background-color', @colors[2])

  setMode: (dir) ->
    @mode = dir
    @reset()
    @activateMode()

activateGrid = (cell_q) ->
  dispatcher = new WebSocketRails('f66a36ce.ngrok.io/websocket')
  channel = dispatcher.subscribe('hmc')
  grid = new Grid(cell_q)
  channel.bind('new_mode', (mode) ->
    console.log 'recieved new mode', mode
    grid.setMode(mode)
  )

$(document).ready ->
  $(".static_pages.home").ready ->
    console.log '.static_pages.home'
    cell_q = new CellsQuerier1([[$("#cell1-1"), $("#cell1-2")], [$("#cell2-1"), $("#cell2-2")]])
    activateGrid(cell_q)

  $(".static_pages.grid_two").ready ->
    console.log '.static_pages.grid_two'
    cell_q = new CellsQuerier2([
      [$("#cell1-1"), $("#cell1-2"), $("#cell1-3"), $("#cell1-4")],
      [$("#cell2-1"), $("#cell2-2"), $("#cell2-3"), $("#cell2-4")],
      [$("#cell3-1"), $("#cell3-2"), $("#cell3-3"), $("#cell3-4")],
      [$("#cell4-1"), $("#cell4-2"), $("#cell4-3"), $("#cell4-4")],
    ])
    activateGrid(cell_q)

  $(".static_pages.final_version").ready ->
    console.log '.static_pages.final_version'

    x_start = 130
    y_start = 150
    $left_butt = $("#left-butt")
    $tailbone = $("#tailbone")
    $right_butt = $("#right-butt")
    $left_leg = $("#left-leg")
    $right_leg = $("#right-leg")


    # Set the positioning
    $left_butt.css("left", x_start + "px")
    $left_butt.css("top", y_start + "px")
    $tailbone.css("left", x_start + $left_butt.width() + "px")
    $tailbone.css("top", y_start + "px")
    $right_butt.css("left", x_start + $left_butt.width() + $tailbone.width() + "px")
    $right_butt.css("top", y_start + "px")
    $left_leg.css("left", x_start + "px")
    $left_leg.css("top", y_start + $left_butt.height() + "px")
    $right_leg.css("left", x_start + $left_butt.width() + $tailbone.width() + "px")
    $right_leg.css("top", y_start + $right_butt.height() + "px")


    dispatcher = new WebSocketRails('f66a36ce.ngrok.io/websocket')
    channel = dispatcher.subscribe('hmc')
    cells_map =
      "top": [$tailbone, $left_butt, $right_butt]
      "bottom": [$left_leg, $right_leg]
      "center": []
      "left": [$left_butt, $left_leg]
      "right": [$right_butt, $right_leg]
      "top-left": [$left_butt]
      "top-right": [$right_butt]
      "bottom-left": [$left_leg]
      "bottom-right": [$right_leg]

    cells = [$left_butt, $tailbone, $right_butt, $left_leg, $right_leg]

    channel.bind('new_mode', (mode) ->
      console.log 'final version recieved new mode', mode
      for c in cells
        c.css('background-color', 'rgba(82, 187, 30, 0.6)')
      for c in cells_map[mode]
        c.css('background-color', 'rgba(255, 0, 0, 0.6)')
    )


  $(".static_pages.admin").ready ->
    console.log '.static_pages.admin'

    dispatcher = new WebSocketRails('f66a36ce.ngrok.io/websocket')
    channel = dispatcher.subscribe('hmc')

    $("#mode-selection").on "click", "td", ->
      $("#mode-selection").find("td").css('background-color', "transparent")
      mode = $(this).text().trim().replace(/\s+/g, '-').toLowerCase()
      channel.trigger('new_mode', mode)
      $(this).css('background-color', "lightblue")
      console.log 'should have triggered'

  $(".static_pages.detailed_heatmap").ready ->
    console.log '.static_pages.detailed_heatmap'

    dispatcher = new WebSocketRails('f66a36ce.ngrok.io/websocket')
    channel = dispatcher.subscribe('hmc')
    heatmap = new Heatmap()
    channel.bind('new_mode', (mode) ->
      console.log 'heatmap recieved new mode', mode
      heatmap.setMode(mode)
    )
    heatmap.setMode("bottom")
