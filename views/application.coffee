draw_chart = (data) ->
  console.log data
  hours = (moment(k).format('MMM Do, ha') for k, v of data).reverse()
  commit_totals = (v.total_commits for k, v of data).reverse()
  commit_averages = (v.average_commits for k, v of data).reverse()
  message_length_averages = (v.average_message_length for k, v of data).reverse()
  swearword_count_totals = (v.total_swearword_count for k, v of data).reverse()
  swearword_count_averages = (v.average_total_swearword_count for k, v of data).reverse()

  chart = new Highcharts.Chart(
    chart:
      renderTo: "stats"
      type: "line"
      margin: [ 50, 50, 100, 80]

    title:
      text: "Live Hackathon Stats"
      x: -20 #center

    subtitle:
      text: "Source: Github Repositories"
      x: -20

    xAxis:
      title:
        text: "Time"
      categories: hours
      labels:
        align: "right"
        rotation: -45,

    yAxis:
      title: ""
      min: 0
      plotLines: [
        value: 0
        width: 1
        color: "#808080"
      ]

    tooltip:
      formatter: ->
        "<b>#{@series.name} during #{@x}</b><br/>#{@y}"

    legend:
      layout: "vertical"
      align: "right"
      verticalAlign: "top"
      x: -10
      y: 100
      borderWidth: 0

    series: [
      name: "Total Commits"
      data: commit_totals
    ,
      name: "Per-Hack Commits"
      data: commit_averages
    ,
      name: "Message Length (Avg)"
      data: message_length_averages
    ,
      name: "Commit Message Swearwords"
      data: swearword_count_totals
    ]
  )


$(document).ready ->
  hostname = window.location.hostname
  $("a[href^=http]").not("a[href*='" + hostname + "']").addClass("link external").attr "target", "_blank"
  $("[rel='tooltip']").tooltip()
  $(".btn.disabled").live "click", (e) ->
    e.preventDefault()
  $('.btn-delete').bind 'click', (e) ->
    e.preventDefault()
    answer = confirm("Are you sure?")
    if answer
      $.ajax
        type: "DELETE"
        url: $(this).attr('href')
      .success ->
        window.location.reload()
  if $('#stats').length > 0
    $.getJSON $('#stats-link').val(), (data) ->
      draw_chart(data)