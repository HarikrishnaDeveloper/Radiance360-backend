const time = new Date(); // assume now is 14:55 IST
const h = 10, m = 0;
const graceMinutes = 15;

const istFormatter = new Intl.DateTimeFormat('en-US', {
  timeZone: 'Asia/Kolkata',
  hour: 'numeric',
  minute: 'numeric',
  hour12: false,
});

let currentH = 0;
let currentM = 0;
console.log(istFormatter.formatToParts(time));
istFormatter.formatToParts(time).forEach(p => {
  if (p.type === 'hour') currentH = parseInt(p.value, 10);
  if (p.type === 'minute') currentM = parseInt(p.value, 10);
});
if (currentH === 24) currentH = 0;

const currentMinutes = currentH * 60 + currentM;
const officialMinutes = h * 60 + m;
const graceCutoffMinutes = officialMinutes + graceMinutes;
const veryLateCutoffMinutes = officialMinutes + 120;

console.log({ currentH, currentM, currentMinutes, officialMinutes, graceCutoffMinutes });

if (currentMinutes <= graceCutoffMinutes) console.log('ON_TIME');
else if (currentMinutes > veryLateCutoffMinutes) console.log('VERY_LATE');
else console.log('LATE');
