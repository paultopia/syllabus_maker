

// unused 

function dateEquals(date1, date2) {
	return date1.getTime() === date2.getTime();
}
// for some reason I can't get date filtration to work, two dates initialized from same date string come back as not equal.
// that function isn't actually used, but I'm keeping it here to remind myself how to compare dates and make it work.



function dateString(date) {
	let options = { weekday: 'long', year: '2-digit', month: 'short', day: 'numeric'};
	str = date.toLocaleDateString("us-EN", options)
	return str.substring(0, str.length-4)
}




// used code starts here

let daynums = [["Sunday", 0], ["Monday", 1], ["Tuesday", 2], ["Wednesday", 3], ["Thursday", 4], ["Friday", 5], ["Saturday", 6]];
let numdays = daynums.map(inner => [inner[1], inner[0]]);
let dn = daynums.concat(numdays);
let dnMap = new Map(dn);

var state = new Map()
state.set("startDate", new Date());
state.set("endDate", new Date());
state.set("holidays", [])
state.set("days", ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"])

function addHoliday(date){
	var h = state.get("holidays");
	h.push(date);
	state.set("holidays", h);
}

function blacklistDays(dr, blacklist) {
	if (blacklist.length != 0) {
		let bl = blacklist.map(d => d.getTime())
		return dr.filter(date => !contains(bl, date.getTime()))	
	}
	return dr
	
}


function specificDays(dateRange, dayList){
	return dateRange.filter(date => contains(dayList, dnMap.get(date.getDay())));
}

function dateRange(start, end){
	var output = [];
	var loop = new Date(start);
	while(loop <= end){           
    	output.push(new Date(loop));
    	loop.setDate(loop.getDate() + 1);
	}
	return output;
}

function schedule(start, end, days, holidays) {
	let dr = dateRange(start, end);
	let daylist = specificDays(dr, days);
	let output = blacklistDays(daylist, state.get("holidays"))
	return output;
}


function contains(array, element){
	return array.indexOf(element) >= 0;
}



function printDateRange(dr){
	const strings = dr.map(d => "<li>" + d.toDateString() + "</li>");
	return "<ul>" + strings.join() + "</ul>";
}

function updateDateRange(){
let s = state.get("startDate");
let e = state.get("endDate");
let d = state.get("days");
let h = state.get("holidays");
state.set("schedule", schedule(s, e, d, h));
}

function parseDate(formstring){
    const parts = formstring.split('-');
    const d = new Date(parts[0], parts[1]-1, parts[2]);
    return d
}




function logDate(id){
	let d = parseDate(document.getElementById(id).value)
	console.log(d)
}

function updateState(){
	updateDateRange()
	var drstring = printDateRange(state.get("schedule"));
	document.getElementById("dates").innerHTML = drstring;
	var holidaystring = printDateRange(state.get("holidays"));
	document.getElementById("holidays").innerHTML = holidaystring;	
}

function changeDate(dateElement, stateDate, textElement){
	let d = parseDate(document.getElementById(dateElement).value)
	state.set(stateDate, d);
	document.getElementById(textElement).innerHTML = state.get(stateDate).toDateString()
	updateState()
}

function addHolidayDate(_){
	let d = parseDate(document.getElementById("holidayDate").value)
	addHoliday(d)
	updateState()
}


document.getElementById("start").addEventListener("change", e => changeDate("start", "startDate", "starttext"))
document.getElementById("end").addEventListener("change", e => changeDate("end", "endDate", "endtext"))
document.getElementById("addHolidayDate").addEventListener("click", e => addHolidayDate())


//function logValue(e) {
//	var date = new Date(e.target.value)
//	console.log(date)
//}

//document.getElementById("start").addEventListener("change", logValue)

