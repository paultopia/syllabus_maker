function dateRange(startDateString, endDateString) {
	var start = new Date(startDateString);
	var end = new Date(endDateString);
	var output = [];
	var loop = new Date(start);
	while(loop <= end){           
    	output.push(new Date(loop));
    	loop.setDate(loop.getDate() + 1);
	}
	return output;
}

let daynums = [["Sunday", 0], ["Monday", 1], ["Tuesday", 2], ["Wednesday", 3], ["Thursday", 4], ["Friday", 5], ["Saturday", 6]];
let numdays = daynums.map(inner => [inner[1], inner[0]]);
let dn = daynums.concat(numdays);
let dnMap = new Map(dn);
let dr = dateRange("02/05/2013", "02/20/2013");
//console.log(dr)
let days = dr.map(d => dnMap.get(d.getDay()));
//console.log(days)

function contains(array, element){
	return array.indexOf(element) >= 0;
}

function specificDays(dateRange, dayList){
	return dateRange.filter(date => contains(dayList, dnMap.get(date.getDay())));
}

let monTue = specificDays(dr, ["Monday", "Tuesday"]);
//console.log(monTue)

function dateEquals(date1, date2) {
	return date1.getTime() === date2.getTime();
}
// for some reason I can't get date filtration to work, two dates initialized from same date string come back as not equal.
// that function isn't actually used, but I'm keeping it here to remind myself how to compare dates and make it work.

function blacklistDays(dateRange, blacklist) {
	let bl = blacklist.map(d => d.getTime())
	return dateRange.filter(date => !contains(bl, date.getTime()))
}

var blacklist = [];
let blacklistExample = new Date("02/18/2013");
blacklist.push(blacklistExample);

let blacklisted = blacklistDays(monTue, blacklist);
//console.log(blacklisted);
function dateString(date) {
	let options = { weekday: 'long', year: '2-digit', month: 'short', day: 'numeric' };
	str = date.toLocaleDateString("us-EN", options)
	return str.substring(0, str.length-4)
}

readable = blacklisted.map(dateString)
console.log(readable)