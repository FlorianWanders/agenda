# Agenda

I could not find the agenda that I wanted, so I decided to knit one. 
Can be printed and bound at any good (online) copy-shop.

*NOTE*: Will rewrite some code more neatly if I find the time. Feel free to use in the meantime and make changes on your own. Provided as is without any guarantees.

## Features: 

- A4 agenda (default, can be nearly any format)<sup>[1](#flexibility)</sup>
- Monthly overview with weeknumbers and highlighted weekends
- One week on 2 pages 

Search for "Cusomizable input" in the [Master file](https://github.com/FlorianWanders/agenda/blob/master/calendarMaster.Rnw) to

- enter a date at which the agenda should start (can be literally any date)
- specify how many overview sheets you would like (must be uneven at the moment)<sup>[2](#unvevenoverview)</sup>
- enter the first and last hour you would like to see in the weekly agenda

[Preview the agenda](https://github.com/FlorianWanders/agenda/blob/master/calendarMaster.pdf)
## Set-up

1. Clone this repository or download all `.Rnw` files and the fontawesome files (`FontAwesome.otf` and `fontawesomeupdated.sty`).
2. In R-Studio, set the sweave options (under global options) to XeLaTeX. 
Then run the [Master file](https://github.com/FlorianWanders/agenda/blob/master/calendarMaster.Rnw) to knit the agenda.

## Errors and Future Work

- Errors might stem from attempting to load uninstalled packages. 
Check that all required packages are installed. 
Will automate this in a future version. 

- Formatting will be off by one page when an even number of overview sheets is used (I like 1.5 year overviews, which works fine with 3 overview sheets). Might fix that sometime in the (far) future.<sup>[2](#unvevenoverview)</sup>

<a name="flexibility">1</a>: All relevant heights/widths are relative, so if you want to change the format, the agenda should still be displayed correctly. Have not tried it and, as stated above, no guarantees, but I created the agenda with the goal to make it as flexible as possible.

<a name="unvevenoverview">2</a>: At the moment you need to add an extra page between the monthly overview and the weekly agenda if you want to use an even number of overview sheets. 
