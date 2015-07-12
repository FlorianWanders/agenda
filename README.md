# Agenda

I could not find the agenda that I wanted, so I decided to knit one. 
Can be printed and bound at any good (online) copy-shop.

*NOTE*: work under progress, still experimenting with the layout and some code bits. 
Once I'm happy I will include more comments in the code. 
Feel free to use in the meantime and make changes on your own. 

## Features: 

- A4 agenda
- Monthly overview
- One week on 2 pages 

## Set-up

1. Clone this repository or download all `.Rnw` files and the fontawesome files (`FontAwesome.otf` and `fontawesomeupdated.sty`; 
not using fontawesome at the moment, but you will get an error if these files are not included).
2. In R-Studio, set the sweave options (under global options) to XeLaTeX. 
Then run the [Master file](https://github.com/FlorianWanders/agenda/blob/master/calendarMaster.Rnw) to knit the agenda.

## Errors

Erros might stem from attempting to load uninstalled packages. 
Check that all required packages are installed. 
Will automate this in a future version. 
